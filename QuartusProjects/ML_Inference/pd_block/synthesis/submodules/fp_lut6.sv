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
            6'h1 : lut_data = 16'h4080;
            6'h2 : lut_data = 16'h4100;
            6'h3 : lut_data = 16'h4140;
            6'h4 : lut_data = 16'h4180;
            6'h5 : lut_data = 16'h41a0;
            6'h6 : lut_data = 16'h41c0;
            6'h7 : lut_data = 16'h41e0;
            6'h8 : lut_data = 16'h4200;
            6'h9 : lut_data = 16'h4210;
            6'ha : lut_data = 16'h4220;
            6'hb : lut_data = 16'h4230;
            6'hc : lut_data = 16'h4240;
            6'hd : lut_data = 16'h4250;
            6'he : lut_data = 16'h4260;
            6'hf : lut_data = 16'h4270;
            6'h10 : lut_data = 16'h4280;
            6'h11 : lut_data = 16'h4288;
            6'h12 : lut_data = 16'h4290;
            6'h13 : lut_data = 16'h4298;
            6'h14 : lut_data = 16'h42a0;
            6'h15 : lut_data = 16'h42a8;
            6'h16 : lut_data = 16'h42b0;
            6'h17 : lut_data = 16'h42b8;
            6'h18 : lut_data = 16'h42c0;
            6'h19 : lut_data = 16'h42c8;
            6'h1a : lut_data = 16'h42d0;
            6'h1b : lut_data = 16'h42d8;
            6'h1c : lut_data = 16'h42e0;
            6'h1d : lut_data = 16'h42e8;
            6'h1e : lut_data = 16'h42f0;
            6'h1f : lut_data = 16'h42f8;
            6'h20 : lut_data = 16'h4300;
            6'h21 : lut_data = 16'h4304;
            6'h22 : lut_data = 16'h4308;
            6'h23 : lut_data = 16'h430c;
            6'h24 : lut_data = 16'h4310;
            6'h25 : lut_data = 16'h4314;
            6'h26 : lut_data = 16'h4318;
            6'h27 : lut_data = 16'h431c;
            6'h28 : lut_data = 16'h4320;
            6'h29 : lut_data = 16'h4324;
            6'h2a : lut_data = 16'h4328;
            6'h2b : lut_data = 16'h432c;
            6'h2c : lut_data = 16'h4330;
            6'h2d : lut_data = 16'h4334;
            6'h2e : lut_data = 16'h4338;
            6'h2f : lut_data = 16'h433c;
            6'h30 : lut_data = 16'h4340;
            6'h31 : lut_data = 16'h4344;
            6'h32 : lut_data = 16'h4348;
            6'h33 : lut_data = 16'h434c;
            6'h34 : lut_data = 16'h4350;
            6'h35 : lut_data = 16'h4354;
            6'h36 : lut_data = 16'h4358;
            6'h37 : lut_data = 16'h435c;
            6'h38 : lut_data = 16'h4360;
            6'h39 : lut_data = 16'h4364;
            6'h3a : lut_data = 16'h4368;
            6'h3b : lut_data = 16'h436c;
            6'h3c : lut_data = 16'h4370;
            6'h3d : lut_data = 16'h4374;
            6'h3e : lut_data = 16'h4378;
            default : lut_data = 16'h437c;
        endcase
    end
endmodule
