// +FHDR------------------------------------------------------------------------
// My detail and (C) notice
// -----------------------------------------------------------------------------
// FILE NAME : fifo.sv
// DEPARTMENT :
// AUTHOR : Steven Groom
// AUTHOR’S EMAIL : steve@bems.se
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION  DATE        AUTHOR DESCRIPTION
// 1.0      13Oct2020   Steven Groom
// -----------------------------------------------------------------------------
// KEYWORDS : 
// -----------------------------------------------------------------------------
// PURPOSE : A synchronous fifo
// -----------------------------------------------------------------------------
// PARAMETERS
// PARAM NAME RANGE : DESCRIPTION                : DEFAULT : UNITS
// WIDTH      1..n  : width of input/output      : 16      : bits
// DEPTH      1..n  : number of FIFO words       : 512     : words
// WIDTHP     1..n  : number of bits+1 for depth : 10      : bits
// -----------------------------------------------------------------------------
// REUSE ISSUES
// Reset Strategy : fully synchronous - clock_sreset
// Clock Domains : one domain - clock
// Critical Timing :
// Test Features :
// Asynchronous I/F :
// Scan Methodology :
// Instantiations :
// Synthesizable (y/n) : y
// Other :
// -FHDR------------------------------------------------------------------------
//
module fifo # (
            parameter           WIDTH = 16,
            parameter           DEPTH = 512,
            parameter           WIDTHP = $clog2(DEPTH) + 1
)
(
    input   logic               clock,
    input   logic               clock_sreset,
    input   logic               wrreq,
    input   logic [WIDTH-1:0]   data,
    input   logic               rdreq,
    output  logic               illegal,
    output  logic               empty,
    output  logic               full,
    output  logic [WIDTHP-1:0]  usedw,
    output  logic [WIDTH-1:0]   q
);
            localparam          ONE = 128'h1;
            localparam          ZERO = 128'h0;
            logic [WIDTH-1:0]   ram[0:DEPTH-1];
            logic [WIDTHP-1:0]  rd_ptr, wr_ptr;
            wire [WIDTHP-1:0]   sreset_mask = {WIDTHP{~clock_sreset}};
    
    always_comb begin
        q = ram[rd_ptr];
        empty = ~|(rd_ptr ^ wr_ptr);
        full = ~|(usedw ^ DEPTH[WIDTHP-1:0]);
        illegal = (wrreq & full) | (rdreq & empty);
        
    end
    always_ff @ (posedge clock) begin
        if (wrreq & ~full) begin
            ram[wr_ptr[WIDTHP-2:0]] <= data;
        end
        wr_ptr <= (wr_ptr + (wrreq & ~full)) & sreset_mask;
        rd_ptr <= (rd_ptr + (rdreq & ~empty)) & sreset_mask;
        usedw <= (usedw + {{WIDTHP-1{rdreq & ~wrreq}}, (rdreq ^ wrreq)}) & sreset_mask;
    end

endmodule
