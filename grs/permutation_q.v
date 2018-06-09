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

module permutation_q (
	input  clk,
	input  [3:0] round,
	input  [1023:0] in,
	output [1023:0] out
);

	reg [1023:0] t0, t1;

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

	reg [7:0] a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10,a11,a12,a13,a14,a15;
	reg [7:0] a16,a17,a18,a19,a20,a21,a22,a23,a24,a25,a26,a27,a28,a29,a30,a31;
	reg [7:0] a32,a33,a34,a35,a36,a37,a38,a39,a40,a41,a42,a43,a44,a45,a46,a47;
	reg [7:0] a48,a49,a50,a51,a52,a53,a54,a55,a56,a57,a58,a59,a60,a61,a62,a63;
	reg [7:0] a64,a65,a66,a67,a68,a69,a70,a71,a72,a73,a74,a75,a76,a77,a78,a79;
	reg [7:0] a80,a81,a82,a83,a84,a85,a86,a87,a88,a89,a90,a91,a92,a93,a94,a95;
	reg [7:0] a96,a97,a98,a99,a100,a101,a102,a103,a104,a105,a106,a107,a108,a109,a110,a111;
	reg [7:0] a112,a113,a114,a115,a116,a117,a118,a119,a120,a121,a122,a123,a124,a125,a126,a127;

	always @ (*) begin

		a0 <= s_box[in[952 +: 8]];
		a1 <= s_box[in[816 +: 8]];
		a2 <= s_box[in[680 +: 8]];
		a3 <= s_box[in[288 +: 8]];
		a4 <= s_box[in[984 +: 8]];
		a5 <= s_box[in[848 +: 8]];
		a6 <= s_box[in[712 +: 8]];
		a7 <= s_box[~in[576 +: 8] ^ { 4'h9, 4'hF - round } ];
		a8 <= s_box[in[888 +: 8]];
		a9 <= s_box[in[752 +: 8]];
		a10 <= s_box[in[616 +: 8]];
		a11 <= s_box[in[224 +: 8]];
		a12 <= s_box[in[920 +: 8]];
		a13 <= s_box[in[784 +: 8]];
		a14 <= s_box[in[648 +: 8]];
		a15 <= s_box[~in[512 +: 8] ^ { 4'h8, 4'hF - round } ];
		a16 <= s_box[in[824 +: 8]];
		a17 <= s_box[in[688 +: 8]];
		a18 <= s_box[in[552 +: 8]];
		a19 <= s_box[in[160 +: 8]];
		a20 <= s_box[in[856 +: 8]];
		a21 <= s_box[in[720 +: 8]];
		a22 <= s_box[in[584 +: 8]];
		a23 <= s_box[~in[448 +: 8] ^ { 4'h7, 4'hF - round } ];
		a24 <= s_box[in[760 +: 8]];
		a25 <= s_box[in[624 +: 8]];
		a26 <= s_box[in[488 +: 8]];
		a27 <= s_box[in[96 +: 8]];
		a28 <= s_box[in[792 +: 8]];
		a29 <= s_box[in[656 +: 8]];
		a30 <= s_box[in[520 +: 8]];
		a31 <= s_box[~in[384 +: 8] ^ { 4'h6, 4'hF - round } ];
		a32 <= s_box[in[696 +: 8]];
		a33 <= s_box[in[560 +: 8]];
		a34 <= s_box[in[424 +: 8]];
		a35 <= s_box[in[32 +: 8]];
		a36 <= s_box[in[728 +: 8]];
		a37 <= s_box[in[592 +: 8]];
		a38 <= s_box[in[456 +: 8]];
		a39 <= s_box[~in[320 +: 8] ^ { 4'h5, 4'hF - round } ];
		a40 <= s_box[in[632 +: 8]];
		a41 <= s_box[in[496 +: 8]];
		a42 <= s_box[in[360 +: 8]];
		a43 <= s_box[in[992 +: 8]];
		a44 <= s_box[in[664 +: 8]];
		a45 <= s_box[in[528 +: 8]];
		a46 <= s_box[in[392 +: 8]];
		a47 <= s_box[~in[256 +: 8] ^ { 4'h4, 4'hF - round } ];
		a48 <= s_box[in[568 +: 8]];
		a49 <= s_box[in[432 +: 8]];
		a50 <= s_box[in[296 +: 8]];
		a51 <= s_box[in[928 +: 8]];
		a52 <= s_box[in[600 +: 8]];
		a53 <= s_box[in[464 +: 8]];
		a54 <= s_box[in[328 +: 8]];
		a55 <= s_box[~in[192 +: 8] ^ { 4'h3, 4'hF - round } ];
		a56 <= s_box[in[504 +: 8]];
		a57 <= s_box[in[368 +: 8]];
		a58 <= s_box[in[232 +: 8]];
		a59 <= s_box[in[864 +: 8]];
		a60 <= s_box[in[536 +: 8]];
		a61 <= s_box[in[400 +: 8]];
		a62 <= s_box[in[264 +: 8]];
		a63 <= s_box[~in[128 +: 8] ^ { 4'h2, 4'hF - round } ];
		a64 <= s_box[in[440 +: 8]];
		a65 <= s_box[in[304 +: 8]];
		a66 <= s_box[in[168 +: 8]];
		a67 <= s_box[in[800 +: 8]];
		a68 <= s_box[in[472 +: 8]];
		a69 <= s_box[in[336 +: 8]];
		a70 <= s_box[in[200 +: 8]];
		a71 <= s_box[~in[64 +: 8] ^ { 4'h1, 4'hF - round } ];
		a72 <= s_box[in[376 +: 8]];
		a73 <= s_box[in[240 +: 8]];
		a74 <= s_box[in[104 +: 8]];
		a75 <= s_box[in[736 +: 8]];
		a76 <= s_box[in[408 +: 8]];
		a77 <= s_box[in[272 +: 8]];
		a78 <= s_box[in[136 +: 8]];
		a79 <= s_box[~in[0 +: 8] ^ { 4'h0, 4'hF - round } ];
		a80 <= s_box[in[312 +: 8]];
		a81 <= s_box[in[176 +: 8]];
		a82 <= s_box[in[40 +: 8]];
		a83 <= s_box[in[672 +: 8]];
		a84 <= s_box[in[344 +: 8]];
		a85 <= s_box[in[208 +: 8]];
		a86 <= s_box[in[72 +: 8]];
		a87 <= s_box[~in[960 +: 8] ^ { 4'hF, 4'hF - round } ];
		a88 <= s_box[in[248 +: 8]];
		a89 <= s_box[in[112 +: 8]];
		a90 <= s_box[in[1000 +: 8]];
		a91 <= s_box[in[608 +: 8]];
		a92 <= s_box[in[280 +: 8]];
		a93 <= s_box[in[144 +: 8]];
		a94 <= s_box[in[8 +: 8]];
		a95 <= s_box[~in[896 +: 8] ^ { 4'hE, 4'hF - round } ];
		a96 <= s_box[in[184 +: 8]];
		a97 <= s_box[in[48 +: 8]];
		a98 <= s_box[in[936 +: 8]];
		a99 <= s_box[in[544 +: 8]];
		a100 <= s_box[in[216 +: 8]];
		a101 <= s_box[in[80 +: 8]];
		a102 <= s_box[in[968 +: 8]];
		a103 <= s_box[~in[832 +: 8] ^ { 4'hD, 4'hF - round } ];
		a104 <= s_box[in[120 +: 8]];
		a105 <= s_box[in[1008 +: 8]];
		a106 <= s_box[in[872 +: 8]];
		a107 <= s_box[in[480 +: 8]];
		a108 <= s_box[in[152 +: 8]];
		a109 <= s_box[in[16 +: 8]];
		a110 <= s_box[in[904 +: 8]];
		a111 <= s_box[~in[768 +: 8] ^ { 4'hC, 4'hF - round } ];
		a112 <= s_box[in[56 +: 8]];
		a113 <= s_box[in[944 +: 8]];
		a114 <= s_box[in[808 +: 8]];
		a115 <= s_box[in[416 +: 8]];
		a116 <= s_box[in[88 +: 8]];
		a117 <= s_box[in[976 +: 8]];
		a118 <= s_box[in[840 +: 8]];
		a119 <= s_box[~in[704 +: 8] ^ { 4'hB, 4'hF - round } ];
		a120 <= s_box[in[1016 +: 8]];
		a121 <= s_box[in[880 +: 8]];
		a122 <= s_box[in[744 +: 8]];
		a123 <= s_box[in[352 +: 8]];
		a124 <= s_box[in[24 +: 8]];
		a125 <= s_box[in[912 +: 8]];
		a126 <= s_box[in[776 +: 8]];
		a127 <= s_box[~in[640 +: 8] ^ { 4'hA, 4'hF - round } ];

	end
	
	always @ (*) begin
	
		t0 <= {
			a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10,a11,a12,a13,a14,a15,
			a16,a17,a18,a19,a20,a21,a22,a23,a24,a25,a26,a27,a28,a29,a30,a31,
			a32,a33,a34,a35,a36,a37,a38,a39,a40,a41,a42,a43,a44,a45,a46,a47,
			a48,a49,a50,a51,a52,a53,a54,a55,a56,a57,a58,a59,a60,a61,a62,a63,
			a64,a65,a66,a67,a68,a69,a70,a71,a72,a73,a74,a75,a76,a77,a78,a79,
			a80,a81,a82,a83,a84,a85,a86,a87,a88,a89,a90,a91,a92,a93,a94,a95,
			a96,a97,a98,a99,a100,a101,a102,a103,a104,a105,a106,a107,a108,a109,a110,a111,
			a112,a113,a114,a115,a116,a117,a118,a119,a120,a121,a122,a123,a124,a125,a126,a127
		};

	end

	always @ (posedge clk) begin
	
		t1 <= t0;

	end
	
	mix_bytes mb00 (clk, t1, out);

endmodule
