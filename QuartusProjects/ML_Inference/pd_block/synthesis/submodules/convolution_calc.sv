module convolution_calc # (
            parameter           XRES = 72,
            parameter           KX = 3,
            parameter           KY = 3,
            parameter           EXP = 8,
            parameter           MANT = 7,
            parameter           WIDTH = EXP + MANT + 1,
            parameter           MLT_LCYCLES = 1,
            parameter           ADD_LCYCLES = 4
)
(
    input   logic               clock,
    input   logic               clock_sreset,
    
    input   logic               s_address,
    input   logic [15:0]        s_writedata,
    input   logic               s_write,
    output  logic               s_waitrequest,
    
    output  logic               st_ready,
    input   logic               st_valid,
    input   logic               st_sop,
    input   logic               st_eop,
    input   logic [15:0]   st_data,
    
    output  logic               result_valid,
    output  logic [15:0]   result
);
            localparam          DONTCARE = {128{1'bx}};
            localparam          ONE = 128'h1;
            localparam          KX_LH = (KX / 2);
            localparam          KX_UH = KX - KX_LH;
            localparam          KY_LH = (KY / 2);
            localparam          KY_UH = KY - KY_LH;
            integer             x, y;
    enum    logic [7:0]         {S1, S2, S3, S4, S5, S6, S7, S8} fsm_a, fsm_b;
            logic [WIDTH-1:0]   kernel[KX-1:0][KY-1:0];
            logic [WIDTH-1:0]   mlt_result[KX-1:0][KY-1:0];
            logic [WIDTH-1:0]   buffer[XRES-1:0][KY-1:0];
            logic [11:0]        xres_reg, yres_reg, count_x, count_y;
            logic               st_ready_reg;
            logic               mlt_result_valid;
            logic               adder_result_valid;
            logic [KX-1:0][KY-1:0][WIDTH-1:0] adder_node;
            logic [WIDTH-1:0]   adder_result;
            logic               calc_valid, shift_buffer;
           
    assign s_waitrequest = 1'b0;
    assign st_ready = 1'b1;
            
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            for (y=0; y<KY; y++) begin
                for (x=0; x<KX; x++) begin
                    kernel[x][y] <= DONTCARE[WIDTH-1:0];
                end
            end
        end
        else begin
            if (s_write & ~s_waitrequest) begin
                for (y=0; y<KY; y++) begin
                    for (x=0; x<KX; x++) begin
                        if (x==0) begin
                            if (y==0) begin
                                kernel[x][y] <= s_writedata;
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
    end
    
    always_comb begin
        shift_buffer = 1'b0;
        case (fsm_a)
            S3 : shift_buffer = st_valid & st_ready_reg;
            default;
        endcase
    end
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            for (y=0; y<KY; y++) begin
                for (x=0; x<XRES; x++) begin
                    buffer[x][y] <= DONTCARE[WIDTH-1:0];
                end
            end
        end
        else begin
            if (shift_buffer) begin 
                for (y=0; y<KY; y++) begin
                    for (x=0; x<XRES; x++) begin
                        if (x==0) begin
                            if (y==0) begin
                                buffer[0][0] <= st_data;
                            end
                            else begin
                                buffer[x][y] <= buffer[XRES-1][y-1];
                            end
                        end
                        else begin
                            buffer[x][y] <= buffer[x-1][y];
                        end
                    end
                end
            end
        end
    end
    
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            st_ready_reg <= 1'b0;
            count_x <= DONTCARE[11:0];
            count_y <= DONTCARE[11:0];
            fsm_a <= S1;
        end
        else begin
            st_ready_reg <= st_ready;
            case (fsm_a)
                S1 : begin
                    if (st_ready_reg & st_valid & st_sop) begin
                        xres_reg <= st_data[11:0];
                        fsm_a <= S2;
                    end
                end
                S2 : begin
                    count_x <= 12'h0;
                    count_y <= 12'h0;
                    if (st_ready_reg & st_valid) begin
                        yres_reg <= st_data[11:0];
                        fsm_a <= S3;
                    end
                end
                S3 : begin  // may need checks here for malformed packets?
                    if (st_valid & st_ready_reg) begin
                        if (st_eop) begin
                            fsm_a <= S1;
                        end
                        if (count_x >= (xres_reg - 12'h1)) begin
                            count_x <= 12'h0;
                            count_y <= count_y + 12'h1;
                            if (count_y >= (yres_reg - 12'h1)) begin
                                fsm_a <= S1;
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
    
    always_comb begin
        calc_valid = 1'b0;
        if ((count_y >= (KY_UH[11:0] - ONE[11:0])) && (count_y <= (yres_reg - KY_LH[11:0]))) begin
            if ((count_x >= (KX_UH[11:0] - ONE[11:0])) && (count_x <= (xres_reg - KX_LH[11:0]))) begin
                calc_valid = 1'b1;
            end
        end
    end

    genvar xx, yy;
    generate
        begin
            for (yy=0; yy<KY; yy++) begin : mlt_y
                for (xx=0; xx<KX; xx++) begin : mlt_x
                    if ((xx == 0) && (yy == 0)) begin
                        fp_mlt # (
                            .EXP(EXP),
                            .MANT(MANT),
                            .WIDTH(WIDTH),
                            .LCYCLES(MLT_LCYCLES)
                        )
                        mlt (
                            .clock(clock),
                            .clock_sreset(clock_sreset),
                            .dataa(kernel[0][0]),
                            .datab(buffer[0][0]),
                            .data_valid(calc_valid),
                            .result_valid(mlt_result_valid),
                            .result(mlt_result[0][0])
                        );
                    end
                    else begin
                        fp_mlt # (
                            .EXP(EXP),
                            .MANT(MANT),
                            .WIDTH(WIDTH),
                            .LCYCLES(MLT_LCYCLES)
                        )
                        mlt (
                            .clock(clock),
                            .clock_sreset(clock_sreset),
                            .dataa(kernel[xx][yy]),
                            .datab(buffer[xx][yy]),
                            .data_valid(1'b1),
                            .result_valid(),
                            .result(mlt_result[xx][yy])
                        );
                    end
                    assign adder_node[xx][yy] = mlt_result[xx][yy];
                end
            end
            fp_add_tree # (
                .EXP(EXP),
                .MANT(MANT),
                .ITEMS(KX * KY),
                .LCYCLES(ADD_LCYCLES),
                .WIDTH(WIDTH)
            )
            adder_tree (
                .clock(clock),
                .clock_sreset(clock_sreset),
                .dataa(adder_node),
                .data_valid(mlt_result_valid),
                .result_valid(result_valid),
                .result(result)
            );
        end
    endgenerate
    
    always_ff @ (posedge clock) begin
        
    end
    
endmodule
