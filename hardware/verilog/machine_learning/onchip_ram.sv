module onchip_ram # (
            parameter           WIDTHA = 5,
            parameter           WIDTHD = 16
)
(
    input   logic               clock,
    input   logic               clock_sreset,
    input   logic [WIDTHA-1:0]  rd_address,
    input   logic [WIDTHA-1:0]  wr_address,
    input   logic [WIDTHD-1:0]  data,
    input   logic               read,
    input   logic               write,
    output  logic               readdata_valid,
    output  logic [WIDTHD-1:0]  readdata
);
            logic [WIDTHD-1:0]  ram[(2**WIDTHA)-1:0], data_reg;
    
    always_ff @ (posedge clock) begin
        if (write) begin
            ram[wr_address] <= data;
        end
        readdata <= ram[rd_address];
        readdata_valid <= read;
    end

endmodule
