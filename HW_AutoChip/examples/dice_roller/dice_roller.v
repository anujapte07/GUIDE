module dice_roller (
    input clk,
    input rst_n,
    input [1:0] die_select,
    input roll,
    output reg [7:0] rolled_number
);
    reg [7:0] lfsr;
    wire feedback = lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            lfsr <= 8'hA5;
        else
            lfsr <= {lfsr[6:0], feedback};
    end

    reg [4:0] sides;
    always @(*) begin
        case (die_select)
            2'b00: sides = 5'd4;
            2'b01: sides = 5'd6;
            2'b10: sides = 5'd8;
            default: sides = 5'd20;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            rolled_number <= 8'd1;
        else if (roll)
            rolled_number <= (lfsr % sides) + 1'b1;
    end
endmodule
