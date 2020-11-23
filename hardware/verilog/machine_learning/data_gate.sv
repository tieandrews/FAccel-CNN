module data_gate # (
            parameter                   WIDTH = 16,
            parameter                   CH = 2
)
(
    input   logic                       clock,
    input   logic                       clock_sreset,
    input   logic [CH-1:0]              data_valid,
    input   logic [CH-1:0][WIDTH-1:0]   data,
    output  logic                       result_valid,
    output  logic [CH-1:0][WIDTH-1:0]   result
);
            localparam                  DONTCARE = {CH*WIDTH*2{1'bx}};
            localparam                  ZERO = 128'h0;
            integer                     i;
            logic [CH-1:0][WIDTH-1:0]   data_reg;
            logic [CH-1:0]              set_reg, data_valid_reg;
            
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            data_valid_reg <= ZERO[CH-1:0];
            data_reg <= DONTCARE[(CH*WIDTH)-1:0];
            result <= DONTCARE[(CH*WIDTH)-1:0];
            set_reg <= ZERO[CH-1:0];
            result_valid <= 1'b0;
        end
        else begin
            data_valid_reg <= data_valid;
            data_reg <= data;
            for (i=0; i<CH; i++) begin
                if (data_valid_reg[i]) begin
                    result[i] <= data_reg[i];
                end
            end
            result_valid <= &set_reg;
            if (&set_reg) begin
                set_reg <= data_valid;
            end
            else begin
                set_reg <= set_reg | data_valid;
            end
        end
    end

endmodule
