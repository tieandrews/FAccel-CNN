module pad_video # (
            parameter               WIDTH = 16,
            parameter               FIFO_DEPTH = 512,
            parameter               WIDTHF = $clog2(FIFO_DEPTH)
)
(
    input   logic                   clock,
    input   logic                   clock_sreset,   // glitch free synchronous reset in 'clock' domain

    input   logic [2:0]             s_address,
    input   logic [31:0]            s_writedata,
    output  logic [31:0]            s_readdata,
    input   logic                   s_read,
    input   logic                   s_write,
    output  logic                   s_waitrequest,
    
    output  logic                   fifo_rdreq,
    input   logic [WIDTHF-1:0]      fifo_usedw,
    input   logic [WIDTH-1:0]       fifo_q,
    
    output  logic                   conv_enable_calc,
    output  logic                   conv_data_shift,
    output  logic [WIDTH-1:0]       conv_data,
    output  logic [2:0]             conv_xres_select
);

            localparam              ONE = 128'h1;
            localparam              ZERO = 128'h0;
            localparam              DONTCARE = {128{1'bx}};
    enum    logic [2:0]             {S1, S2, S3} fsm;
            logic [11:0]            xres_reg, yres_reg, xres_count, yres_count;
            logic [2:0]             pad_reg;
            logic                   read_latency;
            logic                   go_flag, busy_flag;

    // handle slave interface
    always_comb begin
        s_waitrequest = s_write ? 1'b0 : (s_read ? ~read_latency : 1'b0);
    end
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            go_flag <= 1'b0;
            read_latency <= 1'b0;
            xres_reg <= DONTCARE[11:0];
            yres_reg <= DONTCARE[11:0];
            pad_reg <= DONTCARE[2:0];
        end
        else begin
            read_latency <= read_latency ? 1'b0 : s_read;
            if (s_address == 3'h0) begin
                s_readdata <= {busy_flag, 2'b0};
                go_flag <= s_write & s_writedata[0];
            end
            else begin
                go_flag <= 1'b0;
            end
            if (s_address == 3'h1) begin    // 
                s_readdata <= xres_reg;
                if (s_write) begin
                    xres_reg <= s_writedata[11:0];
                end
            end
            if (s_address == 3'h2) begin    // 
                s_readdata <= yres_reg;
                if (s_write) begin
                    yres_reg <= s_writedata[11:0];
                end
            end
            if (s_address == 3'h3) begin    // 
                s_readdata <= conv_xres_select;
                if (s_write) begin
                    conv_xres_select <= s_writedata[2:0];
                end
            end
            if (s_address == 3'h4) begin    // 
                s_readdata <= pad_reg;
                if (s_write) begin
                    pad_reg <= s_writedata[2:0];
                end
            end
        end
    end
    
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
            conv_data_shift <= 1'b0;
            conv_enable_calc <= 1'b0;
            fsm <= S1;
        end
        else begin
            case (fsm)
                S1 : begin
                    if (go_flag) begin
                        busy_flag <= 1'b1;
                        fsm <= S2;
                    end
                    else begin
                        busy_flag <= 1'b0;
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
