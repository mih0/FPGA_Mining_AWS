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

module skein512 (
	input clk,
	input [511:0] midstate,
	input [95:0] data,
	input [31:0] nonce,
	output [511:0] hash
);

	wire [31:0] nonce_le, nonce2_le;

	reg [31:0] nonce2;

	reg [575:0] h00_d, h00_q, h10_d, h10_q;
	reg [575:0] h00,h01,h02,h03,h04,h05,h06,h07,h08,h09,h0A,h0B,h0C,h0D,h0E,h0F,h0G,h0H;
	reg [575:0] h10,h11,h12,h13,h14,h15,h16,h17,h18,h19,h1A,h1B,h1C,h1D,h1E,h1F,h1G,h1H;
	
	reg [511:0] p00_d, p00_q;
	reg [511:0] p00,p01,p02,p03,p04,p05,p06,p07,p08,p09,p0A,p0B,p0C,p0D,p0E,p0F,p0G,p0H;
	reg [511:0] p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p1A,p1B,p1C,p1D,p1E,p1F,p1G,p1H;

	wire [511:0] o00,o01,o02,o03,o04,o05,o06,o07,o08,o09,o0A,o0B,o0C,o0D,o0E,o0F,o0G,o0H;
	wire [511:0] o10,o11,o12,o13,o14,o15,o16,o17,o18,o19,o1A,o1B,o1C,o1D,o1E,o1F,o1G,o1H;

	wire [575:0] ho00,ho01,ho02,ho03,ho04,ho05,ho06,ho07,ho08,ho09,ho0A,ho0B,ho0C,ho0D,ho0E,ho0F,ho0G,ho0H;
	wire [575:0] ho10,ho11,ho12,ho13,ho14,ho15,ho16,ho17,ho18,ho19,ho1A,ho1B,ho1C,ho1D,ho1E,ho1F,ho1G,ho1H;
	
	reg [511:0] h_d, h_q;

	assign nonce_le = { nonce[7:0], nonce[15:8], nonce[23:16], nonce[31:24] };
	assign nonce2_le = { nonce2[7:0], nonce2[15:8], nonce2[23:16], nonce2[31:24] };
	
	assign hash = { h_q[455:448],
			h_q[463:456],
			h_q[471:464],
			h_q[479:472],
			h_q[487:480],
			h_q[495:488],
			h_q[503:496],
			h_q[511:504],
			h_q[391:384],
			h_q[399:392],
			h_q[407:400],
			h_q[415:408],
			h_q[423:416],
			h_q[431:424],
			h_q[439:432],
			h_q[447:440],
			h_q[327:320],
			h_q[335:328],
			h_q[343:336],
			h_q[351:344],
			h_q[359:352],
			h_q[367:360],
			h_q[375:368],
			h_q[383:376],
			h_q[263:256],
			h_q[271:264],
			h_q[279:272],
			h_q[287:280],
			h_q[295:288],
			h_q[303:296],
			h_q[311:304],
			h_q[319:312],
			h_q[199:192],
			h_q[207:200],
			h_q[215:208],
			h_q[223:216],
			h_q[231:224],
			h_q[239:232],
			h_q[247:240],
			h_q[255:248],
			h_q[135:128],
			h_q[143:136],
			h_q[151:144],
			h_q[159:152],
			h_q[167:160],
			h_q[175:168],
			h_q[183:176],
			h_q[191:184],
			h_q[71:64],
			h_q[79:72],
			h_q[87:80],
			h_q[95:88],
			h_q[103:96],
			h_q[111:104],
			h_q[119:112],
			h_q[127:120],
			h_q[7:0],
			h_q[15:8],
			h_q[23:16],
			h_q[31:24],
			h_q[39:32],
			h_q[47:40],
			h_q[55:48],
			h_q[63:56]
		};

	skein_round sr00 (clk,  0, p00_q, h00_q, 64'h0000000000000050, 64'hb000000000000000, o00, ho00);
	skein_round sr01 (clk,  1, p01, h01, 64'hb000000000000000, 64'hb000000000000050, o01, ho01);
	skein_round sr02 (clk,  2, p02, h02, 64'hb000000000000050, 64'h0000000000000050, o02, ho02);
	skein_round sr03 (clk,  3, p03, h03, 64'h0000000000000050, 64'hb000000000000000, o03, ho03);
	skein_round sr04 (clk,  4, p04, h04, 64'hb000000000000000, 64'hb000000000000050, o04, ho04);
	skein_round sr05 (clk,  5, p05, h05, 64'hb000000000000050, 64'h0000000000000050, o05, ho05);
	skein_round sr06 (clk,  6, p06, h06, 64'h0000000000000050, 64'hb000000000000000, o06, ho06);
	skein_round sr07 (clk,  7, p07, h07, 64'hb000000000000000, 64'hb000000000000050, o07, ho07);
	skein_round sr08 (clk,  8, p08, h08, 64'hb000000000000050, 64'h0000000000000050, o08, ho08);
	skein_round sr09 (clk,  9, p09, h09, 64'h0000000000000050, 64'hb000000000000000, o09, ho09);
	skein_round sr0A (clk, 10, p0A, h0A, 64'hb000000000000000, 64'hb000000000000050, o0A, ho0A);
	skein_round sr0B (clk, 11, p0B, h0B, 64'hb000000000000050, 64'h0000000000000050, o0B, ho0B);
	skein_round sr0C (clk, 12, p0C, h0C, 64'h0000000000000050, 64'hb000000000000000, o0C, ho0C);
	skein_round sr0D (clk, 13, p0D, h0D, 64'hb000000000000000, 64'hb000000000000050, o0D, ho0D);
	skein_round sr0E (clk, 14, p0E, h0E, 64'hb000000000000050, 64'h0000000000000050, o0E, ho0E);
	skein_round sr0F (clk, 15, p0F, h0F, 64'h0000000000000050, 64'hb000000000000000, o0F, ho0F);
	skein_round sr0G (clk, 16, p0G, h0G, 64'hb000000000000000, 64'hb000000000000050, o0G, ho0G);
	skein_round sr0H (clk, 17, p0H, h0H, 64'hb000000000000050, 64'h0000000000000050, o0H, ho0H);
                                                                                        
	skein_round sr10 (clk,  0, p10, h10_q, 64'h0000000000000008, 64'hFF00000000000000, o10, ho10);
	skein_round sr11 (clk,  1, p11, h11, 64'hFF00000000000000, 64'hFF00000000000008, o11, ho11);
	skein_round sr12 (clk,  2, p12, h12, 64'hFF00000000000008, 64'h0000000000000008, o12, ho12);
	skein_round sr13 (clk,  3, p13, h13, 64'h0000000000000008, 64'hFF00000000000000, o13, ho13);
	skein_round sr14 (clk,  4, p14, h14, 64'hFF00000000000000, 64'hFF00000000000008, o14, ho14);
	skein_round sr15 (clk,  5, p15, h15, 64'hFF00000000000008, 64'h0000000000000008, o15, ho15);
	skein_round sr16 (clk,  6, p16, h16, 64'h0000000000000008, 64'hFF00000000000000, o16, ho16);
	skein_round sr17 (clk,  7, p17, h17, 64'hFF00000000000000, 64'hFF00000000000008, o17, ho17);
	skein_round sr18 (clk,  8, p18, h18, 64'hFF00000000000008, 64'h0000000000000008, o18, ho18);
	skein_round sr19 (clk,  9, p19, h19, 64'h0000000000000008, 64'hFF00000000000000, o19, ho19);
	skein_round sr1A (clk, 10, p1A, h1A, 64'hFF00000000000000, 64'hFF00000000000008, o1A, ho1A);
	skein_round sr1B (clk, 11, p1B, h1B, 64'hFF00000000000008, 64'h0000000000000008, o1B, ho1B);
	skein_round sr1C (clk, 12, p1C, h1C, 64'h0000000000000008, 64'hFF00000000000000, o1C, ho1C);
	skein_round sr1D (clk, 13, p1D, h1D, 64'hFF00000000000000, 64'hFF00000000000008, o1D, ho1D);
	skein_round sr1E (clk, 14, p1E, h1E, 64'hFF00000000000008, 64'h0000000000000008, o1E, ho1E);
	skein_round sr1F (clk, 15, p1F, h1F, 64'h0000000000000008, 64'hFF00000000000000, o1F, ho1F);
	skein_round sr1G (clk, 16, p1G, h1G, 64'hFF00000000000000, 64'hFF00000000000008, o1G, ho1G);
	skein_round sr1H (clk, 17, p1H, h1H, 64'hFF00000000000008, 64'h0000000000000008, o1H, ho1H);

	always @ (*) begin

		p00_d = {data[63:0], nonce_le, data[95:64], 384'd0 };
		
		h00_d[575:64] = midstate;
		h00_d[63:0] = ((midstate[448 +: 64] ^ midstate[384 +: 64]) ^ (midstate[320 +: 64] ^ midstate[256 +: 64])) ^ ((midstate[192 +: 64] ^ midstate[128 +: 64]) ^ (midstate[ 64 +: 64] ^ midstate[  0 +: 64])) ^ 64'h1BD11BDAA9FC1A22;

		h10_d[575:512] = data[63:0] ^ ( o0H[511:448] + h0H[511:448] );
		h10_d[511:448] = { nonce2_le, data[95:64] } ^ ( o0H[447:384] + h0H[447:384] );
		h10_d[447:384] = o0H[383:320] + h0H[383:320];
		h10_d[383:320] = o0H[319:256] + h0H[319:256];
		h10_d[319:256] = o0H[255:192] + h0H[255:192];
		h10_d[255:192] = o0H[191:128] + h0H[191:128] + 64'h0000000000000050;
		h10_d[191:128] = o0H[127: 64] + h0H[127: 64] + 64'hb000000000000000;
		h10_d[127: 64] = o0H[ 63:  0] + h0H[ 63:  0] + 18;
		h10_d[63:0] = ((h10_d[575:512] ^ h10_d[511:448]) ^ (h10_d[447:384] ^ h10_d[383:320])) ^ ((h10_d[319:256] ^ h10_d[255:192]) ^ (h10_d[191:128] ^ h10_d[127: 64])) ^ 64'h1BD11BDAA9FC1A22;

		h_d[511:448] = ( o1H[511:448] + ho1H[575:512] );
		h_d[447:384] = ( o1H[447:384] + ho1H[511:448] );
		h_d[383:320] = ( o1H[383:320] + ho1H[447:384] );
		h_d[319:256] = ( o1H[319:256] + ho1H[383:320] );
		h_d[255:192] = ( o1H[255:192] + ho1H[319:256] );
		h_d[191:128] = ( o1H[191:128] + ho1H[255:192] + 64'h0000000000000008 );
		h_d[127: 64] = ( o1H[127: 64] + ho1H[191:128] + 64'hFF00000000000000 );
		h_d[ 63:  0] = ( o1H[ 63:  0] + ho1H[127: 64] + 18 );
		
	end
	
	always @ (posedge clk) begin

		h_q <= h_d;

		p0H <= o0G;
		h0H <= ho0G;
		p0G <= o0F;
		h0G <= ho0F;
		p0F <= o0E;
		h0F <= ho0E;
		p0E <= o0D;
		h0E <= ho0D;
		p0D <= o0C;
		h0D <= ho0C;
		p0C <= o0B;
		h0C <= ho0B;
		p0B <= o0A;
		h0B <= ho0A;
		p0A <= o09;
		h0A <= ho09;
		p09 <= o08;
		h09 <= ho08;
		p08 <= o07;
		h08 <= ho07;
		p07 <= o06;
		h07 <= ho06;
		p06 <= o05;
		h06 <= ho05;
		p05 <= o04;
		h05 <= ho04;
		p04 <= o03;
		h04 <= ho03;
		p03 <= o02;
		h03 <= ho02;
		p02 <= o01;
		h02 <= ho01;
		p01 <= o00;
		h01 <= ho00;
		p00_q <= p00_d;
		h00_q <= h00_d;

		p1H <= o1G;
		h1H <= ho1G;
		p1G <= o1F;
		h1G <= ho1F;
		p1F <= o1E;
		h1F <= ho1E;
		p1E <= o1D;
		h1E <= ho1D;
		p1D <= o1C;
		h1D <= ho1C;
		p1C <= o1B;
		h1C <= ho1B;
		p1B <= o1A;
		h1B <= ho1A;
		p1A <= o19;
		h1A <= ho19;
		p19 <= o18;
		h19 <= ho18;
		p18 <= o17;
		h18 <= ho17;
		p17 <= o16;
		h17 <= ho16;
		p16 <= o15;
		h16 <= ho15;
		p15 <= o14;
		h15 <= ho14;
		p14 <= o13;
		h14 <= ho13;
		p13 <= o12;
		h13 <= ho12;
		p12 <= o11;
		h12 <= ho11;
		p11 <= o10;
		h11 <= ho10;
		p10 <= 512'd0;
		h10_q <= h10_d;

		nonce2 <= nonce - 32'd71;

//		$display("m46:  %x", m46);
//		$display("o0H:  %x", o0H);
//		$display("n2:   %x", nonce2_le);
//		$display("p01:  %x", p01);
//		$display("h01:  %x", h01);
//		$display("p02:  %x", p02);
//		$display("h02:  %x", h02);
//		$display("p03:  %x", p03);
//		$display("h03:  %x", h03);
//		$display("p0H:  %x", p0H);
//		$display("h0H:  %x", h0H);
//		$display("p10:  %x", p10);
//		$display("h10:  %x", h10_d);
//		$display("p11:  %x", p11);
//		$display("h11:  %x", h11);
//		$display("p12:  %x", p12);
//		$display("h12:  %x", h12);
//		$display("p13:  %x", p13);
//		$display("h13:  %x", h13);
//		$display("p1H:  %x", p1H);
//		$display("h1H:  %x", h1H);
//
//		$display("o1H:  %x", o1H);
//		$display("ho1H: %x", ho1H);
//		$display("Hash: %x", hash);
		
	end

endmodule

module skein_round (
	input clk,
	input [31:0] round,
	input [511:0] p,
	input [575:0] h,
	input [63:0] t0,
	input [63:0] t1,
	output [511:0] po,
	output [575:0] ho
);

	reg [63:0] p0, p1, p2, p3, p4, p5, p6, p7;
	reg [575:0] hx0, hx1, hx2, hx3, hx4;

//	assign ho = hx4;
	assign ho = hx2;

	wire [511:0] po0, po1, po2, po3, po4;
	
//	assign po = po4;
	assign po = po2;
	assign po0 = { p0, p1, p2, p3, p4, p5, p6, p7 };

//	skein_roundx r1 (clk, round, po0, po4); 

	skein_round_1x r1 (clk, !round[0], po0, po1); 
	skein_round_2x r2 (clk, !round[0], po1, po2); 
//	skein_round_3 r3 (clk, !round[0], po2, po3); 
//	skein_round_4 r4 (clk, !round[0], po3, po4); 

	always @ (posedge clk) begin
	
		// Add Key
		p0 <= p[511:448] + h[575:512];
		p1 <= p[447:384] + h[511:448];
		p2 <= p[383:320] + h[447:384];
		p3 <= p[319:256] + h[383:320];
		p4 <= p[255:192] + h[319:256];
		p5 <= p[191:128] + h[255:192] + t0;
		p6 <= p[127: 64] + h[191:128] + t1;
		p7 <= p[ 63:  0] + h[127: 64] + round;
		
		hx4 <= hx3;
		hx3 <= hx2;
		hx2 <= hx1;
		hx1 <= hx0;
		hx0 <= { h[511:0], h[575:512] };
		
	end

endmodule

module skein_round_1 (
	input clk,
	input even,
	input [511:0] p,
	output [511:0] po
);

	reg [63:0] p0, p1, p2, p3, p4, p5, p6, p7;
	assign po = { p0, p1, p2, p3, p4, p5, p6, p7 };

	always @ (posedge clk) begin
	
		{ p0, p1, p2, p3, p4, p5, p6, p7 } = p;

		if ( !even ) begin // Mix Odd
		
			p0 = p0 + p1;
			p1 = { p1[24:0], p1[63:25] } ^ p0;
			p2 = p2 + p3;
			p3 = { p3[33:0], p3[63:34] } ^ p2;
			p4 = p4 + p5;
			p5 = { p5[29:0], p5[63:30] } ^ p4;
			p6 = p6 + p7;
			p7 = { p7[39:0], p7[63:40] } ^ p6;
		
		end
		else begin // Mix Even

			p0 = p0 + p1;
			p1 = { p1[17:0], p1[63:18] } ^ p0;
			p2 = p2 + p3;
			p3 = { p3[27:0], p3[63:28] } ^ p2;
			p4 = p4 + p5;
			p5 = { p5[44:0], p5[63:45] } ^ p4;
			p6 = p6 + p7;
			p7 = { p7[26:0], p7[63:27] } ^ p6;

		end
		
	end

endmodule

module skein_round_2 (
	input clk,
	input even,
	input [511:0] p,
	output [511:0] po
);

	reg [63:0] p0, p1, p2, p3, p4, p5, p6, p7;
	assign po = { p0, p1, p2, p3, p4, p5, p6, p7 };

	always @ (posedge clk) begin
	
		{ p0, p1, p2, p3, p4, p5, p6, p7 } = p;

		if ( !even ) begin // Mix Odd
		
			p2 = p2 + p1;
			p1 = { p1[50:0], p1[63:51] } ^ p2;
			p4 = p4 + p7;
			p7 = { p7[13:0], p7[63:14] } ^ p4;
			p6 = p6 + p5;
			p5 = { p5[53:0], p5[63:54] } ^ p6;
			p0 = p0 + p3;
			p3 = { p3[46:0], p3[63:47] } ^ p0;

		end
		else begin // Mix Even

			p2 = p2 + p1;
			p1 = { p1[30:0], p1[63:31] } ^ p2;
			p4 = p4 + p7;
			p7 = { p7[36:0], p7[63:37] } ^ p4;
			p6 = p6 + p5;
			p5 = { p5[49:0], p5[63:50] } ^ p6;
			p0 = p0 + p3;
			p3 = { p3[21:0], p3[63:22] } ^ p0;

		end
		
	end

endmodule

module skein_round_3 (
	input clk,
	input even,
	input [511:0] p,
	output [511:0] po
);

	reg [63:0] p0, p1, p2, p3, p4, p5, p6, p7;
	assign po = { p0, p1, p2, p3, p4, p5, p6, p7 };

	always @ (posedge clk) begin
	
		{ p0, p1, p2, p3, p4, p5, p6, p7 } = p;

		if ( !even ) begin // Mix Odd

			p4 = p4 + p1;
			p1 = { p1[38:0], p1[63:39] } ^ p4;
			p6 = p6 + p3;
			p3 = { p3[34:0], p3[63:35] } ^ p6;
			p0 = p0 + p5;
			p5 = { p5[24:0], p5[63:25] } ^ p0;
			p2 = p2 + p7;
			p7 = { p7[20:0], p7[63:21] } ^ p2;
		
		end
		else begin // Mix Even

			p4 = p4 + p1;
			p1 = { p1[46:0], p1[63:47] } ^ p4;
			p6 = p6 + p3;
			p3 = { p3[14:0], p3[63:15] } ^ p6;
			p0 = p0 + p5;
			p5 = { p5[27:0], p5[63:28] } ^ p0;
			p2 = p2 + p7;
			p7 = { p7[24:0], p7[63:25] } ^ p2;

		end
		
	end

endmodule

module skein_round_4 (
	input clk,
	input even,
	input [511:0] p,
	output [511:0] po
);

	reg [63:0] p0, p1, p2, p3, p4, p5, p6, p7;
	assign po = { p0, p1, p2, p3, p4, p5, p6, p7 };

	always @ (posedge clk) begin
	
		{ p0, p1, p2, p3, p4, p5, p6, p7 } = p;

		if ( !even ) begin // Mix Odd

			p6 = p6 + p1;
			p1 = { p1[55:0], p1[63:56] } ^ p6;
			p0 = p0 + p7;
			p7 = { p7[28:0], p7[63:29] } ^ p0;
			p2 = p2 + p5;
			p5 = { p5[ 7:0], p5[63: 8] } ^ p2;
			p4 = p4 + p3;
			p3 = { p3[41:0], p3[63:42] } ^ p4;
		
		end
		else begin // Mix Even

			p6 = p6 + p1;
			p1 = { p1[19:0], p1[63:20] } ^ p6;
			p0 = p0 + p7;
			p7 = { p7[54:0], p7[63:55] } ^ p0;
			p2 = p2 + p5;
			p5 = { p5[ 9:0], p5[63:10] } ^ p2;
			p4 = p4 + p3;
			p3 = { p3[ 7:0], p3[63: 8] } ^ p4;

		end
		
	end

endmodule

module skein_round_2x (
	input clk,
	input even,
	input [511:0] p,
	output [511:0] po
);

	reg [63:0] p0, p1, p2, p3, p4, p5, p6, p7;
	
	assign po = { p0, p1, p2, p3, p4, p5, p6, p7 };

	always @ (posedge clk) begin
	
		{ p0, p1, p2, p3, p4, p5, p6, p7 } = p;

		if ( !even ) begin // Mix Odd
		
			p4 = p4 + p1;
			p1 = { p1[38:0], p1[63:39] } ^ p4;
			p6 = p6 + p3;
			p3 = { p3[34:0], p3[63:35] } ^ p6;
			p0 = p0 + p5;
			p5 = { p5[24:0], p5[63:25] } ^ p0;
			p2 = p2 + p7;
			p7 = { p7[20:0], p7[63:21] } ^ p2;

			p6 = p6 + p1;
			p1 = { p1[55:0], p1[63:56] } ^ p6;
			p0 = p0 + p7;
			p7 = { p7[28:0], p7[63:29] } ^ p0;
			p2 = p2 + p5;
			p5 = { p5[ 7:0], p5[63: 8] } ^ p2;
			p4 = p4 + p3;
			p3 = { p3[41:0], p3[63:42] } ^ p4;
		
		end
		else begin // Mix Even

			p4 = p4 + p1;
			p1 = { p1[46:0], p1[63:47] } ^ p4;
			p6 = p6 + p3;
			p3 = { p3[14:0], p3[63:15] } ^ p6;
			p0 = p0 + p5;
			p5 = { p5[27:0], p5[63:28] } ^ p0;
			p2 = p2 + p7;
			p7 = { p7[24:0], p7[63:25] } ^ p2;

			p6 = p6 + p1;
			p1 = { p1[19:0], p1[63:20] } ^ p6;
			p0 = p0 + p7;
			p7 = { p7[54:0], p7[63:55] } ^ p0;
			p2 = p2 + p5;
			p5 = { p5[ 9:0], p5[63:10] } ^ p2;
			p4 = p4 + p3;
			p3 = { p3[ 7:0], p3[63: 8] } ^ p4;

		end
		
	end

endmodule

module skein_round_1x (
	input clk,
	input even,
	input [511:0] p,
	output [511:0] po
);

	reg [63:0] p0, p1, p2, p3, p4, p5, p6, p7;
	
	assign po = { p0, p1, p2, p3, p4, p5, p6, p7 };

	always @ (posedge clk) begin
	
		{ p0, p1, p2, p3, p4, p5, p6, p7 } = p;

		if ( !even ) begin // Mix Odd
		
			p0 = p0 + p1;
			p1 = { p1[24:0], p1[63:25] } ^ p0;
			p2 = p2 + p3;
			p3 = { p3[33:0], p3[63:34] } ^ p2;
			p4 = p4 + p5;
			p5 = { p5[29:0], p5[63:30] } ^ p4;
			p6 = p6 + p7;
			p7 = { p7[39:0], p7[63:40] } ^ p6;

			p2 = p2 + p1;
			p1 = { p1[50:0], p1[63:51] } ^ p2;
			p4 = p4 + p7;
			p7 = { p7[13:0], p7[63:14] } ^ p4;
			p6 = p6 + p5;
			p5 = { p5[53:0], p5[63:54] } ^ p6;
			p0 = p0 + p3;
			p3 = { p3[46:0], p3[63:47] } ^ p0;

		end
		else begin // Mix Even

			p0 = p0 + p1;
			p1 = { p1[17:0], p1[63:18] } ^ p0;
			p2 = p2 + p3;
			p3 = { p3[27:0], p3[63:28] } ^ p2;
			p4 = p4 + p5;
			p5 = { p5[44:0], p5[63:45] } ^ p4;
			p6 = p6 + p7;
			p7 = { p7[26:0], p7[63:27] } ^ p6;

			p2 = p2 + p1;
			p1 = { p1[30:0], p1[63:31] } ^ p2;
			p4 = p4 + p7;
			p7 = { p7[36:0], p7[63:37] } ^ p4;
			p6 = p6 + p5;
			p5 = { p5[49:0], p5[63:50] } ^ p6;
			p0 = p0 + p3;
			p3 = { p3[21:0], p3[63:22] } ^ p0;

		end
		
	end

endmodule

