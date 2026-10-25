| step | iteration | changed | TB | RTL | sim | # tests | line | toggle 0->1 | toggle 1->0 | logic |
|---|---|---|---|---|---|---|---|---|---|---|
| 0 | baseline | none | tb_iter_0.v | adder8_v0.v | passed | 8 | 100.0% | 94.7% | 87.9% | 86.6% |
| 1 | tb_refine_1 | TB | tb_iter_1.v | adder8_v0.v | FAILED | 19 | 100.0% | 100.0% | 100.0% | 100.0% |
| 2 | rtl_repair_1 | RTL | tb_iter_1.v | adder8_v1.v | passed | 19 | 100.0% | 100.0% | 100.0% | 100.0% |
