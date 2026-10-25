// Baseline self-checking testbench: half_adder (exhaustive, 4 input combinations)
// Reference: sum = a ^ b, carry = a & b
module tb_half_adder;
    reg  a, b;
    wire sum, carry;
    integer i, tests, errors;

    half_adder dut (.a(a), .b(b), .sum(sum), .carry(carry));

    initial begin
        tests = 0; errors = 0;
        for (i = 0; i < 4; i = i + 1) begin
            {a, b} = i;
            #1;
            tests = tests + 1;
            if (sum !== (a ^ b) || carry !== (a & b)) begin
                errors = errors + 1;
                $display("MISMATCH a=%b b=%b -> sum=%b carry=%b (expected sum=%b carry=%b)",
                         a, b, sum, carry, a ^ b, a & b);
            end
        end
        $display("tests run: %0d, mismatches: %0d", tests, errors);
        if (errors == 0) $display("passed!");
        else             $display("FAILED: %0d of %0d checks", errors, tests);
        $finish;
    end
endmodule
