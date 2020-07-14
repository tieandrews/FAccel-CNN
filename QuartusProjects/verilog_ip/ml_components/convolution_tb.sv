`timescale 1ns/1ns

module convolution_tb();

    integer i;  
    logic   clock, clock_sreset;
    
    always #10 clock = ~clock;
    
    initial begin
        clock = 1'b0;
        clock_sreset = 1'b0;
        for (i=0; i<5; i++)
            @ (posedge clock);
        clock_sreset = 1'b1;
        @ (posedge clock);
        clock_sreset = 1'b0;
    end
    
    logic [7:0]     state, count;
    logic [3:0]     address;
    logic [31:0]    readdata, writedata;
    logic           read, write, waitrequest;
    logic [15:0]    k_data;
    logic           k_ready, k_valid, k_sop, k_eop;
    logic [15:0]    f1_data;
    logic           f1_ready, f1_valid, f1_sop, f1_eop;
    logic [15:0]    f2_data;
    logic           f2_valid;
    
    convolution         # (
                            .XRES_TAPS('{16, 16, 16, 16, 16}),
                            .YRES_TAPS('{16, 16, 16, 16, 16}),
                            .KX(3),
                            .KY(3),
                            .PAD(1),
                            .EXP(8),
                            .MANT(7),
                            .WIDTH(16)
                        )
                        convolution (
                            .clock(clock),
                            .clock_sreset(clock_sreset),
                            
                            .s_address(address),
                            .s_writedata(writedata),
                            .s_readdata(readdata),
                            .s_read(read),
                            .s_write(write),
                            .s_waitrequest(waitrequest),
                            
                            .k_st_ready(k_ready),
                            .k_st_valid(k_valid),
                            .k_st_sop(k_sop),
                            .k_st_eop(k_eop),
                            .k_st_data(k_data),
                            
                            .f1_st_ready(f1_ready),
                            .f1_st_valid(f1_valid),
                            .f1_st_sop(f1_sop),
                            .f1_st_eop(f1_eop),
                            .f1_st_data(f1_data),

                            .f2_st_ready(1'b1),
                            .f2_st_valid(f2_valid),
                            .f2_st_sop(),
                            .f2_st_eop(),
                            .f2_st_data(f2_data)
                        );
                        
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            address <= 4'bxxxx;
            writedata <= {32{1'bx}};
            read <= 1'b0;
            write <= 1'b0;
            count <= 8'h0;
            k_sop <= 1'b0;
            k_eop <= 1'b0;
            k_valid <= 1'b0;
            k_data <= 16'hx;
            f1_sop <= 1'b0;
            f1_eop <= 1'b0;
            f1_valid <= 1'b0;
            f1_data <= 16'hx;
            state <= 8'h0;
        end
        else begin
            case (state)
                0 : begin
                    count <= 8'h0;
                    writedata <= 4;
                    address <= 4'h1;
                    if (write) begin
                        if (~waitrequest) begin
                            write <= 1'b0;
                            state++;
                        end
                    end
                    else begin
                        write <= 1'b1;
                    end
                end
                1 : begin
                    if (k_ready) begin
                        k_sop <= (count == 1);
                        k_data <= (count == 5) ? 16'h3f80 : 16'h0; //$random() & 16'hffff;
                        k_eop <= (count >= 9);
                        if (count >= 10) begin
                            count <= 0;
                            k_valid <= 1'b0;
                            k_eop <= 1'b0;
                            state++;
                        end
                        else begin
                            count++;
                            k_valid <= 1'b1;
                        end
                    end
                    else begin
                        k_sop <= 1'b0;
                        k_valid <= 1'b0;
                        k_eop <= 1'b0;
                    end
                end
                2 : begin
                    if (f1_ready) begin
                        count++;
                        f1_sop <= (count == 1);
                        f1_data <= (count == 16) ? 16'h3f80 : 16'h0; //$random() & 16'hffff;
                        f1_eop <= (count >= 256);
                        if (count >= 257) begin
                            f1_valid <= 1'b0;
                            f1_eop <= 1'b0;
                            state++;
                        end
                        else begin
                            f1_valid <= 1'b1;
                        end
                    end
                    else begin
                        f1_sop <= 1'b0;
                        f1_valid <= 1'b0;
                        f1_eop <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule
