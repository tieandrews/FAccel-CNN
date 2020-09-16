module bcd_mult (
    input   logic               clock,
    input   logic               clock_sreset,
    input   logic               data_valid,
    input   logic [3:0]         dataa,  // bcd inputs
    input   logic [3:0]         datab,
    output  logic               result_valid,
    output  logic [7:0]         result  // bcd output
);

            integer             i, j;
            logic [3:0]         dataa_reg, datab_reg;
            wire [7:0]          mult = dataa_reg * datab_reg;
            logic [1:0][3:0]    node;
            logic               latency;
            

    always_comb begin
        node = 8'h0;
        for (i=0; i<8; i++) begin
            for (j=0; j<2; j++) begin
                if (node[j] >= 4'h5) begin
                    node[j] = node[j] + 4'h3;
                end
            end
            node = (node << 1) | mult[7-i];
        end
    end
    
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            result_valid <= 1'b0;
            dataa_reg <= 4'hx;
            datab_reg <= 4'hx;
            result <= 7'h0;
            latency <= 1'b0;
        end
        else begin
            dataa_reg <= dataa;
            datab_reg <= datab;
            latency <= data_valid;
            result_valid <= latency;
            result <= node;
        end
    end
endmodule
