`include "environment.sv"
program test(fifo_if fif);
    environment env;
    initial begin
      env=new(fif);
        env.gen.count=20;
        env.run();
    end
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end
endprogram