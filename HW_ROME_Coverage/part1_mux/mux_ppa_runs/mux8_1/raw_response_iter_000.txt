module mux8_1(input [2:0] sel, input [7:0] in, output reg out);
    always @(*) begin
        out = in[sel];
    end
endmodule
