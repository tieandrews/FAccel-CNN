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
    
    input   logic [3:0]         s_address,
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
    
            integer             i;
    
            logic [4:0]         go_flag, busy_flag;
            logic               flush_flag;
            logic [WIDTHFD-1:0] pad_fifo_usedw;
            logic [WIDTH-1:0]   pad_fifo_q, adder_dataa, adder_datab;
            logic               pad_fifo_rdreq, adder_data_valid;
            logic [WIDTH-1:0]   conv_result, adder_result, conv_kernel_data, conv_data;
            logic               conv_result_valid,adder_result_valid;
            logic               conv_kernel_data_shift,conv_enable_calc, conv_data_shift;
            logic [2:0]         xres_select, pad;
            logic [31:0]        source_pointer, destination_pointer, kernel_pointer;
            logic [11:0]        xres, yres;
            logic [WIDTHB-1:0]  burst_count;
            logic [23:0]        word_size;

    convolution_csr             # (
                                    .WIDTHB(WIDTHB)
                                )
                                csr (
                                    .clock(clock),
                                    .clock_sreset(clock_sreset),
                                    .s_address(s_address),
                                    .s_readdata(s_readdata),
                                    .s_writedata(s_writedata),
                                    .s_read(s_read),
                                    .s_write(s_write),
                                    .s_waitrequest(s_waitrequest),
                                    .go_flag(go_flag),
                                    .busy_flag(busy_flag),
                                    .word_size(word_size),
                                    .burst_count(burst_count),
                                    .kernel_pointer(kernel_pointer),
                                    .source_pointer(source_pointer),
                                    .destination_pointer(destination_pointer),
                                    .xres(xres),
                                    .yres(yres),
                                    .xres_select(xres_select),
                                    .pad(pad)
                                );
    
    burst_from_memory           # (
                                    .WIDTH(WIDTH),
                                    .WIDTHB(WIDTHB),
                                    .WIDTHBE(WIDTH / 8)
                                )
                                kernel_weights (
                                    .clock(clock),
                                    .clock_sreset(clock_sreset),
                                    .go(go_flag[0]),
                                    .busy(busy_flag[0]),
                                    .pointer(kernel_pointer),
                                    .burst_count(KX * KY),
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
                                    .go(go_flag[1]),
                                    .busy(busy_flag[1]),
                                    .pointer(source_pointer),
                                    .word_size(word_size),
                                    .burst_count(burst_count),
                                    .m_address(rm1_address),
                                    .m_byteenable(rm1_byteenable),
                                    .m_readdata(rm1_readdata),
                                    .m_burstcount(rm1_burstcount),
                                    .m_read(rm1_read),
                                    .m_waitrequest(rm1_waitrequest),
                                    .m_readdatavalid(rm1_readdatavalid),
                                    .fifo_rdreq(pad_fifo_rdreq),
                                    .fifo_usedw(pad_fifo_usedw),
                                    .fifo_q(pad_fifo_q)
                                );
                                
    pad_video                   # (
                                    .WIDTH(WIDTH),
                                    .WIDTHF(WIDTHFD),
                                    .FIFO_DEPTH(FIFO_DEPTH)
                                )
                                pad_video (
                                    .clock(clock),
                                    .clock_sreset(clock_sreset),
                                    .go(go_flag[2]),
                                    .busy(busy_flag[2]),
                                    .xres(xres),
                                    .yres(yres),
                                    .pad(pad),
                                    .fifo_rdreq(pad_fifo_rdreq),
                                    .fifo_usedw(pad_fifo_usedw),
                                    .fifo_q(pad_fifo_q),
                                    .conv_enable_calc(conv_enable_calc),
                                    .conv_data_shift(conv_data_shift),
                                    .conv_data(conv_data)
                                );
                                
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
                                    .xres_select(xres_select),
                                    .kernel_data_shift(conv_kernel_data_shift),
                                    .kernel_data(conv_kernel_data),
                                    .enable_calc(conv_enable_calc),
                                    .data_shift(conv_data_shift),
                                    .data(conv_data),
                                    .result_valid(adder_data_valid),
                                    .result(adder_dataa)
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
                                    .go(go_flag[3]),
                                    .busy(busy_flag[3]),
                                    .pointer(destination_pointer),
                                    .word_size(word_size),
                                    .burst_count(burst_count),
                                    .m_address(rm2_address),
                                    .m_byteenable(rm2_byteenable),
                                    .m_readdata(rm2_readdata),
                                    .m_burstcount(rm2_burstcount),
                                    .m_read(rm2_read),
                                    .m_waitrequest(rm2_waitrequest),
                                    .m_readdatavalid(rm2_readdatavalid),
                                    .fifo_rdreq(adder_data_valid),
                                    .fifo_usedw(),
                                    .fifo_q(adder_datab)
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
                                    .data_valid(adder_data_valid),    // when conv_result and add_datab are valid
                                    .dataa(adder_dataa),
                                    .datab(adder_datab),
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
                                    .go(go_flag[4]),
                                    .busy(busy_flag[4]),
                                    .flush(flush_flag),
                                    .pointer(destination_pointer),
                                    .word_size(word_size),
                                    .burst_count(burst_count),
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
                        
endmodule
