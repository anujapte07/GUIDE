module sequence_generator (
    input clk,
    input reset_n,
    input enable,
    output [7:0] data
);
    // The testbench samples `data` immediately after each posedge,
    // before this edge's own nonblocking updates have settled, so
    // the output must be combinational off of a register that was
    // already settled as of the *previous* edge (same pattern as
    // sequence_detector), rather than itself carrying a one-cycle
    // register delay.
    reg [2:0] idx;
    reg [7:0] seq [0:7];

    initial begin
        seq[0] = 8'hAF;
        seq[1] = 8'hBC;
        seq[2] = 8'hE2;
        seq[3] = 8'h78;
        seq[4] = 8'hFF;
        seq[5] = 8'hE2;
        seq[6] = 8'h0B;
        seq[7] = 8'h8D;
    end

    assign data = seq[idx];

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            idx <= 3'd0;
        else if (enable)
            idx <= idx + 1'b1;
    end
endmodule
