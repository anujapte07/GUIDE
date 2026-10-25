// Baseline self-checking testbench: adder8 (top of the hierarchy)
// 8 directed tests. This is the "baseline TB" that the coverage loop in Part III starts from.
// Reference: {cout, sum} = a + b + cin
//            ovf (signed two's-complement overflow) = (a[7] == b[7]) && (sum[7] != a[7])
module tb_adder8;
    reg  [7:0] a, b;
    reg        cin;
    wire [7:0] sum;
    wire       cout, ovf;

    reg  [8:0] exp_full;
    reg        exp_ovf;
    integer    tests, errors;

    adder8 dut (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout), .ovf(ovf));

    // Apply one vector, wait for the ripple to settle, compare against the reference model.
    task check;
        input [7:0] ta;
        input [7:0] tb;
        input       tc;
        begin
            a = ta; b = tb; cin = tc;
            #1;
            exp_full = ta + tb + tc;
            exp_ovf  = (ta[7] == tb[7]) && (exp_full[7] != ta[7]);
            tests = tests + 1;
            if (sum !== exp_full[7:0] || cout !== exp_full[8] || ovf !== exp_ovf) begin
                errors = errors + 1;
                $display("MISMATCH test %0d: a=%h b=%h cin=%b -> sum=%h cout=%b ovf=%b (expected sum=%h cout=%b ovf=%b)",
                         tests, ta, tb, tc, sum, cout, ovf, exp_full[7:0], exp_full[8], exp_ovf);
            end
        end
    endtask

    initial begin
        tests = 0; errors = 0;
        a = 8'h00; b = 8'h00; cin = 1'b0;

        // ---------------- baseline directed tests ----------------
        check(8'h00, 8'h00, 1'b0);   // zero
        check(8'h01, 8'h01, 1'b0);   // simple add
        check(8'h0F, 8'h01, 1'b0);   // carry across the nibble boundary (adder4 -> adder4)
        check(8'hFF, 8'h01, 1'b0);   // full ripple, carry-out
        check(8'h80, 8'h80, 1'b0);   // two negatives -> signed overflow, carry-out
        check(8'h12, 8'h34, 1'b1);   // carry-in
        check(8'hA5, 8'h5A, 1'b0);   // complementary patterns, no carry
        check(8'h3C, 8'hC3, 1'b1);   // carry-in ripples through all bits

        // ---------------- coverage-guided tests ----------------
        // @@COVERAGE_TESTS@@

        $display("tests run: %0d, mismatches: %0d", tests, errors);
        if (errors == 0) $display("passed!");
        else             $display("FAILED: %0d of %0d checks", errors, tests);
        $finish;
    end
endmodule
