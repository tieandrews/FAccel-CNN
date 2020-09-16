module pad_video # (
            parameter               WIDTH = 16,
            parameter               FIFO_DEPTH = 512,
            parameter               WIDTHF = $clog2(FIFO_DEPTH)
)
(
    input   logic                   clock,
    input   logic                   clock_sreset,   // glitch free synchronous reset in 'clock' domain
    
    input   logic                   go,
    output  logic                   busy,
    input   logic [11:0]            xres,
    input   logic [11:0]            yres,
    input   logic [2:0]             pad,

    output  logic                   fifo_rdreq,
    input   logic [WIDTHF-1:0]      fifo_usedw,
    input   logic [WIDTH-1:0]       fifo_q,
    
    output  logic                   conv_enable_calc,
    output  logic                   conv_data_shift,
    output  logic [WIDTH-1:0]       conv_data
);

            localparam              ONE = 128'h1;
            localparam              ZERO = 128'h0;
            localparam              DONTCARE = {128{1'bx}};
    enum    logic [2:0]             {S1, S2, S3} fsm;
            logic [11:0]            xres_reg, yres_reg, xres_count, yres_count;
            logic [2:0]             pad_reg;
            logic                   read_latency;
            logic                   go_flag, busy_flag;
    
    always_comb begin
        fifo_rdreq = 1'b0;
        case (fsm)
            S3 : begin
                fifo_rdreq = (xres_count >= pad_reg) && (xres_count < (pad_reg + xres_reg));
            end
            default;
        endcase
    end
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            xres_reg <= DONTCARE[11:0];
            yres_reg <= DONTCARE[11:0];
            pad_reg <= DONTCARE[2:0];
            conv_data_shift <= 1'b0;
            conv_enable_calc <= 1'b0;
            fsm <= S1;
        end
        else begin
            case (fsm)
                S1 : begin
                    xres_reg <= xres;
                    yres_reg <= yres;
                    pad_reg <= pad;
                    if (go) begin
                        busy <= 1'b1;
                        fsm <= S2;
                    end
                    else begin
                        busy <= 1'b0;
                    end
                end
                S2 : begin  // pad top line(s)
                    conv_data <= ZERO[WIDTH-1:0];
                    if (xres_count >= ((pad_reg << 1) + xres_reg - ONE[11:0])) begin
                        xres_count <= ZERO[11:0];
                        if (yres_count >= (pad_reg - ONE[11:0])) begin
                            conv_data_shift <= 1'b0;
                            if (fifo_usedw >= xres_reg) begin
                                fsm <= S3;
                            end
                        end
                        else begin
                            conv_data_shift <= 1'b1;
                            yres_count <= yres_count + ONE[11:0];
                        end
                    end
                    else begin
                        conv_data_shift <= 1'b1;
                        xres_count <= xres_count + ONE[11:0];
                    end
                end
                S3 : begin  // burst featuremap padded line
                    conv_data <= fifo_q;
                    if (xres_count >= ((pad_reg << 1) + xres_reg - ONE[11:0])) begin
                        conv_data_shift <= 1'b0;
                        conv_enable_calc <= 1'b0;
                        if (fifo_usedw >= xres_reg) begin
                            xres_count <= ZERO[11:0];
                            if (yres_count >= (pad_reg + yres_reg - ONE[11:0])) begin
                                fsm <= S1;
                            end
                            else begin
                                yres_count <= yres_count + ONE[11:0];
                            end
                        end
                    end
                    else begin
                        conv_data_shift <= 1'b1;
                        conv_enable_calc <= fifo_rdreq;
                        xres_count <= xres_count + ONE[11:0];
                    end
                end
            endcase
        end
    end

endmodule
