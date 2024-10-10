`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Takshila Institute of VLSI Technologies
// Engineer: Ganesh Boppudi, ASIC Design Verification
// 
// Create Date: 10.10.2024 02:49:02
// Design Name: AsynchronousFIFO
// Project Name: DESIGN & VERIFICATION OF ASYNCHRONOUS FIFO
// Target Devices: 
// Tool Versions: VIVADO 2023.1 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Async_fifo(wclk,rclk,rst,data_in,data_out,wr,rd,full,empty,over_flow,under_flow);
input wclk,rclk,rst,wr,rd;
input [7:0]data_in;
output reg [7:0]data_out;
output reg full,empty,over_flow,under_flow;

reg [3:0]wr_ptr,rd_ptr;
reg [7:0]mem[0:7];
reg [7:0]items=0;

always @(posedge wclk)begin
	if(rst==1)begin
		data_out<=8'bx;
		full<=0;
		empty<=1;
		over_flow<=0;
		under_flow<=0;
		wr_ptr<=0;
		rd_ptr<=0;
		items<=0;
	end
    else
		if(wr==1)begin
			if(full==0)begin
				mem[wr_ptr]=data_in;
				items=items+1; over_flow<=0;under_flow<=0;
				if(wr_ptr==7)
					wr_ptr=0;
				else
					wr_ptr=(wr_ptr+1);
			end
			else begin
			    mem[wr_ptr]=data_in;
				wr_ptr=(wr_ptr+1);
			    over_flow<=1; under_flow<=0;
			end
		end
		end
always @(posedge rclk) begin
    if(rst==1)begin
		data_out<=8'bx;
		full<=0;
		empty<=1;
		over_flow<=0;
		under_flow<=0;
		wr_ptr<=0;
		rd_ptr<=0;
		items<=0;
	end
		if(rd==1)begin
			if(empty==0)begin
				data_out=mem[rd_ptr];
				items=items-1; over_flow<=0; under_flow<=0;
				if(rd_ptr==7)
					rd_ptr=0;
				else
					rd_ptr=(rd_ptr+1);
			end
			else begin
			    data_out=8'bz;
			    rd_ptr=(rd_ptr+1);
			    over_flow<=0; under_flow<=1;
			end
		end 
		end
		always @(*) begin
		empty=(items==0)?1:0; full=(items==8)?1:0;
		end
endmodule

module Async_fifo_tb();
reg wclk,rclk,rst,rd,wr;
reg [7:0]data_in;
wire [7:0]data_out;
wire full,empty,over_flow,under_flow;
Async_fifo uut (wclk,rclk,rst,data_in,data_out,wr,rd,full,empty,over_flow,under_flow);
always #1 wclk=~wclk;
always #2 rclk=~rclk;
always #100 $finish();
initial begin

wclk=1; rclk=1; rst=1; wr=1; rd=0;
data_in=8'b00000000;
#2 rst=0;
#2 data_in=8'd1;
#2 data_in=8'd2;  
#2 data_in=8'd3;
#2 data_in=8'd4; 
#2 data_in=8'd5;
#2 data_in=8'd6; 
#2 data_in=8'd7; 
#2 data_in=8'd8; 
#2 data_in=8'd9;
#2 data_in=8'ha;rd=1;
#2 data_in=8'hb;wr=0; 
#2 data_in=8'hc;
#2 data_in=8'hd;
#2 data_in=8'he;
#2 data_in=8'hf;
end
endmodule