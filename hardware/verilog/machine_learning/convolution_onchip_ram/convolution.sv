module convolution # (
            parameter           MAX_XRES = 128,
            parameter           XRES1 = 16, XRES2 = 32, XRES3 = 64,
            parameter           XRES4 = 4, XRES5 = 8,   // x resolution
            parameter           RESOLUTIONS = 5,
            parameter           K = 3,
            parameter           EXP = 8,
            parameter           MANT = 7,
            parameter           WIDTHF = 1 + EXP + MANT,
            parameter           EXTRA_PIPELINE = 2,
            parameter           LAYERS = 4,
            parameter           BURST_SIZE = 8,
            parameter           WIDTHB = 5
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
    
    output  logic [31:0]        rm_address,
    input   logic [15:0]        rm_readdata,
    output  logic [1:0]         rm_byteenable,
    output  logic [WIDTHB-1:0]  rm_burstcount,
    output  logic               rm_read,
    input   logic               rm_waitrequest,
    input   logic               rm_readdatavalid,

    output  logic [31:0]        wm_address,
    output  logic [15:0]        wm_writedata,
    output  logic [1:0]         wm_byteenable,
    output  logic [WIDTHB-1:0]  wm_burstcount,
    output  logic               wm_write,
    input   logic               wm_waitrequest
);
            localparam          ONE = 128'h1;
            localparam          ZERO = 128'h0;
            localparam          DONTCARE = {128{1'bx}};
            localparam          FIFO_DEPTH = MAX_XRES * MAX_XRES;
            localparam          WIDTHFD = $clog2(FIFO_DEPTH);

    enum    logic [9:0]         {S1, S2, S3, S4, S5, S6, S7, S8, S9, S10} fsm;
    
            logic [31:0]        src_pointer, dst_pointer, knl_pointer;
            logic [15:0]        feature_size, xres;
            logic [15:0]        word_count, read_pointer;
            logic [2:0]         xres_select;
            logic               go_flag, busy_flag, kernel_go_flag;
            logic [WIDTHF-1:0]  src_fifo_q;
            logic               src_fifo_wrreq, src_fifo_rdreq;
            logic [WIDTHF-1:0]  kernel_out[LAYERS-1:0];
            logic               conv_enable_calc, conv_data_shift, kernel_data_shift;
            logic [31:0]        rd_burst_address;
            logic [15:0]        rd_burst_words;
            logic               rd_burst_go, rd_burst_data_wait, rd_burst_busy, rd_burst_data_valid;
            logic [WIDTHF-1:0]  rd_burst_data;
            logic [LAYERS-1:0]  acc_pop_fifo;
            
    always_comb begin
        xres = XRES1[11:0] * XRES1[11:0];
        if (xres_select == 3'h1) begin
            xres = XRES2[11:0] * XRES2[11:0];
        end
        if (xres_select == 3'h2) begin
            xres = XRES3[11:0] * XRES3[11:0];
        end
        if (xres_select == 3'h3) begin
            xres = XRES4[11:0] * XRES4[11:0];
        end
        if (xres_select == 3'h4) begin
            xres = XRES5[11:0] * XRES5[11:0];
        end
    end
                        
    convolution_csr             (
                                    .clock(clock),
                                    .clock_sreset(clock_sreset),
                                    .s_address(s_address),
                                    .s_writedata(s_writedata),
                                    .s_readdata(s_readdata),
                                    .s_read(s_read),
                                    .s_write(s_write),
                                    .s_waitrequest(s_waitrequest),
                                    .go_flag(go_flag),
                                    .kernel_go_flag(kernel_go_flag),
                                    .busy_flag(busy_flag),
                                    .src_pointer(src_pointer),
                                    .dst_pointer(dst_pointer),
                                    .knl_pointer(knl_pointer),
                                    .feature_size(feature_size),
                                    .xres_select(xres_select)
                                );

    genvar l;
    generate
        for (l=0; l<LAYERS; l++) begin : conv
            logic conv_result_valid;
            logic [WIDTHF-1:0] conv_result;
            logic [WIDTHF-1:0] kernel_data;
            
            if (l == 0) begin
                assign kernel_data = rd_burst_data;
            end
            else begin
                assign kernel_data = kernel_out[l-1];
            end
            
            convolution_calc    # (
                                    .MAX_XRES(MAX_XRES),
                                    .XRES1(XRES1),
                                    .XRES2(XRES2),
                                    .XRES3(XRES3),
                                    .XRES4(XRES4),
                                    .XRES5(XRES5),
                                    .RESOLUTIONS(RESOLUTIONS),
                                    .K(K),
                                    .EXP(EXP),
                                    .MANT(MANT),
                                    .WIDTH(WIDTHF),
                                    .EXTRA_PIPELINE(EXTRA_PIPELINE)
                                )
                                conv (
                                    .clock(clock),
                                    .clock_sreset(clock_sreset),
                                    .xres_select(xres_select),
                                    .kernel_data_shift(kernel_data_shift),
                                    .kernel_data(kernel_data),
                                    .kernel_out(kernel_out[l]),
                                    .enable_calc(conv_enable_calc),
                                    .data_shift(conv_data_shift),
                                    .data(src_fifo_q),
                                    .result_valid(conv_result_valid),
                                    .result(conv_result)
                                );
    
            fifo_accumulator    # (
                                    .EXP(EXP),
                                    .MANT(MANT),
                                    .WIDTH(WIDTHF),
                                    .EXTRA_PIPELINE(EXTRA_PIPELINE),
                                    .FIFO_DEPTH(MAX_XRES*MAX_XRES)
                                )
                                acc (
                                    .clock(clock),
                                    .clock_sreset(clock_sreset),
                                    .push_fifo(),
                                    .pop_fifo(acc_pop_fifo[l]),
                                    .rdreq_fifo(),
                                    .data_valid(conv_result_valid),
                                    .data(conv_result),
                                    .result_valid(),
                                    .result()
                                );
        end
    endgenerate
    
    burst_read_master           # (
                                    .BURST_SIZE(BURST_SIZE),
                                    .WIDTHB(WIDTHB)
                                )
                                rd_burst (
                                    .clock(clock),
                                    .clock_sreset(clock_sreset),
                                    .address(rd_burst_address),
                                    .words(rd_burst_words),
                                    .go(rd_burst_go),
                                    .data_wait(rd_burst_data_wait),
                                    .busy(rd_burst_busy),
                                    .data_valid(rd_burst_data_valid),
                                    .data(rd_burst_data),
                                    .m_address(rm_address),
                                    .m_readdata(rm_readdata),
                                    .m_byteenable(rm_byteenable),
                                    .m_burstcount(rm_burstcount),
                                    .m_read(rm_read),
                                    .m_readdatavalid(rm_readdatavalid),
                                    .m_waitrequest(rm_waitrequest)
                                );
                                
    always_comb begin
        kernel_data_shift = 1'b0;
        case (fsm)
            S2 : begin
                kernel_data_shift = rd_burst_data_valid;
            end
        endcase
    end
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            rd_burst_address <= DONTCARE[31:0];
            rd_burst_words <= DONTCARE[15:0];
            rd_burst_go <= 1'b0;
            rd_burst_data_wait <= 1'b0;
            word_count <= DONTCARE[15:0];
            busy_flag <= 1'b0;
            fsm <= S1;
        end
        else begin
            case (fsm)
                S1 : begin
                    busy_flag <= go_flag;
                    if (go_flag) begin
                        fsm <= S4;
                    end
                    if (kernel_go_flag) begin
                        fsm <= S2;
                    end
                end
                S2 : begin  // burst kernel weights
                    rd_burst_address <= knl_pointer;
                    rd_burst_words <= K[15:0] * K[15:0] * LAYERS[15:0];
                    if (rd_burst_go) begin
                        if (~rd_burst_busy) begin
                            rd_burst_go <= 1'b0;
                            fsm <= S3;
                        end
                    end
                    else begin
                        rd_burst_go <= 1'b1;
                    end
                end
                S3 : begin
                    rd_burst_address <= src_pointer;
                    rd_burst_words <= xres;
                    if (rd_burst_go) begin
                        if (~rd_burst_busy) begin
                            rd_burst_go <= 1'b0;
                            fsm <= S3;
                        end
                    end
                    else begin
                        rd_burst_go <= 1'b1;
                    end
                end
            endcase
        end
    end

endmodule
