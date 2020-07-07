module stream_to_memory  #(
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
    
    output  logic [31:0]        wm_address,
    output  logic [15:0]        wm_writedata,
    output  logic [1:0]         wm_byteenable,
    output  logic               wm_write,
    input   logic               wm_waitrequest,
    
    output  logic               st_ready,
    input   logic               st_valid,
    input   logic               st_sop,
    input   logic               st_eop,
    input   logic [15:0]        st_data
);
            localparam          ONE = 128'h1;
            localparam          ZERO = 128'h0;
            localparam          DONTCARE = {128{1'bx}};
            localparam          FIFO_BUFFER = FIFO_DEPTH >> 2;
            localparam          FIFO_END = FIFO_DEPTH - FIFO_BUFFER;
            localparam          WIDTHF = $clog2(FIFO_DEPTH);

    enum    logic [7:0]         {S1, S2, S3, S4, S5, S6, S7, S8} fsm;
            logic [23:0]        word_count;
            logic [31:0]        pointer_reg;
            logic               busy_flag, go_flag;
            logic               read_latency, st_ready_reg;
            logic [WIDTHF-1:0]  fifo_usedw;
            logic [15:0]        fifo_q;
            logic               stop_flag, fifo_wrreq;
            
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
                                    .data (st_data),
                                    .rdreq (wm_write & ~wm_waitrequest),
                                    .sclr (clock_sreset),
                                    .wrreq (fifo_wrreq),
                                    .usedw (fifo_usedw),
                                    .q (wm_writedata),
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
            word_count <= DONTCARE[23:0];
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
            if (s_address == 4'h2) begin    // read back the number of words written
                s_readdata <= word_count;
            end
        end
    end
    
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            wm_address <= DONTCARE[31:0];
            wm_byteenable <= 2'bxx;
            wm_write <= 1'b0;
            word_count <= DONTCARE[23:0];
            busy_flag <= 1'b0;
            st_ready_reg <= 1'b0;
            stop_flag <= 1'b0;
            fsm <= S1;
        end
        else begin
            st_ready_reg <= st_ready;
            wm_byteenable <= 2'b11;
            case (fsm)
                S1 : begin
                    stop_flag <= 1'b0;
                    wm_address <= pointer_reg;
                    if (go_flag) begin
                        busy_flag <= 1'b1;
                        fsm <= S2;
                    end
                    else begin
                        busy_flag <= 1'b0;
                    end
                end
                S2 : begin
                    if (st_ready_reg & st_valid & st_sop) begin
                        word_count <= 24'h1;
                        fsm <= S3;
                    end
                end
                S3 : begin
                    if (st_ready_reg & st_valid) begin
                        word_count <= word_count + 24'h1;
                        if (st_eop | (fifo_usedw >= FIFO_END[WIDTHF-1:0])) begin
                            stop_flag <= st_eop;
                            fsm <= S4;
                        end
                    end
                end
                S4 : begin
                    if (wm_write) begin
                        if (~wm_waitrequest) begin
                            wm_address <= wm_address + 32'h2;
                            if (fifo_usedw == 8'h1) begin
                                wm_write <= 1'b0;
                                if (stop_flag) begin
                                    fsm <= S1;
                                end
                                else begin
                                    fsm <= S3;
                                end
                            end
                        end
                    end
                    else begin
                        wm_write <= 1'b1;
                    end
                end
            endcase
        end
    end
    
    always_comb begin
        st_ready = 1'b0;
        fifo_wrreq = 1'b0;
        case (fsm)
            S2, S3 : begin
                st_ready = ~st_eop;
                fifo_wrreq = st_ready_reg & st_valid;
            end
            S4 : begin
            end
            default;
        endcase
    end

endmodule
