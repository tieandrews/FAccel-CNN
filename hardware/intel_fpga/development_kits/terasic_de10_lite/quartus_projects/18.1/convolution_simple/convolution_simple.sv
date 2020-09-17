module convolution_simple (
    input   logic                   clock50
);

    platform_designer_block         u0 (
                                        .clk_clk       (clock50),
                                        .reset_reset_n (1'b1)
                                    );


endmodule
