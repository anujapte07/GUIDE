#!/bin/sh
# Reproduce this coverage run from inside this folder.
set -e
iverilog -g2001 -Wall -s tb_adder8 -s cov_dump -o sim.vvp adder8_rtl.v tb_iter_1.v cov_dump.v
vvp sim.vvp | tee sim.log
perl -0pe 's/^\$comment [^\n]*\n//mg; s/\$timescale\s+(\S+)\s+\$end/\$timescale $1 \$end/' raw.vcd > adder8.vcd
covered score -t adder8 -i tb_adder8.dut -v adder8_rtl.v -vcd adder8.vcd -o adder8.cdd
covered report -m ltc -d s -i -o coverage_summary.rpt adder8.cdd
covered report -m ltc -d s -o coverage_summary_by_module.rpt adder8.cdd
covered report -m ltc -d v -i -o coverage_detail.rpt adder8.cdd
