module mux64_1(input [5:0] sel, input [63:0] in, output reg out);
    wire lo, hi, y;

    mux32_1 m_lo  (.sel(sel[4:0]), .in(in[31:0]),  .out(lo));
    mux32_1 m_hi  (.sel(sel[4:0]), .in(in[63:32]), .out(hi));
    mux2_1  m_out (.in1(lo), .in2(hi), .select(sel[5]), .out(y));

    always @(*) begin
        out = y;
    end
endmodule
