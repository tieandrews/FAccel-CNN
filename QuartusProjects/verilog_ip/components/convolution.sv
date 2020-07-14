module convolution # (
            parameter integer   XRES_TAPS[4:0] = '{16, 32, 64, 128, 256},   // x resolution + padding (1?)
            parameter integer   YRES_TAPS[4:0] = '{16, 32, 64, 128, 256},
            parameter           KX = 3,
            parameter           KY = 3,
            parameter           PAD = 1,
            parameter           EXP = 8,
            parameter           MANT = 7,
            parameter           WIDTH = 1 + EXP + MANT
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

    output  logic               k_st_ready,
    input   logic               k_st_valid,
    input   logic               k_st_sop,
    input   logic               k_st_eop,
    input   logic [WIDTH-1:0]   k_st_data,
    
    output  logic               f1_st_ready,
    input   logic               f1_st_valid,
    input   logic               f1_st_sop,
    input   logic               f1_st_eop,
    input   logic [WIDTH-1:0]   f1_st_data,
    
    input   logic               f2_st_ready,
    output  logic               f2_st_valid,
    output  logic               f2_st_sop,
    output  logic               f2_st_eop,
    output  logic [WIDTH-1:0]   f2_st_data
);
            localparam          TAPS = $size(XRES_TAPS);
            localparam          WIDTHT = $clog2(TAPS);
            localparam          WIDTHC = $clog2(XRES_TAPS[0]);
            localparam          DONTCARE = {WIDTH{1'bx}};
            localparam          ZERO = {WIDTH{1'b0}};
            localparam          ONE = {ZERO, 1'b1};
            
            integer             x, y, yy, t;
    
    enum    logic [2:0]         {S1, S2, S3} fsm;
    
            logic               read_latency, k_st_ready_reg, f1_st_ready_reg, f2_st_ready_reg;
            logic [WIDTHT-1:0]  select_reg;
            logic [WIDTH-1:0]   kernel[KX-1:0][KY-1:0];
            logic [WIDTH-1:0]   buffer[XRES_TAPS[0]-1:0][KY-1:0];
            logic [KX*KY-1:0][WIDTH-1:0] add_items;
            logic [WIDTH-1:0]   buffer_taps[TAPS-1:0][KY-2:0];
            logic [WIDTHC-1:0]  count_x, count_y;
            logic               pixel_valid;
            logic [KX*KY-1:0]   mlt_valid;
            
    assign k_st_ready = 1'b1;
    assign f1_st_ready = 1'b1;
            
    // handle avalon slave
    always_comb begin
        s_waitrequest = s_write ? 1'b0 : (s_read ? ~read_latency : 1'b0);
    end
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            read_latency <= 1'b0;
        end
        else begin
            read_latency <= read_latency ? 1'b0 : s_read;
            if (s_address == 4'h1) begin
                s_readdata <= select_reg;
                if (s_write) begin
                    select_reg <= s_writedata[WIDTHT-1:0];
                end
            end
        end
    end
    
    // handle kernel stream
    always_ff @ (posedge clock) begin
        k_st_ready_reg <= k_st_ready;
        if (k_st_ready_reg & k_st_valid) begin
            for (y=0; y<KY; y++) begin
                for (x=0; x<KX; x++) begin
                    if (x == 0) begin
                        if (y == 0) begin
                            kernel[x][y] <= k_st_data;
                        end
                        else begin
                            kernel[x][y] <= kernel[KX-1][y-1];
                        end
                    end
                    else begin
                        kernel[x][y] <= kernel[x-1][y];
                    end
                end
            end
        end
    end

    // handle feature map stream
    // count incoming pixels to generate valid-result signal
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            count_x <= DONTCARE[WIDTHC-1:0];
            count_y <= DONTCARE[WIDTHC-1:0];
            fsm <= S1;
        end
        else begin
            case (fsm)
                S1 : begin
                    count_x <= ZERO[WIDTHC-1:0];
                    count_y <= ZERO[WIDTHC-1:0];
                    if (f1_st_ready_reg & f1_st_valid & f1_st_sop) begin
                        fsm <= S2;
                    end
                end
                S2 : begin
                    if (f1_st_ready_reg & f1_st_valid) begin
                        if (f1_st_eop) begin
                            fsm <= S1;
                        end
                        if (count_x >= (XRES_TAPS[select_reg] - 1)) begin
                            count_x <= ZERO[WIDTHC-1:0];
                            count_y <= count_y + ONE[WIDTHC-1:0];
                        end
                        else begin
                            count_x <= count_x + ONE[WIDTHC-1:0];
                        end
                    end
                end
            endcase
        end
    end
    always_comb begin
        for (yy=0; yy<KY-1; yy++) begin
            for (t=0; t<TAPS; t++) begin
                buffer_taps[t][yy] = buffer[XRES_TAPS[t]-1][yy];
            end
        end
    end
    always_ff @ (posedge clock) begin
        pixel_valid <= ((count_x >= PAD) && (count_x <= (XRES_TAPS[select_reg] - PAD - 1))) &&
            ((count_y >= PAD) && (count_y <= (YRES_TAPS[select_reg] - PAD - 1)));
        f1_st_ready_reg <= f1_st_ready;
        if (f1_st_ready_reg & f1_st_valid) begin
            for (y=0; y<KY; y++) begin
                for (x=0; x<XRES_TAPS[0]; x++) begin
                    if (x == 0) begin
                        if (y == 0) begin
                            buffer[x][y] <= f1_st_data;
                        end
                        else begin
                            buffer[x][y] <= buffer_taps[select_reg][y-1];
                        end
                    end
                    else begin
                        buffer[x][y] <= buffer[x-1][y];
                    end
                end
            end
        end
    end
    
    // handle computation
    genvar i,j;
    generate
        begin
            for (j=0; j<KY; j++) begin : my
                for (i=0; i<KX; i++) begin : mx
                    fp_mlt      # (
                                    .EXP(EXP),
                                    .MANT(MANT),
                                    .WIDTH(WIDTH)
                                    //.LCYCLES(MULT_LATENCY)
                                )
                                mlt (
                                    .clock(clock),
                                    .clock_sreset(clock_sreset),
                                    .data_valid(pixel_valid),
                                    .dataa(kernel[KX-i-1][KY-j-1]),
                                    .datab(buffer[i][j]),
                                    .result_valid(mlt_valid[i+(j*KX)]),
                                    .result(add_items[i+(j*KX)])
                                );
                end
            end
        end
    endgenerate
    
    fp_add_tree                 # (
                                    .EXP(EXP),
                                    .MANT(MANT),
                                    .WIDTH(WIDTH),
                                    .ITEMS(2 ** $clog2(KX*KY))
                                )
                                adder_tree (
                                    .clock(clock),
                                    .clock_sreset(clock_sreset),
                                    .data_valid(mlt_valid[0]),
                                    .data({add_items, {7*16{1'b0}}}),
                                    .result_valid(f2_st_valid),
                                    .result(f2_st_data)
                                );
    
endmodule
