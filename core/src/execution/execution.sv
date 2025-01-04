import instr_type::*;
import register_file_params::*;

module execution (
    input logic clk,
    input logic rst,
    input logic valid_input,
    input logic stall_input,
    input instr_kind_t instr_kind,
    input logic [OPERAND_WIDTH-1:0] rs1_data,
    input logic [OPERAND_WIDTH-1:0] rs2_data,
    input logic [OPERAND_WIDTH-1:0] immediate_data,
    input logic [REGISTER_DESCRIPTOR_WIDTH-1:0] rd_addr_input,
    input logic [31:0] pc,
    output logic valid_output,
    output logic stall_output,
    output logic [OPERAND_WIDTH-1:0] result,
    output logic [REGISTER_DESCRIPTOR_WIDTH-1:0] rd_addr_output,
    output logic write_register,
    output logic write_memory,
    output logic branch,
    output logic [REGISTER_DESCRIPTOR_WIDTH-1:0] branch_dest_address
);
  logic signed [OPERAND_WIDTH-1:0] signed_rs1_data;
  logic signed [OPERAND_WIDTH-1:0] signed_rs2_data;
  always_comb begin
    signed_rs1_data = rs1_data;
    signed_rs2_data = rs2_data;
    valid_output = valid_input;
    stall_output = stall_input;
    result = 'b0;
    write_register = 0;
    write_memory = 0;
    branch = 0;
    branch_dest_address = 'b0;
    rd_addr_output = rd_addr_input;

    case (instr_kind)
      LUI: begin
        // The zero padding is already done in the decoder.
        result = immediate_data;
        write_register = 1;
      end
      AUIPC: begin
        // The zero padding (12bit left shift) is already done in the decoder.
        result = immediate_data + pc;
        write_register = 1;
      end
      JAL: ;
      JALR: ;
      BEQ: begin
        branch_dest_address = (rs1_data == rs2_data) ? (pc + immediate_data) : (pc + 4);
      end
      BNE: begin
        branch_dest_address = (rs1_data !== rs2_data) ? (pc + immediate_data) : (pc + 4);
      end
      BLT: begin
        branch_dest_address =
          (signed_rs1_data < signed_rs2_data) ? (pc + immediate_data) : (pc + 4);
      end
      BGE: begin
        branch_dest_address =
          (signed_rs1_data >= signed_rs2_data) ? (pc + immediate_data) : (pc + 4);
      end
      BLTU: begin
        branch_dest_address = (rs1_data < rs2_data) ? (pc + immediate_data) : (pc + 4);
      end
      BGEU: begin
        branch_dest_address = (rs1_data >= rs2_data) ? (pc + immediate_data) : (pc + 4);
      end
      LB: begin
        result = rs1_data + immediate_data;
        write_memory = 1;
      end
      LH: ;
      LW: ;
      LBU: ;
      LHU: ;
      SB: ;
      SH: ;
      SW: ;
      ADDI: begin
        result = rs1_data + immediate_data;
      end
      SLTI: ;
      SLTIU: ;
      XORI: begin
        result = rs1_data ^ immediate_data;
      end
      ORI: begin
        result = rs1_data - immediate_data;
      end
      ANDI: begin
        result = rs1_data & immediate_data;
      end
      SLLI: ;
      SRLI: ;
      SRAI: ;
      ADD: begin
        result = rs1_data + rs2_data;
      end
      SUB: begin
        result = rs1_data - rs2_data;
      end
      SLL: begin
        result = rs1_data << rs2_data;
      end
      SLT: begin
        result = signed_rs1_data < signed_rs2_data;
      end
      SLTU: begin
        result = rs1_data < rs2_data;
      end
      XOR: begin
        result = rs1_data ^ rs2_data;
      end
      SRL: ;
      SRA: ;
      OR: begin
        result = rs1_data | rs2_data;
      end
      AND: begin
        result = rs1_data & rs2_data;
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
