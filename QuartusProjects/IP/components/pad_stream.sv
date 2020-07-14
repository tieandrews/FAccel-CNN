module pad_stream # (
            parameter           PAD = 1,
            parameter           WIDTH = 16
)
(
    input   logic               clock,
    input   logic               clock_sreset,
    
    input   logic [3:0]         s_address,
    input   logic [31:0]        s_writedata,
    output  logic [31:0]        s_readdata,
    input   logic               s_read,
    input   logic               s_write,
    output  logic               s_waitrequest,
    
    output  logic               si_ready,
    input   logic               si_valid,
    input   logic               si_sop,
    input   logic               si_eop,
    input   logic [WIDTH-1:0]   si_data,
    
    input   logic               so_ready,
    output  logic               so_valid,
    output  logic               so_sop,
    output  logic               so_eop,
    output  logic [WIDTH-1:0]   so_data
);
            localparam          DONTCARE = {128{1'bx}};
    enum    logic [7:0]         {S1, S2, S3, S4, S5, S6, S7, S8} fsm;
            logic [11:0]        xres_reg, yres_reg;
            logic [11:0]        count_x, count_y;
            logic               si_ready_reg, read_latency;
            wire                pad_y = ((count_y < PAD[11:0]) || (count_y >= (yres_reg + PAD[11:0])));
            wire                pad_x = ((count_x < PAD[11:0]) || (count_x >= (xres_reg + PAD[11:0])));
            
    always_comb begin
        s_waitrequest = s_write ? 1'b0 : (s_read ? ~read_latency : 1'b0);
    end
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            xres_reg <= DONTCARE[11:0];
            yres_reg <= DONTCARE[11:0];
            read_latency <= 1'b0;
        end
        else begin
            read_latency <= read_latency ? 1'b0 : s_read;
            if (s_address == 4'h1) begin
                s_readdata <= xres_reg;
                if (s_write) begin
                    xres_reg <= s_writedata[11:0];
                end
            end
            if (s_address == 4'h2) begin
                s_readdata <= yres_reg;
                if (s_write) begin
                    yres_reg <= s_writedata[11:0];
                end
            end
        end
    end

    always_comb begin
        si_ready = 1'b0;
        case (fsm)
            S2 : begin
                si_ready = ~(pad_x | pad_y) & so_ready;
            end
            default;
        endcase
    end
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            so_sop <= 1'b0;
            so_eop <= 1'b0;
            so_valid <= 1'b0;
            count_x <= DONTCARE[11:0];
            count_y <= DONTCARE[11:0];
            si_ready_reg <= 1'b0;
            fsm <= S1;
        end
        else begin
            si_ready_reg <= si_ready;
            case (fsm)
                S1 : begin
                    count_x <= 12'h0;
                    count_y <= 12'h0;
                    fsm <= S2;
                end
                S2 : begin
                    if (pad_x | pad_y) begin
                        so_valid <= so_ready;
                        so_data <= 16'h0;
                        so_sop <= (count_x == 0) && (count_y == 0);
                    end
                    else begin
                        so_valid <= si_valid & si_ready_reg & so_ready;
                        so_data <= si_data;
                    end
                    if (so_ready & ((pad_x | pad_y) | (si_ready_reg & si_valid))) begin
                        if (count_x >= (xres_reg + ((PAD[11:0] << 1) - 1))) begin
                            count_x <= 12'h0;
                            if (count_y >= (yres_reg + ((PAD[11:0] << 1) - 1))) begin
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
