module mux16_1(input [3:0] sel, input [15:0] in, output reg out);
    wire lo, hi, y;

    mux8_1 m_lo  (.sel(sel[2:0]), .in(in[7:0]),  .out(lo));
    mux8_1 m_hi  (.sel(sel[2:0]), .in(in[15:8]), .out(hi));
    mux2_1 m_out (.in1(lo), .in2(hi), .select(sel[3]), .out(y));

    always @(*) begin
        out = y;
    end
endmodule
