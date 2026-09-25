// 8-bit accumulator-based microprocessor.
// Co-design constraints from the starting prompt: severely limited
// space/IO (~1000 standard cells), accumulator architecture, no
// multi-byte instructions -> every instruction is exactly one byte.
//
// Instruction format: [7:5] = opcode (3 bits), [4:0] = operand/address (5 bits)
//   000 NOP
//   001 LDA addr   ACC <= DMEM[addr]
//   010 STA addr   DMEM[addr] <= ACC
//   011 ADD addr   ACC <= ACC + DMEM[addr]
//   100 SUB addr   ACC <= ACC - DMEM[addr]
//   101 JMP addr   PC  <= addr
//   110 JZ  addr   if (ACC==0) PC <= addr; else PC <= PC + 1
//   111 HALT       halted <= 1
//
// Harvard split: 32x8 program ROM addressed by 5-bit PC, 32x8 data RAM
// addressed by the 5-bit operand. Single-cycle fetch+execute per instruction.

module cpu_8bit (
    input  wire       clk,
    input  wire       reset_n,
    output reg  [7:0] acc,
    output reg  [4:0] pc,
    output reg        halted
);
    localparam OP_NOP  = 3'b000;
    localparam OP_LDA  = 3'b001;
    localparam OP_STA  = 3'b010;
    localparam OP_ADD  = 3'b011;
    localparam OP_SUB  = 3'b100;
    localparam OP_JMP  = 3'b101;
    localparam OP_JZ   = 3'b110;
    localparam OP_HALT = 3'b111;

    reg [7:0] prog_mem [0:31];
    reg [7:0] data_mem [0:31];

    initial $readmemh("program.hex", prog_mem);

    wire [7:0] instr   = prog_mem[pc];
    wire [2:0] opcode  = instr[7:5];
    wire [4:0] operand = instr[4:0];

    always @(posedge clk) begin
        if (!reset_n) begin
            acc    <= 8'd0;
            pc     <= 5'd0;
            halted <= 1'b0;
        end else if (!halted) begin
            case (opcode)
                OP_NOP:  pc <= pc + 5'd1;
                OP_LDA:  begin acc <= data_mem[operand]; pc <= pc + 5'd1; end
                OP_STA:  begin data_mem[operand] <= acc; pc <= pc + 5'd1; end
                OP_ADD:  begin acc <= acc + data_mem[operand]; pc <= pc + 5'd1; end
                OP_SUB:  begin acc <= acc - data_mem[operand]; pc <= pc + 5'd1; end
                OP_JMP:  pc <= operand;
                OP_JZ:   pc <= (acc == 8'd0) ? operand : pc + 5'd1;
                OP_HALT: halted <= 1'b1;
                default: pc <= pc + 5'd1;
            endcase
        end
    end
endmodule
