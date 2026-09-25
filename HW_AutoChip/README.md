# HW_AutoChip

AutoChip Tutorial Assignment (LLM4ChipDesign). Contains:

- `AutoChip_hw.ipynb` -- executed notebook covering all eight tutorial examples
  plus the 8-bit CPU example. Runs top-to-bottom with no API key required (it
  replays the real per-iteration Verilog this assignment's author produced
  while acting as AutoChip's generation step, then re-runs AutoChip's actual
  compile/simulate/feedback loop against it with real `iverilog`/`vvp` calls).
  An API-key cell is included for anyone who wants to point it at a live
  `ChatGPT`/`Claude` backend instead.
- `AutoChip_Report.pdf` -- summary report: spec, AutoChip configuration,
  generation trajectory, verification, and discussion for every example.
- `examples/<name>/` -- per-example artifacts:
  - `<name>_tb.v` -- the testbench used for verification.
  - `<module>.v` -- the final generated Verilog module.
  - `iterN/response0/` -- AutoChip-style per-iteration trajectory: the
    generated `.sv`, the compiled `.vvp`, `compile.log` / `sim.log` (real
    `iverilog`/`vvp` output), and `log.txt` (the full conversation state at
    that iteration, matching AutoChip's own log format).
  - `my_design.vcd` -- waveform dump, where the testbench produces one.

## Status

7 of 8 tutorial examples pass their testbench. `shift_register` does not:
the provided testbench's expected-output constant does not depend on its
own `data_in`/`shift_enable` stimulus at all (verified directly against
Icarus Verilog, not just by inspection), so no correct shift register can
satisfy it -- see `AutoChip_Report.pdf` and
`examples/shift_register/iter1/response0/log.txt` for the full
investigation. The 8-bit CPU example (Part II) passes its testbench.

## Reproducing

```
cd examples/<name>
iverilog -Wall -Winfloop -Wno-timescale -g2012 -s <tb_top> \
    -o <module>.vvp <module>.v <name>_tb.v
vvp -n <module>.vvp
```

`<tb_top>` is the testbench's own top module name (e.g.
`tb_sequence_detector`), given in each example's `iterN/response0/log.txt`
and in `AutoChip_Report.pdf`.
