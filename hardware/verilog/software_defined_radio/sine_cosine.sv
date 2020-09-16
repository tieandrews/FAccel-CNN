module sine_cosine # (
            parameter                       WIDTH = 16, // width of sine cosine output
            parameter                       WIDTHT = 11,    // width theta input (4 * LUT)
            parameter                       FILE = "quarter_wave_64.hex"
)
(
    input   logic                           clock,
    input   logic                           clock_sreset,
    input   logic           [WIDTHT-1:0]    theta,
    input   logic                           enable,
    output  logic signed    [WIDTH-1:0]     sine_out,
    output  logic signed    [WIDTH-1:0]     cosine_out,
    output  logic                           out_valid
);
            localparam                      SIZET = (2 ** (WIDTHT - 2));
            logic [WIDTHT-1:0]              theta_reg;
            logic [1:0]                     theta_sign[1:0];
            logic signed [WIDTH-1:0]        ram_table[0:SIZET-1], ram_dataa, ram_datab;
            logic [WIDTHT-3:0]              sine_address, cosine_address;
            logic [3:0]                     valid_pipe;
            
    initial begin
        $readmemh(FILE, ram_table);
    end
    
    always_ff @ (posedge clock) begin
        ram_dataa <= ram_table[sine_address];
        ram_datab <= ram_table[cosine_address];
    end
    
    assign out_valid = valid_pipe[3];

    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            theta_reg <= {WIDTHT{1'b0}};
            sine_address <= {WIDTHT-2{1'b0}};
            cosine_address <= {WIDTHT-2{1'b0}};
            sine_out <= {WIDTH{1'b0}};
            cosine_out <= {WIDTH{1'b0}};
            theta_sign[0] <= 2'b00;
            theta_sign[1] <= 2'b00;
            valid_pipe <= 4'b00;
        end
        else begin
            valid_pipe <= {valid_pipe[2:0], enable};    
            if (enable) begin
                theta_reg <= theta;
                
                theta_sign[0] <= theta_reg[WIDTHT-1:WIDTHT-2];
                theta_sign[1] <= theta_sign[0];
                
                sine_address <= {WIDTHT-2{theta_reg[WIDTHT-2]}} ^ theta_reg[WIDTHT-3:0];
                cosine_address <= {WIDTHT-2{~theta_reg[WIDTHT-2]}} ^ theta_reg[WIDTHT-3:0];
                
                sine_out <= theta_sign[1][1] ? -ram_dataa : ram_dataa;
                cosine_out <= ^theta_sign[1] ? -ram_datab : ram_datab;
            end
        end
    end
endmodule
