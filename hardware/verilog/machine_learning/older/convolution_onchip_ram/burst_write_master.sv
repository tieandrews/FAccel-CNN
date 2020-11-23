module burst_write_master # (
            parameter               CH = 6,
            parameter               BURST_SIZE = 8,
            parameter               WIDTHB = 4
)
(
    input   logic                   clock,
    input   logic                   clock_sreset,
    
    input   logic [31:0]            address,
    input   logic [15:0]            words,
    input   logic                   go,
    input   logic                   data_wait,
    output  logic                   busy,
    output  logic [CH-1:0]          fifo_read,
    input   logic [CH-1:0][15:0]    fifo_words,
    input   logic [CH-1:0][15:0]    fifo_q,
    
    output  logic [31:0]            m_address,
    input   logic [15:0]            m_writedata,
    output  logic [1:0]             m_byteenable,
    output  logic [WIDTHB-1:0]      m_burstcount,
    output  logic                   m_write,
    input   logic                   m_waitrequest
);
            localparam              DONTCARE = {128{1'bx}};
            localparam              ZERO = 128'h0;
    enum    logic [7:0]             {S1, S2, S3, S4, S5, S6, S7, S8} fsm;
            logic [15:0]            word_count, burst_count;
            wire                    last_word = (word_count >= BURST_SIZE[15:0]);

    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            m_address <= DONTCARE[31:0];
            m_byteenable <= 2'bxx;
            m_write <= 1'b0;
            busy <= 1'b0;
            fsm <= S1;
        end
        else begin
            m_byteenable <= 2'b11;
            case (fsm)
                S1 : begin
                    m_address <= address;
                    word_count <= words;
                    burst_count <= words;
                    if (go) begin
                        busy <= 1'b1;
                        fsm <= S2;
                    end
                    else begin
                        busy <= 1'b0;
                    end
                end
                S2 : begin
                    if (m_write) begin
                        
                    end
                    else begin
                    end
                end
            endcase
        end
    end

endmodule
