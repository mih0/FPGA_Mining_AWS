/*!
   btcminer -- BTCMiner for ZTEX USB-FPGA Modules: HDL code: hash pipelines
   Copyright (C) 2011 ZTEX GmbH
   http://www.ztex.de

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License version 3 as
   published by the Free Software Foundation.

   This program is distributed in the hope that it will be useful, but
   WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
   General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, see http://www.gnu.org/licenses/.
!*/

`define IDX(x) (((x)+1)*(32)-1):((x)*(32))
`define E0(x) ( {{x}[1:0],{x}[31:2]} ^ {{x}[12:0],{x}[31:13]} ^ {{x}[21:0],{x}[31:22]} )
`define E1(x) ( {{x}[5:0],{x}[31:6]} ^ {{x}[10:0],{x}[31:11]} ^ {{x}[24:0],{x}[31:25]} )
`define CH(x,y,z) ( (z) ^ ((x) & ((y) ^ (z))) )
`define MAJ(x,y,z) ( ((x) & (y)) | ((z) & ((x) | (y))) )
`define S0(x) ( { {x}[6:4] ^ {x}[17:15], {{x}[3:0], {x}[31:7]} ^ {{x}[14:0],{x}[31:18]} ^ {x}[31:3] } )
`define S1(x) ( { {x}[16:7] ^ {x}[18:9], {{x}[6:0], {x}[31:17]} ^ {{x}[8:0],{x}[31:19]} ^ {x}[31:10] } )

module sha256_pipe2_base ( clk, i_state, i_data, out );

	parameter STAGES = 64;
	
	input clk;
	input [255:0] i_state;
	input [511:0] i_data;
	output [255:0] out;

	localparam Ks = {
		32'h428a2f98, 32'h71374491, 32'hb5c0fbcf, 32'he9b5dba5,
		32'h3956c25b, 32'h59f111f1, 32'h923f82a4, 32'hab1c5ed5,
		32'hd807aa98, 32'h12835b01, 32'h243185be, 32'h550c7dc3,
		32'h72be5d74, 32'h80deb1fe, 32'h9bdc06a7, 32'hc19bf174,
		32'he49b69c1, 32'hefbe4786, 32'h0fc19dc6, 32'h240ca1cc,
		32'h2de92c6f, 32'h4a7484aa, 32'h5cb0a9dc, 32'h76f988da,
		32'h983e5152, 32'ha831c66d, 32'hb00327c8, 32'hbf597fc7,
		32'hc6e00bf3, 32'hd5a79147, 32'h06ca6351, 32'h14292967,
		32'h27b70a85, 32'h2e1b2138, 32'h4d2c6dfc, 32'h53380d13,
		32'h650a7354, 32'h766a0abb, 32'h81c2c92e, 32'h92722c85,
		32'ha2bfe8a1, 32'ha81a664b, 32'hc24b8b70, 32'hc76c51a3,
		32'hd192e819, 32'hd6990624, 32'hf40e3585, 32'h106aa070,
		32'h19a4c116, 32'h1e376c08, 32'h2748774c, 32'h34b0bcb5,
		32'h391c0cb3, 32'h4ed8aa4a, 32'h5b9cca4f, 32'h682e6ff3,
		32'h748f82ee, 32'h78a5636f, 32'h84c87814, 32'h8cc70208,
		32'h90befffa, 32'ha4506ceb, 32'hbef9a3f7, 32'hc67178f2 
	};

	genvar i;

	generate

	for (i = 0; i <= STAGES; i = i + 1) begin : S

		reg [511:0] data;
		reg [223:0] state;
		reg [31:0] t1_p1;

		reg [511:0] data_buf;
		reg [223:0] state_buf;
		reg [31:0] data15_p1, data15_p2, data15_p3, t1;

		if(i == 0) 
		begin

			always @ (posedge clk)
			begin
				data <= i_data;
				state <= i_state[223:0];
				t1_p1 <= i_state[`IDX(7)] + i_data[`IDX(0)] + Ks[`IDX(63)];
			end

		end else
		begin

			always @ (posedge clk)
			begin
				data_buf <= S[i-1].data;
				data[479:0] <= data_buf[511:32];

				data15_p1 <= { S[i-1].data[496:487] ^ S[i-1].data[498:489], {S[i-1].data[486:480], S[i-1].data[511:497]} ^ {S[i-1].data[488:480],S[i-1].data[511:499]} ^ S[i-1].data[511:490] };
				data15_p2 <= data15_p1;														// 1
				data15_p3 <= ( ( i == 1 ) ? ( { S[i-1].data[464:455] ^ S[i-1].data[466:457], {S[i-1].data[454:448], S[i-1].data[479:465]} ^ {S[i-1].data[456:448],S[i-1].data[479:467]} ^ S[i-1].data[479:458] } ) : S[i-1].data15_p2 ) + S[i-1].data[`IDX(9)] + S[i-1].data[`IDX(0)];	// 3

				data[`IDX(15)] <= { data_buf[38:36] ^ data_buf[49:47], {data_buf[35:32], data_buf[63:39]} ^ {data_buf[46:32],data_buf[63:50]} ^ data_buf[63:35] } + data15_p3;

				state_buf <= S[i-1].state;													// 2

				t1 <= `CH( S[i-1].state[`IDX(4)], S[i-1].state[`IDX(5)], S[i-1].state[`IDX(6)] ) + ({S[i-1].state[133:128],S[i-1].state[159:134]} ^ {S[i-1].state[138:128],S[i-1].state[159:139]} ^ {S[i-1].state[152:128],S[i-1].state[159:153]}) + S[i-1].t1_p1;

				state[`IDX(0)] <= `MAJ( state_buf[`IDX(0)], state_buf[`IDX(1)], state_buf[`IDX(2)] ) + ( {state_buf[1:0],state_buf[31:2]} ^ {state_buf[12:0],state_buf[31:13]} ^ {state_buf[21:0],state_buf[31:22]} ) + t1;
				state[`IDX(1)] <= state_buf[`IDX(0)];												// 1
				state[`IDX(2)] <= state_buf[`IDX(1)];												// 1
				state[`IDX(3)] <= state_buf[`IDX(2)];												// 1
				state[`IDX(4)] <= state_buf[`IDX(3)] + t1;											// 2
				state[`IDX(5)] <= state_buf[`IDX(4)];												// 1
				state[`IDX(6)] <= state_buf[`IDX(5)];												// 1

				t1_p1 <= state_buf[`IDX(6)] + data_buf[`IDX(1)] + Ks[`IDX((127-i) & 63)];							// 2
			end
		end
	end

	endgenerate

	reg [31:0] state7, state7_buf;

	always @ (posedge clk)
	begin
		state7_buf <= S[STAGES-1].state[`IDX(6)];
		state7 <= state7_buf;
	end

	assign out[223:0] = S[STAGES].state;
	assign out[255:224] = state7;

