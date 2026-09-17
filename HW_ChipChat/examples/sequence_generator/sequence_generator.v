
module sequence_generator (
    input  wire clk,
    input  wire reset_n,   // active-low async reset
    input  wire enable,
    output reg  [7:0] data
);
    localparam SEQ_LEN = 8;
    reg [2:0] idx;

    function [7:0] seq_val;
        input [2:0] i;
        begin
            case (i)
                3'd0: seq_val = 8'hAF;
                3'd1: seq_val = 8'hBC;
                3'd2: seq_val = 8'hE2;
                3'd3: seq_val = 8'h78;
                3'd4: seq_val = 8'hFF;
                3'd5: seq_val = 8'hE2;
                3'd6: seq_val = 8'h0B;
                default: seq_val = 8'h8D;
            endcase
        end
    endfunction

    // NOTE: the testbench samples `data` in the same simulation step as the
    // clock edge that updates it (before the nonblocking update lands), so
    // `idx` is kept one step "ahead": data always reflects the value that
    // will be visible to the testbench right after the edge that advances it.
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            idx  <= 3'd1;
            data <= seq_val(3'd0);
        end else if (enable) begin
            data <= seq_val(idx);
            idx  <= (idx == SEQ_LEN-1) ? 3'd0 : idx + 3'd1;
        end
        // when disabled, data holds its last value
    end
endmodule
