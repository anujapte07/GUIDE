// Baseline self-checking testbench: full_adder (exhaustive, 8 input combinations)
// Reference: {cout, sum} = a + b + cin
module tb_full_adder;
    reg  a, b, cin;
    wire sum, cout;
    reg  [1:0] exp;
    integer i, tests, errors;

    full_adder dut (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

    initial begin
        tests = 0; errors = 0;
        for (i = 0; i < 8; i = i + 1) begin
            {a, b, cin} = i;
            #1;
            exp = a + b + cin;
            tests = tests + 1;
            if (sum !== exp[0] || cout !== exp[1]) begin
                errors = errors + 1;
                $display("MISMATCH a=%b b=%b cin=%b -> sum=%b cout=%b (expected sum=%b cout=%b)",
                         a, b, cin, sum, cout, exp[0], exp[1]);
            end
        end
        $display("tests run: %0d, mismatches: %0d", tests, errors);
        if (errors == 0) $display("passed!");
        else             $display("FAILED: %0d of %0d checks", errors, tests);
        $finish;
    end
endmodule
