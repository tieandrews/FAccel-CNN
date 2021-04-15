`timescale 1ns/1ns
module dma_engine_tb();
    logic clock, clock_sreset;
    integer i;
    logic [3:0] step;
    
    always #10 clock = ~clock;
    
    initial begin
        clock = 1'b0;
        clock_sreset = 1'b0;
        for (i=0; i<5; i++) begin
            @ (posedge clock);
        end
        clock_sreset = 1'b1;
        @ (posedge clock);
        clock_sreset = 1'b0;
    end
    
    logic [3:0]             s_address;
    logic [31:0]            s_writedata;
    logic [31:0]            s_readdata;
    logic                   s_read;
    logic                   s_write;
    logic                   s_waitrequest;
    logic                   s_irq;
    
    logic [31:0]            m_address;
    logic [3:0]             m_byteenable;
    logic [31:0]            m_writedata;
    logic [31:0]            m_readdata;
    logic                   m_read;
    logic                   m_write;
    logic                   m_waitrequest;
    logic                   m_readdatavalid;

    
    dma_engine      # (
                        .WIDTHA(24),
                        .WIDTHD(32),
                        .WIDTHB(4)
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
                        .s_irq(s_irq),
                        .m_address(m_address),
                        .m_byteenable(m_byteenable),
                        .m_readdata(m_readdata),
                        .m_writedata(m_writedata),
                        .m_read(m_read),
                        .m_write(m_write),
                        .m_waitrequest(1'b0),
                        .m_readdatavalid(m_read)
                    );
    
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            step <= 4'h0;
            s_read <= 1'b0;
            s_write <= 1'b0;
        end
        else begin
            case (step)
                4'h0 : begin
                    s_address <= 4'h1;
                    s_writedata <= 32'h1000;
                    s_write <= s_write ? s_waitrequest : 1'b1;
                    step += (s_write & ~s_waitrequest);
                end
                4'h1 : begin
                    s_address <= 4'h2;
                    s_writedata <= 32'h0800;
                    s_write <= s_write ? s_waitrequest : 1'b1;
                    step += (s_write & ~s_waitrequest);
                end
                4'h2 : begin
                    s_address <= 4'h3;
                    s_writedata <= 32'h4;
                    s_write <= s_write ? s_waitrequest : 1'b1;
                    step += (s_write & ~s_waitrequest);
                end
                4'h3 : begin
                    s_address <= 4'h4;
                    s_writedata <= 32'h220;
                    s_write <= s_write ? s_waitrequest : 1'b1;
                    step += (s_write & ~s_waitrequest);
                end
                4'h4 : begin
                    s_address <= 4'h0;
                    s_writedata <= 32'h1;
                    s_write <= s_write ? s_waitrequest : 1'b1;
                    step += (s_write & ~s_waitrequest);
                end
            endcase
        end
    end
    
endmodule
