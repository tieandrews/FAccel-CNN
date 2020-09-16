module next_digit # (
            parameter                   DIGITS = 6
)
(
    input   logic [DIGITS-1:0][3:0]     bcd_in,
    output  logic [DIGITS-1:0][3:0]     bcd_out
);
            integer                     i;

    always_comb begin
        bcd_out = bcd_in; // default value
        for (i=0; i<DIGITS; i++) begin
            if (bcd_in[i] >= 4'h9) begin
                bcd_out[i] = 4'h0;
            end
            else begin
                bcd_out[i] = bcd_in[i] + 4'h1;
                break;
            end
        end
    end

endmodule
