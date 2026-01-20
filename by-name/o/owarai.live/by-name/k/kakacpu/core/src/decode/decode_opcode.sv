import instr_type::*;

// The `decode_opcode` module receives 6bits opcode and outputs an opcode kind.
// It can only process RV32I instructions.
module decode_opcode (
    input logic rst,
    input logic [6:0] opcode,
    output opcode_t opcode_type
);
  always_comb begin
    if (~rst) begin
      opcode_type = op_invalid;
    end else begin
      opcode_type = op_invalid;
      case (opcode)
        7'b0110111: opcode_type = op_lui;  // LUI
        7'b0010111: opcode_type = op_auipc;  // AUIPC
        7'b1101111: opcode_type = op_jal;  // JAL
        7'b1100111: opcode_type = op_jalr;  // JALR
        7'b1100011: opcode_type = op_branch_type;  // BEQ, BNE, BLT, BGE, BLTU, BGRU
        7'b0000011: opcode_type = op_load_type;  // LB, LH, LW, LBU, LHU
        7'b0100011: opcode_type = op_store_type;  // SB, SH, SW
        7'b0010011:
        opcode_type = op_imm_arith_type;  // ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI
        7'b0110011:
        opcode_type = op_reg_arith_type;  // ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND
        7'b0001111: opcode_type = op_fence_type;  // FENCE, FENCE.I
        7'b1110011:
        // ECALL, EBREAK, CSRRW, CSRRS, CSRRC, CSRRWI, CSRRSI, CSRRCI
        opcode_type = op_system_type;
        default: ;
      endcase
    end
  end
endmodule
