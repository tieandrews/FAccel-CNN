`timescale 1ns/1ns

module convolution_calc_tb();

    localparam              ZERO = 128'h0;
    localparam              ONE = 128'h1;
    localparam              ONES = ~ZERO;
    
    integer                 i;
    
    logic                   clock, clock_sreset;
    
    always #10 clock = ~clock;
    
    initial begin
        clock = 1'b0;
        clock_sreset = 1'b0;
        
        for (i=0; i<7; i++) begin
            @ (posedge clock);
            clock_sreset = (i == 5);
        end
    end
    
    localparam              XRES1 = 4;
    localparam              XRES2 = 12;
    localparam              XRES3 = 20;
    localparam              XRES4 = 28;
    localparam              XRES5 = 36;
    localparam              PAD = 1;
    localparam              RESOLUTIONS = 5;
    localparam              KX = 3;
    localparam              KY = 3;
    localparam              EXP = 8;
    localparam              MANT = 7;
    localparam              WIDTH = 1 + EXP + MANT;
    localparam              ADDER_PIPELINE = 1;
    
    logic [7:0]             state, countx, county;
    
    logic [WIDTH-1:0]       data, kernel_data, result;
    logic                   data_shift, kernel_valid, enable_calc, result_valid;
    logic                   pixel_valid;
    
    always_comb begin
        pixel_valid =  ((countx >= PAD) && (countx <= (XRES3 + PAD - 1))) &&
            ((county >= PAD) && (county <= (XRES3 + PAD - 1)));
    end
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            data_shift <= 1'b0;
            kernel_valid <= 1'b0;
            enable_calc <= 1'b0;
            state <= 8'h0;
            countx <= 8'h0;
            county <= 8'h0;
        end
        else begin
            case (state)
                8'h0 : begin    // load kernel weights
                    kernel_data <= $random() & ONES[WIDTH-1:0];
                    if (countx >= 8'h9) begin
                        kernel_valid <= 1'b0;
                        countx <= 0;
                        state++;
                    end
                    else begin
                        kernel_valid <= 1'b1;
                        countx <= countx + 8'h1;
                    end
                end
                8'h1 : begin
                    enable_calc <= pixel_valid;
                    data <= pixel_valid ? $random() & ONES[WIDTH-1:0] : ZERO[WIDTH-1:0];
                    if (countx >= (XRES3 + (PAD << 1)) - 1) begin
                        countx <= 8'h0;
                        if (county >= (XRES3 + (PAD << 1)) - 1) begin
                            enable_calc <= 1'b0;
                            data_shift <= 1'b0;
                            county <= 8'h0;
                            state++;
                        end
                        else begin
                            data_shift <= 1'b1;
                            county <= county + 8'h1;
                        end
                    end
                    else begin
                        data_shift <= 1'b1;
                        countx <= countx + 8'h1;
                    end
                end
            endcase
        end
    end
    
    convolution_calc        # (
                                .MAX_RES(XRES5 + (PAD << 1)),
                                .XRES1(XRES1 + (PAD << 1)), 
                                .XRES2(XRES2 + (PAD << 1)),
                                .XRES3(XRES3 + (PAD << 1)),
                                .XRES4(XRES4 + (PAD << 1)),
                                .XRES5(XRES5 + (PAD << 1)),
                                .RESOLUTIONS(RESOLUTIONS),
                                .KX(KX),
                                .KY(KY),
                                .EXP(EXP),
                                .MANT(MANT),
                                .WIDTH(WIDTH),
                                .ADDER_PIPELINE(ADDER_PIPELINE)
                            )
                            dut (
                                .clock(clock),
                                .clock_sreset(clock_sreset),
                                .xres_select(3'h2),             // XRES3
                                .kernel_valid(kernel_valid),
                                .kernel_data(kernel_data),
                                .enable_calc(enable_calc),
                                .data_shift(data_shift),
                                .data(data),
                                .result_valid(result_valid),
                                .result(result)
                            );

endmodule
