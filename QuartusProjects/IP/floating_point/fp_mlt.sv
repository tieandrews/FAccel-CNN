module fp_mlt # (
            parameter           EXP = 8,
            parameter           MANT = 7,
            parameter           WIDTH = EXP + MANT + 1
)
(
    input   logic               clock,
    input   logic               clock_sreset,
    input   logic               data_valid,
    input   logic [WIDTH-1:0]   dataa,
    input   logic [WIDTH-1:0]   datab,
    output  logic               result_valid,
    output  logic [WIDTH-1:0]   result
);
            localparam          BIAS = (1 << (EXP - 1)) - 1;
            localparam          WIDTH2M = (MANT + 1) * 2;

            integer             i;
            
            logic [EXP:0]       ea, eb, er, delta;
            logic [MANT:0]      ma, mb, mr, zero_count;
            logic [WIDTH2M-1:0] mult, shift;
            logic               sa, sb;
            logic               azero, bzero;
            
lpm_mult    # (
                .lpm_type("lpm_mult"),
                .lpm_widtha(MANT + 1),
                .lpm_widthb(MANT + 1),
                .lpm_widths(1),
                .lpm_widthp(WIDTH2M),
                .lpm_representation("UNSIGNED"),
                .lpm_pipeline(0),
                .lpm_hint("UNUSED")
            )
            multiply (
                .result(mult), 
                .dataa(ma),
                .datab(mb),
                .sum(1'b0),
                .clock(),
                .clken(1'b1),
                .aclr()
            );
            
    always_comb begin
        // check for one input zero ignoring sign
        azero = ~|dataa[WIDTH-2:0];
        bzero = ~|datab[WIDTH-2:0];
        
        // assign sign, exponent, mantissa
        {sa, ea, ma} = {dataa[WIDTH-1], {1'b0, dataa[WIDTH-2:MANT]}, {~azero, dataa[MANT-1:0]}};
        {sb, eb, mb} = {datab[WIDTH-1], {1'b0, datab[WIDTH-2:MANT]}, {~bzero, datab[MANT-1:0]}};
        
        // calculate new exponent
        er = (ea - BIAS[EXP-1:0]) + eb + mult[WIDTH2M-1];
        shift = (mult << ~mult[WIDTH2M-1]);
    end
    
    always_ff @ (posedge clock) begin
        result_valid <= data_valid & ~clock_sreset;
        result[WIDTH-1] <= (sa ^ sb) & (~azero | ~bzero);
        result[WIDTH-2:MANT] <= er[EXP-1:0] & ~{EXP{azero | bzero}};
        result[MANT-1:0] <= shift[WIDTH2M-2:WIDTH2M-MANT-1] & ~{MANT{azero | bzero}};
    end
        
endmodule
