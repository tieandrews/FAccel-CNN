module nco_16lut # (
            parameter                   WIDTH = 16,
            parameter                   WIDTHA = 64     // width accumulator
)
(
    input   logic                       clock,
    input   logic                       clock_sreset,
    input   logic [WIDTHA-1:0]          phase_increment,
    output  logic signed [WIDTH-1:0]    sine_out,
    output  logic signed [WIDTH-1:0]    cosine_out
);

            logic [WIDTHA-1:0]          phase_accumulator;

    always_ff @ (posedge clock) begin
        if (clock_sreset) begin 
            phase_accumulator <= {WIDTH{1'b0}};
        end
        else begin
            phase_accumulator <= phase_accumulator + phase_increment;
        end
    end
            
    sine_cosine_16lut                   # (
                                            .WIDTH(WIDTH)
                                        )
                                        lut (
                                            .clock(clock),
                                            .clock_sreset(clock_sreset),
                                            .theta(phase_accumulator[WIDTHA-1:WIDTHA-6]),
                                            .sine_out(sine_out),
                                            .cosine_out(cosine_out)
                                        );
                                        
endmodule
