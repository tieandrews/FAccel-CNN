`timescale 1ns/1ns

module i2c_master_tb();
    logic       clock, clock_sreset;
    integer     i;
    
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
    
    logic   [3:0]   address;
    logic   [31:0]  readdata, writedata;
    logic           read, write, waitrequest;
    wire            sda, scl;
    
    assign (pull1, pull0) sda = 1'bz;
    
    i2c_master  # (
                )
                dut (
                    .clock(clock),
                    .clock_sreset(clock_sreset),
                    .address(address),
                    .readdata(readdata),
                    .writedata(writedata),
                    .read(read),
                    .write(write),
                    .waitrequest(waitrequest),
                    .sda(sda),
                    .scl(scl)
                );
                
    logic   [3:0]   state;
    
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            address <= 4'hx;
            writedata <= 32'hx;
            read <= 1'b0;
            write <= 1'b0;
            state <= 4'h0;
        end
        else begin
            case (state)
                4'h0 : begin    // start bit
                    address <= 4'h0;
                    writedata <= 32'h4;
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
                4'h1 : begin
                    address <= 4'h1;
                    writedata <= 32'h2;
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
                4'h2 : begin    // wait for busy
                    address <= 4'h0;
                    if (read) begin
                        if (~waitrequest) begin
                            read <= 1'b0;
                            if (~readdata[3]) begin
                                state++;
                            end
                        end
                    end
                    else begin
                        read <= 1'b1;
                    end
                end
                4'h3 : begin    // write '1'
                    address <= 4'h0;
                    writedata <= 32'h1;
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
                4'h4 : begin
                    address <= 4'h1;
                    writedata <= 32'h0; // dont care on this data
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
                4'h5 : begin    // wait for busy
                    address <= 4'h0;
                    if (read) begin
                        if (~waitrequest) begin
                            read <= 1'b0;
                            if (~readdata[3]) begin
                                state++;
                            end
                        end
                    end
                    else begin
                        read <= 1'b1;
                    end
                end
                4'h6 : begin    // start bit
                    address <= 4'h0;
                    writedata <= 32'h4;
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
                4'h7 : begin
                    address <= 4'h1;
                    writedata <= 32'h2;
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
                4'h8 : begin    // wait for busy
                    address <= 4'h0;
                    if (read) begin
                        if (~waitrequest) begin
                            read <= 1'b0;
                            if (~readdata[3]) begin
                                state++;
                            end
                        end
                    end
                    else begin
                        read <= 1'b1;
                    end
                end
                4'h9 : begin    // read bit
                    address <= 4'h0;
                    writedata <= 32'h1;
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
                4'ha : begin
                    address <= 4'h1;
                    if (read) begin
                        if (~waitrequest) begin
                            read <= 1'b0;
                            state++;
                        end
                    end
                    else begin
                        read <= 1'b1;
                    end
                end
                4'hb : begin    // wait for busy
                    address <= 4'h0;
                    if (read) begin
                        if (~waitrequest) begin
                            read <= 1'b0;
                            if (~readdata[3]) begin
                                state++;
                            end
                        end
                    end
                    else begin
                        read <= 1'b1;
                    end
                end
                4'hc : begin    // stop bit
                    address <= 4'h0;
                    writedata <= 32'h2;
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
                4'hd : begin
                    address <= 4'h1;
                    writedata <= 32'h2;
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
                4'he : begin    // wait for busy
                    address <= 4'h0;
                    if (read) begin
                        if (~waitrequest) begin
                            read <= 1'b0;
                            if (~readdata[3]) begin
                                state++;
                            end
                        end
                    end
                    else begin
                        read <= 1'b1;
                    end
                end
            endcase
        end
    end
                
endmodule
