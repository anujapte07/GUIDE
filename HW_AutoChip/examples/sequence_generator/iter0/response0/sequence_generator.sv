module sequence_generator (
    input clk,
    input reset_n,
    input enable,
    output reg [7:0] data
);
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

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            idx  <= 3'd0;
            data <= seq[0];
        end else if (enable) begin
            data <= seq[idx];
            idx  <= idx + 1'b1;
        end
    end
endmodule
