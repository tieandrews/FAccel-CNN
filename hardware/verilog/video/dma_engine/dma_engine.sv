module dma_engine (
    input   logic           clock,
    input   logic           clock_sreset,
    
    input   logic [3:0]     s_address,
    input   logic [31:0]    s_writedata,
    output  logic [31:0]    s_readdata,
    input   logic           s_read,
    input   logic           s_write,
    output  logic           s_waitrequest,
    output  logic           s_irq,
    
    output  logic [31:0]    mr_address,
    output  logic [1:0]     mr_byteenable,
    input   logic [15:0]    mr_readdata,
    output  logic           mr_read,
    input   logic           mr_waitrequest,
    
    output  logic [31:0]    mw_address,
    output  logic [1:0]     mw_byteenable,
    output  logic [15:0]    mw_writedata,
    output  logic           mw_write,
    input   logic           mw_waitrequest
);
            localparam      ONE = 128'h1;
            localparam      ZERO = 128'h0;
            localparam      DONTCARE = {128{1'bx}};
    enum    logic [7:0]     {S1, S2, S3, S4, S5, S6, S7, S8} fsm;
            logic           read_latency;
            logic           go_flag, busy_flag, reset_flag, irq_clear_flag, irq_flag;
            logic [31:0]    read_pointer_reg, write_pointer_reg;
            logic [31:0]    word_count_reg, counter;
            
    always_comb begin
        s_waitrequest = s_write ? 1'b0 : (s_read ? ~read_latency : 1'b0);
    end
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            read_latency <= 1'b0;
            s_readdata <= DONTCARE[31:0];
            read_pointer_reg <= DONTCARE[31:0];
            write_pointer_reg <= DONTCARE[31:0];
            word_count_reg <= DONTCARE[31:0];
            go_flag <= 1'b0;
            reset_flag <= 1'b0;
        end
        else begin
            read_latency <= read_latency ? 1'b0 : s_read;
            if (s_address == 4'h0) begin
                s_readdata <= {irq_flag, busy_flag, go_flag};
                go_flag <= s_write & s_writedata[0];
                if (s_write) begin
                    irq_flag <= s_writedata[1];
                end
            end
            else begin
                go_flag <= 1'b0;
            end
            if (s_address == 4'h1) begin
                reset_flag <= s_write & s_writedata[0];
                irq_clear_flag <= s_write & s_writedata[1];
            end
            else begin
                reset_flag <= 1'b0;
                irq_clear_flag <= 1'b0;
            end
            case (s_address)
                4'h2 : begin
                    s_readdata <= read_pointer_reg;
                    if (s_write) begin
                        read_pointer_reg <= s_writedata[31:0];
                    end
                end
                4'h3 : begin
                    s_readdata <= write_pointer_reg;
                    if (s_write) begin
                        write_pointer_reg <= s_writedata[31:0];
                    end
                end
                4'h4 : begin
                    s_readdata <= word_count_reg;
                    if (s_write) begin
                        word_count_reg <= s_writedata[31:0];
                    end
                end
            endcase
        end
    end
    
    always_ff @ (posedge clock) begin
        if (clock_sreset | reset_flag) begin
            mr_address <= DONTCARE[31:0];
            mr_byteenable <= 2'b11;
            mr_read <= 1'b0;
            mw_address <= DONTCARE[31:0];
            mw_byteenable <= 2'b11;
            mw_writedata <= DONTCARE[15:0];
            mw_write <= 1'b0;
            counter <= DONTCARE[31:0];
            fsm <= S1;
        end
        else begin
            case (fsm)
                S1 : begin
                    counter <= ZERO[31:0];
                    mr_address <= read_pointer_reg;
                    mr_byteenable <= 2'b11;
                    mw_address <= write_pointer_reg;
                    mw_byteenable <= 2'b11;
                    if (irq_clear_flag) begin
                        s_irq <= 1'b0;
                    end
                    if (go_flag) begin
                        mr_read <= 1'b1;
                        busy_flag <= 1'b1;
                        fsm <= S2;
                    end
                    else begin
                        busy_flag <= 1'b0;
                    end
                end
                S2 : begin
                    mw_writedata <= mr_readdata;
                    if (mr_read) begin
                        if (~mr_waitrequest) begin
                            mr_address <= mr_address + 32'h2;
                            mr_read <= 1'b0;
                            mw_write <= 1'b1;
                            fsm <= S3;
                        end
                    end
                end
                S3 : begin
                    if (mw_write) begin
                        if (~mw_waitrequest) begin
                            mw_address <= mw_address + 32'h2;
                            mw_write <= 1'b0;
                            counter <= counter + 32'h1;
                            if (counter >= (word_count_reg - 32'h1)) begin
                                s_irq <= irq_flag;
                                fsm <= S1;
                            end
                            else begin
                                mr_read <= 1'b1;
                                fsm <= S2;
                            end
                        end
                    end
                end
            endcase
        end
    end

endmodule
