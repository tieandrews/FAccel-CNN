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

    enum    logic [7:0]         {S1, S2, S3, S4, S5, S6, S7,S8} fsm;
            logic [WIDTHD-1:0]  ram[0:2**WIDTHA-1];
            logic [WIDTHB-1:0]  count;
            
    always_comb begin
        waitrequest = 1'b0;
        case (fsm)
            S1 : begin
                waitrequest = 1'b0;
            end
            S2 : begin
                waitrequest = 1'b1; // no more burst requests
            end
        endcase
    end
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            fsm <= S1;
            for (i=0; i<(2**WIDTHA); i++) begin
                ram[i] <= {WIDTHD{1'b0}};
            end
        end
        else begin
            readdata <= ram[address];
            readdatavalid <= read;
            case (fsm)
                S1 : begin
                    count <= burstcount;
                    if (|burstcount) begin
                        if (read) begin
                            
                            fsm <= S2;
                        end
                        if (write) begin
                            fsm <= S3;
                        end
                    end
                    else begin
                        
                    end
                end
            endcase
        end
    end
    
endmodule
