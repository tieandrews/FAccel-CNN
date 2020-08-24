module stream_from_memory # (
            parameter               MAX_XRES = 128,
            parameter               XRES1 = 8,
            parameter               XRES2 = 16,
            parameter               XRES3 = 32,
            parameter               XRES4 = 64,
            parameter               XRES5 = 128,
            parameter               RESOLUTIONS = 5,
            parameter               KX = 3,
            parameter               KY = 3,
            parameter               EXP = 8,
            parameter               MANT = 7,
            parameter               WIDTH = 1 + MANT + EXP,
            parameter               WIDTHB = 8,
            parameter               WIDTHE = (WIDTH / 8),
            parameter               FIFO_DEPTH = 512,
            parameter               ADDER_PIPELINE = 1
)
(
    input   logic                   clock,
    input   logic                   clock_sreset,   // glitch free synchronous reset in 'clock' domain
    
    input   logic [3:0]             s_address,
    input   logic [31:0]            s_writedata,
    output  logic [31:0]            s_readdata,
    input   logic                   s_read,
    input   logic                   s_write,
    output  logic                   s_waitrequest,
    
    output  logic [31:0]            m_address,
    output  logic [WIDTHE-1:0]      m_byteenable,
    input   logic [WIDTH-1:0]       m_readdata,
    output  logic [WIDTH-1:0]       m_writedata,
    output  logic [WIDTHB-1:0]      m_burstcount,
    output  logic                   m_read,
    output  logic                   m_write,
    input   logic                   m_waitrequest,
    input   logic                   m_readdatavalid
    
);
            localparam              ONE = 128'h1;
            localparam              ZERO = 128'h0;
            localparam              DONTCARE = {128{1'bx}};
            localparam              BURST_SIZE = 8;
            localparam              WIDTHF = $clog2(FIFO_DEPTH);
    enum    logic [7:0]             {S1, S2, S3, S4, S5, S6, S7, S8} fsm;
            logic                   go_flag, busy_flag;
            logic [31:0]            source_pointer_reg, destination_pointer_reg, kernel_pointer_reg;
            logic [31:0]            src_pointer, dst_pointer;
            logic [11:0]            xres_reg, yres_reg;
            logic [15:0]            src_rd_count, dst_rd_count;
            logic [2:0]             convolution_xres_select_reg;
            logic                   read_latency;
            logic                   adder_result_valid, convolution_kernel_valid;
            logic [WIDTH-1:0]       adder_result, convolution_calc_result;
            logic [WIDTH-1:0]       src_rd_fifo_q, dst_rd_fifo_q;
            logic                   src_rd_fifo_rdreq, dst_rd_fifo_rdreq, src_rd_fifo_wrreq, dst_rd_fifo_wrreq, dst_wr_fifo_rdreq;
            logic [WIDTHF-1:0]      src_rd_fifo_usedw, dst_rd_fifo_usedw, dst_wr_fifo_usedw;
            
    scfifo                          # (
                                        .add_ram_output_register("OFF"),
                                        .lpm_numwords(FIFO_DEPTH),
                                        .lpm_showahead("ON"),
                                        .lpm_type("scfifo"),
                                        .lpm_width(WIDTH),
                                        .lpm_widthu(WIDTHF),
                                        .overflow_checking("OFF"),
                                        .underflow_checking("OFF"),
                                        .use_eab("ON")
                                    )
                                    src_rd_fifo (
                                        .clock (clock),
                                        .sclr (clock_sreset),
                                        .aclr (),
                                        .data (m_readdata),
                                        .rdreq (src_rd_fifo_rdreq),
                                        .wrreq (src_rd_fifo_wrreq),
                                        .usedw (src_rd_fifo_usedw),
                                        .q (src_rd_fifo_q),
                                        .almost_empty (),
                                        .almost_full (),
                                        .empty (),
                                        .full ());

    scfifo                          # (
                                        .add_ram_output_register("OFF"),
                                        .lpm_numwords(FIFO_DEPTH),
                                        .lpm_showahead("ON"),
                                        .lpm_type("scfifo"),
                                        .lpm_width(WIDTH),
                                        .lpm_widthu(WIDTHF),
                                        .overflow_checking("OFF"),
                                        .underflow_checking("OFF"),
                                        .use_eab("ON")
                                    )
                                    dst_rd_fifo (
                                        .clock (clock),
                                        .sclr (clock_sreset),
                                        .aclr (),
                                        .data (m_readdata),
                                        .rdreq (dst_rd_fifo_rdreq),
                                        .wrreq (dst_rd_fifo_wrreq),
                                        .usedw (dst_rd_fifo_usedw),
                                        .q (dst_rd_fifo_q),
                                        .almost_empty (),
                                        .almost_full (),
                                        .empty (),
                                        .full ());
                                        
    convolution_calc                # (
                                        .MAX_XRES(MAX_XRES),
                                        .XRES1(XRES1),
                                        .XRES2(XRES2),
                                        .XRES3(XRES3),
                                        .XRES4(XRES4),
                                        .XRES5(XRES5),
                                        .RESOLUTIONS(RESOLUTIONS),
                                        .KX(KX),
                                        .KY(KY),
                                        .EXP(EXP),
                                        .MANT(MANT),
                                        .WIDTH(WIDTH),
                                        .ADDER_PIPELINE(ADDER_PIPELINE)
                                    )
                                    convolution (
                                        .clock(clock),
                                        .clock_sreset(clock_sreset),
                                        .xres_select(convolution_xres_select_reg),
                                        .kernel_valid(convolution_kernel_valid),
                                        .kernel_data(m_readdata),
                                        .enable_calc(),
                                        .data_shift(),
                                        .data(src_rd_fifo_q),
                                        .result_valid(dst_rd_fifo_rdreq),
                                        .result(convolution_calc_result)
                                    );
                                        
    fp_add                          # (
                                        .EXP(EXP),
                                        .MANT(MANT),
                                        .WIDTH(WIDTH),
                                        .EXTRA_PIPELINE(ADDER_PIPELINE)
                                    )
                                    adder (
                                        .clock(clock),
                                        .clock_sreset(clock_sreset),
                                        .data_valid(dst_rd_fifo_rdreq),
                                        .dataa(convolution_calc_result),
                                        .datab(dst_rd_fifo_q),
                                        .result_valid(adder_result_valid),
                                        .result(adder_result)
                                    );

    scfifo                          # (
                                        .add_ram_output_register("OFF"),
                                        .lpm_numwords(FIFO_DEPTH),
                                        .lpm_showahead("ON"),
                                        .lpm_type("scfifo"),
                                        .lpm_width(WIDTH),
                                        .lpm_widthu(WIDTHF),
                                        .overflow_checking("OFF"),
                                        .underflow_checking("OFF"),
                                        .use_eab("ON")
                                    )
                                    dst_wr_fifo (
                                        .clock (clock),
                                        .sclr (clock_sreset),
                                        .aclr (),
                                        .data (adder_result),
                                        .rdreq (dst_wr_fifo_rdreq),
                                        .wrreq (adder_result_valid),
                                        .usedw (dst_wr_fifo_usedw),
                                        .q (m_writedata),
                                        .almost_empty (),
                                        .almost_full (),
                                        .empty (),
                                        .full ());
                                        
    // handle slave interface
    always_comb begin
        s_waitrequest = s_write ? 1'b0 : (s_read ? ~read_latency : 1'b0);
    end
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            go_flag <= 1'b0;
            read_latency <= 1'b0;
            source_pointer_reg <= DONTCARE[31:0];
        end
        else begin
            read_latency <= read_latency ? 1'b0 : s_read;
            if (s_address == 4'h0) begin    // command reg
                go_flag <= s_write & s_writedata[0];
            end
            else begin
                go_flag <= 1'b0;
            end
            
            if (s_address == 4'h1) begin    // status reg
                s_readdata <= {busy_flag}; // irq source and busy flags
                if (s_write) begin
                end
            end
            
            if (s_address == 4'h2) begin    // a pointer to the source feature map in memory
                s_readdata <= source_pointer_reg;
                if (s_write) begin
                    source_pointer_reg <= s_writedata;
                end
            end

            if (s_address == 4'h3) begin    // a pointer to the destination feature map in memory
                s_readdata <= destination_pointer_reg;
                if (s_write) begin
                    source_pointer_reg <= s_writedata;
                end
            end

            if (s_address == 4'h4) begin    // a pointer to the destination feature map in memory
                s_readdata <= kernel_pointer_reg;
                if (s_write) begin
                    kernel_pointer_reg <= s_writedata;
                end
            end
            
            if (s_address == 4'h5) begin    // x resolution of featuremap
                s_readdata <= xres_reg;
                if (s_write) begin
                    xres_reg <= s_writedata[11:0];
                end
            end

            if (s_address == 4'h6) begin    // y resolution of featuremap
                s_readdata <= yres_reg;
                if (s_write) begin
                    yres_reg <= s_writedata[11:0];
                end
            end
            
            if (s_address == 4'h7) begin
                s_readdata <= convolution_xres_select_reg;
                if (s_write) begin
                    convolution_xres_select_reg <= s_writedata[2:0];
                end
            end

        end
    end
    
    // handle read master interface
    always_comb begin
        convolution_kernel_valid = 1'b0;
        src_rd_fifo_wrreq = 1'b0;
        case (fsm)
            S3 : begin
                convolution_kernel_valid = m_readdatavalid;
            end
            S5 : begin
                src_rd_fifo_wrreq = m_readdatavalid;
            end
            default;
        endcase
    end
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            busy_flag <= 1'b0;
            m_read <= 1'b0;
            m_write <= 1'b0;
            m_address <= DONTCARE[31:0];
            m_byteenable <= ~ZERO[WIDTHE-1:0];
            m_burstcount <= DONTCARE[WIDTHB-1:0];
            fsm <= S1;
        end
        else begin
            m_byteenable <= ~ZERO[WIDTHE-1:0];
            case (fsm)
                S1 : begin  // wait here to begin
                    src_pointer <= source_pointer_reg;
                    dst_pointer <= destination_pointer_reg;
                    m_address <= source_pointer_reg;
                    src_rd_count <= xres_reg * yres_reg;
                    m_read <= 1'b0;
                    if (go_flag) begin
                        busy_flag <= 1'b1;
                        fsm <= S2;
                    end
                    else begin
                        busy_flag <= 1'b0;
                    end
                end
                S2 : begin  // start burst kernel weights
                    m_address <= kernel_pointer_reg;
                    m_burstcount <= KX[3:0] * KY[3:0];
                    if (m_read) begin
                        if (~m_waitrequest) begin
                            m_read <= 1'b0;
                            fsm <= S3;
                        end
                    end
                    else begin
                        m_read <= 1'b1;
                    end
                end
                S3 : begin      // count kernel burst back to zero to count the data
                    m_burstcount <= m_burstcount - m_readdatavalid;
                    if (m_burstcount <= 8'h1) begin
                        fsm <= S4;
                    end
                end
                S4 : begin   // read a source pixel burst
                    if (m_read) begin
                        if (~m_waitrequest) begin
                            src_pointer <= src_pointer + (m_burstcount << $clog2(WIDTHE));
                            m_read <= 1'b0;
                            fsm <= S5;
                        end
                    end
                    else begin
                        m_address <= src_pointer;
                        if (src_rd_fifo_usedw < (FIFO_DEPTH - (BURST_SIZE * 2))) begin
                            if (src_rd_count >= BURST_SIZE[15:0]) begin
                                m_burstcount <= BURST_SIZE[7:0];
                                src_rd_count <= src_rd_count - BURST_SIZE[15:0];
                            end
                            else begin
                                m_burstcount <= src_rd_count[7:0];
                                src_rd_count <= ZERO[15:0];
                            end
                            m_read <= 1'b1;
                        end
                    end
                end
                S5 : begin      // count kernel burst back to zero to count the data
                    m_burstcount <= m_burstcount - m_readdatavalid;
                    if (m_burstcount <= 8'h1) begin
                        fsm <= S6;
                    end
                end
                S6 : begin   // read a source pixel burst
                    if (m_read) begin
                        if (~m_waitrequest) begin
                            dst_pointer <= dst_pointer + (m_burstcount << $clog2(WIDTHE));
                            m_read <= 1'b0;
                            fsm <= S7;
                        end
                    end
                    else begin
                        m_address <= dst_pointer;
                        if (dst_rd_fifo_usedw < (FIFO_DEPTH - (BURST_SIZE * 2))) begin
                            if (dst_rd_count >= BURST_SIZE[15:0]) begin
                                m_burstcount <= BURST_SIZE[7:0];
                                dst_rd_count <= dst_rd_count - BURST_SIZE[15:0];
                            end
                            else begin
                                m_burstcount <= src_rd_count[7:0];
                                dst_rd_count <= ZERO[15:0];
                            end
                            m_read <= 1'b1;
                        end
                    end
                end
            endcase
        end
    end
    
endmodule
