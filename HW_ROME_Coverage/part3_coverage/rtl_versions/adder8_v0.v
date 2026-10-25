module adder8(input wire [7:0] a, input wire [7:0] b, input wire cin, output wire [7:0] sum, output wire cout, output wire ovf);
    wire c4;

    adder4 lo (.a(a[3:0]), .b(b[3:0]), .cin(cin), .sum(sum[3:0]), .cout(c4));
    adder4 hi (.a(a[7:4]), .b(b[7:4]), .cin(c4),  .sum(sum[7:4]), .cout(cout));

    // signed overflow
    assign ovf = a[7] & b[7] & ~sum[7];
endmodule
