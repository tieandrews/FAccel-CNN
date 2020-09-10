module softmax # (
            parameter               CH = 10
)
(
    input   logic                   clock,
    input   logic                   clock_sreset,
    input   logic                   data_valid,
    input   logic [CH-1:0][15:0]    data,
    output  logic [15:0]            result
);
            
            logic [15:0]            max;
            logic [31:0]            fp_exp_result;
            logic [16:0]            fp_exp_latency;
            logic                   fp_exp_result_valid;

    fp_exp                          (
                                        .clock(clock),
                                        .data({data, 16'h0}),
                                        .result(fp_exp_result)
                                    );
                                    
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            fp_exp_latency <= 17'h0;
        end
        else begin
            {fp_exp_result_valid, fp_exp_latency} <= {fp_exp_latency, data_valid};
        end
    end

endmodule
