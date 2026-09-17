# HW_ChipChat — ChipChat Assignment (all 8 examples + CPU example)

**Submitted by:** Anuj Apte

## Contents

- `ChipChat_hw.ipynb` — the notebook as actually executed locally (VS Code + Jupyter, Windows,
  Icarus Verilog 14.0), covering all 8 ChipChat.ipynb examples plus the additional CPU / 8-bit
  accumulator processor example. All outputs are real, live `iverilog`/`vvp` results from that
  run — not pre-populated.
- `ChipChat_Report.pdf` — write-up covering Part I (summary of all 8 examples), Part II (detailed
  CPU example writeup), and Part III (reflection and comparison), per the assignment's report
  requirements.
- `examples/<name>/` — one folder per design, each containing:
  - `<name>.v` — the generated Verilog design
  - `<name>_tb.v` — the testbench it was verified against (the course-provided testbench for the
    8 notebook examples; a custom-written testbench for the `cpu_8bit` example)
  - `simulation_output.log` — the real `iverilog`/`vvp` simulation output for that design, taken
    directly from the local run
  - `cpu_8bit/program.hex` — the hand-assembled test program run on the CPU example

## How to reproduce

Each example can be independently compiled and simulated with Icarus Verilog:

```bash
cd examples/<name>
iverilog -g2012 -o <name>.vvp <name>.v <name>_tb.v && vvp <name>.vvp
```

All 9 designs (8 notebook examples + the CPU example) pass their testbenches.

No API keys, credentials, or other secrets are included anywhere in this submission — see the
report for the note on how the Verilog designs were generated.
