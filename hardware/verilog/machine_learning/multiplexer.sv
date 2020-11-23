module multiplexer # (
            parameter                   WIDTH = 1,
            parameter                   CH = 3,
            parameter                   WIDTHS = $clog2(CH)
)
(
    input   logic [WIDTHS-1:0]          select,    
    input   logic [CH-1:0][WIDTH-1:0]   in,
    output  logic [WIDTH-1:0]           out
);

    assign out = in[select];
    
endmodule
