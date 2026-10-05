# HW_TestbenchGen — Enhanced LLM-Aided Testbench Generation

**Student:** Anuj Apte · **Course:** LLM4ChipDesign

| File / folder | What it is |
|---|---|
| `testbenchgen_hw.ipynb` | Executed notebook (outputs visible). Runs top-to-bottom; the only manual step is the optional API-key cell in Section 1. |
| `TestbenchGen_Report.pdf` | Short report (examples run, LLM setup, DUT interfaces + commands, Part II explanation, Part IV failing/passing snippets). |
| `mux/`, `adder/` | Part I tutorial runs: DUT, `testbench_initial.v`, `golden_model.py`, `test_patterns_with_golden.json`, `testbench_final.v`, `simulation_output.log`. |
| `custom/` | Part III run on my own module `sat_adder8` (8-bit saturating adder with carry-in), same artifact set. |
| `custom/bug_demo/` | Part IV: buggy DUT, failing log (`simulation_fail.log`), passing log after the fix, extra mutants. |
| `llm_responses/` | The recorded LLM responses used in replay mode, plus `build_responses.py` (see below). |

## How the LLM was provided
The pipeline classes are the course's own. With an OpenAI key in the notebook (or `OPENAI_API_KEY` exported) it runs live with `gpt-4o`.
**The submitted outputs were produced in replay mode** (key left empty): each LLM response was written by Claude (Anthropic) for the exact pipeline
prompt and is stored in `llm_responses/<module>/`, because the machine used had no OpenAI access. Parsing, golden-model execution, artifact writing and all
`iverilog`/`vvp` simulations are real. Details are in Section 2 of the report.

## Reproduce
```bash
# needs Python 3 and Icarus Verilog (iverilog/vvp); the notebook installs openai/iverilog if missing on Linux
jupyter nbconvert --to notebook --execute --inplace testbenchgen_hw.ipynb

# or by hand, e.g. for the custom module
iverilog -g2012 -o custom/sim.vvp custom/sat_adder8.v custom/testbench_final.v && vvp custom/sim.vvp
```
No API keys or credentials are included anywhere in this folder.
