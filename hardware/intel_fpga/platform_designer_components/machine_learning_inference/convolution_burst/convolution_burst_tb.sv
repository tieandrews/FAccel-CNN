`timescale 1ns/1ns
module convolution_burst_tb();
    logic           clock, clock_sreset;
    
    always #10 clock = ~clock;
    
    integer         i;
    initial begin
        clock = 1'b0;
        clock_sreset = 1'b0;
        for (i=0; i<7; i++) begin
            @ (posedge clock);
            clock_sreset = (i == 4);
        end
    end
	 
    logic [3:0]     s_address;
    logic [31:0]    s_readdata, s_writedata;
    logic           s_read, s_write, s_waitrequest;
    
    logic [31:0]    m_address;
    logic [15:0]    m_readdata, m_writedata;
    logic [1:0]     m_byteenable;
    logic [7:0]     m_burstcount;
    logic           m_write, m_read, m_waitrequest, m_readdatavalid;
	 
    ram             # (
                        .WIDTHA(16),
                        .WIDTHD(16)
                    )
                    ram (
                        .clock(clock),
                        .clock_sreset(clock_sreset),
                        
                        .address(m_address[15:0]),
                        .writedata(m_writedata),
                        .readdata(m_readdata),
                        .burstcount(m_burstcount),
                        .read(m_read),
                        .write(m_write),
                        .waitrequest(m_waitrequest),
                        .readdatavalid(m_readdatavalid)
                        );
    
    convolution_burst # (
                        .XRES1(9), .XRES2(17), .XRES3(33), .XRES4(65), .XRES5(129),
                        .YRES1(9), .YRES2(17), .YRES3(33), .YRES4(65), .YRES5(129),
                        .RESOLUTIONS(5),
                        .KX(3),
                        .KY(3),
                        .EXP(8),
                        .MANT(7),
                        .WIDTHF(16),
                        .WIDTH(16),
                        .WIDTHB(2),
                        .ADDER_PIPELINE(1)
                    )
                    dut (
                        .clock(clock),
                        .clock_sreset(clock_sreset),
                        
                        .s_address(s_address),
                        .s_writedata(s_writedata),
                        .s_readdata(s_readdata),
                        .s_read(s_read),
                        .s_write(s_write),
                        .s_waitrequest(s_waitrequest),
                        
                        .m_address(m_address),
                        .m_readdata(m_readdata),
                        .m_writedata(m_writedata),
                        .m_byteenable(m_byteenable),
                        .m_burstcount(m_burstcount),
                        .m_read(m_read),
                        .m_write(m_write),
                        .m_waitrequest(m_waitrequest),
                        .m_readdatavalid(m_readdatavalid)
                    );
							
	logic [7:0]     state;
    logic [3:0]     cycle;
	
    wire            write_complete = s_write & ~s_waitrequest;
							
	always_ff @ (posedge clock) begin
		if (clock_sreset) begin
            s_read <= 1'b0;
            s_write <= 1'b0;
            cycle <= 4'h0;
			state <= 8'h0;
		end
		else begin
			case (state)
				8'h0 : begin
					s_address <= 4'h1;
					s_writedata <= 32'b001_001;   // [xres, pad]
					s_write <= ~write_complete;
					if (write_complete) begin
						state++;
					end
				end
                8'h1 : begin
					s_address <= 4'h2;
					s_writedata <= 32'h0;   // source address
					s_write <= ~write_complete;
					if (write_complete) begin
						state++;
					end
                end
                8'h2 : begin
					s_address <= 4'h3;
					s_writedata <= 32'd257;   // number words 64x64
					s_write <= ~write_complete;
					if (write_complete) begin
						state++;
					end
                end
                8'h3 : begin
					s_address <= 4'h4;
					s_writedata <= 32'h1000;   // destination
					s_write <= ~write_complete;
					if (write_complete) begin
						state++;
					end
                end
                8'h4 : begin
					s_address <= 4'h5;
					s_writedata <= 32'h2000;   // kernel
					s_write <= ~write_complete;
					if (write_complete) begin
						state++;
					end
                end
                8'h5 : begin
					s_address <= 4'h0;
					s_writedata <= 32'h2;   // restart
					s_write <= ~write_complete;
					if (write_complete) begin
						state++;
					end
                end
                8'h6 : begin
					s_address <= 4'h0;
					s_writedata <= 32'h1;   // go!
					s_write <= ~write_complete;
					if (write_complete) begin
						state++;
					end
                end
			endcase
		end
	end
    
endmodule
