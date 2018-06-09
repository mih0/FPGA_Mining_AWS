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
//	reg [511:0] h00_d, h00_q, h10_d, h10_q;
//	reg [511:0] h00,h01,h02,h03,h04,h05,h06,h07,h08,h09,h0A,h0B,h0C,h0D,h0E,h0F,h0G,h0H;
	
	reg [511:0] p00_d, p00_q;
	reg [511:0] p00,p01,p02,p03,p04,p05,p06,p07,p08,p09,p0A,p0B,p0C,p0D,p0E,p0F,p0G,p0H;

	wire [511:0] o00,o01,o02,o03,o04,o05,o06,o07,o08,o09,o0A,o0B,o0C,o0D,o0E,o0F,o0G,o0H;

	wire [575:0] ho00,ho01,ho02,ho03,ho04,ho05,ho06,ho07,ho08,ho09,ho0A,ho0B,ho0C,ho0D,ho0E,ho0F,ho0G,ho0H;
//	wire [511:0] ho00,ho01,ho02,ho03,ho04,ho05,ho06,ho07,ho08,ho09,ho0A,ho0B,ho0C,ho0D,ho0E,ho0F,ho0G,ho0H;
	
	reg [575:0] hH;
//	reg [511:0] hH;
	reg [511:0] oH;
	
	reg [511:0] h_d, h_q;
	
	reg [63:0] t0_d, t1_d, t2_d;
	reg [63:0] t0_q, t1_q, t2_q;
	
	reg phase_d = 1'b0, phase_q = 1'b0;

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

	skein_round sr00 (clk,  0, p00_q, h00_q, t0_q, t1_q, o00, ho00);
	skein_round sr01 (clk,  1, p01, h01, t1_q, t2_q, o01, ho01);
	skein_round sr02 (clk,  2, p02, h02, t2_q, t0_q, o02, ho02);
	skein_round sr03 (clk,  3, p03, h03, t0_q, t1_q, o03, ho03);
	skein_round sr04 (clk,  4, p04, h04, t1_q, t2_q, o04, ho04);
	skein_round sr05 (clk,  5, p05, h05, t2_q, t0_q, o05, ho05);
	skein_round sr06 (clk,  6, p06, h06, t0_q, t1_q, o06, ho06);
	skein_round sr07 (clk,  7, p07, h07, t1_q, t2_q, o07, ho07);
	skein_round sr08 (clk,  8, p08, h08, t2_q, t0_q, o08, ho08);
	skein_round sr09 (clk,  9, p09, h09, t0_q, t1_q, o09, ho09);
	skein_round sr0A (clk, 10, p0A, h0A, t1_q, t2_q, o0A, ho0A);
	skein_round sr0B (clk, 11, p0B, h0B, t2_q, t0_q, o0B, ho0B);
	skein_round sr0C (clk, 12, p0C, h0C, t0_q, t1_q, o0C, ho0C);
	skein_round sr0D (clk, 13, p0D, h0D, t1_q, t2_q, o0D, ho0D);
	skein_round sr0E (clk, 14, p0E, h0E, t2_q, t0_q, o0E, ho0E);
	skein_round sr0F (clk, 15, p0F, h0F, t0_q, t1_q, o0F, ho0F);
	skein_round sr0G (clk, 16, p0G, h0G, t1_q, t2_q, o0G, ho0G);
	skein_round sr0H (clk, 17, p0H, h0H, t2_q, t0_q, o0H, ho0H);

	always @ (*) begin

		phase_d <= ~phase_q;

		if ( phase_q ) begin
			p00_d <= {data[63:0], nonce_le, data[95:64], 384'd0 };
			
			h00_d[575:64] <= midstate;
			h00_d[63:0] <= 64'd0;
//			h00_d[63:0] <= ((midstate[448 +: 64] ^ midstate[384 +: 64]) ^ (midstate[320 +: 64] ^ midstate[256 +: 64])) ^ ((midstate[192 +: 64] ^ midstate[128 +: 64]) ^ (midstate[ 64 +: 64] ^ midstate[  0 +: 64])) ^ 64'h1BD11BDAA9FC1A22;
//			h00_d <= midstate;

			t0_d <= 64'h0000000000000050;
			t1_d <= 64'hb000000000000000;
			t2_d <= 64'hb000000000000050;
			
			h_d <= h_q;

		end
		else begin

			p00_d <= 512'd0;

//			h00_d[511:448] <= data[63:0] ^ ( oH[511:448] + hH[511:448] );
//			h00_d[447:384] <= { nonce2_le, data[95:64] } ^ ( oH[447:384] + hH[447:384] );
//			h00_d[383:320] <= oH[383:320] + hH[383:320];
//			h00_d[319:256] <= oH[319:256] + hH[319:256];
//			h00_d[255:192] <= oH[255:192] + hH[255:192];
//			h00_d[191:128] <= oH[191:128] + hH[191:128] + 64'h0000000000000050;
//			h00_d[127: 64] <= oH[127: 64] + hH[127: 64] + 64'hb000000000000000;
//			h00_d[ 63:  0] <= oH[ 63:  0] + hH[ 63:  0] + 18;
//			h00_d[63:0] <= ((h00_d[575:512] ^ h00_d[511:448]) ^ (h00_d[447:384] ^ h00_d[383:320])) ^ ((h00_d[319:256] ^ h00_d[255:192]) ^ (h00_d[191:128] ^ h00_d[127: 64])) ^ 64'h1BD11BDAA9FC1A22;

			h00_d[575:512] <= data[63:0] ^ ( oH[511:448] + hH[575:512] );
			h00_d[511:448] <= { nonce2_le, data[95:64] } ^ ( oH[447:384] + hH[511:448] );
			h00_d[447:384] <= oH[383:320] + hH[447:384];
			h00_d[383:320] <= oH[319:256] + hH[383:320];
			h00_d[319:256] <= oH[255:192] + hH[319:256];
			h00_d[255:192] <= oH[191:128] + hH[255:192] + 64'h0000000000000050;
			h00_d[191:128] <= oH[127: 64] + hH[191:128] + 64'hb000000000000000;
			h00_d[127: 64] <= oH[ 63:  0] + hH[127: 64] + 18;
//			h00_d[63:0] <= ((h00_d[575:512] ^ h00_d[511:448]) ^ (h00_d[447:384] ^ h00_d[383:320])) ^ ((h00_d[319:256] ^ h00_d[255:192]) ^ (h00_d[191:128] ^ h00_d[127: 64])) ^ 64'h1BD11BDAA9FC1A22;

			t0_d <= 64'h0000000000000008;
			t1_d <= 64'hFF00000000000000;
			t2_d <= 64'hFF00000000000008;

			h_d[511:448] <= ( o0H[511:448] + ho0H[575:512] );
			h_d[447:384] <= ( o0H[447:384] + ho0H[511:448] );
			h_d[383:320] <= ( o0H[383:320] + ho0H[447:384] );
			h_d[319:256] <= ( o0H[319:256] + ho0H[383:320] );
			h_d[255:192] <= ( o0H[255:192] + ho0H[319:256] );
			h_d[191:128] <= ( o0H[191:128] + ho0H[255:192] + 64'h0000000000000008 );
			h_d[127: 64] <= ( o0H[127: 64] + ho0H[191:128] + 64'hFF00000000000000 );
			h_d[ 63:  0] <= ( o0H[ 63:  0] + ho0H[127: 64] + 18 );
//			h_d[511:448] <= ( o0H[511:448] + ho0H[511:448] );
//			h_d[447:384] <= ( o0H[447:384] + ho0H[447:384] );
//			h_d[383:320] <= ( o0H[383:320] + ho0H[383:320] );
//			h_d[319:256] <= ( o0H[319:256] + ho0H[319:256] );
//			h_d[255:192] <= ( o0H[255:192] + ho0H[255:192] );
//			h_d[191:128] <= ( o0H[191:128] + ho0H[191:128] + 64'h0000000000000008 );
//			h_d[127: 64] <= ( o0H[127: 64] + ho0H[127: 64] + 64'hFF00000000000000 );
//			h_d[ 63:  0] <= ( o0H[ 63:  0] + ho0H[ 63:  0] + 18 );

		end
	
	end

	always @ (posedge clk) begin
	
//		hH <= { ho0H[63:0], ho0H[575:64] };
		hH <= ho0H;
//		hH <= { ho0H[63:0], ho0H[511:64] };
		oH <= o0H;
	
		phase_q <= phase_d;
		
		t0_q <= t0_d;
		t1_q <= t1_d;
		t2_q <= t2_d;

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

		nonce2 <= nonce - 32'd54;
//		nonce2 <= nonce;

//		$display("n2:   %x", nonce2_le);
//		$display("t0:   %x", t0_d);
//		$display("p00:  %x", p00_d);
//		$display("h00:  %x", h00_d);
//		$display("p01:  %x", p01);
//		$display("h01:  %x", h01);
//		$display("o0G:  %x", o0G);
//		$display("ho0G:  %x", ho0G);
//		$display("o0H:  %x", o0H);
//		$display("ho0H:  %x", ho0H);
//
//		$display("oH:  %x", oH);
//		$display("hH: %x", hH);
//		$display("hx: %x", hx);
//		$display("Hash: %x", hash);
		
	end

endmodule

module skein_round (
	input clk,
	input [31:0] round,
	input [511:0] p,
	input [575:0] h,
//	input [511:0] h,
	input [63:0] t0,
	input [63:0] t1,
	output [511:0] po,
//	output [511:0] ho
	output [575:0] ho
);

	reg [63:0] p0, p1, p2, p3, p4, p5, p6, p7;
	reg [575:0] hx0, hx1, hx2, hx3, hx4;
//	reg [511:0] hx0, hx1, hx2, hx3, hx4;

	assign ho = hx4;

	wire [511:0] po0, po1, po2, po3, po4;
	
	assign po = po4;
	assign po0 = { p0, p1, p2, p3, p4, p5, p6, p7 };

	skein_round_1 r1 (clk, !round[0], po0, po1); 
	skein_round_2 r2 (clk, !round[0], po1, po2); 
	skein_round_3 r3 (clk, !round[0], po2, po3); 
	skein_round_4 r4 (clk, !round[0], po3, po4); 

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
//		p0 <= p[511:448] + h[511:448];
//		p1 <= p[447:384] + h[447:384];
//		p2 <= p[383:320] + h[383:320];
//		p3 <= p[319:256] + h[319:256];
//		p4 <= p[255:192] + h[255:192];
//		p5 <= p[191:128] + h[191:128] + t0;
//		p6 <= p[127: 64] + h[127: 64] + t1;
//		p7 <= p[ 63:  0] + h[ 63:  0] + round;
		
		hx4 <= hx3;
		hx3 <= hx2;
		hx2 <= hx1;
		hx1 <= hx0;
//		hx0 <= { h[511:0], h[575:512] };
		hx0[575:128] <= h[511:64];
		hx0[127:64] <= ((h[575:512] ^ h[511:448]) ^ (h[447:384] ^ h[383:320])) ^ ((h[319:256] ^ h[255:192]) ^ (h[191:128] ^ h[127: 64])) ^ 64'h1BD11BDAA9FC1A22;
//		hx0[511:64] <= h[511:64];
//		hx0[63:0] <= ((h[511:448] ^ h[447:384]) ^ (h[383:320] ^ h[319:256])) ^ ((h[255:192] ^ h[191:128]) ^ (h[127:64] ^ h[63:0])) ^ 64'h1BD11BDAA9FC1A22;
		hx0[63:0] <= h[575:512];
		
//		$display("p:   %x", p);
//		$display("h:   %x", h);
//		$display("po0: %x", po0);
		
	end

endmodule

module skein_round_1 (
	input clk,
	input even,
	input [511:0] in,
	output reg [511:0] out
);
	
	wire [63:0] p0, p1, p2, p3, p4, p5, p6, p7;
	wire [63:0] p0x,p1x,p2x,p3x,p4x,p5x,p6x,p7x;
	
	assign p0 = in[511:448];
	assign p1 = in[447:384];
	assign p2 = in[383:320];
	assign p3 = in[319:256];
	assign p4 = in[255:192];
	assign p5 = in[191:128];
	assign p6 = in[127: 64];
	assign p7 = in[ 63:  0];
	
	assign p0x = p0 + p1;
	assign p1x = (even) ? { p1[17:0], p1[63:18] } : { p1[24:0], p1[63:25] };
	assign p2x = p2 + p3;
	assign p3x = (even) ? { p3[27:0], p3[63:28] } : { p3[33:0], p3[63:34] };
	assign p4x = p4 + p5;
	assign p5x = (even) ? { p5[44:0], p5[63:45] } : { p5[29:0], p5[63:30] };
	assign p6x = p6 + p7;
	assign p7x = (even) ? { p7[26:0], p7[63:27] } : { p7[39:0], p7[63:40] };

	always @ (posedge clk) begin
	
		out[511:448] <= p0x;
		out[447:384] <= p1x ^ p0x;
		out[383:320] <= p2x;
		out[319:256] <= p3x ^ p2x;
		out[255:192] <= p4x;
		out[191:128] <= p5x ^ p4x;
		out[127: 64] <= p6x;
		out[ 63:  0] <= p7x ^ p6x;
		
	end

endmodule

module skein_round_2 (
	input clk,
	input even,
	input [511:0] in,
	output reg [511:0] out
);
	
	wire [63:0] p0, p1, p2, p3, p4, p5, p6, p7;
	wire [63:0] p0x,p1x,p2x,p3x,p4x,p5x,p6x,p7x;
	
	assign p0 = in[511:448];
	assign p1 = in[447:384];
	assign p2 = in[383:320];
	assign p3 = in[319:256];
	assign p4 = in[255:192];
	assign p5 = in[191:128];
	assign p6 = in[127: 64];
	assign p7 = in[ 63:  0];
	
	assign p0x = p0 + p3;
	assign p1x = (even) ? { p1[30:0], p1[63:31] } : { p1[50:0], p1[63:51] };
	assign p2x = p2 + p1;
	assign p3x = (even) ? { p3[21:0], p3[63:22] } : { p3[46:0], p3[63:47] };
	assign p4x = p4 + p7;
	assign p5x = (even) ? { p5[49:0], p5[63:50] } : { p5[53:0], p5[63:54] };
	assign p6x = p6 + p5;
	assign p7x = (even) ? { p7[36:0], p7[63:37] } : { p7[13:0], p7[63:14] };

	always @ (posedge clk) begin
	
		out[511:448] <= p0x;
		out[447:384] <= p1x ^ p2x;
		out[383:320] <= p2x;
		out[319:256] <= p3x ^ p0x;
		out[255:192] <= p4x;
		out[191:128] <= p5x ^ p6x;
		out[127: 64] <= p6x;
		out[ 63:  0] <= p7x ^ p4x;
		
	end

endmodule

module skein_round_3 (
	input clk,
	input even,
	input [511:0] in,
	output reg [511:0] out
);
	
	wire [63:0] p0, p1, p2, p3, p4, p5, p6, p7;
	wire [63:0] p0x,p1x,p2x,p3x,p4x,p5x,p6x,p7x;
	
	assign p0 = in[511:448];
	assign p1 = in[447:384];
	assign p2 = in[383:320];
	assign p3 = in[319:256];
	assign p4 = in[255:192];
	assign p5 = in[191:128];
	assign p6 = in[127: 64];
	assign p7 = in[ 63:  0];
	
	assign p0x = p0 + p5;
	assign p1x = (even) ? { p1[46:0], p1[63:47] } : { p1[38:0], p1[63:39] };
	assign p2x = p2 + p7;
	assign p3x = (even) ? { p3[14:0], p3[63:15] } : { p3[34:0], p3[63:35] };
	assign p4x = p4 + p1;
	assign p5x = (even) ? { p5[27:0], p5[63:28] } : { p5[24:0], p5[63:25] };
	assign p6x = p6 + p3;
	assign p7x = (even) ? { p7[24:0], p7[63:25] } : { p7[20:0], p7[63:21] };

	always @ (posedge clk) begin
	
		out[511:448] <= p0x;
		out[447:384] <= p1x ^ p4x;
		out[383:320] <= p2x;
		out[319:256] <= p3x ^ p6x;
		out[255:192] <= p4x;
		out[191:128] <= p5x ^ p0x;
		out[127: 64] <= p6x;
		out[ 63:  0] <= p7x ^ p2x;
		
	end

endmodule

module skein_round_4 (
	input clk,
	input even,
	input [511:0] in,
	output reg [511:0] out
);
	
	wire [63:0] p0, p1, p2, p3, p4, p5, p6, p7;
	wire [63:0] p0x,p1x,p2x,p3x,p4x,p5x,p6x,p7x;
	
	assign p0 = in[511:448];
	assign p1 = in[447:384];
	assign p2 = in[383:320];
	assign p3 = in[319:256];
	assign p4 = in[255:192];
	assign p5 = in[191:128];
	assign p6 = in[127: 64];
	assign p7 = in[ 63:  0];
	
	assign p0x = p0 + p7;
	assign p1x = (even) ? { p1[19:0], p1[63:20] } : { p1[55:0], p1[63:56] };
	assign p2x = p2 + p5;
	assign p3x = (even) ? { p3[ 7:0], p3[63: 8] } : { p3[41:0], p3[63:42] };
	assign p4x = p4 + p3;
	assign p5x = (even) ? { p5[ 9:0], p5[63:10] } : { p5[ 7:0], p5[63: 8] };
	assign p6x = p6 + p1;
	assign p7x = (even) ? { p7[54:0], p7[63:55] } : { p7[28:0], p7[63:29] };

	always @ (posedge clk) begin
	
		out[511:448] <= p0x;
		out[447:384] <= p1x ^ p6x;
		out[383:320] <= p2x;
		out[319:256] <= p3x ^ p4x;
		out[255:192] <= p4x;
		out[191:128] <= p5x ^ p2x;
		out[127: 64] <= p6x;
		out[ 63:  0] <= p7x ^ p0x;
		
	end

endmodule
