//////////////////////////////////////////////////////////////////////////////////
// Company: Takshila Institute of VLSI Technologies
// Engineer: Ganesh Boppudi, ASIC Design Verification
// 
// Create Date: 14.10.2024 11:12:02
// Design Name: AsynchronousFIFO using binary to gray and Synchronizer
// Project Name: DESIGN & VERIFICATION OF ASYNCHRONOUS FIFO
// Target Devices: 
// Tool Versions: VIVADO 2023.1 

`include "diff_Sync2.v"
`include "binary2gray.v"
module Async_FIFO #(parameter FIFO_DEPTH = 8,
                    parameter DATA_WIDTH = 8)(
  
    input                   i_wClk,
    input                   i_rClk,
    input                   reset_n,
    input [DATA_WIDTH-1:0]  i_wData,
    input                   i_wEN,
    input                   i_rEN,
    output[DATA_WIDTH-1:0]  o_rData,    
    output                  o_Full,
    output                  o_Empty
);

  //Internal reg/wire Declaration
  reg [$clog2(FIFO_DEPTH):0] r_Wr_Ptr, r_Rd_Ptr, r_Wr_Ptr_Synced, r_Rd_Ptr_Synced; // Extra 1 bit MSB for 'full' condition check
  reg [$clog2(FIFO_DEPTH):0] r_Wr_Ptr_G, r_Rd_Ptr_G;
  reg [DATA_WIDTH-1:0] Mem[0: FIFO_DEPTH -1];
  wire w_Empty, w_Full;
  reg [DATA_WIDTH-1:0] r_rData;

  //Output Port Assignments 
  assign w_Full = (r_Wr_Ptr_G == {~r_Rd_Ptr_Synced[$clog2(FIFO_DEPTH):$clog2(FIFO_DEPTH)-1],r_Rd_Ptr_Synced[$clog2(FIFO_DEPTH)-2:0]});
  assign w_Empty = (r_Wr_Ptr_Synced == r_Rd_Ptr_G);
  assign o_Empty = w_Empty;
  assign o_Full = w_Full;
  assign o_rData = r_rData;
  

  //Mem Write
  always @(posedge i_wClk or negedge reset_n)
    begin 
      if(~reset_n) begin
        Mem <= {8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00};
      end
      else if(i_wEN && !w_Full)
        begin
          Mem[r_Wr_Ptr[2:0]] <= i_wData;
        end
    end

  //Mem Read
  always @(posedge i_rClk or negedge reset_n)
    begin
      if(~reset_n) begin
        r_rData <= 8'h00;
      end
      else if(i_rEN && !w_Empty)
        begin
          r_rData <= Mem[r_Rd_Ptr[2:0]];
        end
    end

  //Write Pointer Update 
  always @(posedge i_wClk or negedge reset_n) 
    begin
      if(~reset_n)
        begin
          r_Wr_Ptr <= 4'b0;
        end
      else if(i_wEN && ~w_Full)
        begin
          r_Wr_Ptr <= r_Wr_Ptr + 1;
        end
    end

  //Read Pointer Update
  always @(posedge i_rClk or negedge reset_n)
    begin
      if(!reset_n)
        begin
          r_Rd_Ptr <= 4'b0;
        end
      else if(i_rEN && ~w_Empty)
        begin
          r_Rd_Ptr <= r_Rd_Ptr + 1;
        end
    end

  //Binary 2 Gray Converter 
  binary2gray#(FIFO_DEPTH) b2g_wr_ptr(.i_Binary(r_Wr_Ptr), .o_Gray(r_Wr_Ptr_G)); 
  binary2gray#(FIFO_DEPTH) b2g_rd_ptr(.i_Binary(r_Rd_Ptr), .o_Gray(r_Rd_Ptr_G)); 

  //Synchronizing Read/Write Pointers
  dff_Sync2#(FIFO_DEPTH) dff_sync2_wr_ptr(.clk(i_rClk), .reset_n(reset_n), .i_D(r_Wr_Ptr_G), .o_Q_Synced(r_Wr_Ptr_Synced));
  dff_Sync2#(FIFO_DEPTH) dff_sync2_rd_ptr(.clk(i_wClk), .reset_n(reset_n), .i_D(r_Rd_Ptr_G), .o_Q_Synced(r_Rd_Ptr_Synced));

endmodule
