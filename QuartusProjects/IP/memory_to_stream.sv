module memory_to_stream # (
            parameter           FIFO_DEPTH = 512,
            parameter           USE_EAB = "ON"
)
(
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
            localparam          FIFO_BUFFER = FIFO_DEPTH >> 2;
            localparam          FIFO_END = FIFO_DEPTH - FIFO_BUFFER;
            localparam          WIDTHF = $clog2(FIFO_DEPTH);            

    enum    logic [7:0]         {S1, S2, S3, S4, S5, S6, S7, S8} fsm;
            logic [23:0]        word_count_reg;
            logic [31:0]        pointer_reg;
            logic [23:0]        counter;
            logic               busy_flag, go_flag;
            logic               read_latency;
            logic               fifo_rdreq;
            logic [WIDTHF-1:0]  fifo_usedw;
            logic [15:0]        fifo_q;
            logic               start_flag;
            
    initial begin
        if (FIFO_DEPTH < 4) begin
            $fatal("FIFO_DEPTH too small must be > 3");
        end
    end
            
    scfifo                      # (
                                    .add_ram_output_register("OFF"),
                                    //.intended_device_family("Cyclone IV E"),
                                    .lpm_numwords(FIFO_DEPTH), // M9K by 16 bits wide
                                    .lpm_showahead("ON"),
                                    .lpm_type("scfifo"),
                                    .lpm_width(16),
                                    .lpm_widthu(WIDTHF),
                                    .overflow_checking("OFF"),
                                    .underflow_checking("OFF"),
                                    .use_eab(USE_EAB)
                                )
                                fifo (
                                    .clock (clock),
                                    .data (rm_readdata),
                                    .rdreq (fifo_rdreq),
                                    .sclr (clock_sreset),
                                    .wrreq (rm_readdatavalid),
                                    .usedw (fifo_usedw),
                                    .q (fifo_q),
                                    .aclr (),
                                    .almost_empty (),
                                    .almost_full (),
                                    .empty (),
                                    .full ());

    
    always_comb begin
        s_waitrequest = s_write ? 1'b0 : (s_read ? ~read_latency : 1'b0);
    end
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            s_readdata <= DONTCARE[31:0];
            read_latency <= 1'b0;
            go_flag <= 1'b0;
            pointer_reg <= DONTCARE[31:0];
            word_count_reg <= DONTCARE[23:0];
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
                    word_count_reg <= s_writedata[23:0];
                end
            end
        end
    end
    
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            rm_address <= DONTCARE[31:0];
            rm_byteenable <= 2'bxx;
            rm_read <= 1'b0;
            counter <= DONTCARE[23:0];
            busy_flag <= 1'b0;
            start_flag <= 1'bx;
            st_data <= DONTCARE[15:0];
            st_valid <= 1'b0;
            st_sop <= 1'b0;
            st_eop <= 1'b0;
            fsm <= S1;
        end
        else begin
            rm_byteenable <= 2'b11;
            case (fsm)
                S1 : begin
                    st_valid <= 1'b0;
                    st_sop <= 1'b0;
                    st_eop <= 1'b0;
                    rm_address <= pointer_reg;
                    counter <= word_count_reg - ONE[23:0];
                    start_flag <= 1'b0;
                    if (go_flag) begin
                        busy_flag <= 1'b1;
                        fsm <= S2;
                    end
                    else begin
                        busy_flag <= 1'b0;
                    end
                end
                S2 : begin
                    st_valid <= 1'b0;
                    st_sop <= 1'b0;
                    st_eop <= 1'b0;
                    if (rm_read) begin
                        if (~rm_waitrequest) begin
                            if (~|counter) begin
                                rm_read <= 1'b0;
                                fsm <= S3;
                            end
                            else begin
                                if (fifo_usedw < FIFO_END[WIDTHF-1:0]) begin
                                    rm_address <= rm_address + 32'h2;
                                    counter <= counter - 24'h1;
                                end
                                else begin
                                    rm_read <= 1'b0;
                                    fsm <= S3;
                                end
                            end
                        end
                    end
                    else begin
                        rm_read <= 1'b1;
                    end
                end
                S3 : begin
                    st_data <= fifo_q;
                    if (st_ready) begin
                        if (fifo_usedw > 8'h0) begin
                            st_valid <= 1'b1;
                            st_sop <= ~start_flag;
                            start_flag <= start_flag | 1'b1;
                            if (fifo_usedw == 8'h1) begin
                                if (~|counter) begin
                                    st_eop <=1'b1;
                                    fsm <= S1;
                                end
                                else begin
                                    fsm <= S2;
                                end
                            end
                        end
                        else begin
                            st_valid <= 1'b0;
                            fsm <= S2;
                        end
                    end
                    else begin
                        st_valid <= 1'b0;
                        st_sop <= 1'b0;
                        st_eop <= 1'b0;
                    end
                end
            endcase
        end
    end
    
    always_comb begin
        fifo_rdreq = 1'b0;
        case (fsm)
            S3 : begin
                if (fifo_usedw > 8'h0) begin
                    fifo_rdreq = 1'b1;
                end
            end
            default;
        endcase
    end

endmodule
