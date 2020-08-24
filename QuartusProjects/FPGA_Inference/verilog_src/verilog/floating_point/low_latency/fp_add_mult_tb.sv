`timescale 1ns/1ns

module fp_add_mult_tb();

    integer         i;
    logic           clock, clock_sreset;
    
    always #10 clock = ~clock;
    
    initial begin
        clock = 1'b0;
        clock_sreset = 1'b0;
        for (i=0; i<5; i++) begin
            @ (posedge clock);
        end
        clock_sreset = 1'b1;
        @ (posedge clock);
        clock_sreset = 1'b0;
    end

    logic [7:0][15:0]   mlt_result, kernel, buffer;
    logic [15:0]        add_result;
    logic               mlt_data_valid, mlt_result_valid[7:0];
    logic [7:0]         state, count;

    

    genvar j;
    generate
        for (j=0; j<8; j++) begin : m
            fp_mlt          # (
                                .EXP(8),
                                .MANT(7),
                                .WIDTH(16)
                            )
                            fp_mlt (
                                .clock(clock),
                                .clock_sreset(clock_sreset),
                                .data_valid(mlt_data_valid),
                                .dataa(kernel[j]),
                                .datab(buffer[j]),
                                .result_valid(mlt_result_valid[j]),
                                .result(mlt_result[j])
                            );
        end
    endgenerate

    fp_add_tree     # (
                        .EXP(8),
                        .MANT(7),
                        .WIDTH(16),
                        .ITEMS(8)
                    )
                    fp_add (
                        .clock(clock),
                        .clock_sreset(clock_sreset),
                        .data_valid(mlt_result_valid[0]),
                        .data(mlt_result),
                        .result_valid(add_result_valid),
                        .result(add_result)
                    );
                
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            mlt_data_valid <= 1'b0;
            state <= 0;
        end
        else begin
            case (state)
                0 : begin
                    kernel <= {16'h3f8e, 16'h400e, 16'h4055, 16'h408e,
                                16'h40b1, 16'h40d5, 16'h40f8, 16'h410e};

                    buffer <= {16'h411f, 16'h4121, 16'h4131, 16'h4141,
                                16'h4152, 16'h4162, 16'h4172, 16'h4181};
                    mlt_data_valid <= 1'b1;
                    state <=  state + 1;
                end
                1 : begin
                    mlt_data_valid <= 1'b0;
                end
            endcase
        end
    end

endmodule
