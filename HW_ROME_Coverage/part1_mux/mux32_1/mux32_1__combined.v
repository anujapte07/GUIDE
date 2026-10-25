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
module mux8_1(input [2:0] sel, input [7:0] in, output reg out);
    wire lo, hi, y;

    mux4_1 m_lo  (.sel(sel[1:0]), .in(in[3:0]), .out(lo));
    mux4_1 m_hi  (.sel(sel[1:0]), .in(in[7:4]), .out(hi));
    mux2_1 m_out (.in1(lo), .in2(hi), .select(sel[2]), .out(y));

    always @(*) begin
        out = y;
    end
endmodule
module mux16_1(input [3:0] sel, input [15:0] in, output reg out);
    wire lo, hi, y;

    mux8_1 m_lo  (.sel(sel[2:0]), .in(in[7:0]),  .out(lo));
    mux8_1 m_hi  (.sel(sel[2:0]), .in(in[15:8]), .out(hi));
    mux2_1 m_out (.in1(lo), .in2(hi), .select(sel[3]), .out(y));

    always @(*) begin
        out = y;
    end
endmodule
module mux32_1(input [4:0] sel, input [31:0] in, output reg out);
    wire lo, hi, y;

    mux16_1 m_lo  (.sel(sel[3:0]), .in(in[15:0]),  .out(lo));
    mux16_1 m_hi  (.sel(sel[3:0]), .in(in[31:16]), .out(hi));
    mux2_1  m_out (.in1(lo), .in2(hi), .select(sel[4]), .out(y));

    always @(*) begin
        out = y;
    end
endmodule
