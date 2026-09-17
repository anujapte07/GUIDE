
module lfsr (
    input  wire clk,
    input  wire reset_n,   // active-low async reset
    output reg  [7:0] data
);
    // Fibonacci LFSR, taps at bit positions 1,4,6,7 (0-indexed: 0,3,5,6),
    // initial state 8'b10001010, shifts left, new bit enters LSB.
    wire feedback = data[0] ^ data[3] ^ data[5] ^ data[6];

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            data <= 8'b10001010;
        else
            data <= {data[6:0], feedback};
    end
endmodule
