module binary2gray#(parameter FIFO_DEPTH = 8)(

  input[$clog2(FIFO_DEPTH):0]               i_Binary,
  output[$clog2(FIFO_DEPTH):0]              o_Gray
);

  assign o_Gray = (i_Binary >>1)^(i_Binary);

endmodule
