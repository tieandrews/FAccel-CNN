/* controlling C routines to go wtih this verilog code
void i2c_busy_wait(int base_addr) {
	while ((IORD(base_addr, 0) & 0x8) != 0);
}

void i2c_start_bit(int base_addr) {
	i2c_busy_wait(base_addr);
	IOWR(base_addr, 0, 0x4);
	IOWR(base_addr, 1, 0x0);
}

void i2c_stop_bit(int base_addr) {
	i2c_busy_wait(base_addr);
	IOWR(base_addr, 0, 0x2);
	IOWR(base_addr, 1, 0x0);
}

void i2c_write_bit(int base_addr, int bit) {
	i2c_busy_wait(base_addr);
	if (bit == 0)
		IOWR(base_addr, 0, 0);
	else
		IOWR(base_addr, 0, 1);
	IOWR(base_addr, 1, 0x0);
}

int i2c_read_bit(int base_addr) {
	i2c_busy_wait(base_addr);
	IORD(base_addr, 1);
	i2c_busy_wait(base_addr);
	return (IORD(base_addr, 0) & 0x1);
}

void i2c_nack(int base_addr) {
	i2c_write_bit(base_addr, 0x1);
}

int i2c_ack(int base_addr) {
	return i2c_read_bit(base_addr);
}

void i2c_write_word(int base_addr, int word, int bits) {
  int	bit;

  for (bit = 0; bit<bits; bit++) {
    i2c_write_bit(base_addr, word & (0x1<<(bits - 1)));
    word <<= 1;
  }
}

int i2c_read_word(int base_addr, int bits) {
  int byte;
  int bit;

  byte = 0;
  for (bit = 0; bit<bits; bit++) {
    byte = (byte << 1) | i2c_read_bit(base_addr);
  }

  return byte;
}

code follows https://en.wikipedia.org/wiki/I%C2%B2C without clock stretching

*/
module i2c_master # (
            parameter               I2C_SPEED = 400000,
            parameter               CLOCK_HZ = 50000000
)
(
    input   logic                   clock,
    input   logic                   clock_sreset,
    input   logic   [3:0]           address,
    output  logic   [31:0]          readdata,
    input   logic   [31:0]          writedata,
    input   logic                   read,
    input   logic                   write,
    output  logic                   waitrequest,
    
    inout   wire                    sda,
    inout   wire                    scl
);

            localparam              ONE = 1;
            localparam              ZERO = 0;
            localparam              BIT_DELAY = (CLOCK_HZ / I2C_SPEED) / 2;
            localparam              WIDTHBD = $clog2(BIT_DELAY);
            localparam              DELAY_ENDCOUNT = (BIT_DELAY[WIDTHBD-1:0] - ONE[WIDTHBD-1:0]);
    enum    logic   [10:0]          {IDLE, START_BIT, START_BIT_S1, START_BIT_S2,
                                        STOP_BIT, STOP_BIT_S1, STOP_BIT_S2,
                                        WRITE_BIT, WRITE_BIT_S1,
                                        READ_BIT, READ_BIT_S1} fsm;
            logic   [1:0]           sda_meta, scl_meta;
            logic                   sda_sample;
            logic                   sda_node, scl_node;
            logic   [WIDTHBD-1:0]   delay_counter;
            logic                   read_latency;
            logic                   go_read_flag, go_write_flag, busy_flag, started_flag;
            logic                   start_bit_reg, stop_bit_reg;
            logic                   read_data_bit, write_data_bit;

    assign sda = sda_node ? 1'bz : 1'b0;
    assign scl = scl_node ? 1'bz : 1'b0;
    
    always_comb begin
        waitrequest = write ? 1'b0 : read ? ~read_latency : 1'b0;
    end
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            read_latency <= 1'b0;
            go_read_flag <= 1'b0;
            go_write_flag <= 1'b0;
            start_bit_reg <=1 'b0;
            stop_bit_reg <= 1'b0;
            write_data_bit <= 1'b0;
        end
        else begin
            read_latency <= read_latency ? 1'b0 : read;
            if (address == 4'h0) begin  // 
                readdata <= {busy_flag, start_bit_reg, stop_bit_reg, read_data_bit};
                if (write) begin
                    {start_bit_reg, stop_bit_reg, write_data_bit} <= writedata[2:0];
                end
            end
            if (address == 4'h1) begin  // read and write an I2C byte or start/stop bit
                {go_write_flag , go_read_flag} <= {write, read};
            end
            else begin
                go_write_flag <= 1'b0;
                go_read_flag <= 1'b0;
            end
        end
    end
    
    always_ff @ (posedge clock) begin
        {sda_sample, sda_meta} <= {sda_meta, sda};
    end
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            fsm <= IDLE;
            delay_counter <= {WIDTHBD{1'bx}};
            busy_flag <= 1'b0;
            sda_node <= 1'b1;
            scl_node <= 1'b1;
            started_flag <= 1'b0;
        end
        else begin
            case (fsm)
                IDLE : begin
                    delay_counter <= DELAY_ENDCOUNT;
                    if (go_write_flag) begin
                        busy_flag <= 1'b1;
                        if (start_bit_reg) begin
                            fsm <= START_BIT;
                        end
                        else begin
                            if (stop_bit_reg) begin
                                fsm <= STOP_BIT;
                            end
                            else begin
                                fsm <= WRITE_BIT;
                            end
                        end
                    end
                    if (go_read_flag) begin
                        busy_flag <= 1'b1;
                        fsm <= READ_BIT;
                    end
                end

                //////////////////////////////////////////////////////////////

                START_BIT : begin  // start bit
                    if (started_flag) begin
                        sda_node <= 1'b1;
                        if (~|delay_counter) begin
                            delay_counter <= DELAY_ENDCOUNT;
                            fsm <= START_BIT_S1;
                        end
                        else begin
                            delay_counter <= delay_counter - ONE[WIDTHBD-1:0];
                        end
                    end
                    else begin
                        fsm <= START_BIT_S2;
                    end
                end
                START_BIT_S1 : begin
                    scl_node <= 1'b1;
                    if (~|delay_counter) begin
                        delay_counter <= DELAY_ENDCOUNT;
                        fsm <= START_BIT_S2;
                    end
                    else begin
                        delay_counter <= delay_counter - ONE[WIDTHBD-1:0];
                    end
                end
                START_BIT_S2 : begin
                    sda_node <= 1'b0;
                    if (~|delay_counter) begin
                        delay_counter <= DELAY_ENDCOUNT;
                        scl_node <= 1'b0;
                        started_flag <= 1'b1;
                        busy_flag <= 1'b0;
                        fsm <= IDLE;
                    end
                    else begin
                        delay_counter <= delay_counter - ONE[WIDTHBD-1:0];
                    end
                end
                
                //////////////////////////////////////////////////////////////
                
                STOP_BIT : begin  // stop bit
                    sda_node <= 1'b0;
                    if (~|delay_counter) begin
                        delay_counter <= DELAY_ENDCOUNT;
                        fsm <= STOP_BIT_S1;
                    end
                    else begin
                        delay_counter <= delay_counter - ONE[WIDTHBD-1:0];
                    end
                end
                STOP_BIT_S1 : begin
                    scl_node <= 1'b1;
                    if (~|delay_counter) begin
                        delay_counter <= DELAY_ENDCOUNT;
                        fsm <= STOP_BIT_S2;
                    end
                    else begin
                        delay_counter <= delay_counter - ONE[WIDTHBD-1:0];
                    end
                end
                STOP_BIT_S2 : begin
                    sda_node <= 1'b1;
                    if (~|delay_counter) begin
                        delay_counter <= DELAY_ENDCOUNT;
                        started_flag <= 1'b0;
                        busy_flag <= 1'b0;
                        fsm <= IDLE;
                    end
                    else begin
                        delay_counter <= delay_counter - ONE[WIDTHBD-1:0];
                    end
                end

                //////////////////////////////////////////////////////////////

                WRITE_BIT : begin  // write bit assume sda = x, scl = 0
                    sda_node <= write_data_bit;
                    if (~|delay_counter) begin
                        delay_counter <= DELAY_ENDCOUNT;
                        fsm <= WRITE_BIT_S1;
                    end
                    else begin
                        delay_counter <= delay_counter - ONE[WIDTHBD-1:0];
                    end
                end
                WRITE_BIT_S1 : begin
                    if (~|delay_counter) begin
                        delay_counter <= DELAY_ENDCOUNT;
                        scl_node <= 1'b0;
                        busy_flag <= 1'b0;
                        fsm <= IDLE;
                    end
                    else begin
                        scl_node <= 1'b1;
                        delay_counter <= delay_counter - ONE[WIDTHBD-1:0];
                    end
                end

                //////////////////////////////////////////////////////////////

                READ_BIT : begin  // read bit assume sda = x, scl = 0
                    sda_node <= 1'b1;
                    if (~|delay_counter) begin
                        delay_counter <= DELAY_ENDCOUNT;
                        fsm <= READ_BIT_S1;
                    end
                    else begin
                        delay_counter <= delay_counter - ONE[WIDTHBD-1:0];
                    end
                end
                READ_BIT_S1 : begin
                    if (~|delay_counter) begin
                        delay_counter <= DELAY_ENDCOUNT;
                        read_data_bit <= sda_sample;
                        scl_node <= 1'b0;
                        busy_flag <= 1'b0;
                        fsm <= IDLE;
                    end
                    else begin
                        scl_node <= 1'b1;
                        delay_counter <= delay_counter - ONE[WIDTHBD-1:0];
                    end
                end
            endcase
        end
    end

endmodule
