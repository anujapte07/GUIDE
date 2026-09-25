module sequence_detector (
    input clk,
    input reset_n,
    input [2:0] data,
    output reg sequence_found
);
    reg [23:0] history;
    localparam [23:0] TARGET = {3'b001,3'b101,3'b110,3'b000,3'b110,3'b110,3'b011,3'b101};

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            history <= 24'b0;
            sequence_found <= 1'b0;
        end else begin
            history <= {history[20:0], data};
            sequence_found <= ({history[20:0], data} == TARGET);
        end
    end
endmodule
