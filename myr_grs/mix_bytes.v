/*
 * Copyright (c) 2016 Sprocket
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

module mix_bytes(
	input  clk,
	input  [1023:0] in,
	output [1023:0] out
);

	wire [63:0] m0, m1, m2, m3, m4, m5, m6, m7;
	wire [63:0] m8, m9, m10,m11,m12,m13,m14,m15;
	
	mix_chunk mc0 (clk, in[1023:960], m0);
	mix_chunk mc1 (clk, in[959:896], m1);
	mix_chunk mc2 (clk, in[895:832], m2);
	mix_chunk mc3 (clk, in[831:768], m3);
	mix_chunk mc4 (clk, in[767:704], m4);
	mix_chunk mc5 (clk, in[703:640], m5);
	mix_chunk mc6 (clk, in[639:576], m6);
	mix_chunk mc7 (clk, in[575:512], m7);
	mix_chunk mc8 (clk, in[511:448], m8);
	mix_chunk mc9 (clk, in[447:384], m9);
	mix_chunk mc10 (clk, in[383:320], m10);
	mix_chunk mc11 (clk, in[319:256], m11);
	mix_chunk mc12 (clk, in[255:192], m12);
	mix_chunk mc13 (clk, in[191:128], m13);
	mix_chunk mc14 (clk, in[127: 64], m14);
	mix_chunk mc15 (clk, in[ 63:  0], m15);
	
	assign out = {m0,m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,m11,m12,m13,m14,m15};

endmodule

module mix_chunk (
	input clk,
	input  [63:0] in,
	output reg [63:0] out
);

	wire [7:0] b0,b1,b2,b3,b4,b5,b6,b7;
	wire [7:0] o0,o1,o2,o3,o4,o5,o6,o7;
	
	assign {b0,b1,b2,b3,b4,b5,b6,b7} = in;
	
	mix_chunk2 mc0 (b0,b1,b2,b3,b4,b5,b6,b7,o0);
	mix_chunk2 mc1 (b1,b2,b3,b4,b5,b6,b7,b0,o1);
	mix_chunk2 mc2 (b2,b3,b4,b5,b6,b7,b0,b1,o2);
	mix_chunk2 mc3 (b3,b4,b5,b6,b7,b0,b1,b2,o3);
	mix_chunk2 mc4 (b4,b5,b6,b7,b0,b1,b2,b3,o4);
	mix_chunk2 mc5 (b5,b6,b7,b0,b1,b2,b3,b4,o5);
	mix_chunk2 mc6 (b6,b7,b0,b1,b2,b3,b4,b5,o6);
	mix_chunk2 mc7 (b7,b0,b1,b2,b3,b4,b5,b6,o7);

	reg [63:0] o;

	always @ (*) begin
		o <= { o0, o1, o2, o3, o4, o5, o6, o7 };
	end
	
	always @ (posedge clk) begin
		out <= o;
	end

endmodule

module mix_chunk2(
	input  [7:0] in0,
	input  [7:0] in1,
	input  [7:0] in2,
	input  [7:0] in3,
	input  [7:0] in4,
	input  [7:0] in5,
	input  [7:0] in6,
	input  [7:0] in7,
	output [7:0] out
);

	assign out = mult_2(in0) ^ mult_2(in1) ^ mult_3(in2) ^ mult_4(in3) ^ mult_5(in4) ^ mult_3(in5) ^ mult_5(in6) ^ mult_7(in7);

	// Calculate GF(256) Multiplication (x2)
	function [7:0] mult_2;
		input [7:0] n;
		begin
			mult_2 = {n[6],n[5],n[4],n[3]^n[7],n[2]^n[7],n[1],n[0]^n[7],n[7]};
		end
	endfunction

	// Calculate GF(256) Multiplication (x3)
	function [7:0] mult_3;
		input [7:0] n;
		begin
			mult_3 = {n[6]^n[7],n[5]^n[6],n[4]^n[5],n[3]^n[7]^n[4],n[2]^n[7]^n[3],n[1]^n[2],n[0]^n[7]^n[1],n[7]^n[0]};
		end
	endfunction

	// Calculate GF(256) Multiplication (x4)
	function [7:0] mult_4;
		input [7:0] n;
		begin
			mult_4 = {n[5],n[4],n[3]^n[7],n[2]^n[7]^n[6],n[6]^n[1],n[0]^n[7],n[6]^n[7],n[6]};
		end
	endfunction

	// Calculate GF(256) Multiplication (x5)
	function [7:0] mult_5;
		input [7:0] n;
		begin
			mult_5 = {n[5]^n[7],n[4]^n[6],n[3]^n[7]^n[5],n[2]^n[7]^n[6]^n[4],n[6]^n[1]^n[3],n[0]^n[7]^n[2],n[6]^n[7]^n[1],n[6]^n[0]};
		end
	endfunction

	// Calculate GF(256) Multiplication (x7)
	function [7:0] mult_7;
		input [7:0] n;
		begin
			mult_7 = {n[5]^n[7]^n[6],n[4]^n[6]^n[5],n[3]^n[7]^n[5]^n[4],n[2]^n[7]^n[6]^n[4]^n[3]^n[7],n[6]^n[1]^n[3]^n[2]^n[7],n[0]^n[7]^n[2]^n[1],n[6]^n[7]^n[1]^n[0]^n[7],n[6]^n[0]^n[7]};
		end
	endfunction

endmodule
