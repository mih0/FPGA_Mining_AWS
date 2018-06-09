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

(* ram_style = "distributed" *)
module smix (
	input [31:0] s0,
	input [31:0] s1,
	input [31:0] s2,
	input [31:0] s3,
	output [127:0] out
);

	wire [7:0] gf2 [0:255] = {
		8'h00, 8'h02, 8'h04, 8'h06, 8'h08, 8'h0a, 8'h0c, 8'h0e, 8'h10, 8'h12, 8'h14, 8'h16, 8'h18, 8'h1a, 8'h1c, 8'h1e,
		8'h20, 8'h22, 8'h24, 8'h26, 8'h28, 8'h2a, 8'h2c, 8'h2e, 8'h30, 8'h32, 8'h34, 8'h36, 8'h38, 8'h3a, 8'h3c, 8'h3e,
		8'h40, 8'h42, 8'h44, 8'h46, 8'h48, 8'h4a, 8'h4c, 8'h4e, 8'h50, 8'h52, 8'h54, 8'h56, 8'h58, 8'h5a, 8'h5c, 8'h5e,
		8'h60, 8'h62, 8'h64, 8'h66, 8'h68, 8'h6a, 8'h6c, 8'h6e, 8'h70, 8'h72, 8'h74, 8'h76, 8'h78, 8'h7a, 8'h7c, 8'h7e,
		8'h80, 8'h82, 8'h84, 8'h86, 8'h88, 8'h8a, 8'h8c, 8'h8e, 8'h90, 8'h92, 8'h94, 8'h96, 8'h98, 8'h9a, 8'h9c, 8'h9e,
		8'ha0, 8'ha2, 8'ha4, 8'ha6, 8'ha8, 8'haa, 8'hac, 8'hae, 8'hb0, 8'hb2, 8'hb4, 8'hb6, 8'hb8, 8'hba, 8'hbc, 8'hbe,
		8'hc0, 8'hc2, 8'hc4, 8'hc6, 8'hc8, 8'hca, 8'hcc, 8'hce, 8'hd0, 8'hd2, 8'hd4, 8'hd6, 8'hd8, 8'hda, 8'hdc, 8'hde,
		8'he0, 8'he2, 8'he4, 8'he6, 8'he8, 8'hea, 8'hec, 8'hee, 8'hf0, 8'hf2, 8'hf4, 8'hf6, 8'hf8, 8'hfa, 8'hfc, 8'hfe,
		8'h1b, 8'h19, 8'h1f, 8'h1d, 8'h13, 8'h11, 8'h17, 8'h15, 8'h0b, 8'h09, 8'h0f, 8'h0d, 8'h03, 8'h01, 8'h07, 8'h05,
		8'h3b, 8'h39, 8'h3f, 8'h3d, 8'h33, 8'h31, 8'h37, 8'h35, 8'h2b, 8'h29, 8'h2f, 8'h2d, 8'h23, 8'h21, 8'h27, 8'h25,
		8'h5b, 8'h59, 8'h5f, 8'h5d, 8'h53, 8'h51, 8'h57, 8'h55, 8'h4b, 8'h49, 8'h4f, 8'h4d, 8'h43, 8'h41, 8'h47, 8'h45,
		8'h7b, 8'h79, 8'h7f, 8'h7d, 8'h73, 8'h71, 8'h77, 8'h75, 8'h6b, 8'h69, 8'h6f, 8'h6d, 8'h63, 8'h61, 8'h67, 8'h65,
		8'h9b, 8'h99, 8'h9f, 8'h9d, 8'h93, 8'h91, 8'h97, 8'h95, 8'h8b, 8'h89, 8'h8f, 8'h8d, 8'h83, 8'h81, 8'h87, 8'h85,
		8'hbb, 8'hb9, 8'hbf, 8'hbd, 8'hb3, 8'hb1, 8'hb7, 8'hb5, 8'hab, 8'ha9, 8'haf, 8'had, 8'ha3, 8'ha1, 8'ha7, 8'ha5,
		8'hdb, 8'hd9, 8'hdf, 8'hdd, 8'hd3, 8'hd1, 8'hd7, 8'hd5, 8'hcb, 8'hc9, 8'hcf, 8'hcd, 8'hc3, 8'hc1, 8'hc7, 8'hc5,
		8'hfb, 8'hf9, 8'hff, 8'hfd, 8'hf3, 8'hf1, 8'hf7, 8'hf5, 8'heb, 8'he9, 8'hef, 8'hed, 8'he3, 8'he1, 8'he7, 8'he5
	};

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

	wire [7:0] sb00, sb01, sb02, sb03;
	wire [7:0] sb10, sb11, sb12, sb13;
	wire [7:0] sb20, sb21, sb22, sb23;
	wire [7:0] sb30, sb31, sb32, sb33;
	
	assign sb00 = s_box[s0[31:24]];
	assign sb01 = s_box[s0[23:16]];
	assign sb02 = s_box[s0[15: 8]];
	assign sb03 = s_box[s0[ 7: 0]];

	assign sb10 = s_box[s1[31:24]];
	assign sb11 = s_box[s1[23:16]];
	assign sb12 = s_box[s1[15: 8]];
	assign sb13 = s_box[s1[ 7: 0]];

	assign sb20 = s_box[s2[31:24]];
	assign sb21 = s_box[s2[23:16]];
	assign sb22 = s_box[s2[15: 8]];
	assign sb23 = s_box[s2[ 7: 0]];

	assign sb30 = s_box[s3[31:24]];
	assign sb31 = s_box[s3[23:16]];
	assign sb32 = s_box[s3[15: 8]];
	assign sb33 = s_box[s3[ 7: 0]];

	assign out[127:120] =  sb00 ^ gf2[gf2[sb01]] ^ gf2[gf2[sb02]] ^ gf2[sb02] ^ sb02 ^ sb03 ^ sb10 ^ sb20	^ sb30;
	assign out[119:112] =  sb01 ^ sb10 ^ sb11	^ gf2[gf2[sb12]] ^ gf2[gf2[sb13]] ^ gf2[sb13] ^ sb13 ^ sb21	^ sb31; 
	assign out[111:104] =  sb02 ^ sb12 ^ gf2[gf2[sb20]] ^ gf2[sb20] ^ sb20	^ sb21 ^ sb22 ^ gf2[gf2[sb23]] ^ sb32;
	assign out[103: 96] =  sb03 ^ sb13 ^ sb23	^ gf2[gf2[sb30]] ^ gf2[gf2[sb31]] ^ gf2[sb31] ^ sb31 ^ sb32	^ sb33;
	assign out[ 95: 88] =  gf2[gf2[sb11]] ^ gf2[gf2[sb12]] ^ gf2[sb12] ^ sb12 ^ sb13	^ sb20 ^ sb30;
	assign out[ 87: 80] =  sb01 ^ sb20 ^ gf2[gf2[sb22]] ^ gf2[gf2[sb23]] ^ gf2[sb23] ^ sb23 ^ sb31;
	assign out[ 79: 72] =  sb02 ^ sb12 ^ gf2[gf2[sb30]] ^ gf2[sb30] ^ sb30 ^ sb31 ^ gf2[gf2[sb33]];
	assign out[ 71: 64] =  gf2[gf2[sb00]] ^ gf2[gf2[sb01]] ^ gf2[sb01] ^ sb01 ^ sb02	^ sb13 ^ sb23;
	assign out[ 63: 56] =  gf2[gf2[sb10]] ^ gf2[sb10] ^ sb10 ^ gf2[gf2[sb20]] ^ gf2[sb20] ^ gf2[gf2[sb21]]	^ gf2[gf2[sb22]] ^ gf2[sb22] ^ sb22 ^ sb23 ^ gf2[gf2[sb30]] ^ gf2[sb30] ^ sb30;
	assign out[ 55: 48] =  gf2[gf2[sb01]] ^ gf2[sb01] ^ sb01 ^ gf2[gf2[sb21]] ^ gf2[sb21] ^ sb21 ^ sb30	^ gf2[gf2[sb31]] ^ gf2[sb31] ^ gf2[gf2[sb32]] ^ gf2[gf2[sb33]] ^ gf2[sb33] ^ sb33;
	assign out[ 47: 40] =  gf2[gf2[sb00]] ^ gf2[sb00] ^ sb00 ^ sb01 ^ gf2[gf2[sb02]] ^ gf2[sb02] ^ gf2[gf2[sb03]] ^ gf2[gf2[sb12]] ^ gf2[sb12] ^ sb12 ^ gf2[gf2[sb32]] ^ gf2[sb32] ^ sb32;
	assign out[ 39: 32] =  gf2[gf2[sb03]] ^ gf2[sb03] ^ sb03 ^ gf2[gf2[sb10]] ^ gf2[gf2[sb11]] ^ gf2[sb11] ^ sb11 ^ sb12 ^ gf2[gf2[sb13]] ^ gf2[sb13] ^ gf2[gf2[sb23]] ^ gf2[sb23] ^ sb23;
	assign out[ 31: 24] =  gf2[gf2[sb10]] ^ gf2[gf2[sb20]] ^ gf2[gf2[sb30]] ^ sb30 ^ gf2[gf2[sb31]] ^ gf2[gf2[sb32]] ^ gf2[sb32] ^ sb32 ^ sb33;
	assign out[ 23: 16] =  sb00 ^ gf2[gf2[sb01]] ^ sb01 ^ gf2[gf2[sb02]]	^ gf2[gf2[sb03]] ^ gf2[sb03] ^ sb03 ^ gf2[gf2[sb21]] ^ gf2[gf2[sb31]];
	assign out[ 15:  8] =  gf2[gf2[sb02]] ^ gf2[gf2[sb10]] ^ gf2[sb10] ^ sb10 ^ sb11 ^ gf2[gf2[sb12]] ^ sb12 ^ gf2[gf2[sb13]] ^ gf2[gf2[sb32]];
	assign out[  7:  0] =  gf2[gf2[sb03]] ^ gf2[gf2[sb13]] ^ gf2[gf2[sb20]] ^ gf2[gf2[sb21]] ^ gf2[sb21] ^ sb21 ^ sb22 ^ gf2[gf2[sb23]] ^ sb23;
		
endmodule
