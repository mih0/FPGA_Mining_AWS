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

module cube512 (
	input clk,
	input [511:0] data,
	output [511:0] hash
);
	
	wire [511:0] data_le;
	reg [511:0] hash_le;

	genvar j;
	generate
		for( j=0; j < 64 ; j = j + 1) begin: DATA_REVERSE
			assign data_le[j*8 +: 8] = data[(63-j)*8 +: 8];
		end
	endgenerate

	generate
		for( j=0; j < 64 ; j = j + 1) begin: HASH_REVERSE
			assign hash[j*8 +: 8] = hash_le[(63-j)*8 +: 8];
		end
	endgenerate


	reg [1023:0] i0,i1,i2,i3,i4,i5,i6;
	reg [255:0] d,d1,d2,d3,d4,d5,d6,d7,d8,d9,dA,dB,dC,dD,dE,dF,dG;

	wire [1023:0] o0,o1,o2,o3,o4,o5,o6;
	
	reg phase = 1'b0;

	cube_round cr0 (clk, i0, o0);
	cube_round cr1 (clk, i1, o1);
	cube_round cr2 (clk, i2, o2);
	cube_round cr3 (clk, i3, o3);
	cube_round cr4 (clk, i4, o4);
	cube_round cr5 (clk, i5, o5);
	cube_round cr6 (clk, i6, o6);
	
	always @ (posedge clk) begin
	
		phase = ~phase;
		
		if ( !phase ) begin

//			d  <= dG;
			d  <= d8;
			dG <= dF;
			dF <= dE;
			dE <= dD;
			dD <= dC;
			dC <= dB;
			dB <= dA;
			dA <= d9;
			d9 <= d8;
			d8 <= d7;
			d7 <= d6;
			d6 <= d5;
			d5 <= d4;
			d4 <= d3;
			d3 <= d2;
			d2 <= d1;
			d1 <= data_le[511:256];

			i0[1023:992] <= data_le[  0 +: 32] ^ 32'h2AEA2A61;
			i0[991:960]  <= data_le[ 32 +: 32] ^ 32'h50F494D4;
			i0[959:928]  <= data_le[ 64 +: 32] ^ 32'h2D538B8B;
			i0[927:896]  <= data_le[ 96 +: 32] ^ 32'h4167D83E;
			i0[895:864]  <= data_le[128 +: 32] ^ 32'h3FEE2313;
			i0[863:832]  <= data_le[160 +: 32] ^ 32'hC701CF8C;
			i0[831:800]  <= data_le[192 +: 32] ^ 32'hCC39968E;
			i0[799:768]  <= data_le[224 +: 32] ^ 32'h50AC5695;
			i0[767:  0]  <= 768'h4D42C787A647A8B397CF0BEF825B4537EEF864D2F22090C4D0E5CD33A23911AEFCD398D9148FE4851B017BEFB64445326A5361592FF5781C91FA79340DBADEA9D65C8A2BA5A70E75B1C62456BC7965761921C8F7E7989AF17795D246D43E3B44;

//			i1[1023:992] <= o0[1023:992] ^ d[  0 +: 32];
//			i1[991:960]  <= o0[991:960]  ^ d[ 32 +: 32];
//			i1[959:928]  <= o0[959:928]  ^ d[ 64 +: 32];
//			i1[927:896]  <= o0[927:896]  ^ d[ 96 +: 32];
//			i1[895:864]  <= o0[895:864]  ^ d[128 +: 32];
//			i1[863:832]  <= o0[863:832]  ^ d[160 +: 32];
//			i1[831:800]  <= o0[831:800]  ^ d[192 +: 32];
//			i1[799:768]  <= o0[799:768]  ^ d[224 +: 32];
//			i1[767:  0]  <= o0[767:  0];
			
			i1 <= o0;

			i2[1023:1000] <= o1[1023:1000];
			i2[999:992] <= o1[999:992] ^ 8'h80;
			i2[991:  0] <= o1[991:  0];

			i3 <= o2;

		end
		else begin

			i0 <= o6;

			i1[1023:992] <= o0[1023:992] ^ d[  0 +: 32];
			i1[991:960]  <= o0[991:960]  ^ d[ 32 +: 32];
			i1[959:928]  <= o0[959:928]  ^ d[ 64 +: 32];
			i1[927:896]  <= o0[927:896]  ^ d[ 96 +: 32];
			i1[895:864]  <= o0[895:864]  ^ d[128 +: 32];
			i1[863:832]  <= o0[863:832]  ^ d[160 +: 32];
			i1[831:800]  <= o0[831:800]  ^ d[192 +: 32];
			i1[799:768]  <= o0[799:768]  ^ d[224 +: 32];
			i1[767:  0]  <= o0[767:  0];

