
module Async_fifo(wr_clk_i,rd_clk_i,reset_i,wdata_i,rdata_o,wr_en_i,rd_en_i,empty_o,full_o,error_o);
//fifo parameters.........
parameter DEPTH=16;
parameter WIDTH=4;
parameter ADDR_WIDTH=$clog2(DEPTH);
//input output(or signal declaration)......
input wr_clk_i,rd_clk_i,reset_i,wr_en_i,rd_en_i;
input [WIDTH-1:0]wdata_i;
output reg empty_o,full_o,error_o;
output reg [WIDTH-1:0]rdata_o;

reg [ADDR_WIDTH-1:0]wr_ptr;
reg [ADDR_WIDTH-1:0]rd_ptr;
reg [ADDR_WIDTH-1:0]wr_ptr_rd_clk;
reg [ADDR_WIDTH-1:0]rd_ptr_wr_clk;
reg wr_toggle_f;
reg rd_toggle_f;
reg wr_toggle_f_rd_clk;
reg rd_toggle_f_wr_clk;
reg[WIDTH-1:0]fifo[DEPTH-1:0];//fifo declaration
integer i;
//---asynchronous fifo write_clock---
always@(posedge wr_clk_i)begin//write operation
	if(reset_i==1)begin
		full_o=0;
		empty_o=1;
		error_o=0;
		rdata_o=0;
		wr_ptr=0;
		rd_ptr=0;
		wr_toggle_f=0;
		rd_toggle_f=0;
		wr_ptr_rd_clk=0;
		rd_ptr_wr_clk=0;
		rd_toggle_f_wr_clk=0;
		wr_toggle_f_rd_clk=0;
		for(i=0;i<DEPTH;i=i+1)begin //to initialize fifo
			fifo[i]=0;
		end
	end
	else begin
		if(wr_en_i==1)begin
			if(full_o==0)begin
				error_o=0;
				fifo[wr_ptr]=wdata_i;//wdata will be assigned to the location where write pointer
				if(wr_ptr==DEPTH-1)begin
					wr_ptr=0;
					wr_toggle_f=~wr_toggle_f;
				end
				else begin
					wr_ptr=wr_ptr+1;
				end
			end
			else begin
				error_o=1;
			end
		end
	end
end
//--------for read_clock_logic-------
always@(posedge rd_clk_i)begin
	if(reset_i==1)begin
	end
	else begin
		if(rd_en_i==1)begin
			if(empty_o==0)begin
				error_o=0;
				rdata_o=fifo[rd_ptr];
				if(rd_ptr==DEPTH-1)begin
					rd_ptr=0;
					rd_toggle_f=~rd_toggle_f;
				end
				else begin
					rd_ptr=rd_ptr+1;
				end
			end
			else begin
				error_o=1;
			end
		end
	end
end
//-----for synchronization of two clock-----
always@(posedge wr_clk_i)begin//read pointer and read toggle flag should be synchronized
	rd_ptr_wr_clk<=rd_ptr;
	rd_toggle_f_wr_clk<=rd_toggle_f;
end
always@(posedge rd_clk_i)begin//write pointer and write toggle flag should be synchronized

	wr_ptr_rd_clk<=wr_ptr;
	wr_toggle_f_rd_clk<=wr_toggle_f;
end

always@(*)begin
	full_o=0;
	empty_o=0;
	//---check the status of full and empty condition
	if(wr_ptr_rd_clk==rd_ptr && wr_toggle_f_rd_clk==rd_toggle_f)begin
		empty_o=1;	
	end
	if(wr_ptr==rd_ptr_wr_clk && wr_toggle_f!=rd_toggle_f_wr_clk)begin
		full_o=1;	
	end
end
endmodule

//`timescale 1ns/1ps
//`include "async_fifo.v"
module testbench;
parameter DEPTH=16;
parameter WIDTH=4;
parameter ADDR_WIDTH=$clog2(DEPTH);
reg wr_clk_i,rd_clk_i,reset_i,wr_en_i,rd_en_i;
reg [WIDTH-1:0]wdata_i;
wire empty_o,full_o,error_o;
wire [WIDTH-1:0]rdata_o;
//reg [ADDR_WIDTH-1:0]wr_ptr;//these signals are internal signals, need not to declare inside portlist
//reg [ADDR_WIDTH-1:0]rd_ptr;
//reg wr_toggle_f;
//reg rd_toggle_f;
//reg[WIDTH-1:0]fifo[DEPTH-1:0];
integer i;
Async_fifo dut(.WIDTH(WIDTH),.DEPTH(DEPTH),.ADDR_WIDTH(ADDR_WIDTH)) ;
//---------we need to generate two clock one for write block and another for read block------
initial begin
	wr_clk_i=0;
	forever #10 wr_clk_i=~wr_clk_i;
end
initial begin
	rd_clk_i=0;
	forever #15 rd_clk_i=~rd_clk_i;
end
initial begin
	reset_i=1;
	wr_en_i=0;
	rd_en_i=0;
	wdata_i=0;
	#20;
	reset_i=0;
	for(i=0;i<=DEPTH;i=i+1)begin
		@(posedge wr_clk_i)
		wdata_i=$random;
		wr_en_i=1;
	end
		wdata_i=0;
		wr_en_i=0;
	for(i=0;i<=DEPTH;i=i+1)begin
		@(posedge rd_clk_i)
		rd_en_i=1;
	end
		rd_en_i=0;

end
initial begin
	#1000;
	$finish;
end
endmodule