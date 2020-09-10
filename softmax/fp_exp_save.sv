module fp_exp # (
            parameter               EXP = 8,
            parameter               MANT = 7,
            parameter               WIDTH = 1 + EXP + MANT
)
(
    input   logic                   clock,
    input   logic                   clock_sreset,
    input   logic [WIDTH-1:0]       data,
    output  logic [31:0]       result
);
            
    function automatic reg [WIDTH-1:0]  i_to_f (
        input logic signed [63:0]          x
    );
        
        logic [MANT-1:0]            m;
        logic [EXP-1:0]             e;
        logic                       s;
        integer                     z, ee;
        begin
            z = 0;
            s = 1'b0;
            e = {EXP{1'b0}};
            m = {MANT{1'b0}};
            s = 1'b0;
            if (x < 0 ) begin
                x = -x;
                s = 1'b1;
            end
            if (x != 0) begin
                while (~x[63]) begin
                    x = x << 1;
                    z = z + 1;
                end
                m = x[62:63-MANT];
                ee = ((2 ** (EXP - 1)) - 1) + (63 - z);
                e = ee[EXP-1:0];
            end
            i_to_f = {s, e, m};
        end
    endfunction
    
    integer                         C1 = i_to_f(6196328019);
    logic [31:0]                    r1, mm;
        
    fp_mlt                          # (
                                        .EXP(EXP),
                                        .MANT(MANT),
                                        .WIDTH(WIDTH)
                                    )
                                    mlt1 (
                                        .clock(clock),
                                        .clock_sreset(clock_sreset),
                                        .data_valid(data_valid),
                                        .dataa(data),
                                        .datab(i_to_f(6196328019)),
                                        .result(r1)
                                    );
                                    
    always_ff @ (posedge clock) begin
        mm <= (((((((((r1[MANT-1:0] * 1277) >> 14) + 14825) * r1[MANT-1:0]) >> 14) - 79749) * r1[MANT-1:0]) >> 11) - 626);
        result <= mm[31:0];
    end

endmodule
