module burst_read_master # (
            parameter           BURST_SIZE = 8,
            parameter           WIDTHB = 4
)
(
    input   logic               clock,
    input   logic               clock_sreset,
    
    input   logic [31:0]        address,
    input   logic [15:0]        words,
    input   logic               go,
    input   logic               data_wait,
    output  logic               busy,
    output  logic               data_valid,
    output  logic [15:0]        data,
    
    output  logic [31:0]        m_address,
    input   logic [15:0]        m_readdata,
    output  logic [1:0]         m_byteenable,
    output  logic [WIDTHB-1:0]  m_burstcount,
    output  logic               m_read,
    input   logic               m_readdatavalid,
    input   logic               m_waitrequest
);
            localparam          DONTCARE = {128{1'bx}};
            localparam          ZERO = 128'h0;
    enum    logic [7:0]         {S1, S2, S3, S4, S5, S6, S7, S8} fsm;
            logic [15:0]        word_count, burst_count;
            logic               busy_flag;
            wire                last_word = (word_count >= BURST_SIZE[15:0]);
            
    always_comb begin
        busy = busy_flag | go;
    end

    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            m_address <= DONTCARE[31:0];
            m_byteenable <= 2'bxx;
            m_read <= 1'b0;
            data <= DONTCARE[15:0];
            data_valid <= 1'b0;
            busy_flag <= 1'b0;
            fsm <= S1;
        end
        else begin
            m_byteenable <= 2'b11;
            data <= m_readdata;
            data_valid <= m_readdatavalid;
            case (fsm)
                S1 : begin
                    m_address <= address;
                    word_count <= words;
                    burst_count <= words;
                    if (go) begin
                        busy_flag <= 1'b1;
                        fsm <= S2;
                    end
                    else begin
                        busy_flag <= 1'b0;
                    end
                end
                S2 : begin
                    if (m_read) begin
                        if (~m_waitrequest) begin
                            m_address <= m_address + (m_burstcount << 1);
                            m_read <= ~data_wait;
                            if (~|word_count) begin
                                fsm <= S3;
                            end
                            else begin
                                if (~data_wait) begin
                                    if (last_word) begin
                                        word_count <= word_count - BURST_SIZE[15:0];
                                        m_burstcount <= BURST_SIZE[WIDTHB-1:0];
                                    end
                                    else begin
                                        word_count <= ZERO[15:0];
                                        m_burstcount <= word_count[WIDTHB-1:0];
                                    end
                                end
                            end
                        end
                    end
                    else begin
                        m_read <= ~data_wait;
                        if (~data_wait) begin
                            if (last_word) begin
                                word_count <= word_count - BURST_SIZE[15:0];
                                m_burstcount <= BURST_SIZE[WIDTHB-1:0];
                            end
                            else begin
                                word_count <= ZERO[15:0];
                                m_burstcount <= word_count[WIDTHB-1:0];
                            end
                        end
                    end
                    burst_count <= burst_count - m_readdatavalid;   // count the burst read words
                end
                S3 : begin
                    burst_count <= burst_count - m_readdatavalid;   // count the burst read words
                    if (~|burst_count)  begin
                        fsm <= S1;
                    end
                end
            endcase
        end
    end

endmodule
