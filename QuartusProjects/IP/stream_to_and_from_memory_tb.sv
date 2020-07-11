`timescale 1ns/1ns

module stream_to_and_from_memory_tb();

    integer                 i;
    logic                   clock, clock_sreset;
    
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
    
    integer                     x;
    logic [3:0]                 s1_address, s2_address;
    logic [1:0]                 rm_byteenable, wm_byteenable;
    logic [31:0]                s1_readdata, s1_writedata, rm_address, s2_readdata, s2_writedata, wm_address;
    logic [15:0]                rm_readdata, st_data, wm_writedata;
    logic                       s1_read, s1_write, s1_waitrequest, rm_read, rm_waitrequest, rm_readdatavalid;
    logic                       st_ready, st_valid, st_sop, st_eop, s2_read, s2_write, s2_waitrequest, wm_write, wm_waitrequest;
    
    logic [15:0]                ram[0:65535], ram_rdaddress, ram_wraddress, ram_writedata, ram_readdata;
    logic                       ram_write;
    
    localparam                  FIFO = 512;
    
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            for (x=0; x<65536; x++) begin
                if (x < 16'h1000)
                    ram[x] <= x;
                else
                    ram[x] <= 16'hx;
            end
        end
        else begin
            if (wm_write) begin
                ram[wm_address[16:1]] <= wm_writedata;
            end
            wm_waitrequest <= $random() & 1'b1;
            rm_waitrequest <= $random() & 1'b1;
        end
    end
    always_comb begin
        rm_readdata = ram[rm_address[16:1]];
    end
    
    memory_to_stream            # (
                                    .FIFO_DEPTH(FIFO)
                                )
                                sfm (
                                    .clock(clock),
                                    .clock_sreset(clock_sreset),
                                    .s_address(s1_address),
                                    .s_readdata(s1_readdata),
                                    .s_writedata(s1_writedata),
                                    .s_read(s1_read),
                                    .s_write(s1_write),
                                    .s_waitrequest(s1_waitrequest),
                                    .rm_address(rm_address),
                                    .rm_readdata(rm_readdata),
                                    .rm_byteenable(rm_byteenable),
                                    .rm_read(rm_read),
                                    .rm_waitrequest(rm_waitrequest),
                                    .rm_readdatavalid(rm_read & ~rm_waitrequest),
                                    .st_ready(st_ready),
                                    .st_valid(st_valid),
                                    .st_sop(st_sop),
                                    .st_eop(st_eop),
                                    .st_data(st_data)
                                );

    stream_to_memory            # (
                                    .FIFO_DEPTH(FIFO)
                                )
                                stm (
                                    .clock(clock),
                                    .clock_sreset(clock_sreset),
                                    .s_address(s2_address),
                                    .s_readdata(s2_readdata),
                                    .s_writedata(s2_writedata),
                                    .s_read(s2_read),
                                    .s_write(s2_write),
                                    .s_waitrequest(s2_waitrequest),
                                    .wm_address(wm_address),
                                    .wm_writedata(wm_writedata),
                                    .wm_byteenable(wm_byteenable),
                                    .wm_write(wm_write),
                                    .wm_waitrequest(wm_write & ~wm_waitrequest),
                                    .st_ready(st_ready),
                                    .st_valid(st_valid),
                                    .st_sop(st_sop),
                                    .st_eop(st_eop),
                                    .st_data(st_data)
                                );
                                
    // simulation state machine
    logic [7:0] state;
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            s1_read <= 1'b0;
            s1_write <= 1'b0;
            s2_read <= 2'b0;
            s2_write <= 1'b0;
            state <= 8'h0;
            ram_wraddress <= 16'h1110;
        end
        else begin
            case (state)
                8'h0 : begin
                    s2_address <= 4'h1;
                    s2_writedata <= 32'h4000;   // destination for data
                    if (s2_write) begin
                        if (~s2_waitrequest) begin
                            s2_write <= 1'b0;
                            state++;
                        end
                    end
                    else begin
                        s2_write <= 1'b1;
                    end
                end
                8'h1 : begin
                    s2_address <= 4'h0;
                    s2_writedata <= 32'h1;  // go
                    if (s2_write) begin
                        if (~s2_waitrequest) begin
                            s2_write <= 1'b0;
                            state++;
                        end
                    end
                    else begin
                        s2_write <= 1'b1;
                    end
                end
                8'h2 : begin
                    s1_address <= 4'h1;
                    s1_writedata <= 32'h0;   // source for data
                    if (s1_write) begin
                        if (~s1_waitrequest) begin
                            s1_write <= 1'b0;
                            state++;
                        end
                    end
                    else begin
                        s1_write <= 1'b1;
                    end
                end
                8'h3 : begin
                    s1_address <= 4'h2;
                    s1_writedata <= 32'h1000; // 4096 words
                    if (s1_write) begin
                        if (~s1_waitrequest) begin
                            s1_write <= 1'b0;
                            state++;
                        end
                    end
                    else begin
                        s1_write <= 1'b1;
                    end
                end
                8'h4 : begin
                    s1_address <= 4'h0;
                    s1_writedata <= 32'h1;  // go
                    if (s1_write) begin
                        if (~s1_waitrequest) begin
                            s1_write <= 1'b0;
                            state++;
                        end
                    end
                    else begin
                        s1_write <= 1'b1;
                    end
                end
            endcase
        end
    end

endmodule
