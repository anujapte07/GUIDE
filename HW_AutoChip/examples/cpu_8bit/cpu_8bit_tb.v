
`timescale 1ns/1ps
// Testbench for the 8-bit accumulator CPU.
// Program (program.hex) sums the integers 5,4,3,2,1 using a decrement loop:
//   data_mem[0] = counter (starts at 5)
//   data_mem[1] = running sum (starts at 0)
//   data_mem[2] = constant 1 (for decrementing the counter)
//   data_mem[3] = result (written by the program, expected = 15)
module tb_cpu_8bit;
    reg clk;
    reg reset_n;
    wire [7:0] acc;
    wire [4:0] pc;
    wire halted;

    cpu_8bit dut (
        .clk(clk),
        .reset_n(reset_n),
        .acc(acc),
        .pc(pc),
        .halted(halted)
    );

    always #5 clk = ~clk;

    integer cycles;
    integer errors;

    initial begin
        clk = 0;
        reset_n = 0;
        errors = 0;

        // Seed data memory (simulates loading initial data alongside the program)
        dut.data_mem[0] = 8'd5;  // counter
        dut.data_mem[1] = 8'd0;  // sum
        dut.data_mem[2] = 8'd1;  // constant 1
        dut.data_mem[3] = 8'd0;  // result (to be written)

        @(negedge clk);
        reset_n = 1;

        cycles = 0;
        while (!halted && cycles < 200) begin
            @(negedge clk);
            cycles = cycles + 1;
        end

        if (!halted) begin
            $display("Error: CPU did not halt within %0d cycles", cycles);
            errors = errors + 1;
        end else begin
            $display("CPU halted after %0d cycles. PC=%0d ACC=%0d", cycles, pc, acc);
        end

        if (dut.data_mem[3] !== 8'd15) begin
            $display("Error: expected data_mem[3] = 15 (5+4+3+2+1), got %0d", dut.data_mem[3]);
            errors = errors + 1;
        end else begin
            $display("Result check passed: data_mem[3] = %0d", dut.data_mem[3]);
        end

        if (dut.data_mem[0] !== 8'd0) begin
            $display("Error: expected counter (data_mem[0]) to reach 0, got %0d", dut.data_mem[0]);
            errors = errors + 1;
        end

        if (errors == 0)
            $display("All CPU test cases passed!");
        else
            $display("CPU testbench completed with %0d error(s).", errors);

        $finish;
    end
endmodule
