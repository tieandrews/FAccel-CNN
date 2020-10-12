module fifo # (
            parameter           WIDTH = 16,
            parameter           DEPTH = 512,
            parameter           WIDTHP = 9
)
(
    input   logic               clock,
    input   logic               clock_sreset,
    input   logic               wrreq,
    input   logic [WIDTH-1:0]   data,
    input   logic               rdreq,
    output  logic [WIDTHP:0]    usedw,
    output  logic [WIDTH-1:0]   q
);
            localparam          ONE = 128'h1;
            localparam          ZERO = 128'h0;
            logic [WIDTH-1:0]   ram[0:DEPTH-1];
            logic [WIDTHP:0]    rd_ptr, wr_ptr;
    
    always_comb begin
        q = ram[rd_ptr];
        usedw = wr_ptr - rd_ptr;
    end
    always_ff @ (posedge clock) begin
        if (wrreq) begin
            ram[wr_ptr[WIDTHP-1:0]] <= data;
        end
        if (clock_sreset) begin
            wr_ptr <= ZERO[WIDTHP:0];
            rd_ptr <= ZERO[WIDTHP:0];
        end
        else begin
            if (wrreq) begin
                wr_ptr <= wr_ptr + ONE[WIDTHP:0];
            end
            if (rdreq) begin
                rd_ptr <= rd_ptr + ONE[WIDTHP:0];
            end
        end
    end

endmodule
