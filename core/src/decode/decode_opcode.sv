import instr_type::*;

// The `decode_opcode` module receives 6bits opcode and outputs an opcode kind.
// It can only process RV32I instructions.
module decode_opcode (
    input logic clk,
    input logic rst,
    input logic [6:0] opcode,
    output opcode_t opcode_type
);
  always @(posedge rst) begin
    opcode_type <= invalid;
  end

  always @(posedge clk or negedge rst) begin
    opcode_type <= invalid;

    case (opcode)
      7'b0110111: opcode_type <= lui;  // LUI
      7'b0010111: opcode_type <= auipc;  // AUIPC
      7'b1101111: opcode_type <= jal;  // JAL
      7'b1100111: opcode_type <= jalr;  // JALR
      7'b1100011: opcode_type <= branch_type;  // BEQ, BNE, BLT, BGE, BLTU, BGRU
      7'b0000011: opcode_type <= load_type;  // LB, LH, LW, LBU, LHU
      7'b0100011: opcode_type <= store_type;  // SB, SH, SW
      7'b0010011:
      opcode_type <= imm_arith_type;  // ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI
      7'b0110011:
      opcode_type <= reg_arith_type;  // ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND
      7'b0001111: opcode_type <= fence_type;  // FENCE, FENCE.I
      7'b1110011:
      // ECALL, EBREAK, CSRRW, CSRRS, CSRRC, CSRRWI, CSRRSI, CSRRCI
      opcode_type <= system_type;
      default: ;
    endcase
  end
endmodule
