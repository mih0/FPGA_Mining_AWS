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

module echo512 (
	input clk,
	input [511:0] data,
	output [31:0] hash
);

	reg phase = 1'b0;
	
	reg [31:0] h;
	assign hash = h;

	wire [511:0] msg_le;

	genvar j;
	generate
		for( j=0; j < 64 ; j = j + 1) begin: MSG_REVERSE
			assign msg_le[j*8 +: 8] = data[(63-j)*8 +: 8];
		end
	endgenerate

	reg [3:0] round0,round1,round2,round3,round4;

	reg [31:0] m00,m01,m02,m03,m04,m05,m06,m07,m08,m09;
	reg [31:0] m10,m11,m12,m13,m14,m15,m16,m17,m18,m19;
	reg [31:0] m20,m21,m22,m23,m24,m25,m26,m27,m28,m29;
	reg [31:0] m30,m31,m32,m33,m34,m35,m36,m37,m38,m39;
	reg [31:0] m40,m41,m42,m43,m44,m45,m46,m47,m48,m49;
	reg [31:0] m50,m51,m52,m53,m54,m55,m56,m57,m58,m59;
	reg [31:0] m60,m61,m62,m63,m64,m65,m66,m67,m68,m69;
	reg [31:0] m70,m71,m72,m73,m74,m75,m76,m77,m78,m79,m;
	
	reg [511:0] w00, w01, w02, w03;
	reg [511:0] w10, w11, w12, w13;
	reg [511:0] w20, w21, w22, w23;
	reg [511:0] w30, w31, w32, w33;
	reg [511:0] w40, w41, w42, w43;
	reg [511:0] r40x, r41x, r42x, r43x;
	
	wire [511:0] r00, r01, r02, r03;
	wire [511:0] r10, r11, r12, r13;
	wire [511:0] r20, r21, r22, r23;
	wire [511:0] r30, r31, r32, r33;
	wire [511:0] r40, r41, r42, r43;

	echo_round_4x er00 (clk, w00, round0, 4'h0, 4'h5, 4'hA, 4'hF, r00);
	echo_round_4x er01 (clk, w01, round0, 4'h4, 4'h9, 4'hE, 4'h3, r01);
	echo_round_4x er02 (clk, w02, round0, 4'h8, 4'hD, 4'h2, 4'h7, r02);
	echo_round_4x er03 (clk, w03, round0, 4'hC, 4'h1, 4'h6, 4'hB, r03);

	echo_round_4x er10 (clk, w10, round1, 4'h0, 4'h5, 4'hA, 4'hF, r10);
	echo_round_4x er11 (clk, w11, round1, 4'h4, 4'h9, 4'hE, 4'h3, r11);
	echo_round_4x er12 (clk, w12, round1, 4'h8, 4'hD, 4'h2, 4'h7, r12);
	echo_round_4x er13 (clk, w13, round1, 4'hC, 4'h1, 4'h6, 4'hB, r13);

	echo_round_4x er20 (clk, w20, round2, 4'h0, 4'h5, 4'hA, 4'hF, r20);
	echo_round_4x er21 (clk, w21, round2, 4'h4, 4'h9, 4'hE, 4'h3, r21);
	echo_round_4x er22 (clk, w22, round2, 4'h8, 4'hD, 4'h2, 4'h7, r22);
	echo_round_4x er23 (clk, w23, round2, 4'hC, 4'h1, 4'h6, 4'hB, r23);

	echo_round_4x er30 (clk, w30, round3, 4'h0, 4'h5, 4'hA, 4'hF, r30);
	echo_round_4x er31 (clk, w31, round3, 4'h4, 4'h9, 4'hE, 4'h3, r31);
	echo_round_4x er32 (clk, w32, round3, 4'h8, 4'hD, 4'h2, 4'h7, r32);
	echo_round_4x er33 (clk, w33, round3, 4'hC, 4'h1, 4'h6, 4'hB, r33);

	echo_round_4x er40 (clk, w40, round4, 4'h0, 4'h5, 4'hA, 4'hF, r40);
	echo_round_4x er41 (clk, w41, round4, 4'h4, 4'h9, 4'hE, 4'h3, r41);
	echo_round_4x er42 (clk, w42, round4, 4'h8, 4'hD, 4'h2, 4'h7, r42);
	echo_round_4x er43 (clk, w43, round4, 4'hC, 4'h1, 4'h6, 4'hB, r43);

	always @ ( posedge clk ) begin

		if ( !phase ) begin

			round0 <= 4'd0; 
			round1 <= 4'd1; 
			round2 <= 4'd2; 
			round3 <= 4'd3; 
			round4 <= 4'd4; 

