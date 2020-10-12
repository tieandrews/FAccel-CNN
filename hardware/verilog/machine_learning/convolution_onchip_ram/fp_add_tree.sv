// +FHDR------------------------------------------------------------------------
// My detail and (C) notice
// -----------------------------------------------------------------------------
// FILE NAME : fp_add_tree
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
// PURPOSE : a non-compliant floating point binary adder tree, no NaN's etc
// designed to be small and fast for machine learning
// [s] [eeeeee] [mmmmmmm] mantissa has implied leading 1 unless mantissa and exponent is zero.
// -----------------------------------------------------------------------------
// PARAMETERS
// PARAM NAME RANGE : DESCRIPTION : DEFAULT : UNITS
// e.g.DATA_WIDTH [32,16] : width of the data : 32 :
// EXP [1-?] : width of exponent value : 8 :
// MANT [1-?] : width of mantissa : 7
// ITEMS [1-2**n] : 2**n only width of adder tree : 32
// WIDTH [3-?] : width of float : 1(sign) + EXP + MANT
// EXTRA_PIPELINE [0-2] : extra pipeline stages in adder : 2 : 1 is mid-pipe 2 is front-end and mid-pipe
// -----------------------------------------------------------------------------
// REUSE ISSUES
// Reset Strategy : fully synchronous - clock_sreset
// Clock Domains : one - clock
// Critical Timing :
// Test Features :
// Asynchronous I/F :
// Scan Methodology :
// Instantiations :
// Synthesizable (y/n) : y
// Other :
// -FHDR------------------------------------------------------------------------
module fp_add_tree # (
            parameter                       EXP = 8,
            parameter                       MANT = 7,
            parameter                       ITEMS = 32,
            parameter                       WIDTH = 1 + EXP + MANT,
            parameter                       EXTRA_PIPELINE = 0
)
(
    input   logic                           clock,
    input   logic                           clock_sreset,
    input   logic                           data_valid,
    input   logic [ITEMS-1:0][WIDTH-1:0]    data,
    output  logic                           result_valid,
    output  logic [WIDTH-1:0]               result
);
            localparam                      HALF = (ITEMS / 2);
            localparam                      WIDTHH = (ITEMS - HALF);
            localparam                      ZERO = {WIDTH{1'b0}};
    generate
        begin
            if (ITEMS == 2) begin   // only one branch?
                fp_add                     # (
                                                .EXP(EXP),
                                                .MANT(MANT),
                                                .WIDTH(WIDTH),
                                                .EXTRA_PIPELINE(EXTRA_PIPELINE)
                                            )
                                            addera (
                                                .clock(clock),
                                                .clock_sreset(clock_sreset),
                                                .data_valid(data_valid),
                                                .dataa(data[0]),
                                                .datab(data[1]),
                                                .result_valid(result_valid),
                                                .result(result)
                                            );
            end
            if (ITEMS > 2) begin // keep halving the tree
                logic [WIDTH-1:0]           resulta, resultb;
                logic                       resulta_valid;
                fp_add_tree                 # (
                                                .EXP(EXP),
                                                .MANT(MANT),
                                                .ITEMS(HALF),
                                                .EXTRA_PIPELINE(EXTRA_PIPELINE)
                                            )
                                            addera (
                                                .clock(clock),
                                                .clock_sreset(clock_sreset),
                                                .data_valid(data_valid),
                                                .data(data[ITEMS-1:WIDTHH]),
                                                .result_valid(resulta_valid),
                                                .result(resulta)
                                            );
                fp_add_tree                 # (
                                                .EXP(EXP),
                                                .MANT(MANT),
                                                .ITEMS(WIDTHH),
                                                .EXTRA_PIPELINE(EXTRA_PIPELINE)
                                            )
                                            adderb (
                                                .clock(clock),
                                                .clock_sreset(clock_sreset),
                                                .data_valid(),
                                                .data(data[WIDTHH-1:0]),
                                                .result_valid(),
                                                .result(resultb)
                                            );
                fp_add                      # (
                                                .EXP(EXP),
                                                .MANT(MANT),
                                                .WIDTH(WIDTH),
                                                .EXTRA_PIPELINE(EXTRA_PIPELINE)
                                            )
                                            adderc (
                                                .clock(clock),
                                                .clock_sreset(clock_sreset),
                                                .data_valid(resulta_valid),
                                                .dataa(resulta),
                                                .datab(resultb),
                                                .result_valid(result_valid),
                                                .result(result)
                                            );
         end
      end
   endgenerate

endmodule
