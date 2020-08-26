module convolution_burst # (
            parameter           MAX_XRES = 256,
            parameter integer   XRES1=16, XRES2=32, XRES3=64, XRES4=128, XRES5=256,   // x resolution without padding
            parameter integer   YRES1=16, YRES2=32, YRES3=64, YRES4=128, YRES5=256,
            parameter           RESOLUTIONS = 5,
            parameter           PAD = 1,

            parameter           KX = 3,
            parameter           KY = 3,

            parameter           EXP = 8,
            parameter           MANT = 7,
            parameter           WIDTHF = 16,    // 1 + EXP + MANT
            
            parameter           FIFO_DEPTH = 512,
            
            parameter           WIDTH = 16,     // closest power of 2 for width = 2 ** $clog2(WIDTHF),
            parameter           WIDTHBE = 2,     // byte lanes for WIDTH = (WIDTH / 8),
            parameter           WIDTHB = 8,     // bits for burst fifo words
            
            parameter           ADDER_PIPELINE = 1  // 1 or 0
)
(
    input   logic               clock,
    input   logic               clock_sreset,
    
    input   logic [4:0]         s_address,
    input   logic [31:0]        s_writedata,
    output  logic [31:0]        s_readdata,
    input   logic               s_read,
    input   logic               s_write,
    output  logic               s_waitrequest,
    
    output  logic [31:0]        rm1_address,        // source
    input   logic [WIDTH-1:0]   rm1_readdata,
    output  logic [WIDTHBE-1:0] rm1_byteenable,
    output  logic [WIDTHB-1:0]  rm1_burstcount,
    output  logic               rm1_read,
    input   logic               rm1_readdatavalid,
    input   logic               rm1_waitrequest,
        
    output  logic [31:0]        rm2_address,        // destination
    input   logic [WIDTH-1:0]   rm2_readdata,
    output  logic [WIDTHBE-1:0] rm2_byteenable,
    output  logic [WIDTHB-1:0]  rm2_burstcount,
    output  logic               rm2_read,
    input   logic               rm2_readdatavalid,
    input   logic               rm2_waitrequest,

    output  logic [31:0]        rm3_address,        // kernel
    input   logic [WIDTH-1:0]   rm3_readdata,
    output  logic [WIDTHBE-1:0] rm3_byteenable,
    output  logic [WIDTHB-1:0]  rm3_burstcount,
    output  logic               rm3_read,
    input   logic               rm3_readdatavalid,
    input   logic               rm3_waitrequest,
    
    output  logic [31:0]        wm1_address,        // destination
    output  logic [WIDTH-1:0]   wm1_writedata,
    output  logic [WIDTHBE-1:0] wm1_byteenable,
    output  logic [WIDTHB-1:0]  wm1_burstcount,
    output  logic               wm1_write,
    input   logic               wm1_waitrequest
);
            localparam          DONTCARE = {128{1'bx}};
            localparam          ONE = 128'h1;
            localparam          ZERO = 128'h0;
            localparam          ONES = ~ZERO;
            
            localparam          WIDTHR = $clog2(MAX_XRES);
            localparam          WIDTHFD = $clog2(FIFO_DEPTH);

    enum    logic [9:0]         {S1, S2, S3, S4, S5, S6, S7, S8, S9, S10} fsm;
    
            logic               busy_flag, go_flag;
            logic               read_latency;
            logic [WIDTHFD-1:0] fifo1_usedw, fifo2_usedw;
            logic [WIDTH-1:0]   fifo1_q, fifo2_q;
            logic               fifo1_rdreq, fifo2_rdreq;
            logic [31:0]        ss_readdata[5:0];
            logic [5:0]         ss_waitrequest;
            logic [WIDTH-1:0]   conv_result, adder_result, conv_kernel_data, conv_data;
            logic               conv_result_valid,adder_result_valid;
            logic               conv_kernel_data_shift,conv_enable_calc, conv_data_shift;
            logic [2:0]         conv_xres_select;

            wire  [5:0]         ss_select = 6'h1 << s_address[4:2];
            
    stream_from_memory          # (
                                    .WIDTH(WIDTH),
                                    .WIDTHB(WIDTHB),
                                    .WIDTHBE(WIDTH / 8),
                                    .FIFO_DEPTH(FIFO_DEPTH),
                                    .WIDTHF(WIDTHFD)
                                )
                                from_memory1 (
                                    .clock(clock),
                                    .clock_sreset(clock_sreset),
                                    .s_address(s_address[1:0]),
                                    .s_writedata(s_writedata),
                                    .s_readdata(ss_readdata[1]),
                                    .s_read(s_read & ss_select[1]),
                                    .s_write(s_write & ss_select[1]),
                                    .s_waitrequest(ss_waitrequest[1]),
                                    .m_address(rm1_address),
                                    .m_byteenable(rm1_byteenable),
                                    .m_readdata(rm1_readdata),
                                    .m_burstcount(rm1_burstcount),
                                    .m_read(rm1_read),
                                    .m_waitrequest(rm1_waitrequest),
                                    .m_readdatavalid(rm1_readdatavalid),
                                    .fifo_rdreq(fifo1_rdreq),
                                    .fifo_usedw(fifo1_usedw),
                                    .fifo_q(fifo1_q)
                                );

    stream_from_memory          # (
                                    .WIDTH(WIDTH),
                                    .WIDTHB(WIDTHB),
                                    .WIDTHBE(WIDTH / 8),
                                    .FIFO_DEPTH(FIFO_DEPTH),
                                    .WIDTHF(WIDTHFD)
                                )
                                from_memory2 (
                                    .clock(clock),
                                    .clock_sreset(clock_sreset),
                                    .s_address(s_address[1:0]),
                                    .s_writedata(s_writedata),
                                    .s_readdata(ss_readdata[2]),
                                    .s_read(s_read & ss_select[2]),
                                    .s_write(s_write & ss_select[2]),
                                    .s_waitrequest(ss_waitrequest[2]),
                                    .m_address(rm2_address),
                                    .m_byteenable(rm2_byteenable),
                                    .m_readdata(rm2_readdata),
                                    .m_burstcount(rm2_burstcount),
                                    .m_read(rm2_read),
                                    .m_waitrequest(rm2_waitrequest),
                                    .m_readdatavalid(rm2_readdatavalid),
                                    .fifo_rdreq(conv_result_valid),
                                    .fifo_usedw(),
                                    .fifo_q(fifo2_q)
                                );

    burst_from_memory           # (
                                    .WIDTH(WIDTH),
                                    .WIDTHB(WIDTHB),
                                    .WIDTHBE(WIDTH / 8)
                                )
                                from_memory3 (
                                    .clock(clock),
                                    .clock_sreset(clock_sreset),
                                    .s_address(s_address[1:0]),
                                    .s_writedata(s_writedata),
                                    .s_readdata(ss_readdata[3]),
                                    .s_read(s_read & ss_select[3]),
                                    .s_write(s_write & ss_select[3]),
                                    .s_waitrequest(ss_waitrequest[3]),
                                    .m_address(rm3_address),
                                    .m_byteenable(rm3_byteenable),
                                    .m_readdata(rm3_readdata),
                                    .m_burstcount(rm3_burstcount),
                                    .m_read(rm3_read),
                                    .m_waitrequest(rm3_waitrequest),
                                    .m_readdatavalid(rm3_readdatavalid),
                                    .data_valid(conv_kernel_data_shift),
                                    .data(conv_kernel_data)
                                );
                                
                                
    pad_video                   # (
                                    .WIDTH(WIDTH),
                                    .WIDTHF(WIDTHFD),
                                    .FIFO_DEPTH(FIFO_DEPTH)
                                )
                                pad_video (
                                    .clock(clock),
                                    .clock_sreset(clock_sreset),
                                    .s_address(s_address),
                                    .s_writedata(s_writedata),
                                    .s_readdata(ss_readdata[4]),
                                    .s_read(s_read & ss_select[4]),
                                    .s_write(s_write & ss_select[4]),
                                    .s_waitrequest(ss_waitrequest[4]),
                                    .fifo_rdreq(fifo1_rdreq),
                                    .fifo_usedw(fifo1_usedw),
                                    .fifo_q(fifo1_q),
                                    .conv_enable_calc(conv_enable_calc),
                                    .conv_data_shift(conv_data_shift),
                                    .conv_data(conv_data),
                                    .conv_xres_select(conv_xres_select)                                    
                                );
                                
    always_comb begin
        s_readdata = ss_readdata[s_address[4:2]];
        s_waitrequest = ss_waitrequest[s_address[4:2]];
    end

                                
    // handle convolution and sum
    convolution_calc            # (
                                    .MAX_XRES(XRES5 + (PAD << 1)),
                                    .XRES1(XRES1 + (PAD << 1)), 
                                    .XRES2(XRES2 + (PAD << 1)),
                                    .XRES3(XRES3 + (PAD << 1)),
                                    .XRES4(XRES4 + (PAD << 1)),
                                    .XRES5(XRES5 + (PAD << 1)),
                                    .RESOLUTIONS(RESOLUTIONS),
                                    .KX(KX),
                                    .KY(KY),
                                    .EXP(EXP),
                                    .MANT(MANT),
                                    .WIDTH(WIDTHF),
                                    .ADDER_PIPELINE(ADDER_PIPELINE)
                                )
                                convolution (
                                    .clock(clock),
                                    .clock_sreset(clock_sreset),
                                    .xres_select(conv_xres_select),
                                    .kernel_data_shift(conv_kernel_data_shift),
                                    .kernel_data(conv_kernel_data),
                                    .enable_calc(conv_enable_calc),
                                    .data_shift(conv_data_shift),
                                    .data(conv_data),
                                    .result_valid(conv_result_valid),
                                    .result(conv_result)
                                );
                        
    // accumulate the featuremap sum
    fp_add                      # (
                                    .EXP(EXP),
                                    .MANT(MANT),
                                    .WIDTH(WIDTHF),
                                    .EXTRA_PIPELINE(2)
                                )
                                adder (
                                    .clock(clock),
                                    .clock_sreset(clock_sreset),
                                    .data_valid(conv_result_valid),    // when conv_result and add_datab are valid
                                    .dataa(conv_result),
                                    .datab(fifo2_q),
                                    .result_valid(adder_result_valid),
                                    .result(adder_result)
                                );
                                
    stream_to_memory            # (
                                    .WIDTH(WIDTH),
                                    .WIDTHB(WIDTHB),
                                    .WIDTHBE(WIDTH / 8),
                                    .FIFO_DEPTH(FIFO_DEPTH),
                                    .WIDTHF(WIDTHFD)
                                )
                                to_memory (
                                    .clock(clock),
                                    .clock_sreset(clock_sreset),
                                    .s_address(s_address[1:0]),
                                    .s_writedata(s_writedata),
                                    .s_readdata(ss_readdata[5]),
                                    .s_read(s_read & ss_select[5]),
                                    .s_write(s_write & ss_select[5]),
                                    .s_waitrequest(ss_waitrequest[5]),
                                    .m_address(wm1_address),
                                    .m_byteenable(wm1_byteenable),
                                    .m_writedata(wm1_writedata),
                                    .m_burstcount(wm1_burstcount),
                                    .m_write(wm1_write),
                                    .m_waitrequest(wm1_waitrequest),
                                    .fifo_wrreq(adder_result_valid),
                                    .fifo_usedw(),
                                    .fifo_data(adder_result)
                                );
                        
    // handle control and status registers - slave interface
    always_comb begin
        ss_waitrequest[0] = s_write ? 1'b0 : (s_read ? ~read_latency : 1'b0);
    end
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            read_latency <= 1'b0;
        end
        else begin
            read_latency <= read_latency ? 1'b0 : s_read;
            if (s_address == 4'h0) begin
                ss_readdata[0] <= {busy_flag, go_flag};
                go_flag <= s_write & s_writedata[0];
            end
            else begin
                go_flag <= 1'b0;
            end
        end
    end

    // controlling FSM for bursting from memory and padding data to convolution and write back to memory
    always_comb begin
    end
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
        end
        else begin
        end
    end
                        
endmodule
