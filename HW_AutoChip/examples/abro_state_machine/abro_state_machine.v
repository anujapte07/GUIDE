module abro_state_machine (
    input clk,
    input rst_n,
    input A,
    input B,
    output reg O,
    output reg [3:0] State
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            State <= 4'b0001;
            O     <= 1'b0;
        end else begin
            O <= (A && B) ? 1'b1 : 1'b0;
            if (A && !B)
                State <= 4'b0010;
            else if (!A && B)
                State <= 4'b0001;
            else if (A && B)
                State <= 4'b0100;
            // else A==0 && B==0: hold current State
        end
    end
endmodule
