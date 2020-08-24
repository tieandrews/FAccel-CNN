module fp_lut6 (
    input   logic [5:0]     int_in, // 0x0 -> 0x3f
    output  logic [15:0]    float_out // BFLOAT16 out
);
            logic [15:0]    lut_data;
            logic [5:0]     lut_address;
            
    always_comb begin   // i2f of RGB565 components 0x0-0x1f for r,b : g 0x0-0x3f
        lut_address = int_in;
        float_out = lut_data;
        case (lut_address)
            6'h0 : lut_data = 16'h0;
            6'h1 : lut_data = 16'h3c80;
            6'h2 : lut_data = 16'h3d00;
            6'h3 : lut_data = 16'h3d40;
            6'h4 : lut_data = 16'h3d80;
            6'h5 : lut_data = 16'h3da0;
            6'h6 : lut_data = 16'h3dc0;
            6'h7 : lut_data = 16'h3de0;
            6'h8 : lut_data = 16'h3e00;
            6'h9 : lut_data = 16'h3e10;
            6'ha : lut_data = 16'h3e20;
            6'hb : lut_data = 16'h3e30;
            6'hc : lut_data = 16'h3e40;
            6'hd : lut_data = 16'h3e50;
            6'he : lut_data = 16'h3e60;
            6'hf : lut_data = 16'h3e70;
            6'h10 : lut_data = 16'h3e80;
            6'h11 : lut_data = 16'h3e88;
            6'h12 : lut_data = 16'h3e90;
            6'h13 : lut_data = 16'h3e98;
            6'h14 : lut_data = 16'h3ea0;
            6'h15 : lut_data = 16'h3ea8;
            6'h16 : lut_data = 16'h3eb0;
            6'h17 : lut_data = 16'h3eb8;
            6'h18 : lut_data = 16'h3ec0;
            6'h19 : lut_data = 16'h3ec8;
            6'h1a : lut_data = 16'h3ed0;
            6'h1b : lut_data = 16'h3ed8;
            6'h1c : lut_data = 16'h3ee0;
            6'h1d : lut_data = 16'h3ee8;
            6'h1e : lut_data = 16'h3ef0;
            6'h1f : lut_data = 16'h3ef8;
            6'h20 : lut_data = 16'h3f00;
            6'h21 : lut_data = 16'h3f04;
            6'h22 : lut_data = 16'h3f08;
            6'h23 : lut_data = 16'h3f0c;
            6'h24 : lut_data = 16'h3f10;
            6'h25 : lut_data = 16'h3f14;
            6'h26 : lut_data = 16'h3f18;
            6'h27 : lut_data = 16'h3f1c;
            6'h28 : lut_data = 16'h3f20;
            6'h29 : lut_data = 16'h3f24;
            6'h2a : lut_data = 16'h3f28;
            6'h2b : lut_data = 16'h3f2c;
            6'h2c : lut_data = 16'h3f30;
            6'h2d : lut_data = 16'h3f34;
            6'h2e : lut_data = 16'h3f38;
            6'h2f : lut_data = 16'h3f3c;
            6'h30 : lut_data = 16'h3f40;
            6'h31 : lut_data = 16'h3f44;
            6'h32 : lut_data = 16'h3f48;
            6'h33 : lut_data = 16'h3f4c;
            6'h34 : lut_data = 16'h3f50;
            6'h35 : lut_data = 16'h3f54;
            6'h36 : lut_data = 16'h3f58;
            6'h37 : lut_data = 16'h3f5c;
            6'h38 : lut_data = 16'h3f60;
            6'h39 : lut_data = 16'h3f64;
            6'h3a : lut_data = 16'h3f68;
            6'h3b : lut_data = 16'h3f6c;
            6'h3c : lut_data = 16'h3f70;
            6'h3d : lut_data = 16'h3f74;
            6'h3e : lut_data = 16'h3f78;
            default : lut_data = 16'h3f7c;
        endcase
    end
endmodule