//			i1 <= o0;
			i2 <= o1;

			i3 <= o2;
			i3[1023:8] <= o2[1023:8];
			i3[7:0] <= o2[7:0] ^ 8'h01;

			hash_le <= {
				o5[543:512],
				o5[575:544],
				o5[607:576],
				o5[639:608],
				o5[671:640],
				o5[703:672],
				o5[735:704],
				o5[767:736],
				o5[799:768],
				o5[831:800],
				o5[863:832],
				o5[895:864],
				o5[927:896],
				o5[959:928],
				o5[991:960],
				o5[1023:992] };
	
		end

		i4 <= o3;
		i5 <= o4;
		i6 <= o5;

	end

endmodule

module cube_round (
	input clk,
	input [1023:0] in,
	output [1023:0] out
);

	wire [1023:0] r0, r1, r2, r3, r4, r5, r6;
	
	cube_round_mix rm0 (clk, in, r0);
	cube_round_mix rm1 (clk, r0, r1);
	cube_round_mix rm2 (clk, r1, r2);
	cube_round_mix rm3 (clk, r2, r3);
	cube_round_mix rm4 (clk, r3, r4);
	cube_round_mix rm5 (clk, r4, r5);
	cube_round_mix rm6 (clk, r5, r6);
	cube_round_mix rm7 (clk, r6, out);

endmodule

module cube_round_mix (
	input clk,
	input [1023:0] in,
	output [1023:0] out
);

	wire [1023:0] rm;

	cube_round_mix_1 rm1 (clk, in, rm);
	cube_round_mix_2 rm2 (clk, rm, out);

endmodule

