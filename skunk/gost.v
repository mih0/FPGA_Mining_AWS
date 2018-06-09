/*
 * Copyright (c) 2017 Sprocket
 *
 * This is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License with
 * additional permissions to the one published by the Free Software
 * Foundation, either version 3 of the License, or (at your option)
 * any later version. For more information see LICENSE.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

module gost512 (
	input clk,
	input [511:0] data,
	output [511:0] hash
);

	reg [511:0] N0, N1, N2, N3;
	reg [511:0] h, h0, h1, hx, m0, m1, m2, m3;
	wire [511:0] ho0, ho1;
	
	G G0 (clk, N0, h0, m0, ho0);
	G G1 (clk, N1, h1, m1, ho1);
	
	assign hash = h;
	
	reg [511:0] d00,d01,d02,d03,d04,d05,d06,d07,d08,d09;
	reg [511:0] d10,d11,d12,d13,d14,d15,d16,d17,d18,d19;
	reg [511:0] d20,d21,d22,d23,d24,d25,d26,d27,d28,d29;
	reg [511:0] d30,d31,d32,d33,d34,d35,d36,d37,d38,d39;
	reg [511:0] d40,d41,d42,d43,d44,d45;
	
	reg phase = 1'b0;
	
 	always @ (posedge clk) begin
	
		phase <= ~phase;
		
		if ( !phase ) begin

			m0 <= data;
			h0 <= 512'd0;
			N0 <= 512'd0;
			
			m1 <= 512'd1;
			h1 <= ho0;
			N1 <= 512'd512;

		end
		else begin

			m0 <= 512'd512;
			h0 <= hx;
			N0 <= 512'd0;

			m1[511:8] <= d45[511:8];
			m1[7:0] <= d45[7:0] + 8'd1;
//			m1 <= d45 ^ 512'd1;
			h1 <= ho0;
			N1 <= 512'd0;

			h <= ho1;
						
			d00 <= data;
			d01 <= d00;
			d02 <= d01;
			d03 <= d02;
			d04 <= d03;
			d05 <= d04;
			d06 <= d05;
			d07 <= d06;
			d08 <= d07;
			d09 <= d08;
			d10 <= d09;
			d11 <= d10;
			d12 <= d11;
			d13 <= d12;
			d14 <= d13;
			d15 <= d14;
			d16 <= d15;
			d17 <= d16;
			d18 <= d17;
			d19 <= d18;
			d20 <= d19;
			d21 <= d20;
			d22 <= d21;
			d23 <= d22;
			d24 <= d23;
			d25 <= d24;
			d26 <= d25;
			d27 <= d26;
			d28 <= d27;
			d29 <= d28;
			d30 <= d29;
			d31 <= d30;
			d32 <= d31;
			d33 <= d32;
			d34 <= d33;
			d35 <= d34;
			d36 <= d35;
			d37 <= d36;
			d38 <= d37;
			d39 <= d38;
			d40 <= d39;
			d41 <= d40;
			d42 <= d41;
			d43 <= d42;
			d44 <= d43;
			d45 <= d44;
	
		end
		
		hx <= ho1;


//		$display("d:   %X", d87); 
//		$display("h1:  %X", h1); 
//		$display("h2:  %X", h2); 
//		$display("h3:  %X", h3); 
//		$display("h4:  %X", h4); 

	end

endmodule


module G (
	input clk,
	input [511:0] n,
	input [511:0] h,
	input [511:0] m,
	output [511:0] out
);

	wire [511:0] k0_d, e_d;
	
	reg [511:0] mh00,mh01,mh02,mh03,mh04,mh05,mh06,mh07,mh08,mh09,mh10,mh11,mh12,mh13,mh14,mh15;
	reg [511:0] mh16,mh17,mh18,mh19,mh20,mh21,mh22,mh23,mh24,mh25,mh26,mh27;
	reg [511:0] m0, m1, m2;
	reg [511:0] k0, k1;
	reg [511:0] o;

	assign out = o;
	
	LPS LPS (clk, k0, k0_d);
	E E (clk, m2, k1, e_d);
	
 	always @ (posedge clk) begin
	
		m0 <= m;
		m1 <= m0;
		m2 <= m1;

		k0 <= n ^ h;
		k1 <= k0_d;
		
		mh00 <= m ^ h;
		mh01 <= mh00;
		mh02 <= mh01;
		mh03 <= mh02;
		mh04 <= mh03;
		mh05 <= mh04;
		mh06 <= mh05;
		mh07 <= mh06;
		mh08 <= mh07;
		mh09 <= mh08;
		mh10 <= mh09;
		mh11 <= mh10;
		mh12 <= mh11;
		mh13 <= mh12;
		mh14 <= mh13;
		mh15 <= mh14;
		mh16 <= mh15;
		mh17 <= mh16;
		mh18 <= mh17;
		mh19 <= mh18;
		mh20 <= mh19;
		mh21 <= mh20;
		mh22 <= mh21;
		mh23 <= mh22;
		mh24 <= mh23;
		mh25 <= mh24;
		mh26 <= mh25;
		mh27 <= mh26;
		
		o <= mh27 ^ e_d;

//		if (h == 512'd0) begin
//			$display("m1:  %X", m1); 
//			$display("k1:  %X", k1); 
//			$display("mh26:  %X", mh26); 
//			$display("ed:  %X", e_d); 
//		end


	end

endmodule


module E (
	input clk,
	input [511:0] m,
	input [511:0] k,
	output [511:0] out
);

	localparam [511:0] C0 = 512'hB1085BDA1ECADAE9EBCB2F81C0657C1F2F6A76432E45D016714EB88D7585C4FC4B7CE09192676901A2422A08A460D31505767436CC744D23DD806559F2A64507;
	localparam [511:0] C1 = 512'h6FA3B58AA99D2F1A4FE39D460F70B5D7F3FEEA720A232B9861D55E0F16B501319AB5176B12D699585CB561C2DB0AA7CA55DDA21BD7CBCD56E679047021B19BB7;
	localparam [511:0] C2 = 512'hF574DCAC2BCE2FC70A39FC286A3D843506F15E5F529C1F8BF2EA7514B1297B7BD3E20FE490359EB1C1C93A376062DB09C2B6F443867ADB31991E96F50ABA0AB2;
	localparam [511:0] C3 = 512'hEF1FDFB3E81566D2F948E1A05D71E4DD488E857E335C3C7D9D721CAD685E353FA9D72C82ED03D675D8B71333935203BE3453EAA193E837F1220CBEBC84E3D12E;
	localparam [511:0] C4 = 512'h4BEA6BACAD4747999A3F410C6CA923637F151C1F1686104A359E35D7800FFFBDBFCD1747253AF5A3DFFF00B723271A167A56A27EA9EA63F5601758FD7C6CFE57;
	localparam [511:0] C5 = 512'hAE4FAEAE1D3AD3D96FA4C33B7A3039C02D66C4F95142A46C187F9AB49AF08EC6CFFAA6B71C9AB7B40AF21F66C2BEC6B6BF71C57236904F35FA68407A46647D6E;
	localparam [511:0] C6 = 512'hF4C70E16EEAAC5EC51AC86FEBF240954399EC6C7E6BF87C9D3473E33197A93C90992ABC52D822C3706476983284A05043517454CA23C4AF38886564D3A14D493;
	localparam [511:0] C7 = 512'h9B1F5B424D93C9A703E7AA020C6E41414EB7F8719C36DE1E89B4443B4DDBC49AF4892BCB929B069069D18D2BD1A5C42F36ACC2355951A8D9A47F0DD4BF02E71E;
	localparam [511:0] C8 = 512'h378F5A541631229B944C9AD8EC165FDE3A7D3A1B258942243CD955B7E00D0984800A440BDBB2CEB17B2B8A9AA6079C540E38DC92CB1F2A607261445183235ADB;
	localparam [511:0] C9 = 512'hABBEDEA680056F52382AE548B2E4F3F38941E71CFF8A78DB1FFFE18A1B3361039FE76702AF69334B7A1E6C303B7652F43698FAD1153BB6C374B4C7FB98459CED;
	localparam [511:0] C10 = 512'h7BCD9ED0EFC889FB3002C6CD635AFE94D8FA6BBBEBAB076120018021148466798A1D71EFEA48B9CAEFBACD1D7D476E98DEA2594AC06FD85D6BCAA4CD81F32D1B;
	localparam [511:0] C11 = 512'h378EE767F11631BAD21380B00449B17ACDA43C32BCDF1D77F82012D430219F9B5D80EF9D1891CC86E71DA4AA88E12852FAF417D5D9B21B9948BC924AF11BD720;

	wire [511:0] m0_d, m1_d, m2_d, m3_d, m4_d, m5_d, m6_d, m7_d, m8_d, m9_d, mA_d, mB_d;
	wire [511:0] k0_d, k1_d, k2_d, k3_d, k4_d, k5_d, k6_d, k7_d, k8_d, k9_d, kA_d, kB_d;

	reg [511:0] m0, m1, m2, m3, m4, m5, m6, m7, m8, m9, mA, mB;
	reg [511:0] k0, k1, k2, k3, k4, k5, k6, k7, k8, k9, kA, kB;
	reg [511:0] o;

	assign out = o;

	// 12 Rounds Of Compression
	LPS LPS0_m (clk, m0, m0_d);
	LPS LPS0_k (clk, k0, k0_d);
	LPS LPS1_m (clk, m1, m1_d);
	LPS LPS1_k (clk, k1, k1_d);
	LPS LPS2_m (clk, m2, m2_d);
	LPS LPS2_k (clk, k2, k2_d);
	LPS LPS3_m (clk, m3, m3_d);
	LPS LPS3_k (clk, k3, k3_d);
	LPS LPS4_m (clk, m4, m4_d);
	LPS LPS4_k (clk, k4, k4_d);
	LPS LPS5_m (clk, m5, m5_d);
	LPS LPS5_k (clk, k5, k5_d);
	LPS LPS6_m (clk, m6, m6_d);
	LPS LPS6_k (clk, k6, k6_d);
	LPS LPS7_m (clk, m7, m7_d);
	LPS LPS7_k (clk, k7, k7_d);
	LPS LPS8_m (clk, m8, m8_d);
	LPS LPS8_k (clk, k8, k8_d);
	LPS LPS9_m (clk, m9, m9_d);
	LPS LPS9_k (clk, k9, k9_d);
	LPS LPSA_m (clk, mA, mA_d);
	LPS LPSA_k (clk, kA, kA_d);
	LPS LPSB_m (clk, mB, mB_d);
	LPS LPSB_k (clk, kB, kB_d);
	
 	always @ (posedge clk) begin

		m0 <= m ^ k;
		k0 <= k ^ C0;
		m1 <= m0_d ^ k0_d;
		k1 <= k0_d ^ C1;
		m2 <= m1_d ^ k1_d;
		k2 <= k1_d ^ C2;
		m3 <= m2_d ^ k2_d;
		k3 <= k2_d ^ C3;
		m4 <= m3_d ^ k3_d;
		k4 <= k3_d ^ C4;
		m5 <= m4_d ^ k4_d;
		k5 <= k4_d ^ C5;
		m6 <= m5_d ^ k5_d;
		k6 <= k5_d ^ C6;
		m7 <= m6_d ^ k6_d;
		k7 <= k6_d ^ C7;
		m8 <= m7_d ^ k7_d;
		k8 <= k7_d ^ C8;
		m9 <= m8_d ^ k8_d;
		k9 <= k8_d ^ C9;
		mA <= m9_d ^ k9_d;
		kA <= k9_d ^ C10;
		mB <= mA_d ^ kA_d;
		kB <= kA_d ^ C11;
		
		o <= mB_d ^ kB_d;

	end

endmodule


module LPS (
	input clk,
	input [511:0] in,
	output [511:0] out
);

	wire [511:0] p0;
	wire [63:0] t0, t1, t2, t3, t4, t5, t6, t7;

	// Non-Linear Transformation
	PS PS (in, p0);
	
	// Linear Transformation
	L L0 (clk, p0[511:448], t0);
	L L1 (clk, p0[447:384], t1);
	L L2 (clk, p0[383:320], t2);
	L L3 (clk, p0[319:256], t3);
	L L4 (clk, p0[255:192], t4);
	L L5 (clk, p0[191:128], t5);
	L L6 (clk, p0[127: 64], t6);
	L L7 (clk, p0[ 63:  0], t7);
	
	assign out = { t0, t1, t2, t3, t4, t5, t6, t7 };

endmodule


// Non-Linear Transformation (Pi / Tau Substitution)
module PS (
	input [511:0] in,
	output [511:0] out
);

	wire [7:0] Pi [0:255] = {
		8'hfc,8'hee,8'hdd,8'h11,8'hcf,8'h6e,8'h31,8'h16,8'hfb,8'hc4,8'hfa,8'hda,8'h23,8'hc5,8'h04,8'h4d,
		8'he9,8'h77,8'hf0,8'hdb,8'h93,8'h2e,8'h99,8'hba,8'h17,8'h36,8'hf1,8'hbb,8'h14,8'hcd,8'h5f,8'hc1,
		8'hf9,8'h18,8'h65,8'h5a,8'he2,8'h5c,8'hef,8'h21,8'h81,8'h1c,8'h3c,8'h42,8'h8b,8'h01,8'h8e,8'h4f,
		8'h05,8'h84,8'h02,8'hae,8'he3,8'h6a,8'h8f,8'ha0,8'h06,8'h0b,8'hed,8'h98,8'h7f,8'hd4,8'hd3,8'h1f,
		8'heb,8'h34,8'h2c,8'h51,8'hea,8'hc8,8'h48,8'hab,8'hf2,8'h2a,8'h68,8'ha2,8'hfd,8'h3a,8'hce,8'hcc,
		8'hb5,8'h70,8'h0e,8'h56,8'h08,8'h0c,8'h76,8'h12,8'hbf,8'h72,8'h13,8'h47,8'h9c,8'hb7,8'h5d,8'h87,
		8'h15,8'ha1,8'h96,8'h29,8'h10,8'h7b,8'h9a,8'hc7,8'hf3,8'h91,8'h78,8'h6f,8'h9d,8'h9e,8'hb2,8'hb1,
		8'h32,8'h75,8'h19,8'h3d,8'hff,8'h35,8'h8a,8'h7e,8'h6d,8'h54,8'hc6,8'h80,8'hc3,8'hbd,8'h0d,8'h57,
		8'hdf,8'hf5,8'h24,8'ha9,8'h3e,8'ha8,8'h43,8'hc9,8'hd7,8'h79,8'hd6,8'hf6,8'h7c,8'h22,8'hb9,8'h03,
		8'he0,8'h0f,8'hec,8'hde,8'h7a,8'h94,8'hb0,8'hbc,8'hdc,8'he8,8'h28,8'h50,8'h4e,8'h33,8'h0a,8'h4a,
		8'ha7,8'h97,8'h60,8'h73,8'h1e,8'h00,8'h62,8'h44,8'h1a,8'hb8,8'h38,8'h82,8'h64,8'h9f,8'h26,8'h41,
		8'had,8'h45,8'h46,8'h92,8'h27,8'h5e,8'h55,8'h2f,8'h8c,8'ha3,8'ha5,8'h7d,8'h69,8'hd5,8'h95,8'h3b,
		8'h07,8'h58,8'hb3,8'h40,8'h86,8'hac,8'h1d,8'hf7,8'h30,8'h37,8'h6b,8'he4,8'h88,8'hd9,8'he7,8'h89,
		8'he1,8'h1b,8'h83,8'h49,8'h4c,8'h3f,8'hf8,8'hfe,8'h8d,8'h53,8'haa,8'h90,8'hca,8'hd8,8'h85,8'h61,
		8'h20,8'h71,8'h67,8'ha4,8'h2d,8'h2b,8'h09,8'h5b,8'hcb,8'h9b,8'h25,8'hd0,8'hbe,8'he5,8'h6c,8'h52,
		8'h59,8'ha6,8'h74,8'hd2,8'he6,8'hf4,8'hb4,8'hc0,8'hd1,8'h66,8'haf,8'hc2,8'h39,8'h4b,8'h63,8'hb6
	};

	assign out[511:504] = Pi[ in[511:504] ];
	assign out[447:440] = Pi[ in[503:496] ];
	assign out[383:376] = Pi[ in[495:488] ];
	assign out[319:312] = Pi[ in[487:480] ];
	assign out[255:248] = Pi[ in[479:472] ];
	assign out[191:184] = Pi[ in[471:464] ];
	assign out[127:120] = Pi[ in[463:456] ];
	assign out[ 63: 56] = Pi[ in[455:448] ];
	assign out[503:496] = Pi[ in[447:440] ];
	assign out[439:432] = Pi[ in[439:432] ];
	assign out[375:368] = Pi[ in[431:424] ];
	assign out[311:304] = Pi[ in[423:416] ];
	assign out[247:240] = Pi[ in[415:408] ];
	assign out[183:176] = Pi[ in[407:400] ];
	assign out[119:112] = Pi[ in[399:392] ];
	assign out[ 55: 48] = Pi[ in[391:384] ];
	assign out[495:488] = Pi[ in[383:376] ];
	assign out[431:424] = Pi[ in[375:368] ];
	assign out[367:360] = Pi[ in[367:360] ];
	assign out[303:296] = Pi[ in[359:352] ];
	assign out[239:232] = Pi[ in[351:344] ];
	assign out[175:168] = Pi[ in[343:336] ];
	assign out[111:104] = Pi[ in[335:328] ];
	assign out[ 47: 40] = Pi[ in[327:320] ];
	assign out[487:480] = Pi[ in[319:312] ];
	assign out[423:416] = Pi[ in[311:304] ];
	assign out[359:352] = Pi[ in[303:296] ];
	assign out[295:288] = Pi[ in[295:288] ];
	assign out[231:224] = Pi[ in[287:280] ];
	assign out[167:160] = Pi[ in[279:272] ];
	assign out[103: 96] = Pi[ in[271:264] ];
	assign out[ 39: 32] = Pi[ in[263:256] ];
	assign out[479:472] = Pi[ in[255:248] ];
	assign out[415:408] = Pi[ in[247:240] ];
	assign out[351:344] = Pi[ in[239:232] ];
	assign out[287:280] = Pi[ in[231:224] ];
	assign out[223:216] = Pi[ in[223:216] ];
	assign out[159:152] = Pi[ in[215:208] ];
	assign out[ 95: 88] = Pi[ in[207:200] ];
	assign out[ 31: 24] = Pi[ in[199:192] ];
	assign out[471:464] = Pi[ in[191:184] ];
	assign out[407:400] = Pi[ in[183:176] ];
	assign out[343:336] = Pi[ in[175:168] ];
	assign out[279:272] = Pi[ in[167:160] ];
	assign out[215:208] = Pi[ in[159:152] ];
	assign out[151:144] = Pi[ in[151:144] ];
	assign out[ 87: 80] = Pi[ in[143:136] ];
	assign out[ 23: 16] = Pi[ in[135:128] ];
	assign out[463:456] = Pi[ in[127:120] ];
	assign out[399:392] = Pi[ in[119:112] ];
	assign out[335:328] = Pi[ in[111:104] ];
	assign out[271:264] = Pi[ in[103: 96] ];
	assign out[207:200] = Pi[ in[ 95: 88] ];
	assign out[143:136] = Pi[ in[ 87: 80] ];
	assign out[ 79: 72] = Pi[ in[ 79: 72] ];
	assign out[ 15:  8] = Pi[ in[ 71: 64] ];
	assign out[455:448] = Pi[ in[ 63: 56] ];
	assign out[391:384] = Pi[ in[ 55: 48] ];
	assign out[327:320] = Pi[ in[ 47: 40] ];
	assign out[263:256] = Pi[ in[ 39: 32] ];
	assign out[199:192] = Pi[ in[ 31: 24] ];
	assign out[135:128] = Pi[ in[ 23: 16] ];
	assign out[ 71: 64] = Pi[ in[ 15:  8] ];
	assign out[  7:  0] = Pi[ in[  7:  0] ];
	
endmodule


// Linear Transformation
module L (
	input clk,
	input [63:0] in,
	output [63:0] out
);

	reg [63:0] t;
	
	assign out = t;
	
	always @ (posedge clk) begin
	
		t = 64'd0;
		
		if (in[63]) t = t ^ 64'h8e20faa72ba0b470;
		if (in[62]) t = t ^ 64'h47107ddd9b505a38;
		if (in[61]) t = t ^ 64'had08b0e0c3282d1c;
		if (in[60]) t = t ^ 64'hd8045870ef14980e;
		if (in[59]) t = t ^ 64'h6c022c38f90a4c07;
		if (in[58]) t = t ^ 64'h3601161cf205268d;
		if (in[57]) t = t ^ 64'h1b8e0b0e798c13c8;
		if (in[56]) t = t ^ 64'h83478b07b2468764;
		if (in[55]) t = t ^ 64'ha011d380818e8f40;
		if (in[54]) t = t ^ 64'h5086e740ce47c920;
		if (in[53]) t = t ^ 64'h2843fd2067adea10;
		if (in[52]) t = t ^ 64'h14aff010bdd87508;
		if (in[51]) t = t ^ 64'h0ad97808d06cb404;
		if (in[50]) t = t ^ 64'h05e23c0468365a02;
		if (in[49]) t = t ^ 64'h8c711e02341b2d01;
		if (in[48]) t = t ^ 64'h46b60f011a83988e;
		if (in[47]) t = t ^ 64'h90dab52a387ae76f;
		if (in[46]) t = t ^ 64'h486dd4151c3dfdb9;
		if (in[45]) t = t ^ 64'h24b86a840e90f0d2;
		if (in[44]) t = t ^ 64'h125c354207487869;
		if (in[43]) t = t ^ 64'h092e94218d243cba;
		if (in[42]) t = t ^ 64'h8a174a9ec8121e5d;
		if (in[41]) t = t ^ 64'h4585254f64090fa0;
		if (in[40]) t = t ^ 64'haccc9ca9328a8950;
		if (in[39]) t = t ^ 64'h9d4df05d5f661451;
		if (in[38]) t = t ^ 64'hc0a878a0a1330aa6;
		if (in[37]) t = t ^ 64'h60543c50de970553;
		if (in[36]) t = t ^ 64'h302a1e286fc58ca7;
		if (in[35]) t = t ^ 64'h18150f14b9ec46dd;
		if (in[34]) t = t ^ 64'h0c84890ad27623e0;
		if (in[33]) t = t ^ 64'h0642ca05693b9f70;
		if (in[32]) t = t ^ 64'h0321658cba93c138;
		if (in[31]) t = t ^ 64'h86275df09ce8aaa8;
		if (in[30]) t = t ^ 64'h439da0784e745554;
		if (in[29]) t = t ^ 64'hafc0503c273aa42a;
		if (in[28]) t = t ^ 64'hd960281e9d1d5215;
		if (in[27]) t = t ^ 64'he230140fc0802984;
		if (in[26]) t = t ^ 64'h71180a8960409a42;
		if (in[25]) t = t ^ 64'hb60c05ca30204d21;
		if (in[24]) t = t ^ 64'h5b068c651810a89e;
		if (in[23]) t = t ^ 64'h456c34887a3805b9;
		if (in[22]) t = t ^ 64'hac361a443d1c8cd2;
		if (in[21]) t = t ^ 64'h561b0d22900e4669;
		if (in[20]) t = t ^ 64'h2b838811480723ba;
		if (in[19]) t = t ^ 64'h9bcf4486248d9f5d;
		if (in[18]) t = t ^ 64'hc3e9224312c8c1a0;
		if (in[17]) t = t ^ 64'heffa11af0964ee50;
		if (in[16]) t = t ^ 64'hf97d86d98a327728;
		if (in[15]) t = t ^ 64'he4fa2054a80b329c;
		if (in[14]) t = t ^ 64'h727d102a548b194e;
		if (in[13]) t = t ^ 64'h39b008152acb8227;
		if (in[12]) t = t ^ 64'h9258048415eb419d;
		if (in[11]) t = t ^ 64'h492c024284fbaec0;
		if (in[10]) t = t ^ 64'haa16012142f35760;
		if (in[ 9]) t = t ^ 64'h550b8e9e21f7a530;
		if (in[ 8]) t = t ^ 64'ha48b474f9ef5dc18;
		if (in[ 7]) t = t ^ 64'h70a6a56e2440598e;
		if (in[ 6]) t = t ^ 64'h3853dc371220a247;
		if (in[ 5]) t = t ^ 64'h1ca76e95091051ad;
		if (in[ 4]) t = t ^ 64'h0edd37c48a08a6d8;
		if (in[ 3]) t = t ^ 64'h07e095624504536c;
		if (in[ 2]) t = t ^ 64'h8d70c431ac02a736;
		if (in[ 1]) t = t ^ 64'hc83862965601dd1b;
		if (in[ 0]) t = t ^ 64'h641c314b2b8ee083;
	
	end

endmodule
