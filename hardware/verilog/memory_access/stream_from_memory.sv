module stream_from_memory # (
            parameter               WIDTH = 16,
            parameter               WIDTHB = 8,
            parameter               WIDTHBE = (WIDTH / 8),
            parameter               FIFO_DEPTH = 512,
            parameter               WIDTHF = $clog2(FIFO_DEPTH)
)
(
    input   logic                   clock,
    input   logic                   clock_sreset,   // glitch free synchronous reset in 'clock' domain

    input   logic                   go,
    output  logic                   busy,
    input   logic [31:0]            pointer,
    input   logic [23:0]            word_size,
    input   logic [WIDTHB-1:0]      burst_count,

    output  logic [31:0]            m_address,
    output  logic [WIDTHBE-1:0]     m_byteenable,
    input   logic [WIDTH-1:0]       m_readdata,
    output  logic [WIDTHB-1:0]      m_burstcount,
    output  logic                   m_read,
    input   logic                   m_waitrequest,
    input   logic                   m_readdatavalid,
    
    input   logic                   fifo_rdreq,
    output  logic [WIDTH-1:0]       fifo_q,
    output  logic [WIDTHF-1:0]      fifo_usedw
);
            localparam              ONE = 128'h1;
            localparam              ZERO = 128'h0;
            localparam              DONTCARE = {128{1'bx}};
    enum    logic [7:0]             {S1, S2} fsm;
            logic [23:0]            word_size_reg;
            logic [WIDTHB-1:0]      burst_count_reg;
            logic                   read_latency, last_word;
            
    scfifo                          # (
                                        .add_ram_output_register("OFF"),
                                        .lpm_numwords(FIFO_DEPTH),
                                        .lpm_showahead("ON"),
                                        .lpm_type("scfifo"),
                                        .lpm_width(WIDTH),
                                        .lpm_widthu(WIDTHF),
                                        .overflow_checking("OFF"),
                                        .underflow_checking("OFF"),
                                        .use_eab("ON")
                                    )
                                    src_rd_fifo (
                                        .clock (clock),
                                        .sclr (clock_sreset),
                                        .aclr (),
                                        .data (m_readdata),
                                        .rdreq (fifo_rdreq),
                                        .wrreq (m_readdatavalid),
                                        .usedw (fifo_usedw),
                                        .q (fifo_q),
                                        .almost_empty (),
                                        .almost_full (),
                                        .empty (),
                                        .full ());
                                        
    // handle read master interface
    always_comb begin
        last_word = (word_size_reg <= burst_count_reg);
    end
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            busy <= 1'b0;
            m_read <= 1'b0;
            m_address <= DONTCARE[31:0];
            m_byteenable <= ~ZERO[WIDTHBE-1:0];
            m_burstcount <= DONTCARE[WIDTHB-1:0];
            word_size_reg <= DONTCARE[23:0];
            burst_count_reg <= DONTCARE[WIDTHB-1:0];
            fsm <= S1;
        end
        else begin
            m_byteenable <= ~ZERO[WIDTHBE-1:0];
            case (fsm)
                S1 : begin  // wait here to begin
                    m_address <= pointer;
                    m_read <= 1'b0;
                    word_size_reg <= word_size;
                    burst_count_reg <= burst_count;
                    if (go) begin
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
                            m_address <= m_address + burst_count_reg;
                            m_read <= 1'b0;
                            if (~|word_size_reg) begin
                                fsm <= S1;
                            end
                        end
                    end
                    else begin
                        if (fifo_usedw < (FIFO_DEPTH - (burst_count_reg << 1))) begin
                            if (|word_size_reg) begin
                                m_read <= 1'b1;
                                if (last_word) begin
                                    word_size_reg <= ZERO[23:0];
                                    m_burstcount <= word_size_reg[WIDTHB-1:0];
                                end
                                else begin
                                    word_size_reg <= word_size_reg - burst_count_reg;
                                    m_burstcount <= burst_count_reg;
                                end
                            end
                            else begin
                                m_read <= 1'b0;
                                fsm <= S1;
                            end
                        end
                        else begin
                            m_read <= 1'b0;
                        end
                    end
                end
            endcase
        end
    end
    
endmodule
