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
 
    localparam OFFSET = 32'd172;

	wire [511:0] hash1;
    wire [511:0] hash2;
    
    reg reset_d, reset_q;
    reg [647:0] block0_d, block0_q;
    reg [647:0] block1_d, block1_q;
    reg [31:0] target_d, target_q;
    reg [31:0] nonce_d, nonce_q;
    reg [31:0] nonce_out_d, nonce_out_q;
    reg [31:0] hash_out_d, hash_out_q;
    reg nonce_found_d, nonce_found_q;
    
    assign nonce_found = nonce_found_q;
    assign nonce_out = nonce_out_q;
    
    groestl512 groestl_1 ( clk, block0_q, hash1 );
    groestl512 groestl_2 ( clk, block1_q, hash2 );
    
    always @ ( * ) begin
    
        if ( reset_q ) begin
    
            nonce_d = nonce_start;
    
            nonce_found_d = 1'b0;
            nonce_out_d = 32'd0;
            hash_out_d = 32'd0;
    
        end
        else begin
    
            nonce_d = nonce_q + CORES;
    
            nonce_out_d = nonce_q - (CORES * OFFSET);
            hash_out_d = { hash2[263:256], hash2[271:264], hash2[279:272], hash2[287:280] };
    
            if ( hash_out_d <= target_d )
                nonce_found_d = 1'b1;
            else
                nonce_found_d = 1'b0;
        
        end
    
        block0_d = { block[639:32], nonce_q, 8'h80 };
        block1_d = { hash1, 8'h80, 128'd0 };
        target_d = block[31:0];    
    
        reset_d = reset;
        
    end
    
    always @ (posedge clk) begin
    
        block0_q <= block0_d;
        block1_q <= block1_d;
        target_q <= target_d;
        
        nonce_q <= nonce_d;
        nonce_out_q <= nonce_out_d;
        hash_out_q <= hash_out_d;
    
        nonce_found_q <= nonce_found_d;
    
        reset_q <= reset_d;
        
 //        $display ("Hash1 : %x", hash1);
 //        $display ("Hash2 : %x", hash2);
        $display("Nonce: %x, Hash: %x, Found: %d", nonce_out_d, hash_out_d, nonce_found_d );
        
    end

endmodule