endmodule


module sha256_pipe130 (
	input clk,
	input [511:0] data,
	output reg [255:0] hash
);

	wire [255:0] out;	

	sha256_pipe2_base #( .STAGES(64) ) P (
	    .clk(clk),
	    .i_state(256'h5be0cd191f83d9ab9b05688c510e527fa54ff53a3c6ef372bb67ae856a09e667),
	    .i_data(data),
	    .out(out)
	);

	always @ (posedge clk)
	begin
	    hash[`IDX(0)] <= out[`IDX(0)] + 32'h6a09e667;
	    hash[`IDX(1)] <= out[`IDX(1)] + 32'hbb67ae85;
	    hash[`IDX(2)] <= out[`IDX(2)] + 32'h3c6ef372;
	    hash[`IDX(3)] <= out[`IDX(3)] + 32'ha54ff53a;
	    hash[`IDX(4)] <= out[`IDX(4)] + 32'h510e527f;
	    hash[`IDX(5)] <= out[`IDX(5)] + 32'h9b05688c;
	    hash[`IDX(6)] <= out[`IDX(6)] + 32'h1f83d9ab;
	    hash[`IDX(7)] <= out[`IDX(7)] + 32'h5be0cd19;
	end 

endmodule


module sha256_pipe123 (
	input clk,
	input [255:0] state,
	output [31:0] hash
);

	wire [255:0] out;
	reg [31:0] hash_d, hash_q;
	
	assign hash = hash_q;

	reg [31:0] s0_d, s1_d, s2_d, s3_d, s4_d, s5_d, s6_d, s7_d;
	reg [31:0] s8_d, s9_d, s10_d,s11_d,s12_d,s13_d,s14_d,s15_d;
	reg [31:0] s16_d,s17_d,s18_d,s19_d,s20_d,s21_d,s22_d,s23_d;
	reg [31:0] s24_d,s25_d,s26_d,s27_d,s28_d,s29_d,s30_d,s31_d;
	reg [31:0] s32_d,s33_d,s34_d,s35_d,s36_d,s37_d,s38_d,s39_d;
	reg [31:0] s40_d,s41_d,s42_d,s43_d,s44_d,s45_d,s46_d,s47_d;
	reg [31:0] s48_d,s49_d,s50_d,s51_d,s52_d,s53_d,s54_d,s55_d;
	reg [31:0] s56_d,s57_d,s58_d,s59_d,s60_d,s61_d,s62_d,s63_d;
	reg [31:0] s64_d,s65_d,s66_d,s67_d,s68_d,s69_d,s70_d,s71_d;
	reg [31:0] s72_d,s73_d,s74_d,s75_d,s76_d,s77_d,s78_d,s79_d;
	reg [31:0] s80_d,s81_d,s82_d,s83_d,s84_d,s85_d,s86_d,s87_d;
	reg [31:0] s88_d,s89_d,s90_d,s91_d,s92_d,s93_d,s94_d,s95_d;
	reg [31:0] s96_d,s97_d,s98_d,s99_d,s100_d,s101_d,s102_d,s103_d;
	reg [31:0] s104_d,s105_d,s106_d,s107_d,s108_d,s109_d,s110_d,s111_d;
	reg [31:0] s112_d,s113_d,s114_d,s115_d,s116_d,s117_d,s118_d,s119_d;
	reg [31:0] s120_d,s121_d,s122_d,s123_d;
	
	reg [31:0] s0_q, s1_q, s2_q, s3_q, s4_q, s5_q, s6_q, s7_q;
	reg [31:0] s8_q, s9_q, s10_q,s11_q,s12_q,s13_q,s14_q,s15_q;
	reg [31:0] s16_q,s17_q,s18_q,s19_q,s20_q,s21_q,s22_q,s23_q;
	reg [31:0] s24_q,s25_q,s26_q,s27_q,s28_q,s29_q,s30_q,s31_q;
	reg [31:0] s32_q,s33_q,s34_q,s35_q,s36_q,s37_q,s38_q,s39_q;
	reg [31:0] s40_q,s41_q,s42_q,s43_q,s44_q,s45_q,s46_q,s47_q;
	reg [31:0] s48_q,s49_q,s50_q,s51_q,s52_q,s53_q,s54_q,s55_q;
	reg [31:0] s56_q,s57_q,s58_q,s59_q,s60_q,s61_q,s62_q,s63_q;
	reg [31:0] s64_q,s65_q,s66_q,s67_q,s68_q,s69_q,s70_q,s71_q;
	reg [31:0] s72_q,s73_q,s74_q,s75_q,s76_q,s77_q,s78_q,s79_q;
	reg [31:0] s80_q,s81_q,s82_q,s83_q,s84_q,s85_q,s86_q,s87_q;
	reg [31:0] s88_q,s89_q,s90_q,s91_q,s92_q,s93_q,s94_q,s95_q;
	reg [31:0] s96_q,s97_q,s98_q,s99_q,s100_q,s101_q,s102_q,s103_q;
	reg [31:0] s104_q,s105_q,s106_q,s107_q,s108_q,s109_q,s110_q,s111_q;
	reg [31:0] s112_q,s113_q,s114_q,s115_q,s116_q,s117_q,s118_q,s119_q;
	reg [31:0] s120_q,s121_q,s122_q,s123_q;

	sha256_pipe2_base #( .STAGES(61) ) P (
	    .clk(clk),
	    .i_state(state),
	    .i_data(512'h00000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080000000),
	    .out(out)
	);

	always @ (*) begin

		s122_d <= s121_q;
		s121_d <= s120_q;
		s120_d <= s119_q;
		s119_d <= s118_q;
		s118_d <= s117_q;
		s117_d <= s116_q;
		s116_d <= s115_q;
		s115_d <= s114_q;
		s114_d <= s113_q;
		s113_d <= s112_q;
		s112_d <= s111_q;
		s111_d <= s110_q;
		s110_d <= s109_q;
		s109_d <= s108_q;
		s108_d <= s107_q;
		s107_d <= s106_q;
		s106_d <= s105_q;
		s105_d <= s104_q;
		s104_d <= s103_q;
		s103_d <= s102_q;
		s102_d <= s101_q;
		s101_d <= s100_q;
		s100_d <= s99_q;
		s99_d <= s98_q;
		s98_d <= s97_q;
		s97_d <= s96_q;
		s96_d <= s95_q;
		s95_d <= s94_q;
		s94_d <= s93_q;
		s93_d <= s92_q;
		s92_d <= s91_q;
		s91_d <= s90_q;
		s90_d <= s89_q;
		s89_d <= s88_q;
		s88_d <= s87_q;
		s87_d <= s86_q;
		s86_d <= s85_q;
		s85_d <= s84_q;
		s84_d <= s83_q;
		s83_d <= s82_q;
		s82_d <= s81_q;
		s81_d <= s80_q;
		s80_d <= s79_q;
		s79_d <= s78_q;
		s78_d <= s77_q;
		s77_d <= s76_q;
		s76_d <= s75_q;
		s75_d <= s74_q;
		s74_d <= s73_q;
		s73_d <= s72_q;
		s72_d <= s71_q;
		s71_d <= s70_q;
		s70_d <= s69_q;
		s69_d <= s68_q;
		s68_d <= s67_q;
		s67_d <= s66_q;
		s66_d <= s65_q;
		s65_d <= s64_q;
		s64_d <= s63_q;
		s63_d <= s62_q;
		s62_d <= s61_q;
		s61_d <= s60_q;
		s60_d <= s59_q;
		s59_d <= s58_q;
		s58_d <= s57_q;
		s57_d <= s56_q;
		s56_d <= s55_q;
		s55_d <= s54_q;
		s54_d <= s53_q;
		s53_d <= s52_q;
		s52_d <= s51_q;
		s51_d <= s50_q;
		s50_d <= s49_q;
		s49_d <= s48_q;
		s48_d <= s47_q;
		s47_d <= s46_q;
		s46_d <= s45_q;
		s45_d <= s44_q;
		s44_d <= s43_q;
		s43_d <= s42_q;
		s42_d <= s41_q;
		s41_d <= s40_q;
		s40_d <= s39_q;
		s39_d <= s38_q;
		s38_d <= s37_q;
		s37_d <= s36_q;
		s36_d <= s35_q;
		s35_d <= s34_q;
		s34_d <= s33_q;
		s33_d <= s32_q;
		s32_d <= s31_q;
		s31_d <= s30_q;
		s30_d <= s29_q;
		s29_d <= s28_q;
		s28_d <= s27_q;
		s27_d <= s26_q;
		s26_d <= s25_q;
		s25_d <= s24_q;
		s24_d <= s23_q;
		s23_d <= s22_q;
		s22_d <= s21_q;
		s21_d <= s20_q;
		s20_d <= s19_q;
		s19_d <= s18_q;
		s18_d <= s17_q;
		s17_d <= s16_q;
		s16_d <= s15_q;
		s15_d <= s14_q;
		s14_d <= s13_q;
		s13_d <= s12_q;
		s12_d <= s11_q;
		s11_d <= s10_q;
		s10_d <= s9_q;
		s9_d <= s8_q;
		s8_d <= s7_q;
		s7_d <= s6_q;
		s6_d <= s5_q;
		s5_d <= s4_q;
		s4_d <= s3_q;
		s3_d <= s2_q;
		s2_d <= s1_q;
		s1_d <= s0_q;
		s0_d <= state[255:224];
		
		
		hash_d <= out[`IDX(4)] + s122_q;

	end

	always @ (posedge clk) begin
	
		s122_q <= s122_d;
		s121_q <= s121_d;
		s120_q <= s120_d;
		s119_q <= s119_d;
		s118_q <= s118_d;
		s117_q <= s117_d;
		s116_q <= s116_d;
		s115_q <= s115_d;
		s114_q <= s114_d;
		s113_q <= s113_d;
		s112_q <= s112_d;
		s111_q <= s111_d;
		s110_q <= s110_d;
		s109_q <= s109_d;
		s108_q <= s108_d;
		s107_q <= s107_d;
		s106_q <= s106_d;
		s105_q <= s105_d;
		s104_q <= s104_d;
		s103_q <= s103_d;
		s102_q <= s102_d;
		s101_q <= s101_d;
		s100_q <= s100_d;
		s99_q <= s99_d;
		s98_q <= s98_d;
		s97_q <= s97_d;
		s96_q <= s96_d;
		s95_q <= s95_d;
		s94_q <= s94_d;
		s93_q <= s93_d;
		s92_q <= s92_d;
		s91_q <= s91_d;
		s90_q <= s90_d;
		s89_q <= s89_d;
		s88_q <= s88_d;
		s87_q <= s87_d;
		s86_q <= s86_d;
		s85_q <= s85_d;
		s84_q <= s84_d;
		s83_q <= s83_d;
		s82_q <= s82_d;
		s81_q <= s81_d;
		s80_q <= s80_d;
		s79_q <= s79_d;
		s78_q <= s78_d;
		s77_q <= s77_d;
		s76_q <= s76_d;
		s75_q <= s75_d;
		s74_q <= s74_d;
		s73_q <= s73_d;
		s72_q <= s72_d;
		s71_q <= s71_d;
		s70_q <= s70_d;
		s69_q <= s69_d;
		s68_q <= s68_d;
		s67_q <= s67_d;
		s66_q <= s66_d;
		s65_q <= s65_d;
		s64_q <= s64_d;
		s63_q <= s63_d;
		s62_q <= s62_d;
		s61_q <= s61_d;
		s60_q <= s60_d;
		s59_q <= s59_d;
		s58_q <= s58_d;
		s57_q <= s57_d;
		s56_q <= s56_d;
		s55_q <= s55_d;
		s54_q <= s54_d;
		s53_q <= s53_d;
		s52_q <= s52_d;
		s51_q <= s51_d;
		s50_q <= s50_d;
		s49_q <= s49_d;
		s48_q <= s48_d;
		s47_q <= s47_d;
		s46_q <= s46_d;
		s45_q <= s45_d;
		s44_q <= s44_d;
		s43_q <= s43_d;
		s42_q <= s42_d;
		s41_q <= s41_d;
		s40_q <= s40_d;
		s39_q <= s39_d;
		s38_q <= s38_d;
		s37_q <= s37_d;
		s36_q <= s36_d;
		s35_q <= s35_d;
		s34_q <= s34_d;
		s33_q <= s33_d;
		s32_q <= s32_d;
		s31_q <= s31_d;
		s30_q <= s30_d;
		s29_q <= s29_d;
		s28_q <= s28_d;
		s27_q <= s27_d;
		s26_q <= s26_d;
		s25_q <= s25_d;
		s24_q <= s24_d;
		s23_q <= s23_d;
		s22_q <= s22_d;
		s21_q <= s21_d;
		s20_q <= s20_d;
		s19_q <= s19_d;
		s18_q <= s18_d;
		s17_q <= s17_d;
		s16_q <= s16_d;
		s15_q <= s15_d;
		s14_q <= s14_d;
		s13_q <= s13_d;
		s12_q <= s12_d;
		s11_q <= s11_d;
		s10_q <= s10_d;
		s9_q <= s9_d;
		s8_q <= s8_d;
		s7_q <= s7_d;
		s6_q <= s6_d;
		s5_q <= s5_d;
		s4_q <= s4_d;
		s3_q <= s3_d;
		s2_q <= s2_d;
		s1_q <= s1_d;
		s0_q <= s0_d;
		
		hash_q <= { hash_d[7:0], hash_d[15:8], hash_d[23:16], hash_d[31:24] };

	end

endmodule
