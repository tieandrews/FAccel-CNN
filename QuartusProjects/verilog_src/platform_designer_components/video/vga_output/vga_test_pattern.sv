module vga_test_pattern # (
            parameter           XRES = 640,
            parameter           YRES = 480,
            parameter           WIDTHR = 5,
            parameter           WIDTHG = 6,
            parameter           WIDTHB = 5,
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
    
    input   logic               st_ready,
    output  logic               st_valid,
    output  logic               st_sop,
    output  logic               st_eop,
    output  logic [WIDTH-1:0]   st_data
);
            localparam          ONE = 128'h1;
            localparam          ZERO = 128'h0;
            localparam          WIDTHV = $clog2(XRES);
            localparam          DONTCARE = {128{1'bx}};
            localparam          QUARTER = (XRES >> 2);
            integer             i;
    enum    logic [7:0]         {S1, S2, S3, S4, S5, S6, S7, S8} fsm;
            logic [WIDTHV-1:0]  counter_x, counter_y;
            logic               go_flag, busy_flag, read_latency;

    always_comb begin
        s_waitrequest = s_write ? 1'b0 : (s_read ? ~read_latency : 1'b0);
    end
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            read_latency <= 1'b0;
        end
        else begin
            read_latency <= read_latency ? 1'b0 : s_read;
            if (s_address == 4'h0) begin
                s_readdata <= {busy_flag, go_flag};
                if (s_write) begin
                    go_flag <= s_writedata[0];
                end
            end
        end
    end
    
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            busy_flag <= 1'b0;
            st_valid <= 1'b0;
            st_sop <= 1'bx;
            st_eop <= 1'bx;
            st_data <= DONTCARE[WIDTH-1:0];
            counter_x <= DONTCARE[WIDTHV-1:0];
            counter_y <= DONTCARE[WIDTHV-1:0];
            fsm <= S1;
        end
        else begin
            case (fsm)
                S1 : begin
                    counter_x <= ZERO[WIDTHV-1:0];
                    counter_y <= ZERO[WIDTHV-1:0];
                    st_valid <= 1'b0;
                    st_sop <= 1'b0;
                    st_eop <= 1'b0;
                    if (go_flag) begin
                        busy_flag <= 1'b1;
                        fsm <= S2;
                    end
                    else begin
                        busy_flag <= 1'b0;
                    end
                end
                S2 : begin
                    st_eop <= 1'b0;
                    st_valid <= st_ready;
                    st_sop <= st_ready;
                    st_data <= XRES[WIDTH-1:0]; // xres, yres header
                    if (st_ready) begin
                        fsm <= S3;
                    end
                end
                S3 : begin
                    st_sop <= 1'b0;
                    st_valid <= st_ready;
                    st_data <= YRES[WIDTH-1:0]; 
                    if (st_ready) begin
                        fsm <= S4;
                    end
                end
                S4 : begin
                    if ((counter_y == (YRES >> 1)) || (counter_x == 0) || (counter_x == (XRES - 1)) ||
                            (counter_y == 0) || (counter_y == (YRES - 1))) begin
                        st_data <= {{WIDTHR{1'b1}}, {WIDTHG{1'b0}}, {WIDTHB{1'b1}}}; // purple border
                    end
                    else begin
                        if ((counter_x >= 0) && (counter_x < QUARTER)) begin
                            st_data <= {{WIDTHR{1'b0}}, {WIDTHG{1'b0}}, {WIDTHB{1'b1}}};
                        end
                        if ((counter_x >= QUARTER) && (counter_x < (QUARTER * 2))) begin
                            st_data <= {{WIDTHR{1'b0}}, {WIDTHG{1'b1}}, {WIDTHB{1'b0}}};
                        end
                        if ((counter_x >= (QUARTER * 2)) && (counter_x < (QUARTER * 3))) begin
                            st_data <= {{WIDTHR{1'b1}}, {WIDTHG{1'b1}}, {WIDTHB{1'b0}}};
                        end
                        if (counter_x >= (QUARTER * 3)) begin
                            st_data <= {{WIDTHR{1'b1}}, {WIDTHG{1'b0}}, {WIDTHB{1'b0}}};
                        end
                    end
                    st_valid <= st_ready;
                    if (st_ready) begin
                        if (counter_x >= (XRES - 1)) begin
                            counter_x <= ZERO[WIDTHV-1:0];
                            if (counter_y >= (YRES - 1)) begin  // last line done
                                st_eop <= 1'b1;
                                fsm <= S1;
                            end
                            else begin
                                counter_y <= counter_y + ONE[WIDTHV-1:0];
                            end
                        end
                        else begin
                            counter_x <= counter_x + ONE[WIDTHV-1:0];
                        end
                    end
                    else begin
                        st_eop <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule
