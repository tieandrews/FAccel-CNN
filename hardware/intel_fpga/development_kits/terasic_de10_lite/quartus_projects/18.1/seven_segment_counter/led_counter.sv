module led_counter # (
            parameter               NUM = 6,
            parameter               CLOCK_HZ = 50000000,
            parameter               COUNT_RATE_HZ = 1000
)
(
    input   logic                   clock,
    
    output  logic [NUM-1:0][7:0]    seven_segment
);
            localparam              ZERO = 128'h0;
            localparam              ONE = 128'h1;
            localparam              TIMEOUT = (CLOCK_HZ / COUNT_RATE_HZ);
            localparam              WIDTHT = $clog2(TIMEOUT);
            integer                 i;
            logic [NUM-1:0][3:0]    digit, calc_digit;
            logic [WIDTHT-1:0]      timer = ZERO[WIDTHT-1:0];  // initial start condition

    // calculate the next count state
    next_digit      # (
                        .DIGITS(NUM)
                    )
                    calc_next (
                        .bcd_in(digit),
                        .bcd_out(calc_digit)
                    );
    
    // measure out time for rate of increment
    always_ff @ (posedge clock) begin
        if (timer >= (TIMEOUT - 1)) begin
            digit <= calc_digit;
            timer <= ZERO[WIDTHT-1:0];
        end
        else begin
            timer <= timer + ONE[WIDTHT-1:0];
        end
    end
    
    // decode the 7 segments for each digit 0..9
    genvar j;
    generate
        for (j=0; j<NUM; j++) begin : d
            decode_seven_segment (
                .bcd_in(digit[j]),
                .segments(seven_segment[j])
            );
        end
    endgenerate

endmodule
