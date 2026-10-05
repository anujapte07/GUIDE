
module sat_adder8 (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire cin,
    output wire [7:0] sum,
    output wire sat
);
    // 9-bit full-precision result: bit 8 is set only when the true sum exceeds 255
    wire [8:0] full;
    assign full = a + b + cin;
    assign sat  = full[8];
    assign sum  = full[8] ? 8'hFF : full[7:0];
endmodule
