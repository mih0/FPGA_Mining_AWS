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

module mix_bytes(
	input  clk,
	input  [1023:0] in,
	output reg [1023:0] out
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

	reg [63:0] m0, m1, m2, m3, m4, m5, m6, m7;
	reg [63:0] m8, m9, m10,m11,m12,m13,m14,m15;
	
	reg [1023:0] m;

	always @ (*) begin

		m0  <= GF_Mult(in[1023:960]);
		m1  <= GF_Mult(in[959:896]);
		m2  <= GF_Mult(in[895:832]);
		m3  <= GF_Mult(in[831:768]);
		m4  <= GF_Mult(in[767:704]);
		m5  <= GF_Mult(in[703:640]);
		m6  <= GF_Mult(in[639:576]);
		m7  <= GF_Mult(in[575:512]);
		m8  <= GF_Mult(in[511:448]);
		m9  <= GF_Mult(in[447:384]);
		m10 <= GF_Mult(in[383:320]);
		m11 <= GF_Mult(in[319:256]);
		m12 <= GF_Mult(in[255:192]);
		m13 <= GF_Mult(in[191:128]);
		m14 <= GF_Mult(in[127: 64]);
		m15 <= GF_Mult(in[ 63:  0]);
	
	end

	always @ (*) begin
		m <= {m0,m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,m11,m12,m13,m14,m15};
	end
	
	always @ (posedge clk) begin
		out <= m;
	end


	// Perform GF(256) Multiplications On a Row
	function [63:0] GF_Mult;
		input [63:0] in;
		
		reg [7:0] b0,b1,b2,b3,b4,b5,b6,b7;
		reg [7:0] b0_x2,b1_x2,b2_x2,b3_x2,b4_x2,b5_x2,b6_x2,b7_x2;
		reg [7:0] b0_x4,b1_x4,b2_x4,b3_x4,b4_x4,b5_x4,b6_x4,b7_x4;
		
		begin
		
			{b0,b1,b2,b3,b4,b5,b6,b7} = in;
			
			b0_x2 = gf2[b0];
			b1_x2 = gf2[b1];
			b2_x2 = gf2[b2];
			b3_x2 = gf2[b3];
			b4_x2 = gf2[b4];
			b5_x2 = gf2[b5];
			b6_x2 = gf2[b6];
			b7_x2 = gf2[b7];

			b0_x4 = gf2[gf2[b0]];
			b1_x4 = gf2[gf2[b1]];
			b2_x4 = gf2[gf2[b2]];
			b3_x4 = gf2[gf2[b3]];
			b4_x4 = gf2[gf2[b4]];
			b5_x4 = gf2[gf2[b5]];
			b6_x4 = gf2[gf2[b6]];
			b7_x4 = gf2[gf2[b7]];

			GF_Mult = {
				b0_x2 ^ b1_x2 ^ b2_x2 ^ b2 ^ b3_x4 ^ b4_x4 ^ b4 ^ b5_x2 ^ b5 ^ b6_x4 ^b6 ^ b7_x4 ^ b7_x2 ^ b7,
				b1_x2 ^ b2_x2 ^ b3_x2 ^ b3 ^ b4_x4 ^ b5_x4 ^ b5 ^ b6_x2 ^ b6 ^ b7_x4 ^b7 ^ b0_x4 ^ b0_x2 ^ b0,
				b2_x2 ^ b3_x2 ^ b4_x2 ^ b4 ^ b5_x4 ^ b6_x4 ^ b6 ^ b7_x2 ^ b7 ^ b0_x4 ^b0 ^ b1_x4 ^ b1_x2 ^ b1,
				b3_x2 ^ b4_x2 ^ b5_x2 ^ b5 ^ b6_x4 ^ b7_x4 ^ b7 ^ b0_x2 ^ b0 ^ b1_x4 ^b1 ^ b2_x4 ^ b2_x2 ^ b2,
				b4_x2 ^ b5_x2 ^ b6_x2 ^ b6 ^ b7_x4 ^ b0_x4 ^ b0 ^ b1_x2 ^ b1 ^ b2_x4 ^b2 ^ b3_x4 ^ b3_x2 ^ b3,
				b5_x2 ^ b6_x2 ^ b7_x2 ^ b7 ^ b0_x4 ^ b1_x4 ^ b1 ^ b2_x2 ^ b2 ^ b3_x4 ^b3 ^ b4_x4 ^ b4_x2 ^ b4,
				b6_x2 ^ b7_x2 ^ b0_x2 ^ b0 ^ b1_x4 ^ b2_x4 ^ b2 ^ b3_x2 ^ b3 ^ b4_x4 ^b4 ^ b5_x4 ^ b5_x2 ^ b5,
				b7_x2 ^ b0_x2 ^ b1_x2 ^ b1 ^ b2_x4 ^ b3_x4 ^ b3 ^ b4_x2 ^ b4 ^ b5_x4 ^b5 ^ b6_x4 ^ b6_x2 ^ b6
			};
			
		end
	endfunction

endmodule
