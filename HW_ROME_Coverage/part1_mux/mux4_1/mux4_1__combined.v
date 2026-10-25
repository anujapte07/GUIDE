module mux2_1(input wire in1, input wire in2, input wire select, output wire out);
    assign out = select ? in2 : in1;
endmodule
module mux4_1(input [1:0] sel, input [3:0] in, output reg out);
    wire lo, hi, y;

    mux2_1 m_lo  (.in1(in[0]), .in2(in[1]), .select(sel[0]), .out(lo));
    mux2_1 m_hi  (.in1(in[2]), .in2(in[3]), .select(sel[0]), .out(hi));
    mux2_1 m_out (.in1(lo),    .in2(hi),    .select(sel[1]), .out(y));

    always @(*) begin
        out = y;
    end
endmodule
