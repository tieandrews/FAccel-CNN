module char_blit # (
            parameter               XRES = 640
)
(
    input   logic                   clock,
    input   logic                   clock_sreset,
    
    input   logic [3:0]             s_address,
    input   logic [31:0]            s_writedata,
    output  logic [31:0]            s_readdata,
    input   logic                   s_read,
    input   logic                   s_write,
    output  logic                   s_waitrequest,
    output  logic                   s_irq,
    
    output  logic [31:0]            m_address,
    output  logic [1:0]             m_byteenable,
    output  logic [15:0]            m_writedata,
    output  logic                   m_write,
    input   logic                   m_waitrequest
);
            localparam              ONE = 128'h1;
            localparam              ZERO = 128'h0;
            localparam              DONTCARE = {128{1'bx}};
    enum    logic [7:0]             {S1, S2, S3, S4, S5, S6, S7, S8} fsm;
            logic [7:0]             char_table[0:1023], char_table_data;
            logic [31:0]            pointer_reg;
            logic [6:0]             char_reg;
            logic [15:0]            rgb_reg;
            logic [2:0]             count_x, count_y;
            logic                   read_latency;
            logic                   go_flag, busy_flag, clear_irq_flag, irq_flag;
    initial begin
        $readmemh("chars.hex", char_table);
    end

    always_ff @ (posedge clock) begin
        char_table_data <= char_table[{char_reg, count_y}];
    end
    
    always_comb begin
        s_waitrequest = s_write ? 1'b0 : (s_read ? ~read_latency : 1'b0);
    end
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            s_readdata <= DONTCARE[31:0];
            go_flag <= 1'b0;
            pointer_reg <= DONTCARE[31:0];
            read_latency <= 1'b0;
            char_reg <= DONTCARE[6:0];
            rgb_reg <= DONTCARE[15:0];
        end
        else begin
            read_latency <= read_latency ? 1'b0 : s_read;
            if (s_address == 4'h0) begin
                s_readdata <= {irq_flag, busy_flag , 1'bx};
                go_flag <= s_write & s_writedata[0];
                if (s_write) begin
                    irq_flag <= s_writedata[2];
                end
            end
            else begin
                go_flag <= 1'b0;
            end
            if (s_address == 4'h1) begin
                s_readdata <= pointer_reg;
                if (s_write) begin
                    pointer_reg <= s_writedata;
                end
            end
            if (s_address == 4'h2) begin
                s_readdata <= char_reg;
                if (s_write) begin
                    char_reg <= s_writedata[6:0];
                end
            end
            if (s_address == 4'h3) begin
                s_readdata <= rgb_reg;
                if (s_write) begin
                    rgb_reg <= s_writedata[15:0];
                end
            end
            if (s_address == 4'h4) begin
                clear_irq_flag <= s_write & s_writedata[0];
            end
            else begin
                clear_irq_flag <= 1'b0;
            end
        end
    end
    
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            busy_flag <= 1'b0;
            count_x <= 3'h0;
            count_y <= 3'h0;
            m_writedata <= DONTCARE[15:0];
            m_byteenable <= 2'b11;
            fsm <= S1;
        end
        else begin
            m_byteenable <= 2'b11;
            if (clear_irq_flag) begin
                s_irq <= 1'b0;
            end
            case (fsm)
                S1 : begin
                    m_address <= pointer_reg;
                    count_x <= 3'h0;
                    count_y <= 3'h0;
                    if (go_flag) begin
                        busy_flag <= 1'b1;
                        fsm <= S2;
                    end
                    else begin
                        busy_flag <= 1'b0;
                    end
                end
                S2 : begin
                    if (m_write) begin
                        if (~m_waitrequest) begin
                            m_writedata <= char_table_data[count_x] ? rgb_reg : 16'h0;
                            m_write <= 1'b0;
                            if (count_x >= 3'h7) begin
                                count_x <= 3'h0;
                                count_y <= count_y + 3'h1;
                                m_address <= m_address + ((XRES - 7) * 2);
                                if (count_y >= 3'h7) begin
                                    s_irq <= irq_flag;
                                    fsm <= S1;
                                end
                            end
                            else begin
                                count_x <= count_x + 3'h1;
                                m_address <= m_address + 32'h2;
                            end
                        end
                    end
                    else begin
                        m_write <= 1'b1;
                    end
                end
            endcase
        end
    end

endmodule