//			w00 <= { F, A, 5, 0 }; 
//			w01 <= { 3, E, 9, 4 }; 
//			w02 <= { 7, 2, D, 8 }; 
//			w03 <= { B, 6, 1, C }; 

			w00 <= {
				128'h00000200000000000000000000000000,
				msg_le[((2*4)+0)*32 +: 32],
				msg_le[((2*4)+1)*32 +: 32],
				msg_le[((2*4)+2)*32 +: 32],
				msg_le[((2*4)+3)*32 +: 32],
				128'h00000200000000000000000000000000,
				128'h00000200000000000000000000000000
			}; 
			w01 <= {
				128'h00000200000000000000000000000000,
				128'h00000000000000000000000002000000,
				msg_le[((1*4)+0)*32 +: 32],
				msg_le[((1*4)+1)*32 +: 32],
				msg_le[((1*4)+2)*32 +: 32],
				msg_le[((1*4)+3)*32 +: 32],
				128'h00000200000000000000000000000000
			}; 
			w02 <= {
				128'h00000200000000000000000000000000,
				128'h00000200000000000000000000000000,
				128'h00000000000000000000000000000000,
				msg_le[((0*4)+0)*32 +: 32],
				msg_le[((0*4)+1)*32 +: 32],
				msg_le[((0*4)+2)*32 +: 32],
				msg_le[((0*4)+3)*32 +: 32]
			}; 
			w03 <= {
				msg_le[((3*4)+0)*32 +: 32],
				msg_le[((3*4)+1)*32 +: 32],
				msg_le[((3*4)+2)*32 +: 32],
				msg_le[((3*4)+3)*32 +: 32],
				128'h00000200000000000000000000000000,
				128'h00000200000000000000000000000000,
				128'h00000080000000000000000000000000
			}; 
			
			r40x <= r40;
			r41x <= r41;
			r42x <= r42;
			r43x <= r43;

			m <= m79;
			m79 <= m78;
			m78 <= m77;
			m77 <= m76;
			m76 <= m75;
			m75 <= m74;
			m74 <= m73;
			m73 <= m72;
			m72 <= m71;
			m71 <= m70;
			m70 <= m69;
			m69 <= m68;
			m68 <= m67;
			m67 <= m66;
			m66 <= m65;
			m65 <= m64;
			m64 <= m63;
			m63 <= m62;
			m62 <= m61;
			m61 <= m60;
			m60 <= m59;
			m59 <= m58;
			m58 <= m57;
			m57 <= m56;
			m56 <= m55;
			m55 <= m54;
			m54 <= m53;
			m53 <= m52;
			m52 <= m51;
			m51 <= m50;
			m50 <= m49;
			m49 <= m48;
			m48 <= m47;
			m47 <= m46;
			m46 <= m45;
			m45 <= m44;
			m44 <= m43;
			m43 <= m42;
			m42 <= m41;
			m41 <= m40;
			m40 <= m39;
			m39 <= m38;
			m38 <= m37;
			m37 <= m36;
			m36 <= m35;
			m35 <= m34;
			m34 <= m33;
			m33 <= m32;
			m32 <= m31;
			m31 <= m30;
			m30 <= m29;
			m29 <= m28;
			m28 <= m27;
			m27 <= m26;
			m26 <= m25;
			m25 <= m24;
			m24 <= m23;
			m23 <= m22;
			m22 <= m21;
			m21 <= m20;
			m20 <= m19;
			m19 <= m18;
			m18 <= m17;
			m17 <= m16;
			m16 <= m15;
			m15 <= m14;
			m14 <= m13;
			m13 <= m12;
			m12 <= m11;
			m11 <= m10;
			m10 <= m09;
			m09 <= m08;
			m08 <= m07;
			m07 <= m06;
			m06 <= m05;
			m05 <= m04;
			m04 <= m03;
			m03 <= m02;
			m02 <= m01;
			m01 <= m00;
			m00 <= msg_le[255:224];

		end
		else begin

			round0 <= 4'd5; 
			round1 <= 4'd6; 
			round2 <= 4'd7; 
			round3 <= 4'd8; 
			round4 <= 4'd9; 

			w00 <= { r43x[511:384], r42x[383:256], r41x[255:128], r40x[127:0] };
			w01 <= { r40x[511:384], r43x[383:256], r42x[255:128], r41x[127:0] };
			w02 <= { r41x[511:384], r40x[383:256], r43x[255:128], r42x[127:0] };
			w03 <= { r42x[511:384], r41x[383:256], r40x[255:128], r43x[127:0] };

