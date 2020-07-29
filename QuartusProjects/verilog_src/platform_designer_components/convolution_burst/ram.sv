module ram # (
            parameter           WIDTHA = 10,
            parameter           WIDTHD = 16,
            localparam          WIDTHB = 8
)
(
    input   logic               clock,
    input   logic               clock_sreset,
    
    input   logic [WIDTHA-1:0]  address,
    input   logic [WIDTHD-1:0]  writedata,
    output  logic [WIDTHD-1:0]  readdata,
    input   logic [WIDTHB-1:0]  burstcount,
    input   logic               read,
    input   logic               write,
    output  logic               waitrequest,
    output  logic               readdatavalid
);
            integer             i;

    enum    logic [7:0]         {S1, S2, S3, S4, S5, S6, S7, S8} fsm;
            logic [WIDTHD-1:0]  ram[0:2**WIDTHA-1];
            logic [WIDTHB-1:0]  count, offset;
            logic               read_latency;
            
    always_comb begin
        waitrequest = write ? 1'b0 : (read ? ~read_latency : 1'b0);
    end
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            for (i=0; i<(2**WIDTHA); i++) begin
                ram[i] <= $random(); //{WIDTHD{1'bx}};
            end
            readdatavalid <= 1'b0;
            fsm <= S1;
        end
        else begin
            read_latency <= read_latency ? 1'b0 : read;
            readdata <= ram[address + offset];
            case (fsm)
                S1 : begin
                    offset <= 0;
                    count <= burstcount;
                    if (read & ~waitrequest & (|burstcount)) begin
                        fsm <= S2;
                    end
                    if (write) begin
                        fsm <= S3;
                    end
                end
                S2 : begin
                    offset <= offset + 1;
                    if (offset >= count) begin
                        readdatavalid <= 1'b0;
                        fsm <= S1;
                    end
                    else begin
                        readdatavalid <= 1'b1;
                    end
                end
                S3 : begin
                    offset <= offset + write;
                    ram[address + offset] <= writedata;
                    if (offset >= count) begin
                        fsm <= S1;
                    end
                end
            endcase
        end
    end
    
endmodule
