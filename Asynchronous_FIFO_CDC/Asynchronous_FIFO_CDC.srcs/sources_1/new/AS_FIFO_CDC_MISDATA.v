//////////////////////////////////////////////////////////////////////////////////
// Company: Takshila Institute of VLSI Technologies
// Engineer: Ganesh Boppudi, ASIC Design Verification
// 
// Create Date: 14.10.2024 11:17:21
// Design Name: 2 Flip Flops Synchronizer
// Project Name: DESIGN & VERIFICATION OF Asynchronous FIFO for solving data miss problems in Clock Domain Crossing (CDC) given in Simulation and Synthesis Techniques for Asynchronous FIFO Design
// Target Devices: 
// Tool Versions: VIVADO 2023.1 

module DF_SYNC(
RST,CLK,DATA_IN,SYNC_OUT
);
parameter DATA_WIDTH =4 ;
input RST,CLK;
input  [DATA_WIDTH-1:0] DATA_IN;
output reg [DATA_WIDTH-1:0] SYNC_OUT;
reg [DATA_WIDTH-1:0] temp ;
always @(posedge CLK or negedge RST ) begin
if (!RST) begin
    temp <= 0;
    SYNC_OUT <=0;
end else begin
    temp <= DATA_IN;
    SYNC_OUT <= temp;
end
end
endmodule
module and_inv (in,inv_in,out);
 input in,inv_in;
 output out;
 assign out =(!inv_in) & in ;   
endmodule


module FIFO_WR(
wfull,winc,waddr,wptr,wclk,wrst_n,wq2_rptr
);
parameter ADD_WIDTH=3;
input  winc,wclk,wrst_n;
input  [ADD_WIDTH:0] wq2_rptr;
output  [ADD_WIDTH-1:0] waddr;
output [ADD_WIDTH:0] wptr;
output reg wfull;
reg [ADD_WIDTH:0] binary_add;
///////B2G_conversion////////////////////
binary_to_gray #(.WIDTH(ADD_WIDTH+1)) converter_block  
(
    .binary(binary_add),  
     .gray(wptr)    
);
/////////////////////////////////////////////
always @(posedge wclk or negedge wrst_n ) begin
 if (! wrst_n) begin
     binary_add  <= 0;
     wfull <= 0;
 end else begin
    if (winc) begin
       binary_add <= binary_add + 1;  
    end
    wfull <=((wq2_rptr[ADD_WIDTH] != wptr[ADD_WIDTH])
    &(wptr[ADD_WIDTH-1:0]==wq2_rptr[ADD_WIDTH-1:0]));
 end   
end   
assign waddr =binary_add[ADD_WIDTH-1:0];
endmodule


module FIFO_RD(raddr,rptr,rq2_wptr,rrst_n,rclk,rempty,rinc);
parameter ADD_WIDTH=3;
input  rinc,rclk,rrst_n;
input  [ADD_WIDTH:0] rq2_wptr;
output [ADD_WIDTH-1:0] raddr;
output [ADD_WIDTH:0] rptr;
output reg rempty;
reg [ADD_WIDTH:0] binary_add;
///////B2G_conversion////////////////////
binary_to_gray #(.WIDTH(ADD_WIDTH+1)) converter_block  
(
    .binary(binary_add),  
     .gray(rptr)    
);
/////////////////////////////////////////////
always @(posedge rclk or negedge rrst_n ) begin
 if (! rrst_n) begin
     binary_add  <= 0;
     rempty <= 1;
 end else begin
    if (rinc) begin
       binary_add <= binary_add + 1;  
    end
    rempty <= (rptr ==rq2_wptr);
 end   
end   
assign raddr =binary_add[ADD_WIDTH-1:0];
endmodule



module FIFO_MEM_CNTRL (wdata,rdata,wCLKen,waddr
,CLK,raddr);
parameter FIFO_DEPTH=8;
parameter DATA_WIDTH=8;
parameter ADD_WIDTH=3;
input CLK,wCLKen;
input [ADD_WIDTH-1:0]raddr;
input [ADD_WIDTH-1:0]waddr;
input [DATA_WIDTH-1:0] wdata;
output  [DATA_WIDTH-1:0] rdata;
reg [FIFO_DEPTH-1:0] mem [DATA_WIDTH-1:0];
always @(posedge CLK) begin
if(wCLKen)
mem[waddr] <= wdata;    
end
assign rdata = mem[raddr];
endmodule


