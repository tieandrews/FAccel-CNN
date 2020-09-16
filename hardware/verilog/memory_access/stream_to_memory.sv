module stream_to_memory # (
            parameter               WIDTH = 16,
            parameter               WIDTHB = 8,
            parameter               WIDTHBE = (WIDTH / 8),
            parameter               FIFO_DEPTH = 512,
            parameter               WIDTHF = $clog2(FIFO_DEPTH)
)
(
    input   logic                   clock,
    input   logic                   clock_sreset,   // glitch free synchronous reset in 'clock' domain
	
	input	logic					go,
    input   logic                   flush,
	output	logic					busy,
	input	logic [31:0]			pointer,
	input	logic [23:0]			word_size,
	input	logic [WIDTHB-1:0]		burst_count,
    
    output  logic [31:0]            m_address,
    output  logic [WIDTHBE-1:0]     m_byteenable,
    output  logic [WIDTH-1:0]       m_writedata,
    output  logic [WIDTHB-1:0]      m_burstcount,
    output  logic                   m_write,
    input   logic                   m_waitrequest,
    
    input   logic                   fifo_wrreq,
    input   logic [WIDTH-1:0]       fifo_data,
    output  logic [WIDTHF-1:0]      fifo_usedw
);
            localparam              ONE = 128'h1;
            localparam              ZERO = 128'h0;
            localparam              DONTCARE = {128{1'bx}};
    enum    logic [7:0]             {S1, S2, S3, S4, S5, S6, S7, S8} fsm;
            logic [31:0]            pointer_reg;
            logic [23:0]            word_counter;
            logic [WIDTHB-1:0]      burst_count_reg;
            logic                   fifo_rdreq;
            logic [WIDTH-1:0]       fifo_q;
            logic                   flush_flag;
            
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
                                        .data (fifo_data),
                                        .rdreq (fifo_rdreq),
                                        .wrreq (fifo_wrreq),
                                        .usedw (fifo_usedw),
                                        .q (fifo_q),
                                        .almost_empty (),
                                        .almost_full (),
                                        .empty (),
                                        .full ());
                                        
    // handle read master interface
    always_comb begin
        case (fsm)
            S2, S3 : fifo_rdreq = m_write & ~m_waitrequest;
            default : fifo_rdreq = 1'b0;
        endcase
    end
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            busy <= 1'b0;
            flush_flag <= 1'b0;
            m_write <= 1'b0;
            m_address <= DONTCARE[31:0];
            m_byteenable <= ~ZERO[WIDTHBE-1:0];
            m_burstcount <= DONTCARE[WIDTHB-1:0];
            word_counter <= DONTCARE[23:0];
            fsm <= S1;
        end
        else begin
            m_byteenable <= ~ZERO[WIDTHBE-1:0];
            case (fsm)
                S1 : begin  // wait here to begin
                    m_address <= pointer;
                    word_counter <= word_size;
                    burst_count_reg <= burst_count;
                    flush_flag <= flush;
                    m_write <= 1'b0;
                    if (go | flush) begin
                        busy <= 1'b1;
                        fsm <= S2;
                    end
                    else begin
                        busy <= 1'b0;
                    end
                end
                S2 : begin   // write a burst to memory
                    m_writedata <= fifo_q;
                    if (m_write) begin
                        if (~m_waitrequest) begin
                            m_burstcount <= m_burstcount - ONE[WIDTHB-1:0];
                            if (m_burstcount <= ONE[WIDTHB-1:0]) begin
                                m_write <= 1'b0;
                                if (~|word_counter) begin
                                    flush_flag <= 1'b0;
									fsm <= S1;
								end
                            end
                        end
                    end
                    else begin
                        if ((flush_flag & |fifo_usedw) || (fifo_usedw >= burst_count_reg)) begin
                            m_write <= 1'b1;
                            if (word_counter >= burst_count_reg) begin
                                m_burstcount <= burst_count_reg;
                                word_counter <= word_counter - burst_count_reg;
                            end
                            else begin
                                m_burstcount <= word_counter[7:0];
                                word_counter <= ZERO[23:0];
                            end
                        end
                    end
                end
            endcase
        end
    end
    
endmodule
