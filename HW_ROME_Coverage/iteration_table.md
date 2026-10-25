| # | phase | module | what changed | testbench used | result |
|---|---|---|---|---|---|
| 1 | ROME loop (Part II) | half_adder | RTL (LLM generation iteration 0) | half_adder_tb.v (fixed) | Testbench ran successfully |
| 2 | ROME loop (Part II) | full_adder | RTL (LLM generation iteration 0) | full_adder_tb.v (fixed) | Testbench ran successfully |
| 3 | ROME loop (Part II) | adder4 | RTL (LLM generation iteration 0) | adder4_tb.v (fixed) | Testbench ran successfully |
| 4 | ROME loop (Part II) | adder8 | RTL (LLM generation iteration 0) | adder8_tb.v (fixed) | Testbench ran successfully |
| 5 | coverage loop | adder8 | nothing (measure) | tb_iter_0.v | sim passed; line 100.0%, tog01 94.7%, tog10 87.9%, logic 86.6% |
| 6 | coverage loop | adder8 | TB: targeted tests added | tb_iter_1.v | sim FAILED; line 100.0%, tog01 100.0%, tog10 100.0%, logic 100.0% |
| 7 | ROME loop (Part III) | adder8 | RTL: ROME repair, TB frozen | tb_iter_1.v | sim passed; line 100.0%, tog01 100.0%, tog10 100.0%, logic 100.0% |
