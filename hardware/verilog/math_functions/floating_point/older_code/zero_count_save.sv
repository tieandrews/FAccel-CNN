module zero_count # (
            parameter           WIDTH = 24,
            parameter           WIDTHR = $clog2(WIDTH),
            parameter           REGISTERED = 1
)
(
    input   logic               clock,
    input   logic [WIDTH-1:0]   data,
    output  logic [WIDTHR-1:0]  distance,
    output  logic [WIDTH-1:0]   result
);
            localparam          ONE = {{WIDTH{1'b0}}, 1'b1};
            integer             i;//, last;
            logic [WIDTH-1:0]   node[WIDTHR:0], data_reg;
            logic [WIDTHR-1:0]  distance_bits, last;
            integer  shift;

    always_comb begin
        last = WIDTH[WIDTHR-1:0];
        node[0] = data_reg;
        for (i=1; i<=WIDTHR; i++) begin
            if ((ONE[WIDTHR-1:0] << (WIDTHR - i)) <= last) begin
                if (~|(node[i-1] >> (WIDTH - (1 << (WIDTHR - i))))) begin
                    last = last - (ONE[WIDTHR-1:0] << (WIDTHR - i));
                    node[i] = node[i-1] << (1 << (WIDTHR - i));
                    distance_bits[WIDTHR-i] = 1'b1;
                end
                else begin
                    node[i] = node[i-1];
                    distance_bits[WIDTHR-i] = 1'b0;
                end
            end
            else begin
                node[i] = node[i-1];
                distance_bits[WIDTHR-i] = 1'b0;
            end
        end
    end
    
    generate
        if (REGISTERED == 1) begin : g
            always_ff @ (posedge clock) begin
                data_reg <= data;
                result <= node[WIDTHR];
                distance <= distance_bits;
            end
        end
        else begin
            assign data_reg = data;
            assign result = node[WIDTHR];
            assign distance = distance_bits;
        end
    endgenerate

endmodule
