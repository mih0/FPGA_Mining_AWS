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

module smix (
	input clk,
	input [31:0] s0,
	input [31:0] s1,
	input [31:0] s2,
	input [31:0] s3,
	output [127:0] out
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

	wire [7:0] sb00x, sb01x, sb02x, sb03x;
	wire [7:0] sb10x, sb11x, sb12x, sb13x;
	wire [7:0] sb20x, sb21x, sb22x, sb23x;
	wire [7:0] sb30x, sb31x, sb32x, sb33x;
	
	assign sb00x = s_box[s0[31:24]];
	assign sb01x = s_box[s0[23:16]];
	assign sb02x = s_box[s0[15: 8]];
	assign sb03x = s_box[s0[ 7: 0]];

	assign sb10x = s_box[s1[31:24]];
	assign sb11x = s_box[s1[23:16]];
	assign sb12x = s_box[s1[15: 8]];
	assign sb13x = s_box[s1[ 7: 0]];

	assign sb20x = s_box[s2[31:24]];
	assign sb21x = s_box[s2[23:16]];
	assign sb22x = s_box[s2[15: 8]];
	assign sb23x = s_box[s2[ 7: 0]];

	assign sb30x = s_box[s3[31:24]];
	assign sb31x = s_box[s3[23:16]];
	assign sb32x = s_box[s3[15: 8]];
	assign sb33x = s_box[s3[ 7: 0]];

	reg [7:0] sb00, sb01, sb02, sb03;
	reg [7:0] sb10, sb11, sb12, sb13;
	reg [7:0] sb20, sb21, sb22, sb23;
	reg [7:0] sb30, sb31, sb32, sb33;

	reg [7:0] gf2_00, gf2_01, gf2_02, gf2_03;
	reg [7:0] gf2_10, gf2_11, gf2_12, gf2_13;
	reg [7:0] gf2_20, gf2_21, gf2_22, gf2_23;
	reg [7:0] gf2_30, gf2_31, gf2_32, gf2_33;

	reg [7:0] gf4_00, gf4_01, gf4_02, gf4_03;
	reg [7:0] gf4_10, gf4_11, gf4_12, gf4_13;
	reg [7:0] gf4_20, gf4_21, gf4_22, gf4_23;
	reg [7:0] gf4_30, gf4_31, gf4_32, gf4_33;
	
	assign out[127:120] = sb00 ^ gf4_01 ^ gf4_02 ^ gf2_02 ^ sb02 ^ sb03 ^ sb10 ^ sb20	^ sb30;
	assign out[119:112] = sb01 ^ sb10 ^ sb11 ^ gf4_12 ^ gf4_13 ^ gf2_13 ^ sb13 ^ sb21 ^ sb31; 
	assign out[111:104] = sb02 ^ sb12 ^ gf4_20 ^ gf2_20 ^ sb20 ^ sb21 ^ sb22 ^ gf4_23 ^ sb32;
	assign out[103: 96] = sb03 ^ sb13 ^ sb23 ^ gf4_30 ^ gf4_31 ^ gf2_31 ^ sb31 ^ sb32 ^ sb33;
	assign out[ 95: 88] = gf4_11 ^ gf4_12 ^ gf2_12 ^ sb12 ^ sb13 ^ sb20 ^ sb30;
	assign out[ 87: 80] = sb01 ^ sb20 ^ gf4_22 ^ gf4_23 ^ gf2_23 ^ sb23 ^ sb31;
	assign out[ 79: 72] = sb02 ^ sb12 ^ gf4_30 ^ gf2_30 ^ sb30 ^ sb31 ^ gf4_33;
	assign out[ 71: 64] = gf4_00 ^ gf4_01 ^ gf2_01 ^ sb01 ^ sb02	^ sb13 ^ sb23;
	assign out[ 63: 56] = gf4_10 ^ gf2_10 ^ sb10 ^ gf4_20 ^ gf2_20 ^ gf4_21 ^ gf4_22 ^ gf2_22 ^ sb22 ^ sb23 ^ gf4_30 ^ gf2_30 ^ sb30;
	assign out[ 55: 48] = gf4_01 ^ gf2_01 ^ sb01 ^ gf4_21 ^ gf2_21 ^ sb21 ^ sb30 ^ gf4_31 ^ gf2_31 ^ gf4_32 ^ gf4_33 ^ gf2_33 ^ sb33;
	assign out[ 47: 40] = gf4_00 ^ gf2_00 ^ sb00 ^ sb01 ^ gf4_02 ^ gf2_02 ^ gf4_03 ^ gf4_12 ^ gf2_12 ^ sb12 ^ gf4_32 ^ gf2_32 ^ sb32;
	assign out[ 39: 32] = gf4_03 ^ gf2_03 ^ sb03 ^ gf4_10 ^ gf4_11 ^ gf2_11 ^ sb11 ^ sb12 ^ gf4_13 ^ gf2_13 ^ gf4_23 ^ gf2_23 ^ sb23;
	assign out[ 31: 24] = gf4_10 ^ gf4_20 ^ gf4_30 ^ sb30 ^ gf4_31 ^ gf4_32 ^ gf2_32 ^ sb32 ^ sb33;
	assign out[ 23: 16] = sb00 ^ gf4_01 ^ sb01 ^ gf4_02 ^ gf4_03 ^ gf2_03 ^ sb03 ^ gf4_21 ^ gf4_31;
	assign out[ 15:  8] = gf4_02 ^ gf4_10 ^ gf2_10 ^ sb10 ^ sb11 ^ gf4_12 ^ sb12 ^ gf4_13 ^ gf4_32;
	assign out[  7:  0] = gf4_03 ^ gf4_13 ^ gf4_20 ^ gf4_21 ^ gf2_21 ^ sb21 ^ sb22 ^ gf4_23 ^ sb23;


	always @ (posedge clk) begin
	
		sb00 <= sb00x;
		sb01 <= sb01x;
		sb02 <= sb02x;
		sb03 <= sb03x;
                
		sb10 <= sb10x;
		sb11 <= sb11x;
		sb12 <= sb12x;
		sb13 <= sb13x;
                
		sb20 <= sb20x;
		sb21 <= sb21x;
		sb22 <= sb22x;
		sb23 <= sb23x;
                
		sb30 <= sb30x;
		sb31 <= sb31x;
		sb32 <= sb32x;
		sb33 <= sb33x;

		gf2_00 <= gf_2(sb00x);
		gf2_01 <= gf_2(sb01x);
		gf2_02 <= gf_2(sb02x);
		gf2_03 <= gf_2(sb03x);
                
		gf2_10 <= gf_2(sb10x);
		gf2_11 <= gf_2(sb11x);
		gf2_12 <= gf_2(sb12x);
		gf2_13 <= gf_2(sb13x);
                
		gf2_20 <= gf_2(sb20x);
		gf2_21 <= gf_2(sb21x);
		gf2_22 <= gf_2(sb22x);
		gf2_23 <= gf_2(sb23x);
                
		gf2_30 <= gf_2(sb30x);
		gf2_31 <= gf_2(sb31x);
		gf2_32 <= gf_2(sb32x);
		gf2_33 <= gf_2(sb33x);

		gf4_00 <= gf_4(sb00x);
		gf4_01 <= gf_4(sb01x);
		gf4_02 <= gf_4(sb02x);
		gf4_03 <= gf_4(sb03x);
                
		gf4_10 <= gf_4(sb10x);
		gf4_11 <= gf_4(sb11x);
		gf4_12 <= gf_4(sb12x);
		gf4_13 <= gf_4(sb13x);
                
		gf4_20 <= gf_4(sb20x);
		gf4_21 <= gf_4(sb21x);
		gf4_22 <= gf_4(sb22x);
		gf4_23 <= gf_4(sb23x);
                
		gf4_30 <= gf_4(sb30x);
		gf4_31 <= gf_4(sb31x);
		gf4_32 <= gf_4(sb32x);
		gf4_33 <= gf_4(sb33x);

	end

//	always @ (posedge clk) begin
//
//		out[127:120] <= sb00 ^ gf4_01 ^ gf4_02 ^ gf2_02 ^ sb02 ^ sb03 ^ sb10 ^ sb20	^ sb30;
//		out[119:112] <= sb01 ^ sb10 ^ sb11 ^ gf4_12 ^ gf4_13 ^ gf2_13 ^ sb13 ^ sb21 ^ sb31; 
//		out[111:104] <= sb02 ^ sb12 ^ gf4_20 ^ gf2_20 ^ sb20 ^ sb21 ^ sb22 ^ gf4_23 ^ sb32;
//		out[103: 96] <= sb03 ^ sb13 ^ sb23 ^ gf4_30 ^ gf4_31 ^ gf2_31 ^ sb31 ^ sb32 ^ sb33;
//		out[ 95: 88] <= gf4_11 ^ gf4_12 ^ gf2_12 ^ sb12 ^ sb13 ^ sb20 ^ sb30;
//		out[ 87: 80] <= sb01 ^ sb20 ^ gf4_22 ^ gf4_23 ^ gf2_23 ^ sb23 ^ sb31;
//		out[ 79: 72] <= sb02 ^ sb12 ^ gf4_30 ^ gf2_30 ^ sb30 ^ sb31 ^ gf4_33;
//		out[ 71: 64] <= gf4_00 ^ gf4_01 ^ gf2_01 ^ sb01 ^ sb02	^ sb13 ^ sb23;
//		out[ 63: 56] <= gf4_10 ^ gf2_10 ^ sb10 ^ gf4_20 ^ gf2_20 ^ gf4_21 ^ gf4_22 ^ gf2_22 ^ sb22 ^ sb23 ^ gf4_30 ^ gf2_30 ^ sb30;
//		out[ 55: 48] <= gf4_01 ^ gf2_01 ^ sb01 ^ gf4_21 ^ gf2_21 ^ sb21 ^ sb30 ^ gf4_31 ^ gf2_31 ^ gf4_32 ^ gf4_33 ^ gf2_33 ^ sb33;
//		out[ 47: 40] <= gf4_00 ^ gf2_00 ^ sb00 ^ sb01 ^ gf4_02 ^ gf2_02 ^ gf4_03 ^ gf4_12 ^ gf2_12 ^ sb12 ^ gf4_32 ^ gf2_32 ^ sb32;
//		out[ 39: 32] <= gf4_03 ^ gf2_03 ^ sb03 ^ gf4_10 ^ gf4_11 ^ gf2_11 ^ sb11 ^ sb12 ^ gf4_13 ^ gf2_13 ^ gf4_23 ^ gf2_23 ^ sb23;
//		out[ 31: 24] <= gf4_10 ^ gf4_20 ^ gf4_30 ^ sb30 ^ gf4_31 ^ gf4_32 ^ gf2_32 ^ sb32 ^ sb33;
//		out[ 23: 16] <= sb00 ^ gf4_01 ^ sb01 ^ gf4_02 ^ gf4_03 ^ gf2_03 ^ sb03 ^ gf4_21 ^ gf4_31;
//		out[ 15:  8] <= gf4_02 ^ gf4_10 ^ gf2_10 ^ sb10 ^ sb11 ^ gf4_12 ^ sb12 ^ gf4_13 ^ gf4_32;
//		out[  7:  0] <= gf4_03 ^ gf4_13 ^ gf4_20 ^ gf4_21 ^ gf2_21 ^ sb21 ^ sb22 ^ gf4_23 ^ sb23;
//
//	end
	
	// Calculate GF(256) Multiplication (x2)
	function [7:0] gf_2;
		input [7:0] n;
		begin
			gf_2 = {n[6],n[5],n[4],n[3]^n[7],n[2]^n[7],n[1],n[0]^n[7],n[7]};
		end
	endfunction

	// Calculate GF(256) Multiplication (x4)
	function [7:0] gf_4;
		input [7:0] n;
		begin
			gf_4 = {n[5],n[4],n[3]^n[7],n[2]^n[7]^n[6],n[6]^n[1],n[0]^n[7],n[6]^n[7],n[6]};
		end
	endfunction
		
endmodule
