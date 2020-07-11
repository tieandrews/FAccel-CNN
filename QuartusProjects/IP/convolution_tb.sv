`timescale 1ns/1ns

module convolution_tb();

    stream_from_memory          (
                                    .clock(clock),
                                    .clock_sreset(clock_sreset),
                                    .s_address(),
                                    .s_readdata(),
                                    .s_writedata(),
                                    .s_read(),
                                    .s_write(),
                                    .s_waitrequest(),
                                    .rm_address(),
                                    .rm_readdata(),
                                    .rm_byteenable(),
                                    .rm_read(),
                                    .rm_waitrequest(),
                                    .rm_readdatavalid(),
                                    .st_ready(),
                                    .st_valid(),
                                    .st_sop(),
                                    .st_eop(),
                                    .st_data()
                                );
                                
    pad_stream                  (
                                )
                        

endmodule
