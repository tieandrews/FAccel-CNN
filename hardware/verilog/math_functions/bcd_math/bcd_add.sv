module bcd_add (
    input   logic           clock,
    input   logic           clock_sreset,
    input   logic           data_valid,
    input   logic [3:0]     dataa,
    input   logic [3:0]     datab,
    input   logic           cin,
    output  logic           result_valid,
    output  logic [3:0]     result,
    output  logic           cout
);
            logic [5:0]     sum;
            logic [3:0]     dataa_reg, datab_reg;
            logic           latency;
    
    always_comb begin
        sum = {1'b0, dataa_reg, 1'b1} + {1'b0, datab_reg, cin};
        if (sum[5:1] >= 6'h9) begin
            sum = sum + {4'h6, 1'b0};
        end
    end
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            result_valid <= 1'b0;
            result <= 4'hx;
            cout <= 1'bx;
            dataa_reg <= 4'hx;
            datab_reg <= 4'hx;
        end
        else begin
            dataa_reg <= dataa;
            datab_reg <= datab;
            latency <= data_valid;
            result_valid <= latency;
            result <= sum[4:1];
            cout <= sum[5];
        end
    end
    
endmodule
