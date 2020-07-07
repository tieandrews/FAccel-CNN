module feature_map_sum # (
            parameter           WIDTH = 16,
            parameter           WORD_STEP = 2,
            parameter           FIFO_DEPTH = 512,
            parameter           FIFO_BURST = 256,
            parameter           EXP = 8,
            parameter           MANT = 7,
            parameter           ADD_LCYCLES = 4
)
(
    input   logic               clock,
    input   logic               clock_sreset,
    
    input   logic [3:0]         s_address,
    input   logic [31:0]        s_writedata,
    output  logic [31:0]        s_readdata,
    input   logic               s_read,
    input   logic               s_write,
    output  logic               s_waitrequest,
    
    output  logic [31:0]        m_address,
    input   logic [WIDTH-1:0]   m_readdata,
    output  logic [WIDTH-1:0]   m_writedata,
    output  logic               m_read,
    output  logic               m_write,
    input   logic               m_waitrequest
    
);
            localparam          DONTCARE = {128{1'bx}};
            localparam          ZERO = 128'h0;
            localparam          ONE = {ZERO, 1'b1};
            localparam          WIDTHF = $clog2(FIFO_DEPTH);
            
    enum    logic [3:0]         {S1, S2, S3, S4} fsm;
            
            logic [31:0]        read_pointer_reg, sum_pointer_reg;
            logic [23:0]        word_count_reg;
            logic [31:0]        rd_pointer, wr_pointer;
            logic [23:0]        word_count;
            logic [WIDTHF-1:0]  burst_count, in_flight_count;
            logic [WIDTH-1:0]   float_result, dataa_reg, datab_reg;
            logic               read_latency, float_result_valid, float_data_valid;
            logic               go_flag , busy_flag;
            
    fp_add                      # (
                                    .EXP(EXP),
                                    .MANT(MANT),
                                    .WIDTH(WIDTH),
                                    .LCYCLES(ADD_LCYCLES)
                                )
                                adder (
                                    .clock(clock),
                                    .clock_sreset(clock_sreset),
                                    .dataa(dataa_reg),
                                    .datab(datab_reg),
                                    .data_valid(float_data_valid),
                                    .result(float_result),
                                    .result_valid(float_result_valid)
                                );

    // handle avalon interface
    always_comb begin
        s_waitrequest = s_write ? 1'b0 : (s_read ? ~read_latency : 1'b0);
    end
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            read_latency <= 1'b0;
            go_flag <= 1'b0;
            s_readdata <= DONTCARE[31:0];
            sum_pointer_reg <= DONTCARE[31:0];
            read_pointer_reg <= DONTCARE[31:0];
        end
        else begin
            s_readdata <= {busy_flag, 1'b0};
            if (s_address == 4'h0) begin
                go_flag <= s_write;
            end
            else begin
                go_flag <= 1'b0;
            end
            if (s_address == 4'h1) begin
                s_readdata <= read_pointer_reg;
                if (s_write) begin
                    read_pointer_reg <= s_writedata;
                end
            end
            if (s_address == 4'h2) begin
                s_readdata <= sum_pointer_reg;
                if (s_write) begin
                    sum_pointer_reg <= s_writedata;
                end
            end
            if (s_address == 4'h3) begin
                s_readdata <= word_count_reg;
                if (s_write) begin
                    word_count_reg <= s_writedata[23:0];
                end
            end
        end
    end
        
    // handle read / write master
    always_comb begin
        m_writedata = float_result;
        float_data_valid = 1'b0;
        case (fsm)
            S3 : begin
                if (~m_read) begin
                    float_data_valid = 1'b1;
                end
            end
        endcase
    end
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            m_address <= DONTCARE[31:0];
            m_read <= 1'b0;
            m_write <= 1'b0;
            dataa_reg <= DONTCARE[WIDTH-1:0];
            datab_reg <= DONTCARE[WIDTH-1:0];
            busy_flag <= 1'b0;
            rd_pointer <= DONTCARE[31:0];
            wr_pointer <= DONTCARE[31:0];
            fsm <= S1;
        end
        else begin
            case (fsm)
                S1 : begin  // wait for the 'go' flag (write 0x1 to address 0x0 on slave)
                    word_count <= ZERO[23:0];
                    rd_pointer <= read_pointer_reg;
                    wr_pointer <= sum_pointer_reg;
                    if (go_flag) begin
                        busy_flag <= 1'b1;  // visible as read from address 0x0 on slave - bit 1 (2nd bit)
                        fsm <= S2;
                    end
                    else begin
                        busy_flag <= 1'b0;
                    end
                end
                S2 : begin  // read in word from rd_pointer
                    dataa_reg <= m_readdata;
                    if (m_read) begin
                        if (~m_waitrequest) begin
                            m_address <= wr_pointer;
                            fsm <= S3;
                        end
                    end
                    else begin
                        m_address <= rd_pointer;
                        m_read <=1 'b1;
                    end
                end
                S3 : begin  // read in word from wr_pointer
                    datab_reg <= m_readdata;
                    if (m_read) begin
                        if (~m_waitrequest) begin
                            m_read <= 1'b0;
                        end
                    end
                    else begin
                        fsm <= S4;
                    end
                end
                S4 : begin  // writeback float sum
                    if (m_write) begin
                        if (~m_waitrequest) begin
                            rd_pointer <= rd_pointer + WORD_STEP;
                            wr_pointer <= wr_pointer + WORD_STEP;
                            word_count <= word_count + ONE[23:0];
                            if (word_count >= word_count_reg) begin
                                fsm <= S1;
                            end
                            else begin
                                fsm <= S2;
                            end
                        end
                    end
                    else begin
                        m_write <= float_result_valid;
                    end
                end
            endcase
        end
    end

endmodule
