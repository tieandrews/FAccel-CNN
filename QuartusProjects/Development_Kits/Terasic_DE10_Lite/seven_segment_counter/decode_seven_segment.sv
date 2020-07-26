module decode_seven_segment (
    input   logic [3:0]     bcd_in,
    output  logic [7:0]     segments
);
    always_comb begin
        case (bcd_in)
            4'h0 : segments = ~8'b0011_1111;    // invert final bit pattern due to board
            4'h1 : segments = ~8'b0000_0110;
            4'h2 : segments = ~8'b0101_1011;
            4'h3 : segments = ~8'b0100_1111;
            4'h4 : segments = ~8'b0110_0110;
            4'h5 : segments = ~8'b0110_1101;
            4'h6 : segments = ~8'b0111_1101;
            4'h7 : segments = ~8'b0000_0111;
            4'h8 : segments = ~8'b0111_1111;
            default : segments = ~8'b0110_1111;
        endcase
    end

endmodule
