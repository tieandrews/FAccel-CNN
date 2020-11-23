module conv_multi # (
            parameter                   CH = 2,
            parameter                   MAX_XRES = 64,
            parameter logic [4:0][9:0]  XRES = '{10'd16, 10'd32, 10'd64, 10'd4, 10'd8},
            parameter                   K = 3,
            parameter                   EXP = 8,
            parameter                   MANT = 7,
            parameter                   WIDTHF = 1 + EXP + MANT,
            parameter                   PIPELINE = 2,
            parameter                   WIDTHP = $clog2((MAX_XRES * MAX_XRES) + 1)
)
(
    input   logic                       clock,
    input   logic                       clock_sreset,
    input   logic [2:0]                 xres_select,
    input   logic                       kernel_data_valid,
    input   logic                       enable_calc,
    input   logic                       data_shift,
    input   logic [WIDTHF-1:0]          data,
    input   logic [15:0]                fifo_select,
    input   logic                       fifo_wrreq,
    input   logic                       fifo_rdreq,
    output  logic [WIDTHP-1:0]          fifo_usedw,
    output  logic [WIDTHF-1:0]          fifo_q
);
            localparam                  WIDTHC = (CH > 1) ? $clog2(CH) : 1;
            integer                     i;
            logic [WIDTHF-1:0]          kernel_out[CH-1:0];
            logic [CH-1:0][WIDTHF-1:0]  accum_q;
            logic [CH-1:0][WIDTHP-1:0]  accum_usedw;
            logic [CH-1:0]              accum_rdreq, accum_wrreq;
            logic [K*K-1:0][WIDTHF-1:0] window;
            
    sliding_window                      # (
                                            .MAX_XRES(MAX_XRES),
                                            .XRES(XRES),
                                            .K(K),
                                            .WIDTH(WIDTHF)
                                        )
                                        window1 (
                                            .clock(clock),
                                            .clock_sreset(clock_sreset),
                                            .data_shift(data_shift),
                                            .data(data),
                                            .xres_select(xres_select),
                                            .window(window)
                                        );
                                        
    generate
        begin
            if (CH > 1) begin
                multiplexer             # (
                                            .WIDTH(WIDTHP),
                                            .CH(CH),
                                            .WIDTHS(WIDTHC)
                                        )
                                        mux_usedw (
                                            .in(accum_usedw),
                                            .select(fifo_select[WIDTHC-1:0]),
                                            .out(fifo_usedw)
                                        );

                multiplexer             # (
                                            .WIDTH(WIDTHF),
                                            .CH(CH),
                                            .WIDTHS(WIDTHC)
                                        )
                                        mux_q (
                                            .in(accum_q),
                                            .select(fifo_select[WIDTHC-1:0]),
                                            .out(fifo_q)
                                        );

                always_comb begin
                    accum_wrreq = {{CH-1{1'b0}}, fifo_wrreq} << fifo_select[WIDTHC-1:0];
                    accum_rdreq= {{CH-1{1'b0}}, fifo_rdreq} << fifo_select[WIDTHC-1:0];
                end
            end
            else begin
                assign fifo_usedw = accum_usedw;
                assign fifo_q = accum_q;
                assign accum_wrreq = fifo_wrreq;
                assign accum_rdreq = fifo_rdreq;
            end
        end
    endgenerate
    
    genvar l;
    generate
        for (l=0; l<CH; l++) begin : channel
            if (l == 0) begin
                logic               conv_result_valid;
                logic [WIDTHF-1:0]  conv_result;
                convolution_calc        # (
                                            .EXP(EXP), .MANT(MANT), .WIDTHF(WIDTHF),
                                            .PIPELINE(PIPELINE)
                                        )
                                        convolution (
                                            .clock(clock),
                                            .clock_sreset(clock_sreset),
                                            .kernel_data_shift(kernel_data_valid),
                                            .enable_calc(enable_calc),
                                            .kernel_in(data),
                                            .kernel_out(kernel_out[l]),
                                            .window(window),
                                            .result_valid(conv_result_valid),
                                            .result(conv_result)
                                        );
            end
            else begin
                logic [WIDTHF-1:0]  conv_result;
                logic               conv_result_valid;
                convolution_calc        # (
                                            .EXP(EXP), .MANT(MANT), .WIDTHF(WIDTHF),
                                            .PIPELINE(PIPELINE)
                                        )
                                        convolution (
                                            .clock(clock),
                                            .clock_sreset(clock_sreset),
                                            .kernel_data_shift(kernel_data_valid),
                                            .enable_calc(enable_calc),
                                            .kernel_in(kernel_out[l-1]),
                                            .kernel_out(kernel_out[l]),
                                            .window(window),
                                            .result_valid(conv_result_valid),
                                            .result(conv_result)
                                        );
            end
            fifo_accumulator            # (
                                            .EXP(EXP),
                                            .MANT(MANT),
                                            .WIDTHF(WIDTHF),
                                            .PIPELINE(PIPELINE),
                                            .FIFO_DEPTH(MAX_XRES * MAX_XRES),
                                            .WIDTHP(WIDTHP)
                                        )
                                        acc (
                                            .clock(clock),
                                            .clock_sreset(clock_sreset),
                                            .rdreq(accum_rdreq[l]),
                                            .wrreq(accum_wrreq[l]),
                                            .empty(),
                                            .full(),
                                            .usedw(accum_usedw[l]),
                                            .data_valid(conv_result_valid),
                                            .data(conv_result),
                                            .q(accum_q[l])
                                        );
        end
    endgenerate

endmodule
