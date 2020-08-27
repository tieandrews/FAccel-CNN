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
    
    input   logic                   fifo_rdreq,
    output  logic [WIDTH-1:0]       fifo_q,
    output  logic [WIDTHF-1:0]      fifo_usedw
);
            localparam              ONE = 128'h1;
            localparam              ZERO = 128'h0;
            localparam              DONTCARE = {128{1'bx}};
    enum    logic [7:0]             {S1, S2, S3, S4, S5, S6, S7, S8} fsm;
            logic                   go_flag, busy_flag;
            logic [31:0]            source_pointer_reg;
            logic [23:0]            word_size_reg, word_counter;
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
            if (s_address == 2'h3) begin    // a pointer to the destination feature map in memory
                s_readdata <= word_size_reg;
                if (s_write) begin
                    word_size_reg <= s_writedata[23:0];
                end
            end
        end
    end
    
    // handle read master interface
    always_comb begin
        last_word = (word_counter <= burst_count_reg);
    end
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            busy_flag <= 1'b0;
            m_read <= 1'b0;
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
                    m_address <= source_pointer_reg;
                    word_counter <= word_size_reg;
                    m_read <= 1'b0;
                    if (go_flag) begin
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
                            if (~|word_counter) begin
                                fsm <= S1;
                            end
                        end
                    end
                    else begin
                        if (fifo_usedw < (FIFO_DEPTH - (burst_count_reg << 1))) begin
                            if (|word_counter) begin
                                m_read <= 1'b1;
                                if (last_word) begin
                                    word_counter <= ZERO[23:0];
                                    m_burstcount <= word_counter[WIDTHB-1:0];
                                end
                                else begin
                                    word_counter <= word_counter - burst_count_reg;
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