//			w00 <= { r43[511:384], r42[383:256], r41[255:128], r40[127:0] };
//			w01 <= { r40[511:384], r43[383:256], r42[255:128], r41[127:0] };
//			w02 <= { r41[511:384], r40[383:256], r43[255:128], r42[127:0] };
//			w03 <= { r42[511:384], r41[383:256], r40[255:128], r43[127:0] };

			h <= r40[(5 -1)*32 +: 32] ^ r42[(5 -1)*32 +: 32] ^ m;

		end

		w10 <= { r03[511:384], r02[383:256], r01[255:128], r00[127:0] };
		w11 <= { r00[511:384], r03[383:256], r02[255:128], r01[127:0] };
		w12 <= { r01[511:384], r00[383:256], r03[255:128], r02[127:0] };
		w13 <= { r02[511:384], r01[383:256], r00[255:128], r03[127:0] };

		w20 <= { r13[511:384], r12[383:256], r11[255:128], r10[127:0] };
		w21 <= { r10[511:384], r13[383:256], r12[255:128], r11[127:0] };
		w22 <= { r11[511:384], r10[383:256], r13[255:128], r12[127:0] };
		w23 <= { r12[511:384], r11[383:256], r10[255:128], r13[127:0] };

		w30 <= { r23[511:384], r22[383:256], r21[255:128], r20[127:0] };
		w31 <= { r20[511:384], r23[383:256], r22[255:128], r21[127:0] };
		w32 <= { r21[511:384], r20[383:256], r23[255:128], r22[127:0] };
		w33 <= { r22[511:384], r21[383:256], r20[255:128], r23[127:0] };

		w40 <= { r33[511:384], r32[383:256], r31[255:128], r30[127:0] };
		w41 <= { r30[511:384], r33[383:256], r32[255:128], r31[127:0] };
		w42 <= { r31[511:384], r30[383:256], r33[255:128], r32[127:0] };
		w43 <= { r32[511:384], r31[383:256], r30[255:128], r33[127:0] };
		
//		$finish;
		
		phase <= ~phase;

	end
			
endmodule

module echo_round_4x (
	input clk,
	input [511:0] in,
	input [3:0] round,
	input [3:0] key0,
	input [3:0] key1,
	input [3:0] key2,
	input [3:0] key3,
	output reg [511:0] out
);

	wire [127:0] a0, a1, a2, a3;
	wire [127:0] b0, b1, b2, b3;
	wire [511:0] o;

	reg [127:0] w0, w1, w2, w3;
	reg [127:0] r0, r1, r2, r3;

	aes_round r0a (clk, in[127:  0], a0);
	aes_round r1a (clk, in[255:128], a1);
	aes_round r2a (clk, in[383:256], a2);
	aes_round r3a (clk, in[511:384], a3);

	aes_round r0b (clk, w0, b0);
	aes_round r1b (clk, w1, b1);
	aes_round r2b (clk, w2, b2);
	aes_round r3b (clk, w3, b3);
	
	echo_mix mix (clk, r0, r1, r2, r3, o);

	always @ ( posedge clk ) begin

		w0 <= a0 ^ { 24'h000002, round, key0, 96'h000000000000000000000000 };
		w1 <= a1 ^ { 24'h000002, round, key1, 96'h000000000000000000000000 };
		w2 <= a2 ^ { 24'h000002, round, key2, 96'h000000000000000000000000 };
		w3 <= a3 ^ { 24'h000002, round, key3, 96'h000000000000000000000000 };
		
		r0 <= b0;
		r1 <= b1;
		r2 <= b2;
		r3 <= b3;

		out <= o;
		
	end

endmodule

