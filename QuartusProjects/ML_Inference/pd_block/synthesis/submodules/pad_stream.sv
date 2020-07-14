module pad_stream # (
            parameter           PAD = 1
)
(
    input   logic               clock,
    input   logic               clock_sreset,
    
    output  logic               si_ready,
    input   logic               si_valid,
    input   logic               si_sop,
    input   logic               si_eop,
    input   logic [15:0]        si_data,
    
    input   logic               so_ready,
    output  logic               so_valid,
    output  logic               so_sop,
    output  logic               so_eop,
    output  logic [15:0]        so_data
);
            localparam          DONTCARE = {128{1'bx}};
    enum    logic [7:0]         {S1, S2, S3, S4, S5, S6, S7, S8} fsm;
            logic [11:0]        xres, yres, count_x, count_y;
            logic               si_ready_reg;
            wire                pad_y = ((count_y < PAD[11:0]) || (count_y >= (yres + PAD[11:0])));
            wire                pad_x = ((count_x < PAD[11:0]) || (count_x >= (xres + PAD[11:0])));

    always_comb begin
        si_ready = 1'b0;
        case (fsm)
            S1, S2 : begin
                si_ready = 1'b1;
            end
            S5 : begin
                si_ready = ~(pad_x | pad_y) & so_ready;
            end
            default;
        endcase
    end
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            so_sop <= 1'bx;
            so_eop <= 1'b0;
            so_valid <= 1'b0;
            xres <= DONTCARE[11:0];
            yres <= DONTCARE[11:0];
            count_x <= DONTCARE[11:0];
            count_y <= DONTCARE[11:0];
            si_ready_reg <= 1'b0;
            fsm <= S1;
        end
        else begin
            si_ready_reg <= si_ready;
            case (fsm)
                S1 : begin
                    so_sop <= 1'b0;
                    so_eop <= 1'b0;
                    so_valid <= 1'b0;
                    xres <= si_data[11:0];
                    if (si_ready_reg & si_valid & si_sop) begin
                        fsm <= S2;
                    end
                end
                S2 : begin
                    yres <= si_data[11:0];
                    if (si_ready_reg & si_valid) begin
                        fsm <= S3;
                    end
                end
                S3 : begin
                    so_sop <= so_ready;
                    so_valid <= so_ready;
                    so_data <= xres + (PAD[11:0] << 1);
                    if (so_ready) begin
                        fsm <= S4;
                    end
                end
                S4 : begin
                    count_x <= 12'h0;
                    count_y <= 12'h0;
                    so_sop <= 1'b0;
                    so_valid <= so_ready;
                    so_data <= yres + (PAD[11:0] << 1);
                    if (so_ready) begin
                        fsm <= S5;
                    end
                end
                S5 : begin
                    if (pad_x | pad_y) begin
                        so_valid <= so_ready;
                        so_data <= 16'h0;
                    end
                    else begin
                        so_valid <= si_valid & si_ready_reg & so_ready;
                        so_data <= si_data;
                    end
                    if (so_ready & ((pad_x | pad_y) | si_ready_reg)) begin
                        if (count_x >= (xres + ((PAD[11:0] << 1) - 1))) begin
                            count_x <= 12'h0;
                            if (count_y >= (yres + ((PAD[11:0] << 1) - 1))) begin
                                so_eop <= 1'b1;
                                fsm <= S1;
                            end
                            else begin
                                count_y <= count_y + 12'h1;
                            end
                        end
                        else begin
                            count_x <= count_x + 12'h1;
                        end
                    end
                end
            endcase
        end
    end

endmodule
