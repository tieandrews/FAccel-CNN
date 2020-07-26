`timescale 1ns/1ns

module zero_count_tb();

    integer     i;
    logic       clock;

    logic [4:0] distance;
    logic [23:0] result, data;
    
    always #10 clock = ~clock;
    
    initial begin
        clock = 1'b0;
        for (i=0; i<2048; i++) begin
            data = i;
            @ (posedge clock);
        end
    end

    zero_count      # (
                        .WIDTH(24),
                        .WIDTHR(5),
                        .REGISTERED(0)
                    )
                    dut (
                        .clock(clock),
                        .data(data),
                        .distance(distance),
                        .result(result)
                    );

endmodule