module echo_mix (
	input clk,
	input [127:0] in0,
	input [127:0] in1,
	input [127:0] in2,
	input [127:0] in3,
	output reg [511:0] out
);

	reg [127:0] i0, i1, i2, i3;
	wire [127:0] o0, o1, o2, o3;
	
	echo_mix_columns emc0 (clk, i0, o0);
	echo_mix_columns emc1 (clk, i1, o1);
	echo_mix_columns emc2 (clk, i2, o2);
	echo_mix_columns emc3 (clk, i3, o3);

	always @ ( posedge clk ) begin

		i0 <= {
			in0[127:120], in1[127:120], in2[127:120], in3[127:120], 
			in0[119:112], in1[119:112], in2[119:112], in3[119:112], 
			in0[111:104], in1[111:104], in2[111:104], in3[111:104], 
			in0[103: 96], in1[103: 96], in2[103: 96], in3[103: 96] };

		i1 <= {
			in0[ 95: 88], in1[ 95: 88], in2[ 95: 88], in3[ 95: 88], 
			in0[ 87: 80], in1[ 87: 80], in2[ 87: 80], in3[ 87: 80], 
			in0[ 79: 72], in1[ 79: 72], in2[ 79: 72], in3[ 79: 72], 
			in0[ 71: 64], in1[ 71: 64], in2[ 71: 64], in3[ 71: 64] };

		i2 <= {
			in0[ 63: 56], in1[ 63: 56], in2[ 63: 56], in3[ 63: 56], 
			in0[ 55: 48], in1[ 55: 48], in2[ 55: 48], in3[ 55: 48], 
			in0[ 47: 40], in1[ 47: 40], in2[ 47: 40], in3[ 47: 40], 
			in0[ 39: 32], in1[ 39: 32], in2[ 39: 32], in3[ 39: 32] };

		i3 <= {
			in0[ 31: 24], in1[ 31: 24], in2[ 31: 24], in3[ 31: 24], 
			in0[ 23: 16], in1[ 23: 16], in2[ 23: 16], in3[ 23: 16], 
			in0[ 15:  8], in1[ 15:  8], in2[ 15:  8], in3[ 15:  8], 
			in0[  7:  0], in1[  7:  0], in2[  7:  0], in3[  7:  0] };

		out <= {
			o0[103: 96], o0[ 71: 64], o0[ 39: 32], o0[ 7: 0], 
			o1[103: 96], o1[ 71: 64], o1[ 39: 32], o1[ 7: 0], 
			o2[103: 96], o2[ 71: 64], o2[ 39: 32], o2[ 7: 0], 
			o3[103: 96], o3[ 71: 64], o3[ 39: 32], o3[ 7: 0], 

			o0[111:104], o0[ 79: 72], o0[ 47: 40], o0[ 15: 8], 
			o1[111:104], o1[ 79: 72], o1[ 47: 40], o1[ 15: 8], 
			o2[111:104], o2[ 79: 72], o2[ 47: 40], o2[ 15: 8], 
			o3[111:104], o3[ 79: 72], o3[ 47: 40], o3[ 15: 8], 

			o0[119:112], o0[ 87: 80], o0[ 55: 48], o0[ 23: 16], 
			o1[119:112], o1[ 87: 80], o1[ 55: 48], o1[ 23: 16], 
			o2[119:112], o2[ 87: 80], o2[ 55: 48], o2[ 23: 16], 
			o3[119:112], o3[ 87: 80], o3[ 55: 48], o3[ 23: 16], 

			o0[127:120], o0[ 95: 88], o0[ 63: 56], o0[ 31: 24], 
			o1[127:120], o1[ 95: 88], o1[ 63: 56], o1[ 31: 24], 
			o2[127:120], o2[ 95: 88], o2[ 63: 56], o2[ 31: 24], 
			o3[127:120], o3[ 95: 88], o3[ 63: 56], o3[ 31: 24]
		};

	end
	
endmodule

