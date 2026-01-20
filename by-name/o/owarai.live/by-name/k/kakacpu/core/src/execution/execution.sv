import instr_type::*;
import register_file_params::*;

module execution (
    input logic clk,
    input logic rst,
    input logic valid_input,
    input logic stall_input,
    input instr_kind_t instr_kind_input,
    input logic [OPERAND_WIDTH-1:0] rs1_data,
    input logic [OPERAND_WIDTH-1:0] rs2_data,
    input logic [REGISTER_DESCRIPTOR_WIDTH-1:0] rd_addr_input,
    input logic [4:0] shamt,
    input logic [3:0] pred,
    input logic [3:0] succ,
    input logic [10:0] csr,
    input logic [4:0] zimm,
    input logic [OPERAND_WIDTH-1:0] immediate_data,
    input logic [31:0] pc,
    output logic valid_output,
    output logic stall_output,
    output instr_kind_t instr_kind_output,
    output logic [OPERAND_WIDTH-1:0] new_register_value,  // *rd_addr_input = new_register_value
    output logic [OPERAND_WIDTH-1:0] read_memory_address,
    output logic [OPERAND_WIDTH-1:0] write_memory_address,
    output logic [OPERAND_WIDTH-1:0] new_memory_value,  // *write_memory_address = new_memory_value
    output logic [REGISTER_DESCRIPTOR_WIDTH-1:0] rd_addr_output,
    output logic write_register,
    output logic read_memory,
    output logic write_memory,
    output logic branch,
    output logic [OPERAND_WIDTH-1:0] branch_dest_address
);
  logic signed [OPERAND_WIDTH-1:0] signed_rs1_data;
  logic signed [OPERAND_WIDTH-1:0] signed_rs2_data;
  logic signed [OPERAND_WIDTH-1:0] signed_immediate_data;

  always_comb begin
    signed_rs1_data = rs1_data;
    signed_rs2_data = rs2_data;
    signed_immediate_data = immediate_data;

    valid_output = valid_input;
    stall_output = stall_input;
    instr_kind_output = instr_kind_input;
    new_register_value = 'b0;
    read_memory_address = 'b0;
    write_memory_address = 'b0;
    new_memory_value = 'b0;
    write_register = 0;
    read_memory = 0;
    write_memory = 0;
    branch = 0;
    branch_dest_address = 'b0;
    rd_addr_output = rd_addr_input;

    case (instr_kind_input)
      LUI: begin
        // The zero padding is already done in the decoder.
        write_register = 1;
        new_register_value = immediate_data;
      end
      AUIPC: begin
        // The zero padding (12bit left shift) is already done in the decoder.
        write_register = 1;
        new_register_value = immediate_data + pc;
      end
      JAL: begin
        write_register = 1;
        new_register_value = pc + 4;
        branch = 1;
        branch_dest_address = pc + immediate_data;
      end
      JALR: begin
        write_register = 1;
        new_register_value = pc + 4;
        branch = 1;
        branch_dest_address = rs1_data + immediate_data;
      end
      BEQ: begin
        branch = 1;
        branch_dest_address = (rs1_data == rs2_data) ? (pc + immediate_data) : (pc + 4);
      end
      BNE: begin
        branch = 1;
        branch_dest_address = (rs1_data !== rs2_data) ? (pc + immediate_data) : (pc + 4);
      end
      BLT: begin
        branch = 1;
        branch_dest_address =
          (signed_rs1_data < signed_rs2_data) ? (pc + immediate_data) : (pc + 4);
      end
      BGE: begin
        branch = 1;
        branch_dest_address =
          (signed_rs1_data >= signed_rs2_data) ? (pc + immediate_data) : (pc + 4);
      end
      BLTU: begin
        branch = 1;
        branch_dest_address = (rs1_data < rs2_data) ? (pc + immediate_data) : (pc + 4);
      end
      BGEU: begin
        branch = 1;
        branch_dest_address = (rs1_data >= rs2_data) ? (pc + immediate_data) : (pc + 4);
      end
      LB, LH, LW, LBU, LHU: begin
        write_register = 1;
        new_register_value = 'b0;  // unknown
        read_memory = 1;
        read_memory_address = rs1_data + immediate_data;
      end
      SB, SH, SW: begin
        write_memory = 1;
        write_memory_address = rs1_data + immediate_data;
        new_memory_value = rs2_data;
      end
      ADDI: begin
        write_register = 1;
        new_register_value = rs1_data + immediate_data;
      end
      SLTI: begin
        write_register = 1;
        new_register_value = (signed_rs1_data < signed_immediate_data) ? 'b1 : 'b0;
      end
      SLTIU: begin
        write_register = 1;
        new_register_value = (rs1_data < immediate_data) ? 'b1 : 'b0;
      end
      XORI: begin
        write_register = 1;
        new_register_value = rs1_data ^ immediate_data;
      end
      ORI: begin
        write_register = 1;
        new_register_value = rs1_data | immediate_data;
      end
      ANDI: begin
        write_register = 1;
        new_register_value = rs1_data & immediate_data;
      end
      SLLI: begin
        write_register = 1;
        new_register_value = rs1_data << shamt;
      end
      SRLI: begin
        write_register = 1;
        new_register_value = rs1_data >> shamt;
      end
      SRAI: begin
        write_register = 1;
        new_register_value = $signed(signed_rs1_data >>> shamt);
      end
      ADD: begin
        write_register = 1;
        new_register_value = rs1_data + rs2_data;
      end
      SUB: begin
        write_register = 1;
        new_register_value = rs1_data - rs2_data;
      end
      SLL: begin
        write_register = 1;
        new_register_value = rs1_data << (rs2_data & 5'b11111);
      end
      SLT: begin
        write_register = 1;
        new_register_value = (signed_rs1_data < signed_rs2_data) ? 'b1 : 'b0;
      end
      SLTU: begin
        write_register = 1;
        new_register_value = (rs1_data < rs2_data) ? 'b1 : 'b0;
      end
      XOR: begin
        write_register = 1;
        new_register_value = rs1_data ^ rs2_data;
      end
      SRL: begin
        write_register = 1;
        new_register_value = rs1_data >> (rs2_data & 5'b11111);
      end
      SRA: begin
        write_register = 1;
        new_register_value = $signed(signed_rs1_data >>> (rs2_data & 5'b11111));
      end
      OR: begin
        write_register = 1;
        new_register_value = rs1_data | rs2_data;
      end
      AND: begin
        write_register = 1;
        new_register_value = rs1_data & rs2_data;
      end
      FENCE: ;
      FENCE_I: ;
      ECALL: ;
      EBREAK: ;
      CSRRW: ;
      CSRRS: ;
      CSRRC: ;
      CSRRWI: ;
      CSRRSI: ;
      CSRRCI: ;
      default: ;
    endcase
  end
endmodule
