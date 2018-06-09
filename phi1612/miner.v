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

module miner # (
	parameter CORES = 32'd1
 ) (
	input clk,
	input reset,
	input [639:0] block,
	input [31:0] nonce_start,
	output nonce_found,
	output [31:0] nonce_out
 );

	localparam OFFSET = 32'd635;

	wire [511:0] hash1, hash2, hash3, hash4, hash5;
	wire [31:0] hash6;

	reg [511:0] midstate_d, midstate_q;
	reg [95:0] data_d, data_q;
	reg [31:0] target_d, target_q;
	reg [31:0] nonce_d, nonce_q;
	reg [31:0] nonce_out_d, nonce_out_q;
	reg nonce_found_d, nonce_found_q;
	reg reset_d, reset_q;

	reg [511:0] hash1_d, hash1_q, hash2_d, hash2_q, hash3_d, hash3_q, hash4_d, hash4_q, hash5_d, hash5_q;
	reg [31:0] hash6_d, hash6_q;
	
	reg phase_d = 1'b0, phase_q = 1'b0;
	
	assign nonce_found = nonce_found_q;
	assign nonce_out = nonce_out_q;

	skein512 skein ( clk, midstate_q, data_q, nonce_q, hash1 );
	JH512 jh ( clk, hash1_q, hash2 );
	cube512 cube ( clk, hash2_q, hash3 );
	fugue512 fugue ( clk, hash3_q, hash4 );
	gost512 gost ( clk, hash4_q, hash5 );
	echo512 echo ( clk, hash5_q, hash6 );

	always @ (*) begin
	
		phase_d <= ~phase_q;

		if ( reset_q ) begin

			nonce_d <= nonce_start;
			nonce_out_d <= nonce_start - (CORES * OFFSET);

			nonce_found_d <= 1'b0;

		end
		else begin

			if ( phase_q ) begin
				nonce_d <= nonce_q + CORES;
				nonce_out_d <= nonce_out_q + CORES;

				if ( hash6_q <= target_q )
					nonce_found_d <= 1'b1;
				else
					nonce_found_d <= 1'b0;
			end
			else begin
				nonce_d <= nonce_q;
				nonce_out_d <= nonce_out_q;

				nonce_found_d <= 1'b0;
			end

		end

		hash1_d <= hash1;
		hash2_d <= hash2;
		hash3_d <= hash3;
		hash4_d <= hash4;
		hash5_d <= hash5;
		hash6_d <= hash6;
		reset_d <= reset;

		midstate_d <= block[639:128];
		data_d <= block[127:32];
		target_d <= block[31:0];    

		reset_d <= reset;

	end

	always @ (posedge clk) begin

		phase_q <= phase_d;

		midstate_q <= midstate_d;
		data_q <= data_d;
		target_q <= target_d;

		nonce_q <= nonce_d;
		nonce_out_q <= nonce_out_d;

		hash1_q <= hash1_d;
		hash2_q <= hash2_d;
		hash3_q <= hash3_d;
		hash4_q <= hash4_d;
		hash5_q <= hash5_d;
		hash6_q <= hash6_d;

		nonce_found_q <= nonce_found_d;

		reset_q <= reset_d;

		$display ("Nonce: %X, Hash: %X, Found: %d", nonce_out_d, hash6_q, nonce_found_d);
//		$display ("   H1: %x", hash1);
//		$display ("   H2: %x", hash2);
//		$display ("   H3: %x", hash3);
//		$display ("   H4: %x", hash4);
//		$display ("   H5: %x", hash5);
//		$display ("   H6: %x", hash6);

	end

endmodule
