module fifo_accumulator # (
            parameter           EXP = 8,
            parameter           MANT = 7,
            parameter           WIDTH = 1 + EXP + MANT,
            parameter           EXTRA_PIPELINE = 2,
            parameter           FIFO_DEPTH = 512
)
(
    input   logic               clock,
    input   logic               clock_sreset,
    input   logic               push_fifo,
    input   logic               pop_fifo,
    input   logic               rdreq_fifo,
    input   logic               data_valid,
    input   logic [WIDTH-1:0]   data,
    output  logic               result_valid,
    output  logic [WIDTH-1:0]   result
);
            logic               adder_result_valid;
            logic [WIDTH-1:0]   src_fifo_q, src_fifo_data, adder_result;
            logic               src_fifo_wrreq, src_fifo_rdreq;

    fp_add                      # (
                                    .EXP(EXP),
                                    .MANT(MANT),
                                    .WIDTH(WIDTH),
                                    .EXTRA_PIPELINE(EXTRA_PIPELINE)
                                )
                                adder (
                                    .clock(clock),
                                    .clock_sreset(clock_sreset),
                                    .data_valid(data_valid & ~push_fifo),
                                    .dataa(data),
                                    .datab(src_fifo_q),
                                    .result_valid(adder_result_valid),
                                    .result(adder_result)
                                );
    
    fifo                        # (
                                    .WIDTH(WIDTH),
                                    .DEPTH(FIFO_DEPTH)
                                )
                                src_fifo (
                                    .clock(clock),
                                    .clock_sreset(clock_sreset),
                                    .data (src_fifo_data),
                                    .rdreq (src_fifo_rdreq),
                                    .wrreq (src_fifo_wrreq),
                                    .q (src_fifo_q)
                                );
                                
    always_comb begin
        result = src_fifo_q;
        src_fifo_wrreq = adder_result_valid;
        src_fifo_data = adder_result;
        src_fifo_rdreq = data_valid;
        if (push_fifo) begin
            src_fifo_wrreq = data_valid;
            src_fifo_data = data;
        end
        if (pop_fifo) begin
            src_fifo_rdreq = rdreq_fifo;
        end
    end
    
endmodule