module echo_mix_columns (
	input clk,
	input [127:0] in,
	output reg [127:0] out
);

	wire [7:0] ax00, ax01, ax02, ax03;
	wire [7:0] ax10, ax11, ax12, ax13;
	wire [7:0] ax20, ax21, ax22, ax23;
	wire [7:0] ax30, ax31, ax32, ax33;

	assign { ax03, ax02, ax01, ax00 } = in[127:96];
	assign { ax13, ax12, ax11, ax10 } = in[ 95:64];
	assign { ax23, ax22, ax21, ax20 } = in[ 63:32];
	assign { ax33, ax32, ax31, ax30 } = in[ 31: 0];

	reg [7:0] a00, a01, a02, a03;
	reg [7:0] a10, a11, a12, a13;
	reg [7:0] a20, a21, a22, a23;
	reg [7:0] a30, a31, a32, a33;

	reg [7:0] b00, b01, b02, b03;
	reg [7:0] b10, b11, b12, b13;
	reg [7:0] b20, b21, b22, b23;
	reg [7:0] b30, b31, b32, b33;

	always @ ( posedge clk ) begin

		a00 <= ax00;
		a01 <= ax01;
		a02 <= ax02;
		a03 <= ax03;

		a10 <= ax10;
		a11 <= ax11;
		a12 <= ax12;
		a13 <= ax13;

		a20 <= ax20;
		a21 <= ax21;
		a22 <= ax22;
		a23 <= ax23;

		a30 <= ax30;
		a31 <= ax31;
		a32 <= ax32;
		a33 <= ax33;
		
		b00 <= ax00 ^ ax03;
		b01 <= ax01 ^ ax00;
		b02 <= ax02 ^ ax01;
		b03 <= ax03 ^ ax02;

		b10 <= ax10 ^ ax13;
		b11 <= ax11 ^ ax10;
		b12 <= ax12 ^ ax11;
		b13 <= ax13 ^ ax12;

		b20 <= ax20 ^ ax23;
		b21 <= ax21 ^ ax20;
		b22 <= ax22 ^ ax21;
		b23 <= ax23 ^ ax22;

		b30 <= ax30 ^ ax33;
		b31 <= ax31 ^ ax30;
		b32 <= ax32 ^ ax31;
		b33 <= ax33 ^ ax32;

	end
	
	always @ ( posedge clk ) begin

		out[127:96] <= {
			a02[7] ^ b01[7] ^ b03[6],          a02[6] ^ b01[6] ^ b03[5],
			a02[5] ^ b01[5] ^ b03[4],          a02[4] ^ b01[4] ^ b03[3] ^ b03[7],
			a02[3] ^ b01[3] ^ b03[2] ^ b03[7], a02[2] ^ b01[2] ^ b03[1],
			a02[1] ^ b01[1] ^ b03[0] ^ b03[7], a02[0] ^ b01[0] ^ b03[7],
			a03[7] ^ b01[7] ^ b02[6],          a03[6] ^ b01[6] ^ b02[5],
			a03[5] ^ b01[5] ^ b02[4],          a03[4] ^ b01[4] ^ b02[3] ^ b02[7],
			a03[3] ^ b01[3] ^ b02[2] ^ b02[7], a03[2] ^ b01[2] ^ b02[1],
			a03[1] ^ b01[1] ^ b02[0] ^ b02[7], a03[0] ^ b01[0] ^ b02[7],
			a00[7] ^ b03[7] ^ b01[6],          a00[6] ^ b03[6] ^ b01[5],
			a00[5] ^ b03[5] ^ b01[4],          a00[4] ^ b03[4] ^ b01[3] ^ b01[7],
			a00[3] ^ b03[3] ^ b01[2] ^ b01[7], a00[2] ^ b03[2] ^ b01[1],
			a00[1] ^ b03[1] ^ b01[0] ^ b01[7], a00[0] ^ b03[0] ^ b01[7],
			a01[7] ^ b03[7] ^ b00[6],          a01[6] ^ b03[6] ^ b00[5],
			a01[5] ^ b03[5] ^ b00[4],          a01[4] ^ b03[4] ^ b00[3] ^ b00[7],
			a01[3] ^ b03[3] ^ b00[2] ^ b00[7], a01[2] ^ b03[2] ^ b00[1],
			a01[1] ^ b03[1] ^ b00[0] ^ b00[7], a01[0] ^ b03[0] ^ b00[7]
		};

		out[95:64] <= {
			a12[7] ^ b11[7] ^ b13[6],          a12[6] ^ b11[6] ^ b13[5],
			a12[5] ^ b11[5] ^ b13[4],          a12[4] ^ b11[4] ^ b13[3] ^ b13[7],
			a12[3] ^ b11[3] ^ b13[2] ^ b13[7], a12[2] ^ b11[2] ^ b13[1],
			a12[1] ^ b11[1] ^ b13[0] ^ b13[7], a12[0] ^ b11[0] ^ b13[7],
			a13[7] ^ b11[7] ^ b12[6],          a13[6] ^ b11[6] ^ b12[5],
			a13[5] ^ b11[5] ^ b12[4],          a13[4] ^ b11[4] ^ b12[3] ^ b12[7],
			a13[3] ^ b11[3] ^ b12[2] ^ b12[7], a13[2] ^ b11[2] ^ b12[1],
			a13[1] ^ b11[1] ^ b12[0] ^ b12[7], a13[0] ^ b11[0] ^ b12[7],
			a10[7] ^ b13[7] ^ b11[6],          a10[6] ^ b13[6] ^ b11[5],
			a10[5] ^ b13[5] ^ b11[4],          a10[4] ^ b13[4] ^ b11[3] ^ b11[7],
			a10[3] ^ b13[3] ^ b11[2] ^ b11[7], a10[2] ^ b13[2] ^ b11[1],
			a10[1] ^ b13[1] ^ b11[0] ^ b11[7], a10[0] ^ b13[0] ^ b11[7],
			a11[7] ^ b13[7] ^ b10[6],          a11[6] ^ b13[6] ^ b10[5],
			a11[5] ^ b13[5] ^ b10[4],          a11[4] ^ b13[4] ^ b10[3] ^ b10[7],
			a11[3] ^ b13[3] ^ b10[2] ^ b10[7], a11[2] ^ b13[2] ^ b10[1],
			a11[1] ^ b13[1] ^ b10[0] ^ b10[7], a11[0] ^ b13[0] ^ b10[7]
		};

		out[63:32] <= {
			a22[7] ^ b21[7] ^ b23[6],          a22[6] ^ b21[6] ^ b23[5],
			a22[5] ^ b21[5] ^ b23[4],          a22[4] ^ b21[4] ^ b23[3] ^ b23[7],
			a22[3] ^ b21[3] ^ b23[2] ^ b23[7], a22[2] ^ b21[2] ^ b23[1],
			a22[1] ^ b21[1] ^ b23[0] ^ b23[7], a22[0] ^ b21[0] ^ b23[7],
			a23[7] ^ b21[7] ^ b22[6],          a23[6] ^ b21[6] ^ b22[5],
			a23[5] ^ b21[5] ^ b22[4],          a23[4] ^ b21[4] ^ b22[3] ^ b22[7],
			a23[3] ^ b21[3] ^ b22[2] ^ b22[7], a23[2] ^ b21[2] ^ b22[1],
			a23[1] ^ b21[1] ^ b22[0] ^ b22[7], a23[0] ^ b21[0] ^ b22[7],
			a20[7] ^ b23[7] ^ b21[6],          a20[6] ^ b23[6] ^ b21[5],
			a20[5] ^ b23[5] ^ b21[4],          a20[4] ^ b23[4] ^ b21[3] ^ b21[7],
			a20[3] ^ b23[3] ^ b21[2] ^ b21[7], a20[2] ^ b23[2] ^ b21[1],
			a20[1] ^ b23[1] ^ b21[0] ^ b21[7], a20[0] ^ b23[0] ^ b21[7],
			a21[7] ^ b23[7] ^ b20[6],          a21[6] ^ b23[6] ^ b20[5],
			a21[5] ^ b23[5] ^ b20[4],          a21[4] ^ b23[4] ^ b20[3] ^ b20[7],
			a21[3] ^ b23[3] ^ b20[2] ^ b20[7], a21[2] ^ b23[2] ^ b20[1],
			a21[1] ^ b23[1] ^ b20[0] ^ b20[7], a21[0] ^ b23[0] ^ b20[7]
		};

		out[31:0] <= {
			a32[7] ^ b31[7] ^ b33[6],          a32[6] ^ b31[6] ^ b33[5],
			a32[5] ^ b31[5] ^ b33[4],          a32[4] ^ b31[4] ^ b33[3] ^ b33[7],
			a32[3] ^ b31[3] ^ b33[2] ^ b33[7], a32[2] ^ b31[2] ^ b33[1],
			a32[1] ^ b31[1] ^ b33[0] ^ b33[7], a32[0] ^ b31[0] ^ b33[7],
			a33[7] ^ b31[7] ^ b32[6],          a33[6] ^ b31[6] ^ b32[5],
			a33[5] ^ b31[5] ^ b32[4],          a33[4] ^ b31[4] ^ b32[3] ^ b32[7],
			a33[3] ^ b31[3] ^ b32[2] ^ b32[7], a33[2] ^ b31[2] ^ b32[1],
			a33[1] ^ b31[1] ^ b32[0] ^ b32[7], a33[0] ^ b31[0] ^ b32[7],
			a30[7] ^ b33[7] ^ b31[6],          a30[6] ^ b33[6] ^ b31[5],
			a30[5] ^ b33[5] ^ b31[4],          a30[4] ^ b33[4] ^ b31[3] ^ b31[7],
			a30[3] ^ b33[3] ^ b31[2] ^ b31[7], a30[2] ^ b33[2] ^ b31[1],
			a30[1] ^ b33[1] ^ b31[0] ^ b31[7], a30[0] ^ b33[0] ^ b31[7],
			a31[7] ^ b33[7] ^ b30[6],          a31[6] ^ b33[6] ^ b30[5],
			a31[5] ^ b33[5] ^ b30[4],          a31[4] ^ b33[4] ^ b30[3] ^ b30[7],
			a31[3] ^ b33[3] ^ b30[2] ^ b30[7], a31[2] ^ b33[2] ^ b30[1],
			a31[1] ^ b33[1] ^ b30[0] ^ b30[7], a31[0] ^ b33[0] ^ b30[7]
		};

	end
	
