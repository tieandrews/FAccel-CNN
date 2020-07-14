// [s]  [eeeeee] [mmmmmmm] mantissa has implied leading 1 unless mantissa and exponent is zero.
module fp_add # (
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
            localparam          ZERO = 128'h0;
            localparam          ONE = 128'h1;
            localparam          WIDTHM = $clog2(MANT+2);
            integer             i;
            logic [EXP-1:0]     ea, ea_reg, eb, er, delta;
            logic [WIDTHM-1:0]  zero_count;
            logic [MANT:0]      ma, ma_reg, mb, mb_shift, mr;
            logic [MANT+1:0]    sum, mr_zc;
            logic               sa, sa_reg, sb, sb_reg, data_valid_reg;
            logic               sr, swap, azero, bzero, expb_gt_expa, expb_eq_expa;
    always_comb begin
        // check for one input zero
        azero = ~|dataa[WIDTH-2:0]; // sign of zero ignored
        bzero = ~|datab[WIDTH-2:0];
        
        sa = dataa[WIDTH-1];
        ea = dataa[WIDTH-2:WIDTH-EXP-1];
        ma = {~azero, dataa[MANT-1:0]};

        sb = datab[WIDTH-1];
        eb = datab[WIDTH-2:WIDTH-EXP-1];
        mb = {~bzero, datab[MANT-1:0]};
        
        // compare exponents
        expb_gt_expa = (eb > ea);
        expb_eq_expa = (eb == ea);
        
        // swap if datab > dataa
        swap = expb_gt_expa || (expb_eq_expa && (datab[MANT-1:0] > dataa[MANT-1:0]));
        if (swap) begin
            {sa, ea, ma} = {datab[WIDTH-1], datab[WIDTH-2:WIDTH-1-EXP], ~bzero, datab[MANT-1:0]};
            {sb, eb, mb} = {dataa[WIDTH-1], dataa[WIDTH-2:WIDTH-1-EXP], ~azero, dataa[MANT-1:0]};
        end
        
        // find exponent distance and hence shift distance to align exponents
        delta = ea - eb;
        
    end
    
    // pipeline halfway point of logic chain
    always_ff @ (posedge clock) begin
        ma_reg <= ma;
        mb_shift <= mb >> delta;
        sa_reg <= sa;
        sb_reg <= sb;
        ea_reg <= ea;
    end

    // add or subtract normalised mantissas
    always_comb begin
        if (sa_reg ~^ sb_reg) begin
            sum = {1'b0, ma_reg} + {1'b0, mb_shift};
        end
        else begin
            sum = {1'b0, ma_reg} - {1'b0, mb_shift};
        end
    end
        
    zero_count      # (
                        .WIDTH(MANT+2),
                        .WIDTHR(WIDTHM),
                        .REGISTERED(0)
                    )
                    zc (
                        .clock(),
                        .data(sum),
                        .distance(zero_count),
                        .result(mr_zc)
                    );
    
    // construct result
    always_comb begin
        sr = sa_reg;
        er = (ea_reg - zero_count + 1'b1);
        mr = mr_zc[MANT:0];
        if (~|sum) begin
            {sr, er, mr} = ZERO[WIDTH:0];
        end
    end
    
    // register the final output
    always_ff @ (posedge clock) begin
        data_valid_reg <= data_valid & ~clock_sreset;
        result_valid <= data_valid_reg & ~clock_sreset;
        result <= {sr, er, mr[MANT:1]};
    end

endmodule
