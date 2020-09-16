module lvds_input_integrator # (
            parameter           WIDTH = 5
)
(
    input   logic               clock,
    input   logic               lvds_in,
    output  logic               integrator_out,
    output  logic [WIDTH-1:0]   data_out,
    output  logic               data_out_valid
);

            logic [WIDTH-1:0]   bit_counter, counter;
            logic [1:0]         lvds_sample;

    always_comb begin
        integrator_out = lvds_sample[1];
    end
    always_ff @ (posedge clock) begin
        lvds_sample[0] <= lvds_in;
        lvds_sample[1] <= lvds_sample[0];
        
        bit_counter <= {WIDTH{~data_out_valid}} & (bit_counter + lvds_sample[1]);
        counter <= counter + {{WIDTH-1{1'b0}}, 1'b1};
    end
    
    assign data_out = bit_counter;
    assign data_out_valid = &counter;

endmodule
