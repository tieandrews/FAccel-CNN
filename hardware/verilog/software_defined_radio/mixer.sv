module mixer # (
            parameter                   WIDTH = 12
)
(
    input   logic                       clock,
    input   logic                       clock_sreset,
    input   logic signed [WIDTH-1:0]    data_in,
    input   logic                       data_in_valid,
    input   logic signed [WIDTH-1:0]    sine_in,
    input   logic signed [WIDTH-1:0]    cosine_in,
    output  logic signed [WIDTH-1:0]    sine_out,
    output  logic signed [WIDTH-1:0]    cosine_out,
    output  logic                       out_valid
);
            localparam                  WIDTHD = (WIDTH * 2);
            localparam                  MULT_PIPE = 2;
            logic signed [WIDTH-1:0]    data_reg;
            logic signed [WIDTHD-1:0]   sine_prod, cosine_prod;
            logic [MULT_PIPE-1:0]       valid_pipe;
            
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            valid_pipe <= {MULT_PIPE{1'b0}};
        end
        else begin
            if (MULT_PIPE < 2) 
                valid_pipe[0] <= data_in_valid;
            else
                valid_pipe <= {valid_pipe[MULT_PIPE-2:0], data_in_valid};
        end
    end
    
    assign out_valid = valid_pipe[MULT_PIPE-1];
    
	lpm_mult	# (
                    .lpm_pipeline(MULT_PIPE),
                    .lpm_widtha(WIDTH),
                    .lpm_widthb(WIDTH),
                    .lpm_widths(1),
                    .lpm_representation("SIGNED"),
                    .lpm_widthp(WIDTHD)
                )
                mult_sine (
                    .clock(clock),
                    .aclr(1'b0),
                    .clken(data_in_valid),
                    .dataa(data_in),
                    .datab(sine_in),
                    .sum(1'b0),
                    .result(sine_prod)
                );

	lpm_mult	# (
                    .lpm_pipeline(MULT_PIPE),
                    .lpm_widtha(WIDTH),
                    .lpm_widthb(WIDTH),
                    .lpm_widths(1),
                    .lpm_representation("SIGNED"),
                    .lpm_widthp(WIDTHD)
                )
                mult_cosine (
                    .clock(clock),
                    .aclr(1'b0),
                    .clken(data_in_valid),
                    .dataa(data_in),
                    .datab(cosine_in),
                    .sum(1'b0),
                    .result(cosine_prod)
                );
                
    assign sine_out = sine_prod[WIDTH-1:0];
    assign cosine_out = cosine_prod[WIDTH-1:0];
                
endmodule
