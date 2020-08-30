module convolution_csr # (
            parameter           WIDTHB = 8
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
    
    output  logic [4:0]         go_flag,
    input   logic [4:0]         busy_flag,
    output  logic               flush_flag,
    output  logic [23:0]        word_size,
    output  logic [WIDTHB-1:0]  burst_count,
    output  logic [31:0]        kernel_pointer,
    output  logic [31:0]        source_pointer,
    output  logic [31:0]        destination_pointer,
    output  logic [11:0]        xres,
    output  logic [11:0]        yres,
    output  logic [2:0]         xres_select,
    output  logic [2:0]         pad
);
            localparam          DONTCARE = {128{1'bx}};
            localparam          ONE = 128'h1;
            localparam          ZERO = 128'h0;
            localparam          ONES = ~ZERO;
            
            integer             i;
            
            logic               read_latency;

    // decode slave interface and controlling registers
    always_comb begin
        s_waitrequest = s_write ? 1'b0 : (s_read ? ~read_latency : 1'b0);
    end
    always_ff @ (posedge clock) begin
        if (clock_sreset) begin
            go_flag <= 5'b0;
            read_latency <= 1'b0;
            s_readdata <= DONTCARE[31:0];
        end
        else begin
            read_latency <= read_latency ? 1'b0 : s_read;
            if (s_address == 4'h0) begin
                for (i=0; i<5; i++) begin
                    go_flag[i] <= s_write & s_writedata[i];
                end
                flush_flag <= s_write & s_writedata[5];
                s_readdata <= {busy_flag};
            end
            else begin
                go_flag <= 5'h0;
                flush_flag <= 1'b0;
            end
            if (s_address == 4'h1) begin
                s_readdata <= source_pointer;
                if (s_write) begin
                    source_pointer <= s_writedata;
                end
            end
            if (s_address == 4'h2) begin
                s_readdata <= destination_pointer;
                if (s_write) begin
                    destination_pointer <= s_writedata;
                end
            end
            if (s_address == 4'h3) begin
                s_readdata <= word_size;
                if (s_write) begin
                    word_size <= s_writedata[23:0];
                end
            end
            if (s_address == 4'h4) begin
                s_readdata <= burst_count;
                if (s_write) begin
                    burst_count <= s_writedata[7:0];
                end
            end
            if (s_address == 4'h5) begin
                s_readdata <= kernel_pointer;
                if (s_write) begin
                    kernel_pointer <= s_writedata;
                end
            end
            if (s_address == 4'h6) begin
                s_readdata <= xres;
                if (s_write) begin
                    xres <= s_writedata[11:0];
                end
            end
            if (s_address == 4'h7) begin
                s_readdata <= yres;
                if (s_write) begin
                    yres <= s_writedata[11:0];
                end
            end
            if (s_address == 4'h8) begin
                s_readdata <= xres_select;
                if (s_write) begin
                    xres_select <= s_writedata[2:0];
                end
            end
            if (s_address == 4'h9) begin
                s_readdata <= pad;
                if (s_write) begin
                    pad <= s_writedata[2:0];
                end
            end
        end
    end


endmodule
