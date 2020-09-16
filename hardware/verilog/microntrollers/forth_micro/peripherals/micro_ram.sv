module micro_ram # (
            parameter            WIDTHD = 18,
            parameter            WIDTHA = 9,
            parameter            RAM_TYPE = "MIF",
            parameter            FILE = "code.mif"
)
(
   input    logic                clock,
   input    logic                clock_sreset,
   input    logic [WIDTHA-1:0]   address,
   input    logic [WIDTHD-1:0]   writedata,
   output   logic [WIDTHD-1:0]   readdata,
   input    logic                read,
   input    logic                write,
   output   logic                waitrequest
);
            localparam           RAM_WORDS = (2**WIDTHA);
            localparam           DONTCARE = {WIDTHD+WIDTHA{1'bx}};
            logic                read_latency;
            
   always_comb begin
      waitrequest = write ? 1'b0 : (read ? ~read_latency : 1'b0);
   end
   always_ff @ (posedge clock) begin
      if (clock_sreset) begin
         read_latency <= 1'b0;
      end
      else begin
         read_latency <= read_latency ? 1'b0 : read;
      end
   end
   generate begin
      if (RAM_TYPE != "MIF") begin
         logic [WIDTHD-1:0]   ram[RAM_WORDS-1:0];
         if (FILE != "")
            initial begin
               $readmemh(FILE, ram);
            end
         assign readdata = ram[address];
         always_ff @ (posedge clock) begin
            if (write)
               ram[address] <= writedata;
         end
      end
      else begin
         altsyncram  # (
                        .clock_enable_input_a("BYPASS"),
                        .clock_enable_output_a("BYPASS"),
                        .init_file(FILE),
                        .intended_device_family("Cyclone V"),
                        .lpm_hint("ENABLE_RUNTIME_MOD=NO"),
                        .lpm_type("altsyncram"),
                        .numwords_a(RAM_WORDS),
                        .operation_mode("SINGLE_PORT"),
                        .outdata_aclr_a("NONE"),
                        .outdata_reg_a("UNREGISTERED"),
                        .power_up_uninitialized("FALSE"),
                        .read_during_write_mode_port_a("DONT_CARE"),
                        .widthad_a(WIDTHA),
                        .width_a(WIDTHD),
                        .width_byteena_a(1)
                     )
                     ram (
                        .address_a (address),
                        .clock0 (clock),
                        .data_a (writedata),
                        .wren_a (write),
                        .q_a (readdata),
                        .aclr0 (1'b0),
                        .aclr1 (1'b0),
                        .address_b (1'b1),
                        .addressstall_a (1'b0),
                        .addressstall_b (1'b0),
                        .byteena_a (1'b1),
                        .byteena_b (1'b1),
                        .clock1 (1'b1),
                        .clocken0 (1'b1),
                        .clocken1 (1'b1),
                        .clocken2 (1'b1),
                        .clocken3 (1'b1),
                        .data_b (1'b1),
                        .eccstatus (),
                        .q_b (),
                        .rden_a (1'b1),
                        .rden_b (1'b1),
                        .wren_b (1'b0));
      end
   end
   endgenerate

endmodule
