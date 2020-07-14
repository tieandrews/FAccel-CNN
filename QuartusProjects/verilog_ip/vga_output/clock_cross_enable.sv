module clock_cross_enable # (
            parameter           META_STAGES = 2
)
(
    input   logic               clock_1,
    input   logic               clock_1_sreset,
    input   logic               enable_1,
    output  logic               ack_1,
    
    input   logic               clock_2,
    input   logic               clock_2_sreset,
    output  logic               enable_2
);
            localparam          WIDTHM = META_STAGES;
            logic [WIDTHM-1:0]  meta_1, meta_2;
            logic               flop_1_1, flop_2_1;
            logic               flop_1_2, flop_2_2;

    //////////////////////////////////////////////////////////////////////////
    
    always_ff @ (posedge clock_1) begin // sample the ack back
        meta_2 <= {meta_2[WIDTHM-2:0], flop_2_2};
    end
    always_ff @ (posedge clock_1) begin
        if (clock_1_sreset) begin
            flop_1_1 <= 1'b0;
            flop_2_1 <= 1'b0;
        end
        else begin
            flop_1_1 <= enable_1 ^ flop_1_1;
            flop_2_1 <= meta_2[WIDTHM-1];
        end
    end
    always_comb begin
        ack_1 = flop_2_1 ^ meta_2[WIDTHM-1];
    end

    //////////////////////////////////////////////////////////////////////////

    always_ff @ (posedge clock_2) begin
        meta_1 <= {meta_1[WIDTHM-2:0], flop_1_1};
    end
    always_ff @ (posedge clock_2) begin
        if (clock_2_sreset) begin
            flop_1_2 <= 1'b0;
            flop_2_2 <= 1'b0;
        end
        else begin
            flop_1_2 <= meta_1[WIDTHM-1];
            flop_2_2 <= enable_2 ^ flop_2_2;
        end
    end
    always_comb begin
        enable_2 = flop_1_2 ^ meta_1[WIDTHM-1];
    end
    
endmodule
