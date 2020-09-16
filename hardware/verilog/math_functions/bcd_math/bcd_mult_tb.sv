`timescale 1ns/1ns
module bcd_mult_tb();
    integer         i;
    logic           clock, clock_sreset;
    logic [7:0]     result;
    
    always #20 clock = ~clock;
    
    initial begin
        clock = 1'b0;
        clock_sreset = 1'b0;
        for (i=0; i<5; i++)
            @ (posedge clock);
        clock_sreset = 1'b1;
        @ (posedge clock);
        clock_sreset = 1'b0;
    end

    bcd_mult    dut (
                    .clock(clock),
                    .clock_sreset(clock_sreset),
                    .data_valid(1'b0),
                    .dataa(4'h4),
                    .datab(4'h7),
                    .result_valid(),
                    .result(result)
                );

endmodule
