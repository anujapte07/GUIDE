
// 8-bit accumulator-based microprocessor
// ChipChat co-design: severely area/IO constrained (~1000 std cells target),
// single-byte instructions only, accumulator architecture.
//
// Instruction format (8 bits, single byte, no multi-byte instructions):
//   [7:5] opcode (3 bits)      [4:0] operand / address (5 bits, 0-31)
//
// Opcodes:
//   000 NOP              -- no operation
//   001 LDA addr         -- ACC <= DMEM[addr]
//   010 STA addr         -- DMEM[addr] <= ACC
//   011 ADD addr         -- ACC <= ACC + DMEM[addr]
//   100 SUB addr         -- ACC <= ACC - DMEM[addr]
//   101 JMP addr         -- PC  <= addr
//   110 JZ  addr         -- if (ACC == 0) PC <= addr; else PC <= PC + 1
//   111 HALT             -- stop execution (halted flag asserted)
//
// Harvard-style: 32 x 8 program ROM (addressed by 5-bit PC) and a separate
// 32 x 8 data RAM (addressed by the 5-bit operand field). Single-cycle
// execution: each instruction fetch+execute completes in one clock edge.

module cpu_8bit (
    input  wire       clk,
    input  wire       reset_n,      // active-low async reset
    output reg  [7:0] acc,          // accumulator (also exposed for debug/observation)
    output reg  [4:0] pc,           // program counter
    output reg        halted        // 1 once a HALT instruction has executed
);
    localparam OP_NOP  = 3'b000;
    localparam OP_LDA  = 3'b001;
    localparam OP_STA  = 3'b010;
    localparam OP_ADD  = 3'b011;
    localparam OP_SUB  = 3'b100;
    localparam OP_JMP  = 3'b101;
    localparam OP_JZ   = 3'b110;
    localparam OP_HALT = 3'b111;

    // Program ROM: 32 x 8-bit instructions
    reg [7:0] prog_mem [0:31];
    // Data RAM: 32 x 8-bit
    reg [7:0] data_mem [0:31];

    initial $readmemh("program.hex", prog_mem);

    wire [7:0] instr  = prog_mem[pc];
    wire [2:0] opcode = instr[7:5];
    wire [4:0] operand = instr[4:0];

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            acc    <= 8'd0;
            pc     <= 5'd0;
            halted <= 1'b0;
        end else if (!halted) begin
            case (opcode)
                OP_NOP: pc <= pc + 5'd1;
                OP_LDA: begin
                    acc <= data_mem[operand];
                    pc  <= pc + 5'd1;
                end
                OP_STA: begin
                    data_mem[operand] <= acc;
                    pc <= pc + 5'd1;
                end
                OP_ADD: begin
                    acc <= acc + data_mem[operand];
                    pc  <= pc + 5'd1;
                end
                OP_SUB: begin
                    acc <= acc - data_mem[operand];
                    pc  <= pc + 5'd1;
                end
                OP_JMP: pc <= operand;
                OP_JZ:  pc <= (acc == 8'd0) ? operand : pc + 5'd1;
                OP_HALT: halted <= 1'b1;
                default: pc <= pc + 5'd1;
            endcase
        end
    end
endmodule
