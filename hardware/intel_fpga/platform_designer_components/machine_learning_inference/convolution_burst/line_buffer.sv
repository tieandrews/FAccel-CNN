module line_buffer # (
            parameter               WIDTH = 16,
            parameter               FIFO_DEPTH = 512,
            parameter               WIDTHFD = 9 // $clog2(FIFO_DEPTH)
)
(
    input   logic                   clock,
    input   logic                   clock_sreset,
    input   logic                   data_valid,
    input   logic [WIDTH-1:0]       data,
    input   logic                   rdreq,
    output  logic [WIDTHFD-1:0]     usedw,
    output  logic [WIDTH-1:0]       q
);

    scfifo                      # (
                                    .add_ram_output_register("OFF"),
                                    .lpm_numwords(FIFO_DEPTH),
                                    .lpm_showahead("ON"),
                                    .lpm_type("scfifo"),
                                    .lpm_width(WIDTH),
                                    .lpm_widthu(WIDTHFD),
                                    .overflow_checking("OFF"),
                                    .underflow_checking("OFF"),
                                    .use_eab("ON")
                                )
                                src_fifo (
                                    .clock (clock),
                                    .sclr (clock_sreset),
                                    .aclr (),
                                    .data (data),
                                    .rdreq (rdreq),
                                    .wrreq (data_valid),
                                    .usedw (usedw),
                                    .q (q),
                                    .almost_empty (),
                                    .almost_full (),
                                    .empty (),
                                    .full (),
                                    .eccstatus()
                                );

endmodule
