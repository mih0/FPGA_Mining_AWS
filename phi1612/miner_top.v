// Amazon FPGA Hardware Development Kit
//
// Copyright 2016 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//
// Licensed under the Amazon Software License (the "License"). You may not use
// this file except in compliance with the License. A copy of the License is
// located at
//
//    http://aws.amazon.com/asl/
//
// or in the "license" file accompanying this file. This file is distributed on
// an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, express or
// implied. See the License for the specific language governing permissions and
// limitations under the License.

module cl_miner

(
   `include "cl_ports.vh" // Fixed port definition

);

`include "cl_common_defines.vh"      // CL Defines for all examples
`include "cl_id_defines.vh"          // Defines for ID0 and ID1 (PCI ID's)
`include "cl_miner_defines.vh"       // CL Defines for cl_miner

logic rst_main_n_sync;


//--------------------------------------------0
// Start with Tie-Off of Unused Interfaces
//---------------------------------------------
// the developer should use the next set of `include
// to properly tie-off any unused interface
// The list is put in the top of the module
// to avoid cases where developer may forget to
// remove it from the end of the file

`include "unused_flr_template.inc"
`include "unused_ddr_a_b_d_template.inc"
`include "unused_ddr_c_template.inc"
`include "unused_pcim_template.inc"
`include "unused_dma_pcis_template.inc"
`include "unused_cl_sda_template.inc"
`include "unused_sh_bar1_template.inc"
`include "unused_apppf_irq_template.inc"

//-------------------------------------------------
// Wires
//-------------------------------------------------
  logic        arvalid_q;
  logic [31:0] araddr_q;

//-------------------------------------------------
// ID Values (cl_miner_defines.vh)
//-------------------------------------------------
  assign cl_sh_id0[31:0] = `CL_SH_ID0;
  assign cl_sh_id1[31:0] = `CL_SH_ID1;

//-------------------------------------------------
// Reset Synchronization
//-------------------------------------------------
logic pre_sync_rst_n;

always @(negedge rst_main_n or posedge clk_main_a0)
   if (!rst_main_n)
   begin
      pre_sync_rst_n  <= 0;
      rst_main_n_sync <= 0;
   end
   else
   begin
      pre_sync_rst_n  <= 1;
      rst_main_n_sync <= pre_sync_rst_n;
   end

//-------------------------------------------------
// PCIe OCL AXI-L (SH to CL) Timing Flops
//-------------------------------------------------

  // Write address                                                                                                              
  logic        sh_ocl_awvalid_q;
  logic [31:0] sh_ocl_awaddr_q;
  logic        ocl_sh_awready_q;
                                                                                                                              
  // Write data                                                                                                                
  logic        sh_ocl_wvalid_q;
  logic [31:0] sh_ocl_wdata_q;
  logic [ 3:0] sh_ocl_wstrb_q;
  logic        ocl_sh_wready_q;
                                                                                                                              
  // Write response                                                                                                            
  logic        ocl_sh_bvalid_q;
  logic [ 1:0] ocl_sh_bresp_q;
  logic        sh_ocl_bready_q;
                                                                                                                              
  // Read address                                                                                                              
  logic        sh_ocl_arvalid_q;
  logic [31:0] sh_ocl_araddr_q;
  logic        ocl_sh_arready_q;
                                                                                                                              
  // Read data/response                                                                                                        
  logic        ocl_sh_rvalid_q;
  logic [31:0] ocl_sh_rdata_q;
  logic [ 1:0] ocl_sh_rresp_q;
  logic        sh_ocl_rready_q;

  axi_register_slice_light AXIL_OCL_REG_SLC (
   .aclk          (clk_main_a0),
   .aresetn       (rst_main_n_sync),
   .s_axi_awaddr  (sh_ocl_awaddr),
   .s_axi_awprot   (2'h0),
   .s_axi_awvalid (sh_ocl_awvalid),
   .s_axi_awready (ocl_sh_awready),
   .s_axi_wdata   (sh_ocl_wdata),
   .s_axi_wstrb   (sh_ocl_wstrb),
   .s_axi_wvalid  (sh_ocl_wvalid),
   .s_axi_wready  (ocl_sh_wready),
   .s_axi_bresp   (ocl_sh_bresp),
   .s_axi_bvalid  (ocl_sh_bvalid),
   .s_axi_bready  (sh_ocl_bready),
   .s_axi_araddr  (sh_ocl_araddr),
   .s_axi_arvalid (sh_ocl_arvalid),
   .s_axi_arready (ocl_sh_arready),
   .s_axi_rdata   (ocl_sh_rdata),
   .s_axi_rresp   (ocl_sh_rresp),
   .s_axi_rvalid  (ocl_sh_rvalid),
   .s_axi_rready  (sh_ocl_rready),
   .m_axi_awaddr  (sh_ocl_awaddr_q),
   .m_axi_awprot  (),
   .m_axi_awvalid (sh_ocl_awvalid_q),
   .m_axi_awready (ocl_sh_awready_q),
   .m_axi_wdata   (sh_ocl_wdata_q),
   .m_axi_wstrb   (sh_ocl_wstrb_q),
   .m_axi_wvalid  (sh_ocl_wvalid_q),
   .m_axi_wready  (ocl_sh_wready_q),
   .m_axi_bresp   (ocl_sh_bresp_q),
   .m_axi_bvalid  (ocl_sh_bvalid_q),
   .m_axi_bready  (sh_ocl_bready_q),
   .m_axi_araddr  (sh_ocl_araddr_q),
   .m_axi_arvalid (sh_ocl_arvalid_q),
   .m_axi_arready (ocl_sh_arready_q),
   .m_axi_rdata   (ocl_sh_rdata_q),
   .m_axi_rresp   (ocl_sh_rresp_q),
   .m_axi_rvalid  (ocl_sh_rvalid_q),
   .m_axi_rready  (sh_ocl_rready_q)
  );

//--------------------------------------------------------------
// PCIe OCL AXI-L Slave Accesses (accesses from PCIe AppPF BAR0)
//--------------------------------------------------------------
// Only supports single-beat accesses.

   logic        awvalid;
   logic [31:0] awaddr;
   logic        wvalid;
   logic [31:0] wdata;
   logic [3:0]  wstrb;
   logic        bready;
   logic        arvalid;
   logic [31:0] araddr;
   logic        rready;

   logic        awready;
   logic        wready;
   logic        bvalid;
   logic [1:0]  bresp;
   logic        arready;
   logic        rvalid;
   logic [31:0] rdata;
   logic [1:0]  rresp;

   // Inputs
   assign awvalid         = sh_ocl_awvalid_q;
   assign awaddr[31:0]    = sh_ocl_awaddr_q;
   assign wvalid          = sh_ocl_wvalid_q;
   assign wdata[31:0]     = sh_ocl_wdata_q;
   assign wstrb[3:0]      = sh_ocl_wstrb_q;
   assign bready          = sh_ocl_bready_q;
   assign arvalid         = sh_ocl_arvalid_q;
   assign araddr[31:0]    = sh_ocl_araddr_q;
   assign rready          = sh_ocl_rready_q;

   // Outputs
   assign ocl_sh_awready_q = awready;
   assign ocl_sh_wready_q  = wready;
   assign ocl_sh_bvalid_q  = bvalid;
   assign ocl_sh_bresp_q   = bresp[1:0];
   assign ocl_sh_arready_q = arready;
   assign ocl_sh_rvalid_q  = rvalid;
   assign ocl_sh_rdata_q   = rdata;
   assign ocl_sh_rresp_q   = rresp[1:0];

// Write Request
logic        wr_active;
logic [31:0] wr_addr;

always @(posedge clk_main_a0)
  if (!rst_main_n_sync) begin
     wr_active <= 0;
     wr_addr   <= 0;
  end
  else begin
     wr_active <=  wr_active && bvalid  && bready ? 1'b0     :
                  ~wr_active && awvalid           ? 1'b1     :
                                                    wr_active;
     wr_addr <= awvalid && ~wr_active ? awaddr : wr_addr     ;
  end

assign awready = ~wr_active;
assign wready  =  wr_active && wvalid;

// Write Response
always @(posedge clk_main_a0)
  if (!rst_main_n_sync) 
    bvalid <= 0;
  else
    bvalid <=  bvalid &&  bready           ? 1'b0  : 
                         ~bvalid && wready ? 1'b1  :
                                             bvalid;
assign bresp = 0;

// Read Request
always @(posedge clk_main_a0)
   if (!rst_main_n_sync) begin
      arvalid_q <= 0;
      araddr_q  <= 0;
   end
   else begin
      arvalid_q <= arvalid;
      araddr_q  <= arvalid ? araddr : araddr_q;
   end

assign arready = !arvalid_q && !rvalid;


//
// BEGIN MINER CODE
//   

	reg new_block = 1'b0;
	reg [639:0] block = 640'd0;
	reg [31:0] result = 32'h00000000;

	// Read Response
	always @(posedge clk_main_a0)
		if (!rst_main_n_sync)
		begin
			rvalid <= 0;
			rdata  <= 0;
			rresp  <= 0;
		end
		else if (rvalid && rready)
		begin
			rvalid <= 0;
			rdata  <= 0;
			rresp  <= 0;
		end
		else if (arvalid_q) 
		begin
			rvalid <= 1;

		if (araddr_q == 32'h00000554)
			rdata <= result;
		else
			rdata <= 32'hFFFFFFFF;

		rresp  <= 0;
	end
	
	// Copy Value From PCIe Register Into Block Register
	always @(posedge clk_main_a0) begin

		if (!rst_main_n_sync) begin		// Reset
			block <= 640'd0;
			new_block <= 1'b0;
		end
		else if ( wready ) begin
			case(wr_addr)
				32'h00000504 : block[639:608] <= wdata[31:0];
				32'h00000508 : block[607:576] <= wdata[31:0];
				32'h0000050C : block[575:544] <= wdata[31:0];
				32'h00000510 : block[543:512] <= wdata[31:0];
				32'h00000514 : block[511:480] <= wdata[31:0];
				32'h00000518 : block[479:448] <= wdata[31:0];
				32'h0000051C : block[447:416] <= wdata[31:0];
				32'h00000520 : block[415:384] <= wdata[31:0];
				32'h00000524 : block[383:352] <= wdata[31:0];
				32'h00000528 : block[351:320] <= wdata[31:0];
				32'h0000052C : block[319:288] <= wdata[31:0];
				32'h00000530 : block[287:256] <= wdata[31:0];
				32'h00000534 : block[255:224] <= wdata[31:0];
				32'h00000538 : block[223:192] <= wdata[31:0];
				32'h0000053C : block[191:160] <= wdata[31:0];
				32'h00000540 : block[159:128] <= wdata[31:0];
				32'h00000544 : block[127: 96] <= wdata[31:0];
				32'h00000548 : block[ 95: 64] <= wdata[31:0];
				32'h0000054C : block[ 63: 32] <= wdata[31:0];
				32'h00000550 : block[ 31:  0] <= wdata[31:0];
				default : block <= block;						// Do Nothing
			endcase

			// Trigger Miner To Start On New Block
			if ( wr_addr == 32'h00000550 ) begin
				new_block <= 1'b1;
			end
			else begin
				new_block <= 1'b0;
			end

		end
		else begin
			block <= block;
			new_block <= 1'b0;
		end

	end

	wire [31:0] nonce1;
	wire nonce_found1;

	miner # (.CORES(1)) m1 (
//		.clk(clk_extra_c0),
		.clk(clk_main_a0),
		.reset(new_block),
		.block(block),
		.nonce_start(32'd0),
		.nonce_found(nonce_found1),
		.nonce_out(nonce1)
	);


//	always @(posedge clk_extra_c0) begin
	always @(posedge clk_main_a0) begin

		if (!rst_main_n_sync) begin
			result <= 32'h00000000;
		end
		else if ( nonce_found1 ) begin
			result <= nonce1;
		end
		else begin
			result <= result;
		end

	end

//
// END MINER CODE
//

//-------------------------------------------
// Tie-Off Global Signals
//-------------------------------------------
`ifndef CL_VERSION
   `define CL_VERSION 32'hee_ee_ee_00
`endif  

  assign cl_sh_status0[31:0] =  32'h0000_0FF0;
  assign cl_sh_status1[31:0] = `CL_VERSION;
  
endmodule
