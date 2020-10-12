module convolution_csr (
    input   logic               clock,
    input   logic               clock_sreset,
    input   logic [3:0]         s_address,
    input   logic [31:0]        s_writedata,
    output  logic [31:0]        s_readdata,
    input   logic               s_read,
    input   logic               s_write,
    output  logic               s_waitrequest,
    
    input   logic               busy_flag,
    output  logic [31:0]        src_pointer,
    output  logic [31:0]        dst_pointer,
    output  logic [31:0]        knl_pointer,
    output  logic [15:0]        feature_size,
    output  logic [2:0]         xres_select,
    output  logic               go_flag,
    output  logic               kernel_go_flag
);
            localparam          ONE = 128'h1;
            localparam          ZERO = 128'h0;
            localparam          DONTCARE = {128{1'bx}};

            logic               read_latency;

    always_comb begin
        s_waitrequest = s_write ? 1'b0 : (s_read ? ~read_latency : 1'b0);
    end
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            src_pointer <= DONTCARE[31:0];
            dst_pointer <= DONTCARE[31:0];
            go_flag <= 1'b0;
            read_latency <= 1'b0;
        end
        else begin
            read_latency <= read_latency ? 1'b0 : s_read;
            if (s_address == 4'h0) begin
                s_readdata <= {busy_flag, 1'b0};
                go_flag <= s_write & s_writedata[0];
                kernel_go_flag <= s_write & s_writedata[1];
            end
            else begin
                go_flag <= 1'b0;
                kernel_go_flag <= 1'b0;
            end
            if (s_address == 4'h1) begin
                s_readdata <= src_pointer;
                if (s_write) begin
                    src_pointer <= s_writedata;
                end
            end
            if (s_address == 4'h2) begin
                s_readdata <= dst_pointer;
                if (s_write) begin
                    dst_pointer <= s_writedata;
                end
            end
            if (s_address == 4'h3) begin
                s_readdata <= knl_pointer;
                if (s_write) begin
                    knl_pointer <= s_writedata;
                end
            end
            if (s_address == 4'h4) begin
                s_readdata <= feature_size;
                if (s_write) begin
                    feature_size <= s_writedata[$bits(feature_size)-1:0];
                end
            end
            if (s_address == 4'h5) begin
                s_readdata <= xres_select;
                if (s_write) begin
                    xres_select <= s_writedata[$bits(xres_select)-1:0];
                end
            end
        end
    end

endmodule
