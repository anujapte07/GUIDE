"""
Authoring helper for the recorded LLM responses in llm_responses/.

In this submission the "LLM" role was played by Claude (Anthropic), because the
environment used to prepare the run had no OpenAI access.  Claude decided the
test patterns (corner cases + random values, seeded below) and wrote the golden
models; this script only does the mechanical part of turning those decisions
into response text in exactly the format the notebook's prompts ask for
(TESTBENCH_CODE / TEST_PATTERNS blocks, a Python function, a full updated
testbench), so that the expected values in testbench_final.v are copied from
the golden model rather than retyped by hand.
"""
import os, random, json

HERE = os.path.dirname(os.path.abspath(__file__))

# ----------------------------------------------------------------- specs ---
SPECS = {
  "mux2to1": dict(
    inputs=[("a",1),("b",1),("sel",1)], outputs=[("y",1)],
    golden='''def mux2to1_golden(a, b, sel):
    """Reference model of a 2-to-1 multiplexer: y = b when sel == 1, else a."""
    a, b, sel = a & 1, b & 1, sel & 1
    y = b if sel else a
    return {'y': y}
''',
    corners=[], rand=0, exhaustive=True),
  "adder4bit": dict(
    inputs=[("a",4),("b",4)], outputs=[("sum",4),("carry",1)],
    golden='''def adder4bit_golden(a, b):
    """Reference model of a 4-bit unsigned adder with carry-out."""
    total = (a & 0xF) + (b & 0xF)          # full-precision unsigned sum (0..30)
    return {'sum': total & 0xF,            # lower 4 bits
            'carry': 1 if total > 15 else 0}
''',
    corners=[(0,0),(0,15),(15,0),(15,15),(1,15),(15,1),(8,8),(7,8),(8,7),(7,9),
             (1,1),(5,10),(15,14),(9,9)],
    rand=18, seed=11),
  "sat_adder8": dict(
    inputs=[("a",8),("b",8),("cin",1)], outputs=[("sum",8),("sat",1)],
    golden='''def sat_adder8_golden(a, b, cin):
    """Reference model of an 8-bit unsigned saturating adder with carry-in.

    sum = min(a + b + cin, 255); sat = 1 only if the true sum exceeds 255.
    """
    total = (a & 0xFF) + (b & 0xFF) + (cin & 1)
    if total > 255:
        return {'sum': 255, 'sat': 1}
    return {'sum': total, 'sat': 0}
''',
    corners=[(0,0,0),(0,0,1),(255,0,0),(0,255,0),(255,0,1),(0,255,1),(255,255,0),
             (255,255,1),(254,1,0),(1,254,0),(254,0,1),(253,1,1),(254,1,1),(254,2,0),
             (128,127,0),(128,127,1),(128,128,0),(127,128,0),(1,1,0),(1,0,1),
             (170,85,0),(85,170,1),(100,100,0),(200,55,0)],
    rand=16, seed=2026),
}

def gen_patterns(name):
    s = SPECS[name]
    widths = [w for _, w in s["inputs"]]
    if s.get("exhaustive"):
        return [tuple((i >> k) & 1 for k in range(len(widths))) for i in range(2**len(widths))]
    pats = [(tuple(p), "corner") for p in s["corners"]]
    rng = random.Random(s["seed"])
    seen = set(s["corners"])
    while len([p for p in pats if p[1] == "random"]) < s["rand"]:
        p = tuple(rng.randrange(2**w) for w in widths)
        if p in seen: continue
        seen.add(p); pats.append((p, "random"))
    return pats

def run_golden(name, p):
    ns = {}; exec(SPECS[name]["golden"], ns)
    return ns[f"{name}_golden"](*p)

# ----------------------------------------------------------- code writers ---
def decl(names_widths, kind):
    out = []
    for n, w in names_widths:
        out.append(f"    {kind} {'[%d:0] ' % (w-1) if w > 1 else ''}{n};")
    return "\n".join(out)

