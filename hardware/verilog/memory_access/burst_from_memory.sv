module burst_from_memory # (
            parameter               WIDTH = 16,
            parameter               WIDTHB = 8,
            parameter               WIDTHBE = (WIDTH / 8)
)
(
    input   logic                   clock,
    input   logic                   clock_sreset,   // glitch free synchronous reset in 'clock' domain
    
    input   logic                   go,
    output  logic                   busy,
    input   logic [31:0]            pointer,
    input   logic [WIDTHB-1:0]      burst_count,
    
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
            logic                   read_latency;
            
    // handle read master interface
    always_comb begin
        data_valid = m_readdatavalid;
        data = m_readdata;
    end
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
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
                    m_address <= pointer;
                    m_burstcount <= burst_count;
                    if (go) begin
                        m_read <= 1'b1;
                        busy <= 1'b1;
                        fsm <= S2;
                    end
                    else begin
                        busy <= 1'b0;
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