module binary_to_gray #(parameter WIDTH = 4) (
    input [WIDTH-1:0] binary,  
    output [WIDTH-1:0] gray    
);
genvar i;
generate
    for (i = 0; i < WIDTH; i = i + 1) begin : gen_gray
        if (i == WIDTH-1) begin
            assign gray[i] = binary[i];  
        end else begin
            assign gray[i] = binary[i+1] ^ binary[i];  
        end
    end
endgenerate

endmodule




module TOP(W_CLK,W_RST,W_INC,
R_CLK,R_RST,R_INC,WR_DATA,RD_DATA,FULL,EMPTY
);
parameter FIFO_DEPTH=8;
parameter ADD_WIDTH=3;
parameter DATA_WIDTH=8;
input W_CLK,W_RST,W_INC;
input R_CLK,R_RST,R_INC;
input [DATA_WIDTH-1:0] WR_DATA;
output FULL,EMPTY;
output  [DATA_WIDTH-1:0] RD_DATA;
wire [ADD_WIDTH-1:0] waddr,raddr;
wire [ADD_WIDTH:0] wptr,rptr;
wire [ADD_WIDTH:0] wq2_rptr,rq2_wptr;
wire wCLKen;


FIFO_WR B0(
.wfull(FULL),.winc(W_INC),.waddr(waddr),.wptr(wptr),
.wclk(W_CLK),.wrst_n(W_RST),.wq2_rptr(wq2_rptr));

FIFO_RD B1 (.raddr(raddr),.rptr(rptr),.rq2_wptr(rq2_wptr),
.rrst_n(R_RST),.rclk(R_CLK),.rempty(EMPTY),.rinc(R_INC));

DF_SYNC B2(
.RST(R_RST),.CLK(R_CLK),.DATA_IN(wptr),
.SYNC_OUT(rq2_wptr)
);

DF_SYNC B3(
.RST(W_RST),.CLK(W_CLK),.DATA_IN(rptr)
,.SYNC_OUT(wq2_rptr)
);

FIFO_MEM_CNTRL B4 (.wdata(WR_DATA),.rdata(RD_DATA),
.wCLKen(wCLKen),.waddr(waddr)
,.CLK(W_CLK),.raddr(raddr));

and_inv B5 (.in(W_INC),.inv_in(FULL),.out(wCLKen));
endmodule

`timescale 1ns/1ps
module TB();
parameter DATA_WIDTH=8;
reg W_CLK,W_RST,W_INC;
reg R_CLK,R_RST,R_INC;
reg  [DATA_WIDTH-1:0] WR_DATA;
wire FULL,EMPTY;
wire  [DATA_WIDTH-1:0] RD_DATA;    
integer  i;
integer read_index,write_index;
TOP DUT(W_CLK,W_RST,W_INC,R_CLK,
R_RST,R_INC,WR_DATA,RD_DATA,FULL,EMPTY);

reg test_failure;
reg [7:0] test_mem [9:0];
reg [7:0] ref_mem [9:0];
  initial begin
read_index=0;
write_index=0;
 for (i = 0; i <10 ; i = i + 1) begin
      ref_mem[i] = $random;
    end
  end
// Clock generation for write clock (100 MHz)
  initial begin
    W_CLK = 0;
    forever #5 W_CLK = ~W_CLK; 
  end
  
  // Clock generation for read clock (40 MHz)
  initial begin
    R_CLK = 0;
    forever #12.5 R_CLK = ~R_CLK; 
  end
///reading_block :  
initial begin  
 R_RST=0; //reset assertion ;
 repeat(2)@(negedge W_CLK); 
 R_RST=1;//reset deassertion ;
 forever begin
    @(negedge R_CLK);
   R_INC=0;
 if((!EMPTY)&&(read_index !=10))
 begin 
   R_INC=1;   
   test_mem[read_index]=RD_DATA;
   read_index =read_index+1;
 end 
 end
end
//writing block  :
initial begin
  W_RST=0; //reset assertion ;
 repeat(2)@(negedge W_CLK); 
 W_RST=1;//reset deassertion ;   
 forever begin
    @(negedge W_CLK);
   W_INC=0;
 if((!FULL)&&(write_index != 10))
 begin
    W_INC=1;
   WR_DATA=ref_mem[write_index];
   write_index =write_index+1;
 end 
 end
end
///////////////////////////
initial
begin
  test_failure=0;
    forever begin
#1;
if (read_index==10) begin
  for (i=0;i<=9;i=i+1)
  begin
    if (test_mem[i] != ref_mem [i]) begin
      test_failure = 1 ;
    end
  end
  if(test_failure)
  begin
    $display("error in test ");
    $stop ;
  end  
  else begin
    @(negedge R_CLK);
    $display("test done :)");
        $stop;
  end
end
    end
end
endmodule
