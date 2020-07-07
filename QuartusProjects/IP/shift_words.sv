module shift_words # (
            parameter           KX = 3,
            parameter           TAPS = 3,
            parameter           WIDTHT = $clog2(TAPS),
            parameter integer   XSIZE[TAPS-1:0] = '{64,128,256},
            parameter           WIDTH = 16
)
(
    input   logic               clock,
    input   logic               clock_sreset,
    input   logic               data_valid,
    input   logic [WIDTH-1:0]   data,
    input   logic [WIDTHT-1:0]  select,
    output  logic [WIDTH-1:0]   buffer_tap,
    output  logic [KX-1:0][WIDTH-1:0]   data_out
);
            localparam          DONTCARE = {WIDTH{1'bx}};
            integer             x, y, t;
            logic [WIDTH-1:0]   buffer[XSIZE[0]-1:0], taps[TAPS-1:0];

    always_comb begin
        for (t=0; t<TAPS; t++) begin
            for (x=0; x<XSIZE[0]; x++) begin
                if (x == (XSIZE[t]- 1)) begin
                    taps[t] = buffer[x]; 
                end
            end
        end
        buffer_tap = taps[select];
        for (x=0; x<KX; x++) begin
            data_out[x] = buffer[x];
        end
    end
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            for (x=0; x<XSIZE[0]; x++) begin
                buffer[x] <= DONTCARE[WIDTH-1:0];
            end
        end
        else begin
            if (data_valid) begin
                for (x=0; x<XSIZE[0]; x++) begin
                    if (x == 0) begin
                        buffer[x] <= data;
                    end
                    else begin
                        buffer[x] <= buffer[x-1];
                    end
                end
            end
        end
    end

endmodule
