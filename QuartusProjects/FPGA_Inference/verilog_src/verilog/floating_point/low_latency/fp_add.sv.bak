// +FHDR------------------------------------------------------------------------
// My detail and (C) notice
// -----------------------------------------------------------------------------
// FILE NAME : fp_add
// DEPARTMENT :
// AUTHOR : Steven Groom
// AUTHOR’S EMAIL : steve@bems.se
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION DATE AUTHOR DESCRIPTION
// 1.0 2020-07-31 Steven Groom
// -----------------------------------------------------------------------------
// KEYWORDS : 
// -----------------------------------------------------------------------------
// PURPOSE : a non-compliant floating point adder, no NaN's etc
// designed to be small and fast for machine learning
// [s] [eeeeee] [mmmmmmm] mantissa has implied leading 1 unless mantissa and exponent is zero.
// -----------------------------------------------------------------------------
// PARAMETERS
// PARAM NAME RANGE : DESCRIPTION : DEFAULT : UNITS
// e.g.DATA_WIDTH [32,16] : width of the data : 32 :
// EXP [1-?] : width of exponent value : 8 :
// MANT [1-?] : width of mantissa : 7
// WIDTH [3-?] : width of float : 1(sign) + EXP + MANT
// EXTRA_PIPELINE [0-2] : extra pipeline stages in adder : 2 : 1 is mid-pipe 2 is front-end and mid-pipe
// -----------------------------------------------------------------------------
// REUSE ISSUES
// Reset Strategy : fully synchronous - clock_sreset
// Clock Domains : one domain - clock
// Critical Timing :
// Test Features :
// Asynchronous I/F :
// Scan Methodology :
// Instantiations :
// Synthesizable (y/n) : y
// Other :
// -FHDR------------------------------------------------------------------------
//
module fp_add # (
            parameter           EXP = 5,
            parameter           MANT = 10,
            parameter           WIDTH = EXP + MANT + 1,
            parameter           EXTRA_PIPELINE = 2
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
            logic [WIDTH-1:0]   dataa_reg, datab_reg;
            logic               data_valid_pipe_reg;
            logic               sa, sa_reg, sb, sb_reg, data_valid_reg;
            logic               sr, swap, azero, bzero, expb_gt_expa, expb_eq_expa;
            
    generate
        if (EXTRA_PIPELINE == 2) begin
            always_ff @ (posedge clock) begin
                dataa_reg <= dataa;
                datab_reg <= datab;
                data_valid_pipe_reg <= data_valid & ~clock_sreset;
            end
        end
        else begin
            assign dataa_reg = dataa;
            assign datab_reg = datab;
            assign data_valid_pipe_reg = data_valid & ~clock_sreset;
        end
    endgenerate
            
    always_comb begin
        // check for one input zero
        azero = ~|dataa_reg[WIDTH-2:0]; // sign of float ignored
        bzero = ~|datab_reg[WIDTH-2:0];
        
        sa = dataa_reg[WIDTH-1];
        ea = dataa_reg[WIDTH-2:WIDTH-EXP-1];
        ma = {~azero, dataa_reg[MANT-1:0]};

        sb = datab_reg[WIDTH-1];
        eb = datab_reg[WIDTH-2:WIDTH-EXP-1];
        mb = {~bzero, datab_reg[MANT-1:0]};
        
        // compare exponents
        expb_gt_expa = (eb > ea);
        expb_eq_expa = (eb == ea);
        
        // swap if datab > dataa
        swap = expb_gt_expa || (expb_eq_expa && (datab_reg[MANT-1:0] > dataa_reg[MANT-1:0]));
        if (swap) begin
            {sa, ea, ma} = {datab_reg[WIDTH-1], datab_reg[WIDTH-2:WIDTH-1-EXP], ~bzero, datab_reg[MANT-1:0]};
            {sb, eb, mb} = {dataa_reg[WIDTH-1], dataa_reg[WIDTH-2:WIDTH-1-EXP], ~azero, dataa_reg[MANT-1:0]};
        end
        
        // find exponent distance and hence shift distance to align exponents
        delta = ea - eb;
        
    end
    
    // optionally pipeline halfway point of logic chain
    generate
        if (EXTRA_PIPELINE >= 1) begin
            always_ff @ (posedge clock) begin
                data_valid_reg <= data_valid_pipe_reg & ~clock_sreset;
                ma_reg <= ma;
                mb_shift <= mb >> delta;
                sa_reg <= sa;
                sb_reg <= sb;
                ea_reg <= ea;
            end
        end
        else begin
            always_comb begin
                data_valid_reg = data_valid_pipe_reg & ~clock_sreset;
                ma_reg = ma;
                mb_shift = mb >> delta;
                sa_reg = sa;
                sb_reg = sb;
                ea_reg = ea;
            end
        end
    endgenerate

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
        result_valid <= data_valid_reg & ~clock_sreset;
        result <= {sr, er, mr[MANT:1]};
    end

endmodule