endmodule

module aes_round(
	input clk,
	input [127:0] in,
	output reg [127:0] out
);

	wire [7:0] s_box [0:255] = {
		8'h63, 8'h7C, 8'h77, 8'h7B, 8'hF2, 8'h6B, 8'h6F, 8'hC5, 8'h30, 8'h01, 8'h67, 8'h2B, 8'hFE, 8'hD7, 8'hAB, 8'h76, 
		8'hCA, 8'h82, 8'hC9, 8'h7D, 8'hFA, 8'h59, 8'h47, 8'hF0, 8'hAD, 8'hD4, 8'hA2, 8'hAF, 8'h9C, 8'hA4, 8'h72, 8'hC0, 
		8'hB7, 8'hFD, 8'h93, 8'h26, 8'h36, 8'h3F, 8'hF7, 8'hCC, 8'h34, 8'hA5, 8'hE5, 8'hF1, 8'h71, 8'hD8, 8'h31, 8'h15, 
		8'h04, 8'hC7, 8'h23, 8'hC3, 8'h18, 8'h96, 8'h05, 8'h9A, 8'h07, 8'h12, 8'h80, 8'hE2, 8'hEB, 8'h27, 8'hB2, 8'h75, 
		8'h09, 8'h83, 8'h2C, 8'h1A, 8'h1B, 8'h6E, 8'h5A, 8'hA0, 8'h52, 8'h3B, 8'hD6, 8'hB3, 8'h29, 8'hE3, 8'h2F, 8'h84, 
		8'h53, 8'hD1, 8'h00, 8'hED, 8'h20, 8'hFC, 8'hB1, 8'h5B, 8'h6A, 8'hCB, 8'hBE, 8'h39, 8'h4A, 8'h4C, 8'h58, 8'hCF, 
		8'hD0, 8'hEF, 8'hAA, 8'hFB, 8'h43, 8'h4D, 8'h33, 8'h85, 8'h45, 8'hF9, 8'h02, 8'h7F, 8'h50, 8'h3C, 8'h9F, 8'hA8, 
		8'h51, 8'hA3, 8'h40, 8'h8F, 8'h92, 8'h9D, 8'h38, 8'hF5, 8'hBC, 8'hB6, 8'hDA, 8'h21, 8'h10, 8'hFF, 8'hF3, 8'hD2, 
		8'hCD, 8'h0C, 8'h13, 8'hEC, 8'h5F, 8'h97, 8'h44, 8'h17, 8'hC4, 8'hA7, 8'h7E, 8'h3D, 8'h64, 8'h5D, 8'h19, 8'h73, 
		8'h60, 8'h81, 8'h4F, 8'hDC, 8'h22, 8'h2A, 8'h90, 8'h88, 8'h46, 8'hEE, 8'hB8, 8'h14, 8'hDE, 8'h5E, 8'h0B, 8'hDB, 
		8'hE0, 8'h32, 8'h3A, 8'h0A, 8'h49, 8'h06, 8'h24, 8'h5C, 8'hC2, 8'hD3, 8'hAC, 8'h62, 8'h91, 8'h95, 8'hE4, 8'h79, 
		8'hE7, 8'hC8, 8'h37, 8'h6D, 8'h8D, 8'hD5, 8'h4E, 8'hA9, 8'h6C, 8'h56, 8'hF4, 8'hEA, 8'h65, 8'h7A, 8'hAE, 8'h08, 
		8'hBA, 8'h78, 8'h25, 8'h2E, 8'h1C, 8'hA6, 8'hB4, 8'hC6, 8'hE8, 8'hDD, 8'h74, 8'h1F, 8'h4B, 8'hBD, 8'h8B, 8'h8A, 
		8'h70, 8'h3E, 8'hB5, 8'h66, 8'h48, 8'h03, 8'hF6, 8'h0E, 8'h61, 8'h35, 8'h57, 8'hB9, 8'h86, 8'hC1, 8'h1D, 8'h9E, 
		8'hE1, 8'hF8, 8'h98, 8'h11, 8'h69, 8'hD9, 8'h8E, 8'h94, 8'h9B, 8'h1E, 8'h87, 8'hE9, 8'hCE, 8'h55, 8'h28, 8'hDF, 
		8'h8C, 8'hA1, 8'h89, 8'h0D, 8'hBF, 8'hE6, 8'h42, 8'h68, 8'h41, 8'h99, 8'h2D, 8'h0F, 8'hB0, 8'h54, 8'hBB, 8'h16
	};

	reg[7:0] sb0,sb1,sb2,sb3,sb4,sb5,sb6,sb7,sb8,sb9,sbA,sbB,sbC,sbD,sbE,sbF;
	reg[7:0] g1_0,g1_1,g1_2,g1_3,g1_4,g1_5,g1_6,g1_7,g1_8,g1_9,g1_A,g1_B,g1_C,g1_D,g1_E,g1_F;
	reg[7:0] g2_0,g2_1,g2_2,g2_3,g2_4,g2_5,g2_6,g2_7,g2_8,g2_9,g2_A,g2_B,g2_C,g2_D,g2_E,g2_F;
	reg[7:0] g3_0,g3_1,g3_2,g3_3,g3_4,g3_5,g3_6,g3_7,g3_8,g3_9,g3_A,g3_B,g3_C,g3_D,g3_E,g3_F;
	reg [127:0] out1;
			
	always @ ( posedge clk ) begin

		sbF <= s_box[in[63:56]];
		sbE <= s_box[in[95:88]];
		sbD <= s_box[in[127:120]];
		sbC <= s_box[in[31:24]];
		sbB <= s_box[in[87:80]];
		sbA <= s_box[in[119:112]];
		sb9 <= s_box[in[23:16]];
		sb8 <= s_box[in[55:48]];
		sb7 <= s_box[in[111:104]];
		sb6 <= s_box[in[15:8]];
		sb5 <= s_box[in[47:40]];
		sb4 <= s_box[in[79:72]];
		sb3 <= s_box[in[7:0]];
		sb2 <= s_box[in[39:32]];
		sb1 <= s_box[in[71:64]];
		sb0 <= s_box[in[103:96]];

	end
	
	always @ ( posedge clk ) begin

		g1_0 <= sb0;
		g1_1 <= sb1;
		g1_2 <= sb2;
		g1_3 <= sb3;
		g1_4 <= sb4;
		g1_5 <= sb5;
		g1_6 <= sb6;
		g1_7 <= sb7;
		g1_8 <= sb8;
		g1_9 <= sb9;
		g1_A <= sbA;
		g1_B <= sbB;
		g1_C <= sbC;
		g1_D <= sbD;
		g1_E <= sbE;
		g1_F <= sbF;

		g2_0 <= gf_2(sb0);
		g2_1 <= gf_2(sb1);
		g2_2 <= gf_2(sb2);
		g2_3 <= gf_2(sb3);
		g2_4 <= gf_2(sb4);
		g2_5 <= gf_2(sb5);
		g2_6 <= gf_2(sb6);
		g2_7 <= gf_2(sb7);
		g2_8 <= gf_2(sb8);
		g2_9 <= gf_2(sb9);
		g2_A <= gf_2(sbA);
		g2_B <= gf_2(sbB);
		g2_C <= gf_2(sbC);
		g2_D <= gf_2(sbD);
		g2_E <= gf_2(sbE);
		g2_F <= gf_2(sbF);

		g3_0 <= gf_3(sb0);
		g3_1 <= gf_3(sb1);
		g3_2 <= gf_3(sb2);
		g3_3 <= gf_3(sb3);
		g3_4 <= gf_3(sb4);
		g3_5 <= gf_3(sb5);
		g3_6 <= gf_3(sb6);
		g3_7 <= gf_3(sb7);
		g3_8 <= gf_3(sb8);
		g3_9 <= gf_3(sb9);
		g3_A <= gf_3(sbA);
		g3_B <= gf_3(sbB);
		g3_C <= gf_3(sbC);
		g3_D <= gf_3(sbD);
		g3_E <= gf_3(sbE);
		g3_F <= gf_3(sbF);

	end

	always @ ( posedge clk ) begin
		out <= out1;
		out1 <= {
			g2_C ^ g3_0 ^ g1_4 ^ g1_8,
			g2_8 ^ g3_C ^ g1_0 ^ g1_4,
			g2_4 ^ g3_8 ^ g1_C ^ g1_0,
			g2_0 ^ g3_4 ^ g1_8 ^ g1_C,
			g2_D ^ g3_1 ^ g1_5 ^ g1_9,
			g2_9 ^ g3_D ^ g1_1 ^ g1_5,
			g2_5 ^ g3_9 ^ g1_D ^ g1_1,
			g2_1 ^ g3_5 ^ g1_9 ^ g1_D,
			g2_E ^ g3_2 ^ g1_6 ^ g1_A,
			g2_A ^ g3_E ^ g1_2 ^ g1_6,
			g2_6 ^ g3_A ^ g1_E ^ g1_2,
			g2_2 ^ g3_6 ^ g1_A ^ g1_E,
			g2_F ^ g3_3 ^ g1_7 ^ g1_B,
			g2_B ^ g3_F ^ g1_3 ^ g1_7,
			g2_7 ^ g3_B ^ g1_F ^ g1_3,
			g2_3 ^ g3_7 ^ g1_B ^ g1_F
		};
			
	end
			
	// Calculate GF(256) Multiplication (x2)
	function [7:0] gf_2;
		input [7:0] n;
		begin
			gf_2 = {n[6],n[5],n[4],n[3]^n[7],n[2]^n[7],n[1],n[0]^n[7],n[7]};
		end
	endfunction

	// Calculate GF(256) Multiplication (x3)
	function [7:0] gf_3;
		input [7:0] n;
		begin
			gf_3 = {n[6]^n[7],n[5]^n[6],n[4]^n[5],n[3]^n[7]^n[4],n[2]^n[7]^n[3],n[1]^n[2],n[0]^n[7]^n[1],n[7]^n[0]};
		end
	endfunction
	
endmodule
