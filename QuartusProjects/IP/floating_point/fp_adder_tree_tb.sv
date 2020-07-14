`timescale 1ns/1ns
module fp_adder_tree_tb();
    integer             i;
    logic               clock, clock_sreset;
    
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
    
    logic [31:0][15:0]       data;
    logic                   data_valid, result_valid;
    logic [15:0]            result;
    
    fp_add_tree             # (
                                .EXP(8),
                                .MANT(7),
                                .WIDTH(16),
                                .ITEMS(32)
                            )
                            dut (
                                .clock(clock),
                                .clock_sreset(clock_sreset),
                                .data_valid(data_valid),
                                .data(data),
                                .result_valid(valid),
                                .result(result)
                            );
                            
    logic [7:0]             state;
                            
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            data_valid <= 1'b0;
            data <= {32*16{1'b0}};
            state <= 8'h0;
        end
        else begin
            case (state)
                0 : begin
                    data_valid <= 1'b1;
                    data[0] <= 16'h400e;
                    data[27] <= 16'h3f8e;
                    state++;
                end
                1 : begin
                    data_valid <= 1'b1;
                    data[0] <= 16'h4055;
                    data[27] <= 16'h408e;
                    state++;
                end
                2 : begin
                    data_valid <= 1'b0;
                end
            endcase
        end
    end
    
endmodule
