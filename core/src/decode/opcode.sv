import opcode_type::opcode_t;

// The `opcode` module receives 6bits opcode and outputs an opcode kind.
// It can only process RV32I instructions.
module opcode (
    input logic clk,
    input logic rst,
    input logic [6:0] opcode,
    output opcode_t opcode_type
);
  always @(posedge rst) begin
    opcode_type <= '{default: 0};
  end

  always @(posedge clk or negedge rst) begin
    opcode_type <= '{default: 0};

    case (opcode)
      7'b0110111: opcode_type.is_lui <= 1;  // LUI
      7'b0010111: opcode_type.is_auipc <= 1;  // AUIPC
      7'b1101111: opcode_type.is_jal <= 1;  // JAL
      7'b1100111: opcode_type.is_jalr <= 1;  // JALR
      7'b1100011: opcode_type.is_branch_type <= 1;  // BEQ, BNE, BLT, BGE, BLTU, BGRU
      7'b0000011: opcode_type.is_load_type <= 1;  // LB, LH, LW, LBU, LHU
      7'b0100011: opcode_type.is_store_type <= 1;  // SB, SH, SW
      7'b0010011:
      opcode_type.is_imm_arith_type <= 1;  // ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI
      7'b0110011:
      opcode_type.is_reg_arith_type <= 1;  // ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND
      7'b0001111: opcode_type.is_fence_type <= 1;  // FENCE, FENCE.I
      7'b1110011:
      // ECALL, EBREAK, CSRRW, CSRRS, CSRRC, CSRRWI, CSRRSI, CSRRCI
      opcode_type.is_system_type <= 1;
      default: ;
    endcase
  end
endmodule
