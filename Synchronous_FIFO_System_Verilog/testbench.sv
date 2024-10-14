
//top tb
`include "interface.sv"
`include "program_test.sv"

  module tb;
    
    fifo_if fif();
    test t1(fif);
    
    fifo dut (fif.clock, fif.rd, fif.wr,fif.full, fif.empty, fif.data_in, fif.data_out, fif.rst);
    
    initial begin
      fif.clock <= 0;
    end
    
    always #10 fif.clock <= ~fif.clock;
       
  endmodule

