module convolution_burst # (
            parameter           MAX_XRES = 256,
            parameter integer   XRES1=16, XRES2=32, XRES3=64, XRES4=128, XRES5=256,   // x resolution with padding (if needed)
            parameter integer   YRES1=16, YRES2=32, YRES3=64, YRES4=128, YRES5=256,
            parameter           RESOLUTIONS = 5,

            parameter           KX = 3,
            parameter           KY = 3,

            parameter           EXP = 8,
            parameter           MANT = 7,
            parameter           WIDTHF = 16,    // 1 + EXP + MANT,
            
            parameter           FIFO_DEPTH = 512,
            
            parameter           WIDTH = 16,     // closest power of 2 for width = 2 ** $clog2(WIDTHF),
            parameter           WIDTHBE = 2,     // byte lanes for WIDTH = (WIDTH / 8),
            parameter           WIDTHBC = 9     // bits for word burst count (1-511)
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
    output  logic               s_irq,
    
    output  logic [31:0]        m_address,
    input   logic [WIDTH-1:0]   m_readdata,
    output  logic [WIDTH-1:0]   m_writedata,
    output  logic [WIDTHBE-1:0] m_byteenable,
    output  logic [WIDTHBC-1:0] m_burstcount,
    output  logic               m_read,
    output  logic               m_write,
    input   logic               m_readdatavalid,
    input   logic               m_waitrequest
);
            localparam          DONTCARE = {128{1'bx}};
            localparam          ONE = 128'h1;
            localparam          ZERO = 128'h0;
            localparam          ONES = ~ZERO;
            
            localparam          WIDTHR = $clog2(MAX_XRES);
            localparam          WIDTHFD = $clog2(FIFO_DEPTH);

    enum    logic [9:0]         {S1, S2, S3, S4, S5, S6, S7, S8, S9, S10} fsm;
    
            logic               go_flag, busy_flag, burst_flag, irq_ena_flag, go_irq_flag;
            logic [31:0]        kernel_pointer_reg, source_pointer_reg, destination_pointer_reg;
            logic [23:0]        offset;
            logic [2:0]         xres_select_reg, pad_reg;
            logic [WIDTHR-1:0]  xr, yr, x_count, y_count;
            logic [WIDTHR-1:0]  word_count;
            logic               read_latency;
            logic               kernel_data_shift, conv_enable_calc, conv_data_shift, conv_result_valid;
            logic [WIDTHF-1:0]  conv_data, conv_result;
            logic               add_data_valid, add_result_valid;
            logic [WIDTHF-1:0]  add_result;
            logic               dest_buffer_data_valid, dest_buffer_rdreq;
            logic [WIDTHF-1:0]  dest_buffer_q;
            logic               result_buffer_rdreq;
            logic [WIDTHFD-1:0] result_buffer_usedw;

            
    // decode the resolution tap
    always_comb begin
        case (xres_select_reg)
            3'h0 : {xr, yr} = {XRES1[WIDTHR-1:0], YRES1[WIDTHR-1:0]};
            3'h1 : {xr, yr} = {XRES2[WIDTHR-1:0], YRES2[WIDTHR-1:0]};
            3'h2 : {xr, yr} = {XRES3[WIDTHR-1:0], YRES3[WIDTHR-1:0]};
            3'h3 : {xr, yr} = {XRES4[WIDTHR-1:0], YRES4[WIDTHR-1:0]};
            default : {xr, yr} = {XRES5[WIDTHR-1:0], YRES5[WIDTHR-1:0]};
        endcase
    end
                    
    // handle convolution and sum
    convolution_calc            # (
                                    .MAX_XRES(MAX_XRES),   // with padding
                                    .XRES1(XRES1), 
                                    .XRES2(XRES2),
                                    .XRES3(XRES3),
                                    .XRES4(XRES4),
                                    .XRES5(XRES5),
                                    .RESOLUTIONS(RESOLUTIONS),
                                    .KX(KX),
                                    .KY(KY),
                                    .CHAN(1),   // number of channels
                                    .EXP(EXP),
                                    .MANT(MANT),
                                    .WIDTH(WIDTHF),
                                    .ADDER_PIPELINE(1)
                                )
                                convolution (
                                    .clock(clock),
                                    .clock_sreset(clock_sreset),
                                    .xres_select(xres_select_reg),
                                    .kernel_data_shift(kernel_data_shift),
                                    .kernel_data(m_readdata[WIDTHF-1:0]),
                                    .enable_calc(conv_enable_calc),
                                    .data_shift(conv_data_shift),
                                    .data(conv_data),
                                    .result_valid(conv_result_valid),
                                    .result(conv_result)
                                );
                                
    line_buffer                 # (
                                    .WIDTH(WIDTHF),
                                    .FIFO_DEPTH(FIFO_DEPTH),
                                    .WIDTHFD(WIDTHFD)
                                )
                                dest_buffer (
                                    .clock(clock),
                                    .clock_sreset(clock_sreset),
                                    .data_valid(dest_buffer_data_valid),
                                    .data(m_readdata[WIDTHF-1:0]),
                                    .usedw(),
                                    .rdreq(conv_result_valid),
                                    .q(dest_buffer_q)
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
                                    .data_valid(conv_result_valid),    // when conv_result and add_datab are valid
                                    .dataa(conv_result),
                                    .datab(dest_buffer_q),
                                    .result_valid(add_result_valid),
                                    .result(add_result)
                                );

    line_buffer                 # (
                                    .WIDTH(WIDTHF),
                                    .FIFO_DEPTH(FIFO_DEPTH),
                                    .WIDTHFD(WIDTHFD)
                                )
                                result_buffer (
                                    .clock(clock),
                                    .clock_sreset(clock_sreset),
                                    .data_valid(add_result_valid),
                                    .data(add_result),
                                    .usedw(result_buffer_usedw),
                                    .rdreq(result_buffer_rdreq),
                                    .q(m_writedata)
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
                s_readdata <= {irq_ena_flag, busy_flag, 1'b0};
                go_flag <= s_write & s_writedata[0];
                if (s_write) begin
                    irq_ena_flag <= s_writedata[2];
                end
                s_irq <= s_write & s_writedata[3] ? 1'b0 : (s_irq | go_irq_flag);
            end
            else begin
                go_flag <= 1'b0;
                s_irq <= (s_irq | go_irq_flag);
            end
            if (s_address == 4'h1) begin
                s_readdata <= xres_select_reg;
                if (s_write) begin
                    xres_select_reg <= s_writedata[2:0];
                end
            end
            if (s_address == 4'h2) begin
                s_readdata <= pad_reg;
                if (s_write) begin
                    pad_reg <= s_writedata[2:0];
                end
            end
            if (s_address == 4'h3) begin
                s_readdata <= kernel_pointer_reg;
                if (s_write) begin
                    kernel_pointer_reg <= s_writedata;
                end
            end
            if (s_address == 4'h4) begin
                s_readdata <= source_pointer_reg;
                if (s_write) begin
                    source_pointer_reg <= s_writedata[15:0];
                end
            end
            if (s_address == 4'h5) begin
                s_readdata <= destination_pointer_reg;
                if (s_write) begin
                    destination_pointer_reg <= s_writedata;
                end
            end
        end
    end

    // controlling FSM for bursting and padding data to convolution
    always_comb begin
        m_byteenable = ONES[WIDTHBE-1:0];
        kernel_data_shift = 1'b0;
        dest_buffer_data_valid = 1'b0;
        conv_enable_calc = 1'b0;
        result_buffer_rdreq = 1'b0;
        conv_data = ZERO[WIDTHF-1:0];
        conv_data_shift = 1'b0;
        case (fsm)
            S2 : begin
                conv_data_shift = 1'b1;
            end
            S3 : begin
                kernel_data_shift = m_readdatavalid;
            end
            S4, S7 : begin
                conv_data_shift = 1'b1;
            end
            S5 : begin
                dest_buffer_data_valid = m_readdatavalid;
            end
            S6 : begin
                conv_data_shift = m_readdatavalid;
                conv_enable_calc = m_readdatavalid;
                conv_data = m_readdata;
            end
            S8 : begin
                result_buffer_rdreq = m_write & ~m_waitrequest;
            end
        endcase
    end
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            m_address <= DONTCARE[31:0];
            m_burstcount <= DONTCARE[WIDTHBC-1:0];
            m_read <= 1'b0;
            m_write <= 1'b0;
            word_count <= DONTCARE[WIDTHR-1:0];
            offset <= DONTCARE[23:0];
            burst_flag <= 1'b0;
            x_count <= DONTCARE[WIDTHR-1:0];
            y_count <= DONTCARE[WIDTHR-1:0];
            fsm <= S1;
        end
        else begin
            case (fsm)
                S1 : begin  // wait for go signal to start convolution
                    m_read <= 1'b0;
                    m_write <= 1'b0;
                    offset <= ZERO[23:0];
                    burst_flag <= 1'b0;
                    x_count <= ZERO[WIDTHR-1:0];
                    y_count <= ZERO[WIDTHR-1:0];
                    go_irq_flag <= 1'b0;
                    if (go_flag) begin
                        busy_flag <= 1'b1;
                        fsm <= S2;
                    end
                    else begin
                        busy_flag <= 1'b0;
                    end
                end
                S2 : begin  // push top padded lines into convolution
                    if (x_count >= (xr - ONE[WIDTHR-1:0])) begin
                        x_count <= ZERO[WIDTHR-1:0];
                        y_count <= y_count + ONE[WIDTHR-1:0];
                        if (y_count >= (pad_reg - 3'h1)) begin
                            fsm <= S3;
                        end
                    end
                    else begin
                        x_count <= x_count + ONE[WIDTHR-1:0];
                    end
                end
                S3 : begin  // burst read kernel KX*KY words to the convolution block
                    m_address <= kernel_pointer_reg;
                    m_burstcount <= (KX[3:0] * KY[3:0]);
                    if (burst_flag) begin   // count the burst data
                        if (word_count >= m_burstcount) begin
                            burst_flag <= 1'b0;
                            fsm <= S4;
                        end
                        word_count <= word_count + m_readdatavalid;
                    end
                    else begin
                        word_count <= ZERO[WIDTHR-1:0];
                        if (m_read) begin   // issue the read burst
                            if (~m_waitrequest) begin
                                m_read <= 1'b0;
                                burst_flag <= 1'b1;
                            end
                        end
                        else begin
                            m_read <= 1'b1;
                        end
                    end
                end
                S4 : begin  // pad left side of line into convolution
                    if (x_count >= (pad_reg - 3'h1)) begin
                        x_count <= (xr - pad_reg - 3'h1);
                        fsm <= S5;
                    end
                    else begin
                        x_count <= x_count + ONE[WIDTHR-1:0];
                    end
                end
                S5 : begin  // burst destination featuremap to line buffer
                    m_address <= destination_pointer_reg + offset;
                    m_burstcount <= xr - (pad_reg << 1);
                    if (burst_flag) begin   // count the burst data
                        if (word_count >= m_burstcount) begin
                            burst_flag <= 1'b0;
                            fsm <= S6;
                        end
                        word_count <= word_count + m_readdatavalid;
                    end
                    else begin
                        word_count <= ZERO[WIDTHR-1:0];
                        if (m_read) begin   // issue the read burst
                            if (~m_waitrequest) begin
                                m_read <= 1'b0;
                                burst_flag <= 1'b1;
                            end
                        end
                        else begin
                            m_read <= 1'b1;
                        end
                    end
                end
                S6 : begin  // burst source featuremap
                    m_address <= source_pointer_reg + offset;
                    if (burst_flag) begin   // count the burst data
                        if (word_count >= m_burstcount) begin
                            burst_flag <= 1'b0;
                            fsm <= S7;
                        end
                        word_count <= word_count + m_readdatavalid;
                    end
                    else begin
                        word_count <= ZERO[WIDTHR-1:0];
                        if (m_read) begin   // issue the read burst
                            if (~m_waitrequest) begin
                                m_read <= 1'b0;
                                burst_flag <= 1'b1;
                            end
                        end
                        else begin
                            m_read <= 1'b1;
                        end
                    end
                end
                S7 : begin  // pad right side of line into convolution
                    if (x_count >= (xr - 3'h1)) begin
                        x_count <= ZERO[WIDTHR-1:0];
                        y_count <= y_count + ONE[WIDTHR-1:0];
                        fsm <= S8;
                    end
                    else begin
                        x_count <= x_count + ONE[WIDTHR-1:0];
                    end
                end
                S8 : begin  // burst write result
                    m_address <= destination_pointer_reg + offset;
                    if (m_write) begin
                        if (~m_waitrequest) begin
                            if (result_buffer_usedw == ONE[WIDTHFD-1:0]) begin
                                offset <= offset + ((xr - (pad_reg << 1)) << $clog2(WIDTHBE));
                                m_write <= 1'b0;
                                burst_flag <= 1'b0;
                                if (y_count >= (yr - pad_reg)) begin
                                    go_irq_flag <= irq_ena_flag;
                                    fsm <= S1;
                                end
                                else begin
                                    fsm <= S4;
                                end
                            end
                        end
                    end
                    else begin
                        if (~burst_flag) begin
                            if (result_buffer_usedw >= (xr - (pad_reg << 1) - ONE[WIDTHR-1:0])) begin
                                m_write <= 1'b1;
                                burst_flag <= 1'b1;
                            end
                        end
                    end
                end
            endcase
        end
    end
endmodule
