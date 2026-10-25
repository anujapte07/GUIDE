// Wrapper added by the coverage integration: dumps the TB hierarchy for Covered.
module cov_dump;
  initial begin
    $dumpfile("raw.vcd");
    $dumpvars(0, tb_adder8);
  end
endmodule
