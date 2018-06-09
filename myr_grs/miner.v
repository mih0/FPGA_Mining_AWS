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

	localparam OFFSET = 32'd341;

	wire [511:0] hash1;
	wire [255:0] hash2;
	wire [31:0] hash3;
	
	reg reset_d, reset_q;
	reg [607:0] block_d, block_q;
	reg [31:0] target_d, target_q;
	reg [31:0] nonce_d, nonce_q;
	reg [31:0] nonce_out_d, nonce_out_q;
	reg nonce_found_d, nonce_found_q;
	
	reg [511:0] hash1_d, hash1_q;
	reg [255:0] hash2_d, hash2_q;
	
	assign nonce_found = nonce_found_q;
	assign nonce_out = nonce_out_q;
	
	grostl512 grostl ( clk, block_q, nonce_q, hash1 );
	sha256_pipe130 sha256_1 ( clk, hash1_q, hash2 );
	sha256_pipe123 sha256_2 ( clk, hash2_q, hash3 );

	always @ ( * ) begin

		if ( reset_q ) begin

			block_d <= block[639:32];
			target_d <= block[31:0];
			
			nonce_d <= nonce_start;

			nonce_found_d <= 1'b0;
			nonce_out_d <= 32'd0;

		end
		else begin

			block_d <= block_q;
			target_d <= target_q;
			nonce_d <= nonce_q + CORES;

			nonce_out_d <= nonce_q - (CORES * OFFSET);

			if ( hash3 <= target_d )
				nonce_found_d <= 1'b1;
			else
				nonce_found_d <= 1'b0;
		
		end

		hash1_d <= hash1;
		hash2_d <= hash2;

		reset_d <= reset;
		
	end

	always @ (posedge clk) begin

		block_q <= block_d;
		target_q <= target_d;
		
		nonce_q <= nonce_d;
		nonce_out_q <= nonce_out_d;

		nonce_found_q <= nonce_found_d;
		
		hash1_q <= hash1_d;
		hash2_q <= hash2_d;

		reset_q <= reset_d;
		
		$display("Hash: %x", hash3);
		
	end

endmodule
