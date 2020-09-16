module dual_clock_pwm # (
            parameter                   WIDTH = 8
)
(
    input   logic                       clock,
    input   logic                       clock_sreset,
    input   logic                       data_valid,
    input   logic signed [WIDTH-1:0]    data,
    
    input   logic                       fast_clock,
    input   logic                       fast_clock_sreset,
    output  logic                       pwm_out
);
            localparam                  ZERO = 128'h0;
            localparam                  ONE = 128'h1;
            localparam                  DONTCARE = {128{1'bx}};
            logic signed [WIDTH-1:0]    data_reg, compare_reg;
            logic [WIDTH-1:0]           counter, fifo_q;
            logic                       fifo_rdempty, fifo_wrempty, fifo_wrreq;
            
    dcfifo  # (
                .clocks_are_synchronized("FALSE"),
                .intended_device_family("Cyclone IV GX"),
                .lpm_numwords(2),
                .lpm_showahead("ON"),
                .lpm_type("dcfifo"),
                .lpm_width(WIDTH),
                .lpm_widthu(1),
                .overflow_checking("OFF"),
                .rdsync_delaypipe(5),
                .underflow_checking("OFF"),
                .use_eab("OFF"),
                .wrsync_delaypipe(5)
            )
            fifo (
                .wrclk (clock),
                .wrreq (fifo_wrreq),
                .wrfull (),
                .data (data_reg),
                .wrempty (fifo_wrempty),
                .wrusedw (),
                .rdclk (fast_clock),
                .rdreq (~fifo_rdempty),
                .q (fifo_q),
                .rdempty (fifo_rdempty),
                .aclr (clock_sreset),
                .rdfull (),
                .rdusedw ()
            );

    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            data_reg <= DONTCARE[WIDTH-1:0];
            fifo_wrreq <= 1'b0;
        end
        else begin
            if (data_valid) begin
                data_reg <= ONE[WIDTH-1:0] + data + {1'b0, ~ZERO[WIDTH-2:0]};
            end
            fifo_wrreq <= data_valid & fifo_wrempty;
        end
    end
    
    always_ff @ (posedge fast_clock) begin
        if (fast_clock_sreset) begin
            counter <= ZERO[WIDTH-1:0];
        end
        else begin
            counter <= counter + ONE[WIDTH-1:0];
        end
        pwm_out <= (counter < fifo_q);
    end

endmodule
