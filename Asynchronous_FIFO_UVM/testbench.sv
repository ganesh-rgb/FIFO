`include "uvm_pkg.sv"

import uvm_pkg::*;

typedef class fifo_env;
typedef class fifo_wagent;
typedef class fifo_ragent;
typedef class fifo_wdrv;
typedef class fifo_rdrv;
typedef class fifo_wsqr;
typedef class fifo_rsqr;
typedef class fifo_wbase_wseq;
typedef class fifo_rbase_rseq;
typedef class fifo_wmon;
typedef class fifo_rmon;
typedef class fifo_wcov;
typedef class fifo_rcov;
typedef class fifo_wtx;
typedef class fifo_rtx;

`include "fifo_wif.sv"
`include "fifo_rif.sv"
`include "fifo_wtx.sv"
`include "fifo_rtx.sv"
`include "fifo_wcov.sv"
`include "fifo_rcov.sv"
`include "fifo_wmon.sv"
`include "fifo_rmon.sv"
`include "fifo_wseq.sv"
`include "fifo_rseq.sv"
`include "fifo_wsqr.sv"
`include "fifo_rsqr.sv"
`include "fifo_wdrv.sv"
`include "fifo_rdrv.sv"
`include "fifo_wagent.sv"
`include "fifo_ragent.sv"
`include "fifo_env.sv"
`include "fifo_test.sv"
`include "design.sv"

  module testbench();
	
	bit wclk,rclk,rst;

	fifo_wif wpif(wclk,rst);
	fifo_rif rpif(rclk,rst);

	async_fifo dut(.wr_clk(wpif.wclk),
				   .rd_clk(rpif.rclk),
				   .rst(wpif.rst),
				   .wr_en(wpif.wwr_en),
				   .rd_en(rpif.rrd_en),
				   .wdata(wpif.wwdata),
				   .rdata(rpif.rrdata),
				   .full(wpif.wfull),
				   .empty(rpif.rempty),
				   .wr_err(wpif.wwr_err),
				   .rd_err(rpif.rrd_err)
				  );

	initial begin
		uvm_resource_db#(virtual fifo_wif)::set("GLOBAL","VIF",wpif,null);
		uvm_config_db#(virtual fifo_rif)::set(null,"*","vif",rpif);
				run_test("fifo_base_test");
	end

	initial begin
		wclk=0;
		rclk=0;
		rst=1;
		repeat(2) @(posedge wclk or posedge rclk);
		rst=0;
	end

	always #5 wclk=~wclk;

	always #10 rclk=~rclk;

endmodule

