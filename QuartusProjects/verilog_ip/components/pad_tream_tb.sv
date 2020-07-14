`timescale 1ns/1ns
module pad_stream_tb();

    logic       clock, clock_sreset;
    logic [7:0] state;
    integer     i;
    
    always #10 clock = ~clock;
    
    initial begin
        clock = 1'b0;
        clock_sreset = 1'b0;
        for (i=0; i<5; i++) begin
            @(posedge clock);
        end
        clock_sreset = 1'b1;
        @ (posedge clock);
        clock_sreset = 1'b0;
    end
    
    logic [31:0]    s_readdata, s_writedata;
    logic [15:0]    st_data, so_data;
    logic [3:0]     s_address;
    logic           s_read, s_write, s_waitrequest, st_valid, st_sop, st_eop, st_ready;
    logic           so_ready, so_valid, so_sop, so_eop;
    
    vga_test_pattern        # (
                                .XRES(10),
                                .YRES(10)
                            )
                            tpg (
                                .clock(clock),
                                .clock_sreset(clock_sreset),
                                .s_address(s_address),
                                .s_writedata(s_writedata),
                                .s_readdata(s_readdata),
                                .s_read(s_read),
                                .s_write(s_write),
                                .s_waitrequest(s_waitrequest),
                                .st_ready(st_ready),
                                .st_valid(st_valid),
                                .st_sop(st_sop),
                                .st_eop(st_eop),
                                .st_data(st_data)
                            );
                            
    pad_stream              # (
                                .PAD(1)
                            )
                            dut (
                                .clock(clock),
                                .clock_sreset(clock_sreset),
                                .si_ready(st_ready),
                                .si_valid(st_valid),
                                .si_sop(st_sop),
                                .si_eop(st_eop),
                                .si_data(st_data),
                                .so_ready(so_ready),
                                .so_valid(so_valid),
                                .so_sop(so_sop),
                                .so_eop(so_eop),
                                .so_data(so_data)
                            );
                            
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            so_ready <= 1'b0;
            s_write <= 1'b0;
            state <= 0;
        end
        else begin
            so_ready <= $random() & 1'b1;
            case (state)
                0 : begin
                    s_address <= 4'h0;
                    s_writedata <= 32'h1;
                    s_write <= s_write ? s_waitrequest : 1'b1;
                    if (s_write & ~s_waitrequest) begin
                        state++;
                    end
                end
                1 : begin
                    s_address <= 4'h0;
                    s_writedata <= 32'h0;
                    s_write <= s_write ? s_waitrequest : 1'b1;
                    if (s_write & ~s_waitrequest) begin
                        state++;
                    end
                end
            endcase
        end
    end

endmodule