module cube_round_mix_1 (
	input clk,
	input [1023:0] in,
	output [1023:0] out
);

	reg [31:0] x0, x1, x2, x3, x4, x5, x6, x7;
	reg [31:0] x8, x9, xa, xb, xc, xd, xe, xf;
	reg [31:0] xg, xh, xi, xj, xk, xl, xm, xn;
	reg [31:0] xo, xp, xq, xr, xs, xt, xu, xv;
	
	assign out = { x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, xa, xb, xc, xd, xe, xf, xg, xh, xi, xj, xk, xl, xm, xn, xo, xp, xq, xr, xs, xt, xu, xv };

	always @ (posedge clk) begin
	
		{ x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, xa, xb, xc, xd, xe, xf, xg, xh, xi, xj, xk, xl, xm, xn, xo, xp, xq, xr, xs, xt, xu, xv } = in;

		xg = x0 + xg;
		x0 = { x0[24:0], x0[31:25] };
		xh = x1 + xh;
		x1 = { x1[24:0], x1[31:25] };
		xi = x2 + xi;
		x2 = { x2[24:0], x2[31:25] };
		xj = x3 + xj;
		x3 = { x3[24:0], x3[31:25] };
		xk = x4 + xk;
		x4 = { x4[24:0], x4[31:25] };
		xl = x5 + xl;
		x5 = { x5[24:0], x5[31:25] };
		xm = x6 + xm;
		x6 = { x6[24:0], x6[31:25] };
		xn = x7 + xn;
		x7 = { x7[24:0], x7[31:25] };
		xo = x8 + xo;
		x8 = { x8[24:0], x8[31:25] };
		xp = x9 + xp;
		x9 = { x9[24:0], x9[31:25] };
		xq = xa + xq;
		xa = { xa[24:0], xa[31:25] };
		xr = xb + xr;
		xb = { xb[24:0], xb[31:25] };
		xs = xc + xs;
		xc = { xc[24:0], xc[31:25] };
		xt = xd + xt;
		xd = { xd[24:0], xd[31:25] };
		xu = xe + xu;
		xe = { xe[24:0], xe[31:25] };
		xv = xf + xv;
		xf = { xf[24:0], xf[31:25] };
		x8 = x8 ^ xg;
		x9 = x9 ^ xh;
		xa = xa ^ xi;
		xb = xb ^ xj;
		xc = xc ^ xk;
		xd = xd ^ xl;
		xe = xe ^ xm;
		xf = xf ^ xn;
		x0 = x0 ^ xo;
		x1 = x1 ^ xp;
		x2 = x2 ^ xq;
		x3 = x3 ^ xr;
		x4 = x4 ^ xs;
		x5 = x5 ^ xt;
		x6 = x6 ^ xu;
		x7 = x7 ^ xv;
		xi = x8 + xi;
		x8 = { x8[20:0], x8[31:21] };
		xj = x9 + xj;
		x9 = { x9[20:0], x9[31:21] };
		xg = xa + xg;
		xa = { xa[20:0], xa[31:21] };
		xh = xb + xh;
		xb = { xb[20:0], xb[31:21] };
		xm = xc + xm;
		xc = { xc[20:0], xc[31:21] };
		xn = xd + xn;
		xd = { xd[20:0], xd[31:21] };
		xk = xe + xk;
		xe = { xe[20:0], xe[31:21] };
		xl = xf + xl;
		xf = { xf[20:0], xf[31:21] };
		xq = x0 + xq;
		x0 = { x0[20:0], x0[31:21] };
		xr = x1 + xr;
		x1 = { x1[20:0], x1[31:21] };
		xo = x2 + xo;
		x2 = { x2[20:0], x2[31:21] };
		xp = x3 + xp;
		x3 = { x3[20:0], x3[31:21] };
		xu = x4 + xu;
		x4 = { x4[20:0], x4[31:21] };
		xv = x5 + xv;
		x5 = { x5[20:0], x5[31:21] };
		xs = x6 + xs;
		x6 = { x6[20:0], x6[31:21] };
		xt = x7 + xt;
		x7 = { x7[20:0], x7[31:21] };
		xc = xc ^ xi;
		xd = xd ^ xj;
		xe = xe ^ xg;
		xf = xf ^ xh;
		x8 = x8 ^ xm;
		x9 = x9 ^ xn;
		xa = xa ^ xk;
		xb = xb ^ xl;
		x4 = x4 ^ xq;
		x5 = x5 ^ xr;
		x6 = x6 ^ xo;
		x7 = x7 ^ xp;
		x0 = x0 ^ xu;
		x1 = x1 ^ xv;
		x2 = x2 ^ xs;
		x3 = x3 ^ xt;

	end
	
endmodule

