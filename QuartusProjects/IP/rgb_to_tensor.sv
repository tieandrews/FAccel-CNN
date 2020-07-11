module rgb_to_tensor // BFLOAT16 only
(
    input   logic                   clock,
    input   logic                   clock_sreset,
    input   logic [3:0]             s_address,
    output  logic [31:0]            s_readdata,
    input   logic [31:0]            s_writedata,
    input   logic                   s_read,
    input   logic                   s_write,
    output  logic                   s_waitrequest,
    
    output  logic [31:0]            m_address,
    output  logic [15:0]            m_writedata,
    input   logic [15:0]            m_readdata,
    output  logic [1:0]             m_byteenable,
    output  logic                   m_read,
    output  logic                   m_write,
    input   logic                   m_waitrequest
);
            localparam              ZERO = 128'h0;
            localparam              ONE = 128'h1;
            localparam              DONTCARE = {128{1'bx}};
    enum    logic [7:0]             {S1, S2, S3, S4, S5, S6, S7} fsm;
            logic                   read_latency;
            logic                   go_flag, busy_flag;
            logic [31:0]            src_pointer, red_pointer, green_pointer, blue_pointer;
            logic [23:0]            offset;
            logic [23:0]            word_count;
            logic [15:0]            red_float, green_float, blue_float;
            logic [15:0]            data_reg;
            logic [2:0]             rgb_phase;
            
    fp_lut6 i2f_red(.int_in({data_reg[15:11], 1'b0}), .float_out(red_float)); // 5 bits
    fp_lut6 i2f_green(.int_in(data_reg[10:5]), .float_out(green_float));      // 6 bits
    fp_lut6 i2f_blue(.int_in({data_reg[4:0], 1'b0}), .float_out(blue_float)); // 5 bits
                        
    always_comb begin
        s_waitrequest = s_write ? 1'b0 : (s_read ? ~read_latency : 1'b0);
    end
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            read_latency <= 1'b0;
            go_flag <= 1'b0;
            src_pointer <= DONTCARE[31:0];
            red_pointer <= DONTCARE[31:0];
            green_pointer <= DONTCARE[31:0];
            blue_pointer <= DONTCARE[31:0];
            s_readdata <= DONTCARE[31:0];
        end
        else begin
            read_latency <= s_read;
            if (s_address == 4'h0) begin
                s_readdata <= {busy_flag, 1'bx};
                go_flag <= s_write & s_writedata[0];
            end
            else begin
                go_flag <= 1'b0;
            end
            if (s_address == 4'h1) begin    // rgb image
                s_readdata <= src_pointer;
                if (s_write) begin
                    src_pointer <= s_writedata;
                end
            end
            if (s_address == 4'h2) begin    // red float page
                s_readdata <= red_pointer;
                if (s_write) begin
                    red_pointer <= s_writedata;
                end
            end
            if (s_address == 4'h3) begin    // green float page
                s_readdata <= green_pointer;
                if (s_write) begin
                    green_pointer <= s_writedata;
                end
            end
            if (s_address == 4'h4) begin    // blue float page
                s_readdata <= blue_pointer;
                if (s_write) begin
                    blue_pointer <= s_writedata;
                end
            end
            if (s_address == 4'h5) begin    // number of words to transfer
                s_readdata <= word_count;
                if (s_write) begin
                    word_count <= s_writedata[23:0];
                end
            end
        end
    end
    
    // read RGB pixels (565 format), write 3 floats one for each plane
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            fsm <= S1;
            m_address <= DONTCARE[31:0];
            m_byteenable <= 2'bxx;
            m_writedata <= DONTCARE[15:0];
            m_read <= 1'b0;
            m_write <= 1'b0;
            busy_flag <= 1'b0;
            rgb_phase <= 2'h0;
            offset <= DONTCARE[23:0];
        end
        else begin
            case (fsm)
                S1 : begin
                    offset <= 24'h0;
                    m_byteenable <= 2'b11;
                    if (go_flag) begin
                        m_read <= 1'b1;
                        busy_flag <= 1'b1;
                        fsm <= S2;
                    end
                    else begin
                        busy_flag <= 1'b0;
                    end
                end
                S2 : begin  // read RGB value
                    data_reg <= m_readdata;
                    if (m_read) begin
                        if (~m_waitrequest) begin
                            m_read <= 1'b0;
                            fsm <= S3;
                        end
                    end
                    else begin
                        m_address <= src_pointer + (offset << 1);   // 16 bit words
                        m_read <= 1'b1;
                    end
                end
                S3 : begin  // write red/green/blue float
                    m_writedata <= (rgb_phase == 2'h0) ? red_float :
                        (rgb_phase == 2'h1) ? green_float : blue_float;
                    if (m_write) begin
                        if (~m_waitrequest) begin
                            m_write <= 1'b0;
                            rgb_phase <= rgb_phase + 2'h1;
                            offset <= offset + 24'h1;
                            if (rgb_phase >= 2'h2) begin
                                if (offset >= (word_count - 24'h1)) begin
                                    fsm <= S1;
                                end
                                else begin
                                    fsm <= S2;
                                end
                            end
                        end
                    end
                    else begin
                        m_address <= ((rgb_phase == 2'h0) ? red_pointer : 
                            (rgb_phase == 2'h1) ? green_pointer : blue_pointer) + (offset << 1);
                        m_write <= 1'b1;
                    end
                end
            endcase
        end
    end

endmodule
