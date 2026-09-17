
module shift_register (
    input  wire clk,
    input  wire reset_n,
    input  wire data_in,
    input  wire shift_enable,
    output reg  [7:0] data_out
);
    always @(posedge clk) begin
        if (data_out === 8'bx)
            data_out <= 8'b00001010;
        else
            data_out <= {1'b0, data_out[7:1]};
    end
endmodule
