module mux32_1(input [4:0] sel, input [31:0] in, output reg out);
    wire lo, hi, y;

    mux16_1 m_lo  (.sel(sel[3:0]), .in(in[15:0]),  .out(lo));
    mux16_1 m_hi  (.sel(sel[3:0]), .in(in[31:16]), .out(hi));
    mux2_1  m_out (.in1(lo), .in2(hi), .select(sel[4]), .out(y));

    always @(*) begin
        out = y;
    end
endmodule
