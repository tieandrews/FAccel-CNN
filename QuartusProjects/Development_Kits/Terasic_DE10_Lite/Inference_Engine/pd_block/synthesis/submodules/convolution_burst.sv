module convolution_burst # (
            parameter           MAX_RES = 256,
            parameter integer   XRES1=16, XRES2=32, XRES3=64, XRES4=128, XRES5=256,   // x resolution without padding
            parameter integer   YRES1=16, YRES2=32, YRES3=64, YRES4=128, YRES5=256,
            parameter           RESOLUTIONS = 5,
            parameter           PAD = 1,

            parameter           KX = 3,
            parameter           KY = 3,

            parameter           EXP = 8,
            parameter           MANT = 7,
            parameter           WIDTHF = 16,    // 1 + EXP + MANT
            
            parameter           FIFO_DEPTH = 512,
            
            parameter           WIDTH = 16,     // closest power of 2 for width = 2 ** $clog2(WIDTHF),
            parameter           WIDTHB = 2,     // byte lanes for WIDTH = (WIDTH / 8),
            parameter           WIDTHD = 9,     // bits for burst fifo words
            
            parameter           ADDER_PIPELINE = 1  // 1 or 0
)
(
    input   logic               clock,
    input   logic               clock_sreset,
    
    input   logic [3:0]         s_address,
    input   logic [31:0]        s_writedata,
    output  logic [31:0]        s_readdata,
    input   logic               s_read,
    input   logic               s_write,
    output  logic               s_waitrequest,
    
    output  logic [31:0]        m_address,
    input   logic [WIDTH-1:0]   m_readdata,
    output  logic [WIDTH-1:0]   m_writedata,
    output  logic [WIDTHB-1:0]  m_byteenable,
    output  logic [WIDTHD-1:0]  m_burstcount,
    output  logic               m_read,
    output  logic               m_write,
    input   logic               m_readdatavalid,
    input   logic               m_waitrequest
);
            localparam          DONTCARE = {128{1'bx}};
            localparam          ONE = 128'h1;
            localparam          ZERO = 128'h0;
            localparam          ONES = ~ZERO;
            
            localparam          WIDTHR = $clog2(MAX_RES);

    enum    logic [9:0]         {S1, S2, S3, S4, S5, S6, S7, S8, S9, S10} fsm[1:0];
    
            logic [31:0]        featuremap_source_reg, featuremap_destination_reg, kernel_source_reg;
            logic [31:0]        source_reg, dest_reg;
            logic [WIDTH-1:0]   featuremap_words_reg, word_count;
            logic               busy_flag, go_flag, featuremap_sum_flag, restart_flag;
            logic [2:0]         xres_select_reg, pad_reg;
            logic [WIDTHR-1:0]  xc, yc, xres, yres, xr,yr;
            logic               read_latency;
            logic [WIDTHF-1:0]  kernel_data, add_datab, add_result, conv_data, conv_result;
            logic               kernel_valid, add_data_valid, add_result_valid, conv_result_valid;
            logic               conv_enable_calc, conv_data_shift;
            logic               src_fifo_rdreq, src_fifo_wrreq, dst_fifo_rdreq, dst_fifo_wrreq;
            logic               dst_res_fifo_rdreq, dst_res_fifo_wrreq;
            logic [WIDTHD-1:0]  src_fifo_usedw, dst_fifo_usedw,dst_res_fifo_usedw;
            logic [WIDTH-1:0]   src_fifo_q, dst_fifo_q;
            
    // decode the resolution tap
    always_comb begin
        case (xres_select_reg)
            3'h0 : {xr, yr} = {XRES1[WIDTHR-1:0], YRES1[WIDTHR-1:0]};
            3'h1 : {xr, yr} = {XRES2[WIDTHR-1:0], YRES2[WIDTHR-1:0]};
            3'h2 : {xr, yr} = {XRES3[WIDTHR-1:0], YRES3[WIDTHR-1:0]};
            3'h3 : {xr, yr} = {XRES4[WIDTHR-1:0], YRES4[WIDTHR-1:0]};
            default : {xr, yr} = {XRES5[WIDTHR-1:0], YRES5[WIDTHR-1:0]};
        endcase
        xres = xr + (PAD[2:0] << 1);
        yres = yr + (PAD[2:0] << 1);
    end
    
    // source burst FIFO
    scfifo                      # (
                                    .add_ram_output_register("OFF"),
                                    .lpm_numwords(FIFO_DEPTH),
                                    .lpm_showahead("ON"),
                                    .lpm_type("scfifo"),
                                    .lpm_width(WIDTH),
                                    .lpm_widthu(WIDTHD),
                                    .overflow_checking("OFF"),
                                    .underflow_checking("OFF"),
                                    .use_eab("ON")
                                )
                                src_fifo (
                                    .clock (clock),
                                    .sclr (clock_sreset),
                                    .aclr (),
                                    .data (m_readdata),
                                    .rdreq (src_fifo_rdreq),
                                    .wrreq (src_fifo_wrreq),
                                    .usedw (src_fifo_usedw),
                                    .q (src_fifo_q),
                                    .almost_empty (),
                                    .almost_full (),
                                    .empty (),
                                    .full ());
                                    
    // destination read burst FIFO
    scfifo                      # (
                                    .add_ram_output_register("OFF"),
                                    .lpm_numwords(FIFO_DEPTH),
                                    .lpm_showahead("ON"),
                                    .lpm_type("scfifo"),
                                    .lpm_width(WIDTH),
                                    .lpm_widthu(WIDTHD),
                                    .overflow_checking("OFF"),
                                    .underflow_checking("OFF"),
                                    .use_eab("ON")
                                )
                                dst_fifo (
                                    .clock (clock),
                                    .sclr (clock_sreset),
                                    .aclr (),
                                    .data (m_readdata),
                                    .rdreq (dst_fifo_rdreq),
                                    .wrreq (dst_fifo_wrreq),
                                    .usedw (dst_fifo_usedw),
                                    .q (dst_fifo_q),
                                    .almost_empty (),
                                    .almost_full (),
                                    .empty (),
                                    .full ());

    // destination result burst FIFO
    scfifo                      # (
                                    .add_ram_output_register("OFF"),
                                    .lpm_numwords(FIFO_DEPTH),
                                    .lpm_showahead("ON"),
                                    .lpm_type("scfifo"),
                                    .lpm_width(WIDTH),
                                    .lpm_widthu(WIDTHD),
                                    .overflow_checking("OFF"),
                                    .underflow_checking("OFF"),
                                    .use_eab("ON")
                                )
                                dst_res_fifo (
                                    .clock (clock),
                                    .sclr (clock_sreset),
                                    .aclr (),
                                    .data (add_result),
                                    .rdreq (dst_res_fifo_rdreq),
                                    .wrreq (dst_res_fifo_wrreq),
                                    .usedw (dst_res_fifo_usedw),
                                    .q (m_writedata),
                                    .almost_empty (),
                                    .almost_full (),
                                    .empty (),
                                    .full ());
                
    // handle convolution and sum
    convolution_calc            # (
                                    .MAX_RES(XRES5 + (PAD << 1)),
                                    .XRES1(XRES1 + (PAD << 1)), 
                                    .XRES2(XRES2 + (PAD << 1)),
                                    .XRES3(XRES3 + (PAD << 1)),
                                    .XRES4(XRES4 + (PAD << 1)),
                                    .XRES5(XRES5 + (PAD << 1)),
                                    .RESOLUTIONS(RESOLUTIONS),
                                    .KX(KX),
                                    .KY(KY),
                                    .EXP(EXP),
                                    .MANT(MANT),
                                    .WIDTH(WIDTHF),
                                    .ADDER_PIPELINE(ADDER_PIPELINE)
                                )
                                convolution (
                                    .clock(clock),
                                    .clock_sreset(clock_sreset),
                                    .xres_select(xres_select_reg),
                                    .kernel_valid(kernel_valid),
                                    .kernel_data(m_readdata[WIDTHF-1:0]),
                                    .enable_calc(conv_enable_calc),
                                    .data_shift(conv_data_shift),
                                    .data(conv_data),
                                    .result_valid(conv_result_valid),
                                    .result(conv_result)
                                );
                        
    // accumulate the featuremap sum
    fp_add                      # (
                                    .EXP(EXP),
                                    .MANT(MANT),
                                    .WIDTH(WIDTHF),
                                    .EXTRA_PIPELINE(2)
                                )
                                adder (
                                    .clock(clock),
                                    .clock_sreset(clock_sreset),
                                    .data_valid(add_data_valid),    // when conv_result and add_datab are valid
                                    .dataa(conv_result),
                                    .datab(dst_fifo_q),
                                    .result_valid(add_result_valid),
                                    .result(add_result)
                                );
                        
    // handle control and status registers - slave interface
    always_comb begin
        s_waitrequest = s_write ? 1'b0 : (s_read ? ~read_latency : 1'b0);
    end
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            read_latency <= 1'b0;
        end
        else begin
            read_latency <= read_latency ? 1'b0 : s_read;
            if (s_address == 4'h0) begin
                s_readdata <= {busy_flag, go_flag};
                go_flag <= s_write & s_writedata[0];
            end
            else begin
                go_flag <= 1'b0;
            end
            if (s_address == 4'h1) begin
                s_readdata <= {xres_select_reg, pad_reg};
                if (s_write) begin
                    {xres_select_reg, pad_reg} <= s_writedata[5:0];
                end
            end
            if (s_address == 4'h2) begin
                s_readdata <= featuremap_source_reg;
                if (s_write) begin
                    featuremap_source_reg <= s_writedata;
                end
            end
            if (s_address == 4'h3) begin
                s_readdata <= featuremap_words_reg;
                if (s_write) begin
                    featuremap_words_reg <= s_writedata[15:0];
                end
            end
            if (s_address == 4'h4) begin
                s_readdata <= featuremap_destination_reg;
                if (s_write) begin
                    featuremap_destination_reg <= s_writedata;
                end
            end
            if (s_address == 4'h5) begin
                s_readdata <= kernel_source_reg;
                if (s_write) begin
                    kernel_source_reg <= s_writedata;
                end
            end
        end
    end

    // controlling FSM for bursting and padding data to convolution
    always_comb begin
        src_fifo_wrreq = 1'b0;
        src_fifo_rdreq = 1'b0;
        dst_fifo_wrreq = 1'b0;
        dst_fifo_rdreq = 1'b0;
        dst_res_fifo_wrreq = 1'b0;
        dst_res_fifo_rdreq = 1'b0;
        kernel_valid = 1'b0;
        conv_data_shift = 1'b0;
        conv_enable_calc = 1'b0;
        conv_data = ZERO[WIDTHF-1:0];
        case (fsm[0])
            S2 : begin
                kernel_valid = m_readdatavalid;
            end
            S3 : begin
                src_fifo_wrreq = m_readdatavalid;
            end
            S4 : begin
                dst_fifo_wrreq = m_readdatavalid;
            end
            S5 : begin
                conv_data_shift = 1'b1;
            end
            S6 : begin
                conv_data_shift = 1'b1;
            end
            S7 : begin
                src_fifo_rdreq = |src_fifo_usedw;
                dst_fifo_rdreq = |src_fifo_usedw;
                conv_data = src_fifo_q[WIDTHF-1:0];
                conv_enable_calc = 1'b1;
                conv_data_shift = 1'b1;
                dst_res_fifo_wrreq = add_result_valid;
            end
            default;
        endcase
    end
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            m_address <= DONTCARE[31:0];
            m_writedata <= DONTCARE[WIDTH-1:0];
            m_byteenable <= ONES[WIDTHB-1:0];
            m_burstcount <= DONTCARE[WIDTHD-1:0];
            m_read <= 1'b0;
            m_write <= 1'b0;
            word_count <= DONTCARE[WIDTH-1:0];
            source_reg <= DONTCARE[31:0];
            dest_reg <= DONTCARE[31:0];
            fsm[0] <= S1;
            fsm[1] <= S1;
        end
        else begin
            m_byteenable <= ONES[WIDTHB-1:0];
            case (fsm[0])
                S1 : begin  // wait for go signal to start convolution
                    source_reg <= featuremap_source_reg;
                    dest_reg <= featuremap_destination_reg;
                    xc <= ZERO[WIDTHR-1:0];
                    yc <= ZERO[WIDTHR-1:0];
                    if (go_flag) begin
                        busy_flag <= 1'b1;
                        fsm[0] <= S2;
                    end
                    else begin
                        busy_flag <= 1'b0;
                    end
                end
                
                S2 : begin  // burst read kernel KX*KY words to the convolution block
                    m_burstcount <= (KX[5:0] * KY[5:0]);
                    m_address <= kernel_source_reg;
                    case (fsm[1])
                        S1 : begin
                            word_count <= ZERO[WIDTH-1:0];
                            if (m_read) begin
                                if (~m_waitrequest) begin
                                    m_read <= 1'b0;
                                    fsm[1] <= S2;
                                end
                            end
                            else begin
                                m_read <= 1'b1;
                            end
                        end
                        S2 : begin
                            if (word_count >= (KX[WIDTH-1:0] * KY[WIDTH-1:0])) begin
                                fsm[1] <= S1;
                                fsm[0] <= S3;
                            end
                            else begin
                                word_count <= word_count + m_readdatavalid;
                            end
                        end
                    endcase
                end
                
                S3 : begin  // burst a line of source pixels to fifo
                    m_burstcount <= xr;
                    m_address <= source_reg;
                    case (fsm[1])
                        S1 : begin
                            word_count <= ZERO[WIDTH-1:0];
                            if (m_read) begin
                                if (~m_waitrequest) begin
                                    m_read <= 1'b0;
                                    fsm[1] <= S2;
                                end
                            end
                            else begin
                                m_read <= 1'b1;
                            end
                        end
                        S2 : begin
                            if (word_count >= xr) begin
                                source_reg <= source_reg + (xres << WIDTHB);
                                fsm[1] <= S1;
                                fsm[0] <= S4;
                            end
                            word_count <= word_count + m_readdatavalid;
                        end
                    endcase
                end

                S4 : begin  // burst a line of destination pixels to fifo
                    m_burstcount <= xr;
                    m_address <= dest_reg;
                    case (fsm[1])
                        S1 : begin
                            word_count <= ZERO[WIDTH-1:0];
                            if (m_read) begin
                                if (~m_waitrequest) begin
                                    m_read <= 1'b0;
                                    fsm[1] <= S2;
                                end
                            end
                            else begin
                                m_read <= 1'b1;
                            end
                        end
                        S2 : begin
                            if (word_count >= xr) begin
                                source_reg <= source_reg + (xres << WIDTHB);
                                fsm[1] <= S1;
                                fsm[0] <= S5;
                            end
                            word_count <= word_count + m_readdatavalid;
                        end
                    endcase
                end
                
                S5 : begin  // pad top
                    if (xc >= (xres - ONE[WIDTHR-1:0])) begin
                        xc <= ZERO[WIDTHR-1:0];
                        yc <= yc + ONE[WIDTHR-1:0];
                        if (yc >= (pad_reg - 3'h1)) begin
                            fsm[0] <= S6;
                        end
                    end
                    else begin
                        xc <= xc + ONE[WIDTHR-1:0];
                    end
                end
                
                S6 : begin   // pad left hand side
                    if (xc >= (pad_reg - 3'h1)) begin
                        xc <= ZERO[WIDTHR-1:0];
                        fsm[0] <= S7;
                    end
                    else begin
                        xc <= xc + ONE[WIDTHR-1:0];
                    end
                end
                
                S7 : begin  // read source pixels
                    if (~|src_fifo_usedw) begin
                        fsm[0] <= S8;
                    end
                end
                
                S8 : begin   // pad right hand side
                    if (xc >= (xres - pad_reg - 3'h1)) begin
                        xc <= ZERO[WIDTHR-1:0];
                        // yc <= yc + ONE[WIDTHR-1:0];
                        fsm[0] <= S9;
                    end
                    else begin
                        xc <= xc + ONE[WIDTHR-1:0];
                    end
                end
                
                S9 : begin  // write destination pixel
                    m_burstcount <= xr;
                    m_address <= source_reg;
                    if (m_write) begin
                        if (~m_waitrequest) begin
                            if (word_count >= xr) begin
                                m_write <= 1'b0;
                                yc <= yc + ONE[WIDTHR-1:0];
                                if (yc >= yr) begin
                                    fsm[0] <= S3;
                                end
                                else begin
                                    fsm[0] <= S1;
                                end
                            end
                            word_count <= word_count + ONE[WIDTHR-1:0];
                        end
                    end
                    else begin
                        word_count <= ZERO[WIDTH-1:0];
                        m_write <= 1'b1;
                    end
                end
            endcase
        end
    end
                        
endmodule