def lit(v, w): return f"{w}'b{v:0{w}b}"

def tb_blocks(name, with_checks):
    s = SPECS[name]
    pats = gen_patterns(name)
    if s.get("exhaustive"):
        pats = [(p, "exhaustive") for p in pats]
    ins, outs = s["inputs"], s["outputs"]
    L = []
    L.append("`timescale 1ns/1ps\n")
    L.append(f"module tb_{name};")
    L.append(decl(ins, "reg")); L.append(decl(outs, "wire")); L.append("")
    conn = ", ".join(f".{n}({n})" for n, _ in ins + outs)
    L.append(f"    {name} uut ({conn});\n")
    L.append("    initial begin")
    if with_checks:
        L.append("        integer passed_tests;")
        L.append("        integer failed_tests;")
        L.append("        passed_tests = 0;")
        L.append("        failed_tests = 0;\n")
    for i, (p, kind) in enumerate(pats, 1):
        assigns = " ".join(f"{n} = {lit(v,w)};" for (n, w), v in zip(ins, p))
        fmt = " ".join(f"{n}=%b" for n, _ in ins)
        args = ", ".join(n for n, _ in ins)
        L.append(f"        // Test {i} ({kind})")
        L.append(f"        {assigns}")
        L.append(f'        $display("Test {i}: {fmt}", {args});')
        if with_checks:
            L.append("        #10; // let outputs settle")
            exp = run_golden(name, p)
            for n, w in outs:
                e = exp[n]
                L.append(f"        if ({n} === {w}'d{e}) begin")
                L.append(f'            $display("  ✓ Test {i}: {n} = %0d (expected: {e})", {n});')
                L.append("            passed_tests = passed_tests + 1;")
                L.append("        end else begin")
                L.append(f'            $display("  ✗ Test {i}: {n} = %0d (expected: {e})", {n});')
                L.append("            failed_tests = failed_tests + 1;")
                L.append("        end")
        L.append("")
    if with_checks:
        L.append("        // Test summary")
        L.append('        $display("\\n========== Test Summary ==========");')
        L.append('        $display("Total Checks: %0d", passed_tests + failed_tests);')
        L.append('        $display("Passed: %0d", passed_tests);')
        L.append('        $display("Failed: %0d", failed_tests);')
        L.append('        if (failed_tests == 0) $display("ALL TESTS PASSED");')
        L.append('        else $display("SOME TESTS FAILED");')
        L.append('        $display("==================================\\n");')
    L.append("        $finish;")
    L.append("    end")
    L.append("endmodule")
    return "\n".join(L) + "\n", pats

def response_testbench(name):
    code, pats = tb_blocks(name, False)
    s = SPECS[name]
    js = []
    for p, _ in pats:
        js.append({n: f"{v:0{w}b}" for (n, w), v in zip(s["inputs"], p)})
    return ("Here is a testbench that drives the module with systematic corner cases "
            "and seeded random patterns, followed by the same patterns as JSON.\n\n"
            "TESTBENCH_CODE:\n```verilog\n" + code + "```\n\n"
            "TEST_PATTERNS:\n```json\n" + json.dumps(js, indent=2) + "\n```\n")

def response_golden(name):
    return "```python\n" + SPECS[name]["golden"] + "```\n"

def response_updater(name):
    code, _ = tb_blocks(name, True)
    return "```verilog\n" + code + "```\n"

if __name__ == "__main__":
    for name in SPECS:
        d = os.path.join(HERE, name); os.makedirs(d, exist_ok=True)
        open(os.path.join(d, "01_testbench_response.txt"), "w", encoding="utf-8").write(response_testbench(name))
        open(os.path.join(d, "02_golden_response.txt"), "w", encoding="utf-8").write(response_golden(name))
        open(os.path.join(d, "03_updater_response.txt"), "w", encoding="utf-8").write(response_updater(name))
        print("wrote", name, len(gen_patterns(name)), "patterns")
