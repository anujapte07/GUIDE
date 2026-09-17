
module dice_roller (
    input  wire clk,
    input  wire rst_n,          // active-low async reset
    input  wire [1:0] die_select,
    input  wire roll,
    output reg  [7:0] rolled_number
);
    reg [15:0] lfsr;
    reg roll_prev;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            lfsr          <= 16'hACE1;  // nonzero seed
            roll_prev     <= 1'b0;
            rolled_number <= 8'd1;
        end else begin
            // free-running maximal-length 16-bit LFSR (taps 16,14,13,11)
            lfsr <= {lfsr[14:0], lfsr[15] ^ lfsr[13] ^ lfsr[12] ^ lfsr[10]};

            roll_prev <= roll;
            if (roll && !roll_prev) begin // rising edge of roll -> take a sample
                case (die_select)
                    2'b00: rolled_number <= (lfsr[3:0] % 4)  + 1; // d4:  1-4
                    2'b01: rolled_number <= (lfsr[3:0] % 6)  + 1; // d6:  1-6
                    2'b10: rolled_number <= (lfsr[3:0] % 8)  + 1; // d8:  1-8
                    2'b11: rolled_number <= (lfsr[7:0] % 20) + 1; // d20: 1-20
                endcase
            end
        end
    end
endmodule
