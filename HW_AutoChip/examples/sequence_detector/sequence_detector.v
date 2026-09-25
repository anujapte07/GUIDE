module sequence_detector (
    input clk,
    input reset_n,
    input [2:0] data,
    output sequence_found
);
    // History holds the previous 7 symbols; the testbench samples
    // sequence_found combinationally right after asserting the new
    // symbol and before the next clock edge's registers have settled,
    // so the comparison must be combinational (current data + the
    // already-registered previous 7 symbols) rather than fully
    // registered, to avoid a one-cycle lag against the checker.
    reg [20:0] history;
    localparam [23:0] TARGET = {3'b001,3'b101,3'b110,3'b000,3'b110,3'b110,3'b011,3'b101};

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            history <= 21'b0;
        else
            history <= {history[17:0], data};
    end

    assign sequence_found = ({history, data} == TARGET);
endmodule
