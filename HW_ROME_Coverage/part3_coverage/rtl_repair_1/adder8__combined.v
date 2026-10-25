module half_adder(input wire a, input wire b, output wire sum, output wire carry);
    assign sum   = a ^ b;
    assign carry = a & b;
endmodule
module full_adder(input wire a, input wire b, input wire cin, output wire sum, output wire cout);
    wire s1, c1, c2;

    half_adder ha0 (.a(a),  .b(b),   .sum(s1),  .carry(c1));
    half_adder ha1 (.a(s1), .b(cin), .sum(sum), .carry(c2));

    assign cout = c1 | c2;
endmodule
module adder4(input wire [3:0] a, input wire [3:0] b, input wire cin, output wire [3:0] sum, output wire cout);
    wire c1, c2, c3;

    full_adder fa0 (.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .cout(c1));
    full_adder fa1 (.a(a[1]), .b(b[1]), .cin(c1),  .sum(sum[1]), .cout(c2));
    full_adder fa2 (.a(a[2]), .b(b[2]), .cin(c2),  .sum(sum[2]), .cout(c3));
    full_adder fa3 (.a(a[3]), .b(b[3]), .cin(c3),  .sum(sum[3]), .cout(cout));
endmodule
module adder8(input wire [7:0] a, input wire [7:0] b, input wire cin, output wire [7:0] sum, output wire cout, output wire ovf);
    wire c4;

    adder4 lo (.a(a[3:0]), .b(b[3:0]), .cin(cin), .sum(sum[3:0]), .cout(c4));
    adder4 hi (.a(a[7:4]), .b(b[7:4]), .cin(c4),  .sum(sum[7:4]), .cout(cout));

    // signed overflow: operands have the same sign and the result sign differs
    // (covers both negative overflow 1+1->0 and positive overflow 0+0->1)
    assign ovf = (a[7] & b[7] & ~sum[7]) | (~a[7] & ~b[7] & sum[7]);
endmodule
