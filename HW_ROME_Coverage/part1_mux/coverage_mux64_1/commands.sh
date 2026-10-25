#!/bin/sh
# Reproduce this coverage run from inside this folder.
set -e
iverilog -g2001 -Wall -s tb_mux64_1 -s cov_dump -o sim.vvp mux64_1_rtl.v mux64_1tb.v cov_dump.v
vvp sim.vvp | tee sim.log
perl -0pe 's/^\$comment [^\n]*\n//mg; s/\$timescale\s+(\S+)\s+\$end/\$timescale $1 \$end/' raw.vcd > mux64_1.vcd
covered score -t mux64_1 -i tb_mux64_1.dut -v mux64_1_rtl.v -vcd mux64_1.vcd -o mux64_1.cdd
covered report -m ltc -d s -i -o coverage_summary.rpt mux64_1.cdd
covered report -m ltc -d s -o coverage_summary_by_module.rpt mux64_1.cdd
covered report -m ltc -d v -i -o coverage_detail.rpt mux64_1.cdd
