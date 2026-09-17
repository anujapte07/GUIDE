
module sequence_detector (
    input  wire clk,
    input  wire reset_n,       // active-low async reset
    input  wire [2:0] data,
    output wire sequence_found
);
    // Target overlapping sequence (8 x 3-bit words):
    // 001, 101, 110, 000, 110, 110, 011, 101
    localparam [23:0] TARGET = {3'b001, 3'b101, 3'b110, 3'b000,
                                 3'b110, 3'b110, 3'b011, 3'b101};

    reg [20:0] history; // last 7 received data words (7*3 = 21 bits)

    assign sequence_found = ({history, data} == TARGET);

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            history <= 21'b0;
        else
            history <= {history[17:0], data};
    end
endmodule
