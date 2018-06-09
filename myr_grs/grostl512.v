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

module grostl512 (
	input clk,
	input [607:0] block,
	input [31:0] nonce,
	output [511:0] hash
);

	reg [511:0] hash_d, hash_q;
	assign hash = hash_q;
	
	reg [1023:0] p_d, p_q;
	reg [1023:0] q_d, q_q;
	reg [1023:0] f_d, f_q;

	reg [1023:0] s00_d, s00_q;
	reg [1023:0] s01_d, s01_q;
	reg [1023:0] s02_d, s02_q;
	reg [1023:0] s03_d, s03_q;
	reg [1023:0] s04_d, s04_q;
	reg [1023:0] s05_d, s05_q;
	reg [1023:0] s06_d, s06_q;
	reg [1023:0] s07_d, s07_q;
	reg [1023:0] s08_d, s08_q;
	reg [1023:0] s09_d, s09_q;
	reg [1023:0] s10_d, s10_q;
	reg [1023:0] s11_d, s11_q;
	reg [1023:0] s12_d, s12_q;
	reg [1023:0] s13_d, s13_q;
	reg [1023:0] s14_d, s14_q;
	reg [1023:0] s15_d, s15_q;
	reg [1023:0] s16_d, s16_q;
	reg [1023:0] s17_d, s17_q;
	reg [1023:0] s18_d, s18_q;
	reg [1023:0] s19_d, s19_q;
	reg [1023:0] s20_d, s20_q;
	reg [1023:0] s21_d, s21_q;
	reg [1023:0] s22_d, s22_q;
	reg [1023:0] s23_d, s23_q;
	reg [1023:0] s24_d, s24_q;
	reg [1023:0] s25_d, s25_q;
	reg [1023:0] s26_d, s26_q;
	reg [1023:0] s27_d, s27_q;
	reg [1023:0] s28_d, s28_q;
	reg [1023:0] s29_d, s29_q;
	reg [1023:0] s30_d, s30_q;
	reg [1023:0] s31_d, s31_q;
	reg [1023:0] s32_d, s32_q;
	reg [1023:0] s33_d, s33_q;
	reg [1023:0] s34_d, s34_q;
	reg [1023:0] s35_d, s35_q;
	reg [1023:0] s36_d, s36_q;
	reg [1023:0] s37_d, s37_q;
	reg [1023:0] s38_d, s38_q;
	reg [1023:0] s39_d, s39_q;
	reg [1023:0] s40_d, s40_q;
	reg [1023:0] s41_d, s41_q;

	wire [1023:0] p00,p01,p02,p03,p04,p05,p06,p07,p08,p09,p10,p11,p12,p13;
	wire [1023:0] q00,q01,q02,q03,q04,q05,q06,q07,q08,q09,q10,q11,q12,q13;
	wire [1023:0] f00,f01,f02,f03,f04,f05,f06,f07,f08,f09,f10,f11,f12,f13;

	reg [1023:0] p00_d,p01_d,p02_d,p03_d,p04_d,p05_d,p06_d,p07_d,p08_d,p09_d,p10_d,p11_d,p12_d;
	reg [1023:0] p00_q,p01_q,p02_q,p03_q,p04_q,p05_q,p06_q,p07_q,p08_q,p09_q,p10_q,p11_q,p12_q;

	reg [1023:0] q00_d,q01_d,q02_d,q03_d,q04_d,q05_d,q06_d,q07_d,q08_d,q09_d,q10_d,q11_d,q12_d;
	reg [1023:0] q00_q,q01_q,q02_q,q03_q,q04_q,q05_q,q06_q,q07_q,q08_q,q09_q,q10_q,q11_q,q12_q;

	reg [1023:0] f00_d,f01_d,f02_d,f03_d,f04_d,f05_d,f06_d,f07_d,f08_d,f09_d,f10_d,f11_d,f12_d;
	reg [1023:0] f00_q,f01_q,f02_q,f03_q,f04_q,f05_q,f06_q,f07_q,f08_q,f09_q,f10_q,f11_q,f12_q;

	reg reset_d, reset_q;

	// Round 0
	permutation_p p_0 (clk, 4'd0, p_q, p00);
	permutation_q q_0 (clk, 4'd0, q_q, q00);
	permutation_p f_0 (clk, 4'd0, f_q, f00);

	// Round 1
	permutation_p p_1 (clk, 4'd1, p00_q, p01);
	permutation_q q_1 (clk, 4'd1, q00_q, q01);
	permutation_p f_1 (clk, 4'd1, f00_q, f01);

	// Round 2
	permutation_p p_2 (clk, 4'd2, p01_q, p02);
	permutation_q q_2 (clk, 4'd2, q01_q, q02);
	permutation_p f_2 (clk, 4'd2, f01_q, f02);

	// Round 3
	permutation_p p_3 (clk, 4'd3, p02_q, p03);
	permutation_q q_3 (clk, 4'd3, q02_q, q03);
	permutation_p f_3 (clk, 4'd3, f02_q, f03);

	// Round 4
	permutation_p p_4 (clk, 4'd4, p03_q, p04);
	permutation_q q_4 (clk, 4'd4, q03_q, q04);
	permutation_p f_4 (clk, 4'd4, f03_q, f04);

	// Round 5
	permutation_p p_5 (clk, 4'd5, p04_q, p05);
	permutation_q q_5 (clk, 4'd5, q04_q, q05);
	permutation_p f_5 (clk, 4'd5, f04_q, f05);

	// Round 6
	permutation_p p_6 (clk, 4'd6, p05_q, p06);
	permutation_q q_6 (clk, 4'd6, q05_q, q06);
	permutation_p f_6 (clk, 4'd6, f05_q, f06);

	// Round 7
	permutation_p p_7 (clk, 4'd7, p06_q, p07);
	permutation_q q_7 (clk, 4'd7, q06_q, q07);
	permutation_p f_7 (clk, 4'd7, f06_q, f07);

	// Round 8
	permutation_p p_8 (clk, 4'd8, p07_q, p08);
	permutation_q q_8 (clk, 4'd8, q07_q, q08);
	permutation_p f_8 (clk, 4'd8, f07_q, f08);

	// Round 9
	permutation_p p_9 (clk, 4'd9, p08_q, p09);
	permutation_q q_9 (clk, 4'd9, q08_q, q09);
	permutation_p f_9 (clk, 4'd9, f08_q, f09);

	// Round 10
	permutation_p p_10 (clk, 4'd10, p09_q, p10);
	permutation_q q_10 (clk, 4'd10, q09_q, q10);
	permutation_p f_10 (clk, 4'd10, f09_q, f10);

	// Round 11
	permutation_p p_11 (clk, 4'd11, p10_q, p11);
	permutation_q q_11 (clk, 4'd11, q10_q, q11);
	permutation_p f_11 (clk, 4'd11, f10_q, f11);

	// Round 12
	permutation_p p_12 (clk, 4'd12, p11_q, p12);
	permutation_q q_12 (clk, 4'd12, q11_q, q12);
	permutation_p f_12 (clk, 4'd12, f11_q, f12);

	// Round 13
	permutation_p p_13 (clk, 4'd13, p12_q, p13);
	permutation_q q_13 (clk, 4'd13, q12_q, q13);
	permutation_p f_13 (clk, 4'd13, f12_q, f13);

	always @ (*) begin

		hash_d <= s41_q[511:0] ^ f13[511:0];

		f_d <= { p13[1023:16] ^ q13[1023:16], p13[15:0] ^ q13[15:0] ^ 16'h0200 };
		p_d <= { block, nonce, 8'h80, 360'd0, 16'h0201 };
		q_d <= { block, nonce, 8'h80, 360'd0, 16'h0001 };

		s00_d <= { p13[1023:16] ^ q13[1023:16], p13[15:0] ^ q13[15:0] ^ 16'h0200 };
		s01_d <= s00_q;
		s02_d <= s01_q;
		s03_d <= s02_q;
		s04_d <= s03_q;
		s05_d <= s04_q;
		s06_d <= s05_q;
		s07_d <= s06_q;
		s08_d <= s07_q;
		s09_d <= s08_q;
		s10_d <= s09_q;
		s11_d <= s10_q;
		s12_d <= s11_q;
		s13_d <= s12_q;
		s14_d <= s13_q;
		s15_d <= s14_q;
		s16_d <= s15_q;
		s17_d <= s16_q;
		s18_d <= s17_q;
		s19_d <= s18_q;
		s20_d <= s19_q;
		s21_d <= s20_q;
		s22_d <= s21_q;
		s23_d <= s22_q;
		s24_d <= s23_q;
		s25_d <= s24_q;
		s26_d <= s25_q;
		s27_d <= s26_q;
		s28_d <= s27_q;
		s29_d <= s28_q;
		s30_d <= s29_q;
		s31_d <= s30_q;
		s32_d <= s31_q;
		s33_d <= s32_q;
		s34_d <= s33_q;
		s35_d <= s34_q;
		s36_d <= s35_q;
		s37_d <= s36_q;
		s38_d <= s37_q;
		s39_d <= s38_q;
		s40_d <= s39_q;
		s41_d <= s40_q;

		p00_d <= p00;
		p01_d <= p01;
		p02_d <= p02;
		p03_d <= p03;
		p04_d <= p04;
		p05_d <= p05;
		p06_d <= p06;
		p07_d <= p07;
		p08_d <= p08;
		p09_d <= p09;
		p10_d <= p10;
		p11_d <= p11;
		p12_d <= p12;

		q00_d <= q00;
		q01_d <= q01;
		q02_d <= q02;
		q03_d <= q03;
		q04_d <= q04;
		q05_d <= q05;
		q06_d <= q06;
		q07_d <= q07;
		q08_d <= q08;
		q09_d <= q09;
		q10_d <= q10;
		q11_d <= q11;
		q12_d <= q12;

		f00_d <= f00;
		f01_d <= f01;
		f02_d <= f02;
		f03_d <= f03;
		f04_d <= f04;
		f05_d <= f05;
		f06_d <= f06;
		f07_d <= f07;
		f08_d <= f08;
		f09_d <= f09;
		f10_d <= f10;
		f11_d <= f11;
		f12_d <= f12;

	end
	
	always @ (posedge clk) begin
	
		hash_q <= { hash_d[31:0], hash_d[63:32], hash_d[95:64], hash_d[127:96], hash_d[159:128], hash_d[191:160], hash_d[223:192], hash_d[255:224], hash_d[287:256], hash_d[319:288], hash_d[351:320], hash_d[383:352], hash_d[415:384], hash_d[447:416], hash_d[479:448], hash_d[511:480] };
		
		p_q <= p_d;
		q_q <= q_d;
		f_q <= f_d;
		
		s00_q <= s00_d;
		s01_q <= s01_d;
		s02_q <= s02_d;
		s03_q <= s03_d;
		s04_q <= s04_d;
		s05_q <= s05_d;
		s06_q <= s06_d;
		s07_q <= s07_d;
		s08_q <= s08_d;
		s09_q <= s09_d;
		s10_q <= s10_d;
		s11_q <= s11_d;
		s12_q <= s12_d;
		s13_q <= s13_d;
		s14_q <= s14_d;
		s15_q <= s15_d;
		s16_q <= s16_d;
		s17_q <= s17_d;
		s18_q <= s18_d;
		s19_q <= s19_d;
		s20_q <= s20_d;
		s21_q <= s21_d;
		s22_q <= s22_d;
		s23_q <= s23_d;
		s24_q <= s24_d;
		s25_q <= s25_d;
		s26_q <= s26_d;
		s27_q <= s27_d;
		s28_q <= s28_d;
		s29_q <= s29_d;
		s30_q <= s30_d;
		s31_q <= s31_d;
		s32_q <= s32_d;
		s33_q <= s33_d;
		s34_q <= s34_d;
		s35_q <= s35_d;
		s36_q <= s36_d;
		s37_q <= s37_d;
		s38_q <= s38_d;
		s39_q <= s39_d;
		s40_q <= s40_d;
		s41_q <= s41_d;

		p00_q <= p00_d;
		p01_q <= p01_d;
		p02_q <= p02_d;
		p03_q <= p03_d;
		p04_q <= p04_d;
		p05_q <= p05_d;
		p06_q <= p06_d;
		p07_q <= p07_d;
		p08_q <= p08_d;
		p09_q <= p09_d;
		p10_q <= p10_d;
		p11_q <= p11_d;
		p12_q <= p12_d;

		q00_q <= q00_d;
		q01_q <= q01_d;
		q02_q <= q02_d;
		q03_q <= q03_d;
		q04_q <= q04_d;
		q05_q <= q05_d;
		q06_q <= q06_d;
		q07_q <= q07_d;
		q08_q <= q08_d;
		q09_q <= q09_d;
		q10_q <= q10_d;
		q11_q <= q11_d;
		q12_q <= q12_d;

		f00_q <= f00_d;
		f01_q <= f01_d;
		f02_q <= f02_d;
		f03_q <= f03_d;
		f04_q <= f04_d;
		f05_q <= f05_d;
		f06_q <= f06_d;
		f07_q <= f07_d;
		f08_q <= f08_d;
		f09_q <= f09_d;
		f10_q <= f10_d;
		f11_q <= f11_d;
		f12_q <= f12_d;
	
	end

endmodule
