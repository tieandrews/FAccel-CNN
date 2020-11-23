module sliding_window # (
            parameter                   MAX_XRES = 10'd64;
            parameter logic [4:0][9:0]  XRES = '{10'd16, 10'd32, 10'd64, 10'd4, 10'd8};
            parameter                   K = 3,
            parameter                   WIDTH = 16
)
(
    input   logic                       clock,
    input   logic                       clock_sreset,
    input   logic                       data_shift,
    input   logic [WIDTH-1:0]           data,
    input   logic [2:0]                 xres_select,
    output  logic [K*K-1:0][WIDTH-1:0]  window
);
            localparam                  DONTCARE = {WIDTH{1'bx}};
            localparam                  ZERO = {WIDTH{1'b0}};
            localparam                  ONE = {ZERO, 1'b1};
            
            integer                     x, y, t;
            
            logic [WIDTH-1:0]           buffer[MAX_XRES-1:0][K-1:0];
            logic [K-1:0][WIDTH-1:0]    buffer_taps[$size(XRES)-1:0];


    always_comb begin
        for (y=0; y<K; y++) begin
            for (x=0; x<K; x++) begin
                window[x+(y*K)] = buffer[(K-1)-x][(K-1)-y];
            end
        end
    end

    // generate buffer taps for X resolutions
    always_comb begin
        for (y=0; y<K; y++) begin
            for (t=0; t<$size(XRES); t++) begin
                buffer_taps[t][y] = buffer[XRES[t] - 10'h1][y];
            end
        end
    end
    always_ff @ (posedge clock) begin
        if (data_shift) begin
            for (y=0; y<K; y++) begin
                for (x=0; x<MAX_XRES; x++) begin
                    if (x == 0) begin
                        if (y == 0) begin
                            buffer[x][y] <= data;
                        end
                        else begin
                            buffer[x][y] <= buffer_taps[xres_select][y-1];
                        end
                    end
                    else begin
                        buffer[x][y] <= buffer[x-1][y];
                    end
                end
            end
        end
    end

endmodule
