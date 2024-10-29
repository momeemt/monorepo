// The `opcode` module receives 6bits opcode and outputs an opcode kind.
// It can only process RV32I instructions.
module opcode (
    input logic clk,
    input logic rst,
    input logic [6:0] opcode,
    // funct7[31:25], rs2[24:20], rs1[19:15], funct3[14:12], rd[11:7], opcode[6:0]
    output logic is_r_type,
    // imm(11:0)[31:20], rs1[19:15], funct3[14:12], rs[11:7], opcode[6:0]
    output logic is_i_type,
    // imm(11:5)[31:25], rs2[24:20], rs1[19:15], funct3[14:12], imm(4:0)[11:7], opcode[6:0]
    output logic is_s_type,
    // imm(12|10:5)[31:25], rs2[24:20], rs1[19:15], funct3[14:12], imm(4:1|11)[11:7], opcode[6:0]
    output logic is_b_type,
    // imm(31:12)[31:12], rd[11:7], opcode[6:0]
    output logic is_u_type,
    // imm(20|10:1|11|19:12)[31:12], rd[11:7], opcode[6:0]
    output logic is_j_type,
    // omitted, opcode[6:0]
    output logic is_fence_type,
    // omitted, opcode[6:0]
    output logic is_system_type
);
  always @(posedge rst) begin
    is_r_type <= 0;
    is_i_type <= 0;
    is_s_type <= 0;
    is_b_type <= 0;
    is_u_type <= 0;
    is_j_type <= 0;
    is_fence_type <= 0;
    is_system_type <= 0;
  end

  always @(posedge clk or negedge rst) begin
    is_r_type <= 0;
    is_i_type <= 0;
    is_s_type <= 0;
    is_b_type <= 0;
    is_u_type <= 0;
    is_j_type <= 0;
    is_fence_type <= 0;
    is_system_type <= 0;

    case (opcode)
      7'b0110111: is_u_type <= 1;  // LUI
      7'b0010111: is_u_type <= 1;  // AUIPC
      7'b1101111: is_j_type <= 1;  // JAL
      7'b1100111: is_i_type <= 1;  // JALR
      7'b1100011: is_b_type <= 1;  // BEQ, BNE, BLT, BGE, BLTU, BGRU
      7'b0000011: is_i_type <= 1;  // LB, LH, LW, LBU, LHU
      7'b0100011: is_s_type <= 1;  // SB, SH, SW
      7'b0010011: is_i_type <= 1;  // ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI
      7'b0110011: is_r_type <= 1;  // ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND
      7'b0001111: is_fence_type <= 1;  // FENCE, FENCE.I
      7'b1110011:
      is_system_type <= 1;  // ECALL, EBREAK, CSRRW, CSRRS, CSRRC, CSRRWI, CSRRSI, CSRRCI
      default: ;
    endcase
  end
endmodule
