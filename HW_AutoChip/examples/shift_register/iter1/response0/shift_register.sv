module shift_register (
    input clk,
    input reset_n,
    input data_in,
    input shift_enable,
    output reg [7:0] data_out
);
    // Give data_out a defined value at t=0 in addition to the
    // asynchronous active-low reset, since the testbench never
    // pulses reset_n low before its first check.
    initial data_out = 8'b0;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            data_out <= 8'b0;
        else if (shift_enable)
            data_out <= {data_out[6:0], data_in};
    end
endmodule
