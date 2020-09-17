module convolution # (
            parameter           MAX_XRES = 256,
            parameter integer   XRES1=16, XRES2=32, XRES3=64, XRES4=128, XRES5=256,   // x resolution without padding
            parameter integer   YRES1=16, YRES2=32, YRES3=64, YRES4=128, YRES5=256,
            parameter           RESOLUTIONS = 5,

            parameter           KX = 3,
            parameter           KY = 3,

            parameter           EXP = 8,
            parameter           MANT = 7,
            parameter           WIDTHF = 16, //1 + EXP + MANT;
            
            parameter           WIDTH = 16, //2 ** $clog2(WIDTHF);
            parameter           WIDTHBE = 2, //WIDTH / 8;
            parameter           WIDTHR = 5, //$clog2(MAX_XRES)+1;
            parameter           WIDTHK = 4 //$clog2(KX * KY);
)
(
    clock, clock_sreset,
    s_address, s_writedata, s_readdata, s_read, s_write, s_waitrequest,
    m_address, m_readdata, m_writedata, m_byteenable, m_read, m_write, m_waitrequest
);


    input   logic               clock;
    input   logic               clock_sreset;
    
    input   logic [3:0]         s_address;
    input   logic [31:0]        s_writedata;
    output  logic [31:0]        s_readdata;
    input   logic               s_read;
    input   logic               s_write;
    output  logic               s_waitrequest;
    
    output  logic [31:0]        m_address;
    input   logic [WIDTH-1:0]   m_readdata;
    output  logic [WIDTH-1:0]   m_writedata;
    output  logic [WIDTHBE-1:0] m_byteenable;
    output  logic               m_read;
    output  logic               m_write;
    input   logic               m_waitrequest;
    
    //////////////////////////////////////////////////////////////////////////

            localparam          DONTCARE = {128{1'bx}};
            localparam          ONE = 128'h1;
            localparam          ZERO = 128'h0;
            localparam          ONES = ~ZERO;
            
            localparam          KERNEL_ENDCOUNT = (KX * KY) - 1;
            
            integer             i;
            
    enum    logic [9:0]         {S1, S2, S3, S4, S5, S6, S7, S8, S9, S10} fsm;
    
            logic               go_flag, busy_flag;
            logic [31:0]        kernel_pointer_reg, source_pointer_reg, destination_pointer_reg;
            logic [23:0]        offset;
            logic [WIDTHR-1:0]  xres, yres, xres_reg, yres_reg, x_count, y_count;
            logic [WIDTHK-1:0]  kernel_count;
            logic [2:0]         xres_select_reg, pad_reg;
            logic               read_latency;
            logic               conv_enable_calc, conv_data_shift, conv_kernel_data_shift, conv_result_valid;
            logic               adder_data_valid, adder_result_valid;
            logic [WIDTHF-1:0]  conv_data, conv_result, conv_kernel_data, adder_dataa, adder_result;

    //////////////////////////////////////////////////////////////////////////
    always_comb begin
        s_waitrequest = s_write ? 1'b0 : (s_read ? ~read_latency : 1'b0);
    end
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            read_latency <= 1'b0;
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
            if (s_address == 4'h2) begin
                s_readdata <= kernel_pointer_reg;
                if (s_write) begin
                    kernel_pointer_reg <= s_writedata;
                end
            end
            if (s_address == 4'h3) begin
                s_readdata <= source_pointer_reg;
                if (s_write) begin
                    source_pointer_reg <= s_writedata;
                end
            end
            if (s_address == 4'h4) begin
                s_readdata <= destination_pointer_reg;
                if (s_write) begin
                    destination_pointer_reg <= s_writedata;
                end
            end
            if (s_address == 4'h5) begin
                s_readdata <= xres_reg;
                if (s_write) begin
                    xres_reg <= s_writedata[WIDTHR-1:0];
                end
            end
            if (s_address == 4'h6) begin
                s_readdata <= yres_reg;
                if (s_write) begin
                    yres_reg <= s_writedata[WIDTHR-1:0];
                end
            end
            if (s_address == 4'h7) begin
                s_readdata <= xres_select_reg;
                if (s_write) begin
                    xres_select_reg <= s_writedata[2:0];
                end
            end
            if (s_address == 4'h8) begin
                s_readdata <= pad_reg;
                if (s_write) begin
                    pad_reg <= s_writedata[2:0];
                end
            end
        end
    end
    //////////////////////////////////////////////////////////////////////////

    convolution_calc            # (
                                    .MAX_XRES(XRES5),
                                    .XRES1(XRES1), 
                                    .XRES2(XRES2),
                                    .XRES3(XRES3),
                                    .XRES4(XRES4),
                                    .XRES5(XRES5),
                                    .RESOLUTIONS(RESOLUTIONS),
                                    .KX(KX),
                                    .KY(KY),
                                    .CHAN(1),
                                    .EXP(EXP),
                                    .MANT(MANT),
                                    .WIDTH(WIDTHF),
                                    .ADDER_PIPELINE(1)
                                )
                                convolution (
                                    .clock(clock),
                                    .clock_sreset(clock_sreset),
                                    .xres_select(xres_select_reg),
                                    .kernel_data_shift(conv_kernel_data_shift),
                                    .kernel_data(conv_kernel_data),
                                    .enable_calc(conv_enable_calc),
                                    .data_shift(conv_data_shift),
                                    .data(conv_data),
                                    .result_valid(conv_result_valid),
                                    .result(conv_result)
                                );
                                                                
    fp_add                      # (
                                    .EXP(EXP),
                                    .MANT(MANT),
                                    .WIDTH(WIDTHF)
                                )
                                float_adder (
                                    .clock(clock),
                                    .clock_sreset(clock_sreset),
                                    .data_valid(adder_data_valid),
                                    .dataa(adder_dataa),
                                    .datab(m_readdata[WIDTHF-1:0]),
                                    .result_valid(adder_result_valid),
                                    .result(adder_result)
                                );
                                
    //////////////////////////////////////////////////////////////////////////
    always_comb begin
        xres = MAX_XRES[WIDTHR-1:0] + (pad_reg << 1);
        yres = MAX_XRES[WIDTHR-1:0] + (pad_reg << 1);
        for (i=0; i<RESOLUTIONS; i++) begin
            if (i == xres_select_reg) begin
                if (i == 0) {xres, yres} = {XRES1[WIDTHR-1:0] + (pad_reg << 1), YRES1[WIDTHR-1:0] + (pad_reg << 1)};
                if (i == 1) {xres, yres} = {XRES2[WIDTHR-1:0] + (pad_reg << 1), YRES2[WIDTHR-1:0] + (pad_reg << 1)};
                if (i == 2) {xres, yres} = {XRES3[WIDTHR-1:0] + (pad_reg << 1), YRES3[WIDTHR-1:0] + (pad_reg << 1)};
                if (i == 3) {xres, yres} = {XRES4[WIDTHR-1:0] + (pad_reg << 1), YRES4[WIDTHR-1:0] + (pad_reg << 1)};
                if (i == 4) {xres, yres} = {XRES5[WIDTHR-1:0] + (pad_reg << 1), YRES5[WIDTHR-1:0] + (pad_reg << 1)};
                break;
            end
        end
    end
    //////////////////////////////////////////////////////////////////////////
    always_comb begin
        conv_kernel_data_shift = 1'b0;
        conv_kernel_data = m_readdata[WIDTHF-1:0];
        conv_data = ZERO[WIDTHF-1:0];
        conv_data_shift = 1'b0;
        conv_enable_calc = 1'b0;
        adder_data_valid = 1'b0;
        case (fsm)
            S2 : begin
                conv_kernel_data_shift = m_read & ~m_waitrequest;
            end
            S3, S4, S8 : begin
                conv_data_shift = 1'b1;
            end
            S5 : begin
                conv_data = m_readdata[WIDTHF-1:0];
                conv_data_shift = m_read & ~m_waitrequest;
                conv_enable_calc = m_read & ~m_waitrequest; 
            end
            S6 : begin
                adder_data_valid = m_read & ~m_waitrequest;
            end
            default;
        endcase
    end
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            x_count <= DONTCARE[WIDTHR-1:0];
            y_count <= DONTCARE[WIDTHR-1:0];
            m_address <= DONTCARE[31:0];
            m_writedata <= DONTCARE[WIDTH-1:0];
            m_byteenable <= ONES[WIDTHBE-1:0];
            m_read <= 1'b0;
            m_write <= 1'b0;
            offset <= DONTCARE[23:0];
            adder_dataa <= DONTCARE[WIDTHF-1:0];
            fsm <= S1;
        end
        else begin
            if (conv_result_valid) begin
                adder_dataa <= conv_result;
            end
            case (fsm)
                S1 : begin
                    offset <= 1'b0;
                    m_byteenable <= ONES[WIDTHBE-1:0];
                    m_read <= 1'b0;
                    m_write <= 1'b0;
                    x_count <= ZERO[WIDTHR-1:0];
                    y_count <= ZERO[WIDTHR-1:0];
                    kernel_count <= ZERO[WIDTHK-1:0];
                    if (go_flag) begin
                        busy_flag <= 1'b1;
                        fsm <= S2;
                    end
                    else begin
                        busy_flag <= 1'b0;
                    end
                end
                S2 : begin  // read kernel weights
                    if (m_read) begin
                        if (~m_waitrequest) begin
                            m_address <= m_address + WIDTHBE;
                            kernel_count <= kernel_count + ONE[WIDTHK-1:0];
                            if (kernel_count >= KERNEL_ENDCOUNT[WIDTHK-1:0]) begin
                                m_read <= 1'b0;
                                if (~|pad_reg) begin     // no padding
                                    fsm <= S5;
                                end
                                else begin
                                    fsm <= S3;
                                end
                            end
                        end
                    end
                    else begin
                        m_address <= kernel_pointer_reg;
                        m_read <= 1'b1;
                    end
                end
                S3 : begin  // shift in padded top lines
                    if (x_count >= (xres - ONE[WIDTHR-1:0])) begin
                        x_count <= ZERO[WIDTHR-1:0];
                        y_count <= y_count + ONE[WIDTHR-1:0];
                        if (y_count >= (pad_reg - 3'h1)) begin
                            fsm <= S4;
                        end
                    end
                    else begin
                        x_count <= x_count + ONE[WIDTHR-1:0];
                    end
                end
                S4 : begin  // shift in padded left edge of line
                    if (x_count >= (pad_reg - 3'h1)) begin
                        fsm <= S5;
                    end
                    else begin
                        x_count <= x_count + ONE[WIDTHR-1:0];
                    end
                end
                S5 : begin  // read source
                    m_address <= source_pointer_reg + offset;
                    if (m_read) begin
                        if (~m_waitrequest) begin
                            m_read <= 1'b0;
                            fsm <= S6;
                        end
                    end
                    else begin
                        m_read <= 1'b1;
                    end
                end
                S6 : begin  // read destination
                    m_address <= destination_pointer_reg + offset;
                    if (m_read) begin
                        if (~m_waitrequest) begin
                            m_read <= 1'b0;
                            fsm <= S7;
                        end
                    end
                    else begin
                        m_read <= conv_result_valid;
                    end
                end
                S7 : begin
                    if (m_write) begin
                        if (~m_waitrequest) begin
                            m_write <= 1'b0;
                            offset <= offset + WIDTHBE[23:0];
                            if (x_count >= (xres - pad_reg - ONE[WIDTHR-1:0])) begin
                                if (y_count >= (yres - pad_reg - ONE[WIDTHR-1:0])) begin
                                    fsm <= S1;
                                end
                                else begin
                                    y_count <= y_count + ONE[WIDTHR-1:0];
                                    if (~|pad_reg) begin
                                        x_count <= ZERO[WIDTHR-1:0];
                                        fsm <= S5;
                                    end
                                    else begin
                                        fsm <= S8;
                                    end
                                end
                            end
                            else begin
                                x_count <= x_count + ONE[WIDTHR-1:0];
                                fsm <= S5;
                            end
                        end
                    end
                    else begin
                        m_write <= adder_result_valid;
                        m_writedata <= adder_result;
                    end
                end
                S8 : begin  // pad right edge
                    if (x_count >= (xres - ONE[WIDTHR-1])) begin
                        x_count <= ZERO[WIDTHR-1:0];
                        fsm <= S4;
                    end
                    else begin
                        x_count <= x_count + ONE[WIDTHR-1:0];
                    end
                end
            endcase
        end
    end
    //////////////////////////////////////////////////////////////////////////


endmodule
