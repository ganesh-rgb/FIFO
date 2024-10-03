
//////////////////////////////////////////////////////////////////////////////////
// Company:  Takshila Intitute of VLSI Technologies
// Engineer: ASIC DESIGN VERIFICATION 
// 
// Create Date: 03.10.2024 15:28:55
// Design Name: FIFO 
// Module Name: SYNCHRONOUS FIFO
// Project Name: SYNCHRONOUS FIFO MODULE  WITH DATA OF VARIABLE LENGTH
// Target Devices: 
// Tool Versions: VIVADO 2023.1
// Description: 
// 
// Dependencies: xc7a100tcsg324-1
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
`define data_width 7
`define depth 10

module S_FIFO#(parameter data_width=7,depth=10)(DATAOUT, full, empty, clock, reset, wn, rn, DATAIN);
  output reg [data_width:0] DATAOUT;
  output full, empty;
  input [data_width:0] DATAIN;
  input clock, reset, wn, rn; // Need to understand what is wn and rn are for
  
  reg [2:0] wptr, rptr; // pointers tracking the stack
  reg [data_width:0] memory [depth:0]; // the stack is 8 bit wide and 8 locations in size
  
  assign full = ( (wptr == 3'b111) & (rptr == 3'b000) ? 1 : 0 );
  assign empty = (wptr == rptr) ? 1 : 0;
  
  always @(posedge clock)
  begin
    if (reset)
      begin
        memory[0] <= 0; memory[1] <= 0; memory[2] <= 0; memory[3] <= 0;
        memory[4] <= 0; memory[5] <= 0; memory[6] <= 0; memory[7] <= 0;
        DATAOUT <= 0; wptr <= 0; rptr <= 0;
      end
    else if (wn & !full)
      begin
        memory[wptr] <= DATAIN;
        wptr <= wptr + 1;
      end
    else if (rn & !empty)
      begin
        DATAOUT <= memory[rptr];
        rptr <= rptr + 1;
      end
  end
endmodule

module S_FIFO_tb;
  wire [7:0] DATAOUT;
  wire full, empty;
  reg clock, reset, wn, rn;
  reg [7:0] DATAIN;  
  
  S_FIFO DUT(DATAOUT, full, empty, clock, reset, wn, rn, DATAIN);
  
    
  //enabling the wave dump
  initial begin 
    $dumpfile("dump.vcd"); $dumpvars;
  end

  initial
  begin
    clock = 0; DATAIN = 8'd0;
    reset = 1; clock = 1; #5 ; clock = 0; #5;
    reset = 0;
    
    $display("Start testing");

    // First write some data into the queue
    wn = 1; rn = 0;
    DATAIN = 8'd100;
    clock = 1; #5 ; clock = 0; #5;
    DATAIN = 8'd150;
    clock = 1; #5 ; clock = 0; #5;
    DATAIN = 8'd200;
    clock = 1; #5 ; clock = 0; #5;
    DATAIN = 8'd40;
    clock = 1; #5 ; clock = 0; #5;
    DATAIN = 8'd70;
    clock = 1; #5 ; clock = 0; #5;
    DATAIN = 8'd65;
    clock = 1; #5 ; clock = 0; #5;
    DATAIN = 8'd15;
    clock = 1; #5 ; clock = 0; #5;
    
    // Now start reading and checking the values
    wn = 0; rn = 1;
    clock = 1; #5 ; clock = 0; #5;
    if ( DATAOUT === 8'd100 )
      $display("PASS %p ", DATAOUT);
    else
      $display("FAIL %p ", DATAOUT);

    clock = 1; #5 ; clock = 0; #5;
    if ( DATAOUT === 8'd150 )
      $display("PASS %p ", DATAOUT);
    else
      $display("FAIL %p ", DATAOUT);

    clock = 1; #5 ; clock = 0; #5;
    if ( DATAOUT === 8'd200 )
      $display("PASS %p ", DATAOUT);
    else
      $display("FAIL %p ", DATAOUT);

    clock = 1; #5 ; clock = 0; #5;
    if ( DATAOUT === 8'd40 )
      $display("PASS %p ", DATAOUT);
    else
      $display("FAIL %p ", DATAOUT);

    clock = 1; #5 ; clock = 0; #5;
    if ( DATAOUT === 8'd70 )
      $display("PASS %p ", DATAOUT);
    else
      $display("FAIL %p ", DATAOUT);

    clock = 1; #5 ; clock = 0; #5;
    if ( DATAOUT === 8'd65 )
      $display("PASS %p ", DATAOUT);
    else
      $display("FAIL %p ", DATAOUT);

    clock = 1; #5 ; clock = 0; #5;
    if ( DATAOUT === 8'd15 )
      $display("PASS %p ", DATAOUT);
    else
      $display("FAIL %p ", DATAOUT);

    clock = 1; #5 ; clock = 0; #5;
    if ( empty === 1 )
      $display("PASS %p ", empty);
    else
      $display("FAIL %p ", empty);
  end

endmodule
