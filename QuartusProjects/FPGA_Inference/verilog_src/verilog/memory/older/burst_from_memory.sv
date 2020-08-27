module burst_from_memory # (
            parameter               WIDTH = 16,
            parameter               WIDTHB = 8,
            parameter               WIDTHBE = (WIDTH / 8)
)
(
    input   logic                   clock,
    input   logic                   clock_sreset,   // glitch free synchronous reset in 'clock' domain
    
    input   logic [1:0]             s_address,
    input   logic [31:0]            s_writedata,
    output  logic [31:0]            s_readdata,
    input   logic                   s_read,
    input   logic                   s_write,
    output  logic                   s_waitrequest,
    
    output  logic [31:0]            m_address,
    output  logic [WIDTHBE-1:0]     m_byteenable,
    input   logic [WIDTH-1:0]       m_readdata,
    output  logic [WIDTHB-1:0]      m_burstcount,
    output  logic                   m_read,
    input   logic                   m_waitrequest,
    input   logic                   m_readdatavalid,
    
    output  logic                   data_valid,
    output  logic [WIDTH-1:0]       data
);
            localparam              ONE = 128'h1;
            localparam              ZERO = 128'h0;
            localparam              DONTCARE = {128{1'bx}};
    enum    logic [7:0]             {S1, S2, S3, S4, S5, S6, S7, S8} fsm;
            logic                   go_flag, busy_flag;
            logic [31:0]            source_pointer_reg;
            logic [WIDTHB-1:0]      burst_count_reg;
            logic                   read_latency;
            
    // handle slave interface
    always_comb begin
        s_waitrequest = s_write ? 1'b0 : (s_read ? ~read_latency : 1'b0);
    end
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            go_flag <= 1'b0;
            read_latency <= 1'b0;
            source_pointer_reg <= DONTCARE[31:0];
        end
        else begin
            read_latency <= read_latency ? 1'b0 : s_read;
            if (s_address == 2'h0) begin    // command reg
                go_flag <= s_write & s_writedata[15];
                s_readdata <= burst_count_reg;
                if (s_write) begin
                    burst_count_reg <= s_writedata[WIDTHB-1:0];
                end
            end
            else begin
                go_flag <= 1'b0;
            end
            if (s_address == 2'h1) begin    // status reg
                s_readdata <= {busy_flag}; 
                if (s_write) begin
                end
            end
            if (s_address == 2'h2) begin    // a pointer to the source feature map in memory
                s_readdata <= source_pointer_reg;
                if (s_write) begin
                    source_pointer_reg <= s_writedata;
                end
            end
        end
    end
    
    // handle read master interface
    always_comb begin
        data_valid = m_readdatavalid;
        data = m_readdata;
    end
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            busy_flag <= 1'b0;
            m_read <= 1'b0;
            m_address <= DONTCARE[31:0];
            m_byteenable <= ~ZERO[WIDTHBE-1:0];
            m_burstcount <= DONTCARE[WIDTHB-1:0];
            fsm <= S1;
        end
        else begin
            m_byteenable <= ~ZERO[WIDTHBE-1:0];
            case (fsm)
                S1 : begin  // wait here to begin
                    m_address <= source_pointer_reg;
                    m_burstcount <= burst_count_reg;
                    if (go_flag) begin
                        m_read <= 1'b1;
                        busy_flag <= 1'b1;
                        fsm <= S2;
                    end
                    else begin
                        busy_flag <= 1'b0;
                    end
                end
                S2 : begin   // read a source pixel burst
                    if (m_read) begin
                        if (~m_waitrequest) begin
                            m_read <= 1'b0;
                        end
                    end
                    else begin
                        m_burstcount <= m_burstcount - m_readdatavalid;
                        if (m_burstcount <= ONE[WIDTHB-1:0]) begin
                            fsm <= S1;
                        end
                    end
                end
            endcase
        end
    end
    
endmodule
