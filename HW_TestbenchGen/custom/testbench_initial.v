`timescale 1ns/1ps

module tb_sat_adder8;
    reg [7:0] a;
    reg [7:0] b;
    reg cin;
    wire [7:0] sum;
    wire sat;

    sat_adder8 uut (.a(a), .b(b), .cin(cin), .sum(sum), .sat(sat));

    initial begin
        // Test 1 (corner)
        a = 8'b00000000; b = 8'b00000000; cin = 1'b0;
        $display("Test 1: a=%b b=%b cin=%b", a, b, cin);

        // Test 2 (corner)
        a = 8'b00000000; b = 8'b00000000; cin = 1'b1;
        $display("Test 2: a=%b b=%b cin=%b", a, b, cin);

        // Test 3 (corner)
        a = 8'b11111111; b = 8'b00000000; cin = 1'b0;
        $display("Test 3: a=%b b=%b cin=%b", a, b, cin);

        // Test 4 (corner)
        a = 8'b00000000; b = 8'b11111111; cin = 1'b0;
        $display("Test 4: a=%b b=%b cin=%b", a, b, cin);

        // Test 5 (corner)
        a = 8'b11111111; b = 8'b00000000; cin = 1'b1;
        $display("Test 5: a=%b b=%b cin=%b", a, b, cin);

        // Test 6 (corner)
        a = 8'b00000000; b = 8'b11111111; cin = 1'b1;
        $display("Test 6: a=%b b=%b cin=%b", a, b, cin);

        // Test 7 (corner)
        a = 8'b11111111; b = 8'b11111111; cin = 1'b0;
        $display("Test 7: a=%b b=%b cin=%b", a, b, cin);

        // Test 8 (corner)
        a = 8'b11111111; b = 8'b11111111; cin = 1'b1;
        $display("Test 8: a=%b b=%b cin=%b", a, b, cin);

        // Test 9 (corner)
        a = 8'b11111110; b = 8'b00000001; cin = 1'b0;
        $display("Test 9: a=%b b=%b cin=%b", a, b, cin);

        // Test 10 (corner)
        a = 8'b00000001; b = 8'b11111110; cin = 1'b0;
        $display("Test 10: a=%b b=%b cin=%b", a, b, cin);

        // Test 11 (corner)
        a = 8'b11111110; b = 8'b00000000; cin = 1'b1;
        $display("Test 11: a=%b b=%b cin=%b", a, b, cin);

        // Test 12 (corner)
        a = 8'b11111101; b = 8'b00000001; cin = 1'b1;
        $display("Test 12: a=%b b=%b cin=%b", a, b, cin);

        // Test 13 (corner)
        a = 8'b11111110; b = 8'b00000001; cin = 1'b1;
        $display("Test 13: a=%b b=%b cin=%b", a, b, cin);

        // Test 14 (corner)
        a = 8'b11111110; b = 8'b00000010; cin = 1'b0;
        $display("Test 14: a=%b b=%b cin=%b", a, b, cin);

        // Test 15 (corner)
        a = 8'b10000000; b = 8'b01111111; cin = 1'b0;
        $display("Test 15: a=%b b=%b cin=%b", a, b, cin);

        // Test 16 (corner)
        a = 8'b10000000; b = 8'b01111111; cin = 1'b1;
        $display("Test 16: a=%b b=%b cin=%b", a, b, cin);

        // Test 17 (corner)
        a = 8'b10000000; b = 8'b10000000; cin = 1'b0;
        $display("Test 17: a=%b b=%b cin=%b", a, b, cin);

        // Test 18 (corner)
        a = 8'b01111111; b = 8'b10000000; cin = 1'b0;
        $display("Test 18: a=%b b=%b cin=%b", a, b, cin);

        // Test 19 (corner)
        a = 8'b00000001; b = 8'b00000001; cin = 1'b0;
        $display("Test 19: a=%b b=%b cin=%b", a, b, cin);

        // Test 20 (corner)
        a = 8'b00000001; b = 8'b00000000; cin = 1'b1;
        $display("Test 20: a=%b b=%b cin=%b", a, b, cin);

        // Test 21 (corner)
        a = 8'b10101010; b = 8'b01010101; cin = 1'b0;
        $display("Test 21: a=%b b=%b cin=%b", a, b, cin);

        // Test 22 (corner)
        a = 8'b01010101; b = 8'b10101010; cin = 1'b1;
        $display("Test 22: a=%b b=%b cin=%b", a, b, cin);

        // Test 23 (corner)
        a = 8'b01100100; b = 8'b01100100; cin = 1'b0;
        $display("Test 23: a=%b b=%b cin=%b", a, b, cin);

        // Test 24 (corner)
        a = 8'b11001000; b = 8'b00110111; cin = 1'b0;
        $display("Test 24: a=%b b=%b cin=%b", a, b, cin);

        // Test 25 (random)
        a = 8'b00111100; b = 8'b10100011; cin = 1'b0;
        $display("Test 25: a=%b b=%b cin=%b", a, b, cin);

        // Test 26 (random)
        a = 8'b01110010; b = 8'b11010111; cin = 1'b1;
        $display("Test 26: a=%b b=%b cin=%b", a, b, cin);

        // Test 27 (random)
        a = 8'b11100001; b = 8'b01111010; cin = 1'b0;
        $display("Test 27: a=%b b=%b cin=%b", a, b, cin);

        // Test 28 (random)
        a = 8'b00101001; b = 8'b00111000; cin = 1'b1;
        $display("Test 28: a=%b b=%b cin=%b", a, b, cin);

        // Test 29 (random)
        a = 8'b00110010; b = 8'b11100110; cin = 1'b0;
        $display("Test 29: a=%b b=%b cin=%b", a, b, cin);

        // Test 30 (random)
        a = 8'b11111011; b = 8'b10100000; cin = 1'b0;
        $display("Test 30: a=%b b=%b cin=%b", a, b, cin);

        // Test 31 (random)
        a = 8'b11001011; b = 8'b10000000; cin = 1'b1;
        $display("Test 31: a=%b b=%b cin=%b", a, b, cin);

        // Test 32 (random)
        a = 8'b10110110; b = 8'b11000000; cin = 1'b0;
        $display("Test 32: a=%b b=%b cin=%b", a, b, cin);

        // Test 33 (random)
        a = 8'b10101110; b = 8'b00101101; cin = 1'b1;
        $display("Test 33: a=%b b=%b cin=%b", a, b, cin);

        // Test 34 (random)
        a = 8'b10010011; b = 8'b11101010; cin = 1'b0;
        $display("Test 34: a=%b b=%b cin=%b", a, b, cin);

        // Test 35 (random)
        a = 8'b10011110; b = 8'b00001100; cin = 1'b1;
        $display("Test 35: a=%b b=%b cin=%b", a, b, cin);

        // Test 36 (random)
        a = 8'b10111010; b = 8'b11101100; cin = 1'b1;
        $display("Test 36: a=%b b=%b cin=%b", a, b, cin);

        // Test 37 (random)
        a = 8'b00101110; b = 8'b11001100; cin = 1'b1;
        $display("Test 37: a=%b b=%b cin=%b", a, b, cin);

        // Test 38 (random)
        a = 8'b00111011; b = 8'b11011001; cin = 1'b1;
        $display("Test 38: a=%b b=%b cin=%b", a, b, cin);

        // Test 39 (random)
        a = 8'b11001011; b = 8'b10000100; cin = 1'b1;
        $display("Test 39: a=%b b=%b cin=%b", a, b, cin);

        // Test 40 (random)
        a = 8'b11110101; b = 8'b00001100; cin = 1'b0;
        $display("Test 40: a=%b b=%b cin=%b", a, b, cin);

        $finish;
    end
endmodule