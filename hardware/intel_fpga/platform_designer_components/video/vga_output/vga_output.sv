module vga_output # (
            parameter           WIDTH = 16,
            parameter           FIFO_DEPTH = 512,
            parameter           VGA_XRES = 640,
            parameter           VGA_HSYNC = 96,
            parameter           VGA_HFPORCH = 16,
            parameter           VGA_HBPORCH = 48,
            parameter           VGA_YRES = 480,
            parameter           VGA_VSYNC = 2,
            parameter           VGA_VFPORCH = 10,
            parameter           VGA_VBPORCH = 33,
            parameter           NO_SIGNAL_RGB = 16'hff00
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
    
    output  logic               st_ready,
    input   logic               st_valid,
    input   logic               st_sop,
    input   logic               st_eop,
    input   logic [WIDTH-1:0]   st_data,
    
    
    input   logic               vga_clock,
    input   logic               vga_clock_sreset,
    output  logic [WIDTH-1:0]   vga_rgb,
    output  logic               vga_valid,
    output  logic               vga_vsync,
    output  logic               vga_hsync
);
            localparam          ZERO = 128'h0;
            localparam          ONE = 128'h1;
            localparam          DONTCARE = {128{1'bx}};
            localparam          WIDTHF = $clog2(FIFO_DEPTH);
            localparam          FIFO_FULL = (FIFO_DEPTH - (FIFO_DEPTH >> 2));
            localparam          FIFO_EMPTY = (FIFO_DEPTH >> 2);
            localparam          VGA_WIDTH = VGA_HFPORCH + VGA_HSYNC + VGA_XRES + VGA_HBPORCH;
            localparam          VGA_HEIGHT = VGA_VFPORCH + VGA_VSYNC + VGA_YRES + VGA_VBPORCH;
            localparam          WIDTHV = $clog2(VGA_WIDTH);
            localparam          WIDTHP = $clog2(VGA_XRES * VGA_YRES);
    enum    logic [7:0]         {S1, S2, S3,S4, S5, S6, S7, S8} fsm_a, fsm_b;
            logic               st_ready_reg;
            logic [WIDTHF-1:0]  fifo_rdusedw, fifo_wrusedw;
            logic               fifo_rdreq, fifo_wrreq, fifo_sreset;
            logic [WIDTH-1:0]   size_x_reg, size_y_reg, fifo_q, fifo_data;
            logic [WIDTHV-1:0]  vga_x_counter, vga_y_counter;
            logic [WIDTHP-1:0]  pixel_count;
            logic               vga_valid_x, vga_valid_y, read_latency;
            logic               go_flag, reset_flag, busy_flag, vga_busy_flag;
            logic               sync_reset_flag;
            logic [2:0]         sync_go_flag, sync_vga_busy_flag;
            
	dcfifo	                    # (
                                    //.intended_device_family("MAX 10"),
                                    .lpm_numwords(FIFO_DEPTH),
                                    .lpm_showahead("ON"),
                                    .lpm_type("dcfifo"),
                                    .lpm_width(WIDTH),
                                    .lpm_widthu(WIDTHF),
                                    .overflow_checking("ON"),
                                    .rdsync_delaypipe(4),
                                    .read_aclr_synch("ON"),
                                    .underflow_checking("OFF"),
                                    .use_eab("ON"),
                                    .write_aclr_synch("ON"),
                                    .wrsync_delaypipe(4),
                                    .clocks_are_synchronized("FALSE")
                                )
                                fifo (
                                    .aclr (fifo_sreset),
                                    .wrclk (clock),
                                    .data (fifo_data),
                                    .wrreq (fifo_wrreq),
                                    .wrusedw (fifo_wrusedw),
                                    .wrempty (),
                                    .wrfull (),
                                    .rdusedw (fifo_rdusedw),
                                    .rdclk (vga_clock),
                                    .rdreq (fifo_rdreq),
                                    .rdempty (),
                                    .rdfull (),
                                    .q (fifo_q),
                                    .eccstatus ()
                                );
                                
    always_ff @ (posedge clock) begin
        sync_vga_busy_flag <= {sync_vga_busy_flag[1:0], vga_busy_flag};
    end
    always_comb begin
        s_waitrequest = s_write ? 1'b0 : (s_read ? ~read_latency : 1'b0);
    end
    always_ff @ (posedge clock) begin
        fifo_sreset <= clock_sreset | reset_flag;
        if (clock_sreset) begin
            read_latency <= 1'b0;
            fifo_sreset <= 1'b0;
            reset_flag <= 1'b0;
            go_flag <= 1'b0;
        end
        else begin
            read_latency <= read_latency ? 1'b0 : s_read;
            if (s_address == 4'h0) begin
                s_readdata <= {sync_vga_busy_flag[2], busy_flag, go_flag};
                if (s_write) begin
                    go_flag <= s_writedata[0];
                end
            end
            if (s_address == 4'h1) begin
                reset_flag <= s_write & s_writedata[0];
            end
            else begin
                reset_flag <= 1'b0;
            end
        end
    end
                                
    always_comb begin
        st_ready = fifo_wrusedw < FIFO_FULL[WIDTHF-1:0];
        fifo_wrreq = 1'b0;
        fifo_data = st_data;
        case (fsm_a)
            S3 : begin
                if ((size_x_reg != VGA_XRES[WIDTH-1:0]) || (size_y_reg != VGA_YRES[WIDTH-1:0])) begin
                    fifo_data = NO_SIGNAL_RGB[WIDTH-1:0];
                end
                fifo_wrreq = st_ready_reg & st_valid;
            end
            default;
        endcase
    end
    always_ff @ (posedge clock) begin
        if (clock_sreset | reset_flag) begin
            size_x_reg <= DONTCARE[WIDTH-1:0];
            size_y_reg <= DONTCARE[WIDTH-1:0];
            pixel_count <= DONTCARE[WIDTHP-1:0];
            fsm_a <= S1;
        end
        else begin
            st_ready_reg <= st_ready;
            case (fsm_a)
                S1 : begin  // new video frame
                    pixel_count <= ZERO[WIDTH-1:0];
                    size_x_reg <= st_data;
                    if (st_ready_reg & st_valid & st_sop & go_flag) begin
                        busy_flag <= 1'b1;
                        fsm_a <= S2;
                    end
                    else begin
                        busy_flag <= 1'b0;
                    end
                end
                S2 : begin  // new line packet
                    pixel_count <= ZERO[WIDTHP-1:0];
                    size_y_reg <= st_data;
                    if (st_ready_reg & st_valid) begin
                        fsm_a <= S3;
                    end
                end
                S3 : begin
                    if (st_ready_reg & st_valid) begin
                        pixel_count <= pixel_count + ONE[WIDTHP-1:0];
                        if (st_eop | (pixel_count >= ((VGA_XRES * VGA_YRES) - 1))) begin
                            fsm_a <= S1;
                        end
                    end
                end
            endcase
        end
    end
    
    clock_cross_enable      # (
                                .META_STAGES(2)
                            )
                            sync_reset (
                                .clock_1(clock),
                                .enable_1(clock_sreset | reset_flag),
                                .ack_1(),
                                .clock_2(vga_clock),
                                .enable_2(sync_reset_flag)
                            );

    always_ff @ (posedge vga_clock) begin
        sync_go_flag <= {sync_go_flag[1:0], go_flag};
    end
                            
    always_comb begin
        fifo_rdreq = 1'b0;
        case (fsm_b)
            S2 : begin
                fifo_rdreq = vga_valid_x & vga_valid_y;
            end
            default;
        endcase
        vga_valid_x = ((vga_x_counter >= (VGA_HSYNC + VGA_HBPORCH)) && (vga_x_counter < (VGA_HSYNC + VGA_HBPORCH + VGA_XRES)));
        vga_valid_y = ((vga_y_counter >= (VGA_VSYNC + VGA_VBPORCH)) && (vga_y_counter < (VGA_VSYNC + VGA_VBPORCH + VGA_YRES)));
    end
    always_ff @ (posedge vga_clock) begin
        if (vga_clock_sreset | sync_reset_flag) begin
            vga_hsync <= 1'b0;
            vga_vsync <= 1'b0;
            vga_valid <= 1'b0;
            vga_rgb <= ZERO[WIDTH-1:0];
        end
        else begin
            vga_hsync <= (vga_x_counter  <= (VGA_HSYNC - 1));
            vga_vsync <= (vga_y_counter  <= (VGA_VSYNC - 1));
            vga_valid <= vga_valid_x & vga_valid_y;
            vga_rgb <= vga_valid_x & vga_valid_y ? fifo_q : ZERO[WIDTH-1:0];
        end
    end
    always_ff @ (posedge vga_clock) begin
        if (vga_clock_sreset | sync_reset_flag) begin
            vga_x_counter <= ZERO[WIDTHV-1:0];
            vga_y_counter <= ZERO[WIDTHV-1:0];
            fsm_b <= S1;
        end
        else begin
            case (fsm_b)
                S1 : begin
                    if (sync_go_flag[2] & (fifo_rdusedw > (FIFO_EMPTY - 1))) begin
                        vga_busy_flag <= 1'b1;
                        fsm_b <= S2;
                    end
                    else begin
                        vga_busy_flag <= 1'b0;
                    end
                end
                S2 : begin
                    if (vga_x_counter >= (VGA_WIDTH - 1)) begin
                        vga_x_counter <= ZERO[WIDTHV-1:0];
                        if (vga_y_counter >= (VGA_HEIGHT - 1)) begin
                            vga_y_counter <= ZERO[WIDTHV-1:0];
                            fsm_b <= S1;
                        end
                        else begin
                            vga_y_counter <= vga_y_counter + ONE[WIDTHV-1:0];
                        end
                    end
                    else begin
                        vga_x_counter <= vga_x_counter + ONE[WIDTHV-1:0];
                    end
                end
            endcase
        end
    end
   
endmodule
