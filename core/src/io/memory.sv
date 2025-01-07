import instr_type::*;
import register_file_params::*;

module memory (
    input logic clk,
    input logic rst,
    // instruction memory stage
    input logic instruction_memory_valid_input,
    input logic instruction_memory_stall_input,
    input logic [OPERAND_WIDTH-1:0] pc_input,
    output logic instruction_memory_valid_output,
    output logic instruction_memory_stall_output,
    output logic [OPERAND_WIDTH-1:0] pc_output,
    output logic [OPERAND_WIDTH-1:0] instruction_data,
    // data memory stage
    input logic data_memory_valid_input,
    input logic data_memory_stall_input,
    input logic read_data_enable,
    input logic [OPERAND_WIDTH-1:0] read_data_address,
    input logic write_data_enable,
    input logic [OPERAND_WIDTH-1:0] write_data,
    input logic [OPERAND_WIDTH-1:0] new_register_value_input,
    input logic [REGISTER_DESCRIPTOR_WIDTH-1:0] rd_addr_input,
    input logic write_register_input,
    input instr_kind_t instr_kind_input,
    output logic data_memory_valid_output,
    output logic data_memory_stall_output,
    output logic [OPERAND_WIDTH-1:0] read_data,
    output logic [REGISTER_DESCRIPTOR_WIDTH-1:0] rd_addr_output,
    output logic write_register_output,
    output instr_kind_t instr_kind_output
);
  assign pc_output = pc_input;
  assign instruction_data = inner_instruction_data;
  assign read_data = (read_data_enable) ? data_memory_read_data : new_register_value_input;
  assign rd_addr_output = rd_addr_input;
  assign write_register_output = write_register_input;
  assign instr_kind_output = instr_kind_input;
  assign instruction_memory_valid_output = instruction_memory_valid_input;
  assign instruction_memory_stall_output = instruction_memory_stall_input;
  assign data_memory_valid_output = data_memory_valid_input;
  assign data_memory_stall_output = data_memory_stall_input;

  logic [OPERAND_WIDTH-1:0] data_memory_read_data;
  logic [OPERAND_WIDTH-1:0] inner_instruction_data;

  altsyncram #(
      .operation_mode("DUAL_PORT"),
      .width_a(OPERAND_WIDTH),
      .widthad_a(7),
      .numwords_a(128),
      .width_b(OPERAND_WIDTH),
      .widthad_b(7),
      .numwords_b(128),
      .lpm_type("altsyncram"),
      .outdata_reg_a("CLOCK0"),
      .outdata_reg_b("CLOCK1"),
      .address_aclr_a("NONE"),
      .outdata_aclr_a("NONE"),
      .indata_aclr_a("NONE"),
      .wrcontrol_aclr_a("NONE"),
      .byte_size(8),
      .read_during_write_mode_mixed_ports("DONT_CARE"),
      .init_file("memory.mif")
  ) ram (
      .clock0(clk),
      .address_a(pc_input[6:0]),
      .q_a(inner_instruction_data),
      .clock1(clk),
      .wren_b(write_data_enable),
      .rden_b(read_data_enable),
      .data_b(write_data),
      .address_b(read_data_address[6:0]),
      .q_b(data_memory_read_data)
  );
endmodule
