
module binary_to_bcd_converter (
    input  wire [4:0] binary_input,   // 5-bit binary input (0-31)
    output reg  [7:0] bcd_output      // 8-bit BCD output (4 bits tens, 4 bits ones)
);
    always @(*) begin
        bcd_output[3:0] = binary_input % 10;  // ones digit
        bcd_output[7:4] = binary_input / 10;  // tens digit
    end
endmodule
