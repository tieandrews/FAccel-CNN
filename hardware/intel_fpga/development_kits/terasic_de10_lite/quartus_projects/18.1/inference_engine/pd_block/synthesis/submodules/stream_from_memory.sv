module stream_from_memory (
    input   logic               clock,
    input   logic               clock_sreset,
    
    input   logic [3:0]         s_address,
    output  logic [31:0]        s_readdata,
    input   logic [31:0]        s_writedata,
    input   logic               s_read,
    input   logic               s_write,
    output  logic               s_waitrequest,
    
    output  logic [31:0]        rm_address,
    input   logic [15:0]        rm_readdata,
    output  logic [1:0]         rm_byteenable,
    output  logic               rm_read,
    input   logic               rm_waitrequest,
    input   logic               rm_readdatavalid,
    
    input   logic               st_ready,
    output  logic               st_valid,
    output  logic               st_sop,
    output  logic               st_eop,
    output  logic [15:0]        st_data
);
            localparam          ONE = 128'h1;
            localparam          ZERO = 128'h0;
            localparam          DONTCARE = {128{1'bx}};

    enum    logic [7:0]         {S1, S2, S3, S4, S5, S6, S7, S8} fsm;
            logic [23:0]        word_count_reg, pointer_reg;
            logic [23:0]        counter, end_word_count;
            logic               busy_flag, go_flag;
            logic               read_latency;
    
    always_comb begin
        s_waitrequest = s_write ? 1'b0 : (s_read ? ~read_latency : 1'b0);
    end
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            s_readdata <= DONTCARE[31:0];
            read_latency <= 1'b0;
            go_flag <= 1'b0;
            pointer_reg <= DONTCARE[31:0];
            word_count_reg <= DONTCARE[31:0];
        end
        else begin
            read_latency <= read_latency ? 1'b0 : s_read;
            if (s_address == 4'h0) begin
                s_readdata <= {busy_flag, 1'b0};
                go_flag <= s_write & s_writedata[0];
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
                s_readdata <= word_count_reg;
                if (s_write) begin
                    word_count_reg <= s_writedata;
                end
            end
        end
    end
    
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            rm_address <= DONTCARE[31:0];
            rm_byteenable <= 2'bxx;
            rm_read <= 1'b0;
            end_word_count <= DONTCARE[23:0];
            counter <= DONTCARE[23:0];
            busy_flag <= 1'b0;
            fsm <= S1;
        end
        else begin
            rm_byteenable <= 2'b11;
            end_word_count <= word_count_reg - ONE[23:0];
            case (fsm)
                S1 : begin
                    rm_address <= pointer_reg;
                    counter <= 24'h0;
                    if (go_flag) begin
                        busy_flag <= 1'b1;
                        fsm <= S2;
                    end
                    else begin
                        busy_flag <= 1'b0;
                    end
                end
                S2 : begin
                    if (rm_read) begin
                        if (~rm_waitrequest) begin
                            rm_address <= rm_address + 32'h2;
                            counter <= counter + 24'h1;
                            if (counter >= end_word_count) begin
                                rm_read <= 1'b0;
                                fsm <= S3;
                            end
                        end
                    end
                    else begin
                        rm_read <= 1'b1;
                    end
                end
            endcase
        end
    end

endmodule
