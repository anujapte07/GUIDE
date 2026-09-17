
module abro_state_machine (
    input  wire clk,
    input  wire rst_n,     // active-low async reset
    input  wire A,
    input  wire B,
    output reg  O,
    output reg  [3:0] State
);
    // One-hot states
    localparam S_WAIT_A = 4'b0001; // B already seen (or idle), waiting for A
    localparam S_WAIT_B = 4'b0010; // A already seen, waiting for B
    localparam S_DONE   = 4'b0100; // both A and B seen this cycle -> O pulses

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            State <= S_WAIT_A;
            O     <= 1'b0;
        end else begin
            if (A && B) begin
                State <= S_DONE;
                O     <= 1'b1;
            end else if (A && !B) begin
                State <= S_WAIT_B;
                O     <= 1'b0;
            end else if (!A && B) begin
                State <= S_WAIT_A;
                O     <= 1'b0;
            end else begin
                // neither A nor B: hold current state
                O <= 1'b0;
            end
        end
    end
endmodule
