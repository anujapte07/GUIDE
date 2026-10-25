module mux8_1(input [2:0] sel, input [7:0] in, output reg out);
    wire lo, hi, y;

    mux4_1 m_lo  (.sel(sel[1:0]), .in(in[3:0]), .out(lo));
    mux4_1 m_hi  (.sel(sel[1:0]), .in(in[7:4]), .out(hi));
    mux2_1 m_out (.in1(lo), .in2(hi), .select(sel[2]), .out(y));

    always @(*) begin
        out = y;
    end
endmodule
