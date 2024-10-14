//////////////////////////////////////////////////////////////////////////////////
// Company: Takshila Institute of VLSI Technologies
// Engineer: Ganesh Boppudi, ASIC Design Verification
// 
// Create Date: 14.10.2024 11:17:21
// Design Name: 2 Flip Flops Synchronizer
// Project Name: DESIGN & VERIFICATION OF ASYNCHRONOUS FIFO
// Target Devices: 
// Tool Versions: VIVADO 2023.1 


module dff_Sync2#(parameter FIFO_DEPTH = 8)(
  
   input                           clk,
   input                           reset_n,
  input[$clog2(FIFO_DEPTH):0]     i_D,
   output [$clog2(FIFO_DEPTH):0]   o_Q_Synced
);

  reg [$clog2(FIFO_DEPTH):0] r_Sync_Flop1;
  reg [$clog2(FIFO_DEPTH):0] r_Sync_Flop2;

  always @(posedge clk or negedge reset_n)
    begin
      if(!reset_n)
        begin
          r_Sync_Flop1 <= {$clog2(FIFO_DEPTH){1'b0}};
          r_Sync_Flop2 <= {$clog2(FIFO_DEPTH){1'b0}};;
        end
      else begin
        r_Sync_Flop1 <= i_D;
        r_Sync_Flop2 <= r_Sync_Flop1;
      end
    end
  assign o_Q_Synced = r_Sync_Flop2;
endmodule
