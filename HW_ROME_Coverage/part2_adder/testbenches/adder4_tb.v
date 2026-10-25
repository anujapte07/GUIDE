// Baseline self-checking testbench: adder4 (exhaustive, 16 x 16 x 2 = 512 combinations)
// Reference: {cout, sum} = a + b + cin
module tb_adder4;
    reg  [3:0] a, b;
    reg        cin;
    wire [3:0] sum;
    wire       cout;
    reg  [4:0] exp;
    integer i, tests, errors;

    adder4 dut (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

    initial begin
        tests = 0; errors = 0;
        for (i = 0; i < 512; i = i + 1) begin
            {cin, a, b} = i;
            #1;
            exp = a + b + cin;
            tests = tests + 1;
            if (sum !== exp[3:0] || cout !== exp[4]) begin
                errors = errors + 1;
                if (errors <= 10)
                    $display("MISMATCH a=%h b=%h cin=%b -> sum=%h cout=%b (expected sum=%h cout=%b)",
                             a, b, cin, sum, cout, exp[3:0], exp[4]);
            end
        end
        $display("tests run: %0d, mismatches: %0d", tests, errors);
        if (errors == 0) $display("passed!");
        else             $display("FAILED: %0d of %0d checks", errors, tests);
        $finish;
    end
endmodule
