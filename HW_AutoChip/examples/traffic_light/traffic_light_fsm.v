module traffic_light_fsm (
    input clk,
    input reset_n,
    input enable,
    output reg red,
    output reg yellow,
    output reg green
);
    localparam S_RED = 2'b00, S_GREEN = 2'b01, S_YELLOW = 2'b10;
    reg [1:0] state;
    reg [5:0] count;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= S_RED;
            count <= 6'd0;
        end else if (enable) begin
            case (state)
                S_RED:    if (count == 6'd31) begin state <= S_GREEN;  count <= 0; end
                          else count <= count + 1'b1;
                S_GREEN:  if (count == 6'd19) begin state <= S_YELLOW; count <= 0; end
                          else count <= count + 1'b1;
                S_YELLOW: if (count == 6'd6)  begin state <= S_RED;    count <= 0; end
                          else count <= count + 1'b1;
                default:  state <= S_RED;
            endcase
        end
    end

    always @(*) begin
        red = 1'b0; yellow = 1'b0; green = 1'b0;
        case (state)
            S_RED:    red    = 1'b1;
            S_GREEN:  green  = 1'b1;
            S_YELLOW: yellow = 1'b1;
        endcase
    end
endmodule
