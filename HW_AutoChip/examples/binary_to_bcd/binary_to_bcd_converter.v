module binary_to_bcd_converter (
    input  [4:0] binary_input,
    output reg [7:0] bcd_output
);
    always @(*) begin
        bcd_output[7:4] = binary_input / 10;
        bcd_output[3:0] = binary_input % 10;
    end
endmodule