module cube_round_mix_2 (
	input clk,
	input [1023:0] in,
	output [1023:0] out
);

	reg [31:0] x0, x1, x2, x3, x4, x5, x6, x7;
	reg [31:0] x8, x9, xa, xb, xc, xd, xe, xf;
	reg [31:0] xg, xh, xi, xj, xk, xl, xm, xn;
	reg [31:0] xo, xp, xq, xr, xs, xt, xu, xv;
	
	assign out = { x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, xa, xb, xc, xd, xe, xf, xg, xh, xi, xj, xk, xl, xm, xn, xo, xp, xq, xr, xs, xt, xu, xv };

	always @ (posedge clk) begin
	
		{ x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, xa, xb, xc, xd, xe, xf, xg, xh, xi, xj, xk, xl, xm, xn, xo, xp, xq, xr, xs, xt, xu, xv } = in;

		xj = xc + xj;
		xc = { xc[24:0], xc[31:25] };
		xi = xd + xi;
		xd = { xd[24:0], xd[31:25] };
		xh = xe + xh;
		xe = { xe[24:0], xe[31:25] };
		xg = xf + xg;
		xf = { xf[24:0], xf[31:25] };
		xn = x8 + xn;
		x8 = { x8[24:0], x8[31:25] };
		xm = x9 + xm;
		x9 = { x9[24:0], x9[31:25] };
		xl = xa + xl;
		xa = { xa[24:0], xa[31:25] };
		xk = xb + xk;
		xb = { xb[24:0], xb[31:25] };
		xr = x4 + xr;
		x4 = { x4[24:0], x4[31:25] };
		xq = x5 + xq;
		x5 = { x5[24:0], x5[31:25] };
		xp = x6 + xp;
		x6 = { x6[24:0], x6[31:25] };
		xo = x7 + xo;
		x7 = { x7[24:0], x7[31:25] };
		xv = x0 + xv;
		x0 = { x0[24:0], x0[31:25] };
		xu = x1 + xu;
		x1 = { x1[24:0], x1[31:25] };
		xt = x2 + xt;
		x2 = { x2[24:0], x2[31:25] };
		xs = x3 + xs;
		x3 = { x3[24:0], x3[31:25] };
		x4 = x4 ^ xj;
		x5 = x5 ^ xi;
		x6 = x6 ^ xh;
		x7 = x7 ^ xg;
		x0 = x0 ^ xn;
		x1 = x1 ^ xm;
		x2 = x2 ^ xl;
		x3 = x3 ^ xk;
		xc = xc ^ xr;
		xd = xd ^ xq;
		xe = xe ^ xp;
		xf = xf ^ xo;
		x8 = x8 ^ xv;
		x9 = x9 ^ xu;
		xa = xa ^ xt;
		xb = xb ^ xs;
		xh = x4 + xh;
		x4 = { x4[20:0], x4[31:21] };
		xg = x5 + xg;
		x5 = { x5[20:0], x5[31:21] };
		xj = x6 + xj;
		x6 = { x6[20:0], x6[31:21] };
		xi = x7 + xi;
		x7 = { x7[20:0], x7[31:21] };
		xl = x0 + xl;
		x0 = { x0[20:0], x0[31:21] };
		xk = x1 + xk;
		x1 = { x1[20:0], x1[31:21] };
		xn = x2 + xn;
		x2 = { x2[20:0], x2[31:21] };
		xm = x3 + xm;
		x3 = { x3[20:0], x3[31:21] };
		xp = xc + xp;
		xc = { xc[20:0], xc[31:21] };
		xo = xd + xo;
		xd = { xd[20:0], xd[31:21] };
		xr = xe + xr;
		xe = { xe[20:0], xe[31:21] };
		xq = xf + xq;
		xf = { xf[20:0], xf[31:21] };
		xt = x8 + xt;
		x8 = { x8[20:0], x8[31:21] };
		xs = x9 + xs;
		x9 = { x9[20:0], x9[31:21] };
		xv = xa + xv;
		xa = { xa[20:0], xa[31:21] };
		xu = xb + xu;
		xb = { xb[20:0], xb[31:21] };
		x0 = x0 ^ xh;
		x1 = x1 ^ xg;
		x2 = x2 ^ xj;
		x3 = x3 ^ xi;
		x4 = x4 ^ xl;
		x5 = x5 ^ xk;
		x6 = x6 ^ xn;
		x7 = x7 ^ xm;
		x8 = x8 ^ xp;
		x9 = x9 ^ xo;
		xa = xa ^ xr;
		xb = xb ^ xq;
		xc = xc ^ xt;
		xd = xd ^ xs;
		xe = xe ^ xv;
		xf = xf ^ xu;

	end
	
endmodule
