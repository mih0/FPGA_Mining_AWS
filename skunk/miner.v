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

	localparam OFFSET = 32'd733;

	wire [511:0] hash1, hash2, hash3, hash4;

	reg [511:0] midstate_d, midstate_q;
	reg [95:0] data_d, data_q;
	reg [31:0] target_d, target_q;
	reg [31:0] nonce_d, nonce_q;
	reg [31:0] nonce_out_d, nonce_out_q;
	reg nonce_found_d, nonce_found_q;
	reg reset_d, reset_q;

	reg [511:0] hash1_d, hash1_q, hash2_d, hash2_q, hash3_d, hash3_q;
	reg [31:0] hash4_d, hash4_q;
	
	assign nonce_found = nonce_found_q;
	assign nonce_out = nonce_out_q;

	skein512 skein ( clk, midstate_q, data_q, nonce_q, hash1 );
	cube512 cube ( clk, hash1_q, hash2 );
	fugue512 fugue ( clk, hash2_q, hash3 );
	gost512 gost ( clk, hash3_q, hash4 );

	always @ (*) begin

		if ( reset_q ) begin

			nonce_d <= nonce_start;
			nonce_out_d <= nonce_start - (CORES * OFFSET);

			nonce_found_d <= 1'b0;

		end
		else begin

			nonce_d <= nonce_q + CORES;
			nonce_out_d <= nonce_out_q + CORES;

			if ( hash4_q <= target_q )
				nonce_found_d <= 1'b1;
			else
				nonce_found_d <= 1'b0;

		end

		midstate_d <= block[639:128];
		data_d <= block[127:32];
		target_d <= block[31:0];    

		hash1_d <= hash1;
		hash2_d <= hash2;
		hash3_d <= hash3;
		hash4_d <= hash4[287:256];
		reset_d <= reset;

	end

	always @ (posedge clk) begin

		midstate_q <= midstate_d;
		data_q <= data_d;
		target_q <= target_d;

		nonce_q <= nonce_d;
		nonce_out_q <= nonce_out_d;

		hash1_q <= hash1_d;
		hash2_q <= hash2_d;
		hash3_q <= hash3_d;
		hash4_q <= hash4_d;

		nonce_found_q <= nonce_found_d;

		reset_q <= reset_d;

		$display ("Nonce: %X, Hash: %X, Found: %d", nonce_out_d, hash4_q, nonce_found_d);
//		$display ("   H1: %x", hash1);
//		$display ("   H2: %x", hash2);
//		$display ("   H3: %x", hash3);
//		$display ("   H4: %x", hash4[511:256]);

	end

endmodule
