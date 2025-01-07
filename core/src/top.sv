module top (
    input logic CLOCK_50,
    input logic [3:0] KEY
);
  assign clk = CLOCK_50;
  assign rst = KEY[0];

  // valid
  logic fetch_valid_output;
  logic instruction_memory_valid_output;
  logic decode_valid_output;
  logic execution_valid_output;
  logic data_memory_valid_output;

  // stall
  logic write_back_stall_output;
  logic data_memory_stall_output;
  logic execution_stall_output;
  logic decode_stall_output;
  logic instruction_memory_stall_output;

  // pc
  logic [OPERAND_WIDTH-1:0] fetch_pc;
  logic [OPERAND_WIDTH-1:0] instruction_memory_pc;
  logic [OPERAND_WIDTH-1:0] decode_pc;

  // instr_kind
  instr_kind_t decode_instr_kind;
  instr_kind_t execution_instr_kind;
  instr_kind_t data_memory_instr_kind;

  // rd
  logic [REGISTER_DESCRIPTOR_WIDTH-1:0] decode_rd_addr;
  logic [REGISTER_DESCRIPTOR_WIDTH-1:0] execution_rd_addr;
  logic [REGISTER_DESCRIPTOR_WIDTH-1:0] data_memory_rd_addr;

  logic branch;
  logic [OPERAND_WIDTH-1:0] branch_dest_address;
  logic [OPERAND_WIDTH-1:0] instruction_data;
  logic [REGISTER_DESCRIPTOR_WIDTH-1:0] decode_rs1_addr;
  logic [REGISTER_DESCRIPTOR_WIDTH-1:0] decode_rs2_addr;
  logic [4:0] decode_shamt;
  logic [3:0] decode_pred;
  logic [3:0] decode_succ;
  logic [10:0] decode_csr;
  logic [4:0] decode_zimm;
  logic [OPERAND_WIDTH-1:0] decode_immediate_data;
  logic decode_write_reserve;
  logic [OPERAND_WIDTH-1:0] reg_file_rs1_data;
  logic [OPERAND_WIDTH-1:0] reg_file_rs2_data;
  logic reg_file_reserved;
  logic [OPERAND_WIDTH-1:0] execution_new_register_value;
  logic [OPERAND_WIDTH-1:0] execution_read_memory_address;
  logic [OPERAND_WIDTH-1:0] execution_write_memory_address;
  logic [OPERAND_WIDTH-1:0] execution_new_memory_value;
  logic execution_write_register;
  logic execution_read_memory;
  logic execution_write_memory;
  logic execution_branch;
  logic [OPERAND_WIDTH-1:0] execution_branch_dest_address;
  logic [OPERAND_WIDTH-1:0] data_memory_new_register_value;
  logic data_memory_write_register;

  fetch fetch (
      .clk(clk),
      .rst(rst),
      .branch_input(branch),
      .branch_dest_address(branch_dest_address),
      .stall_input(instruction_memory_stall_output),
      .valid_output(fetch_valid_output),
      .pc(fetch_pc)
  );

  // read next instruction pointed to by the program counter (pc)
  // write data calculated by the execution stage
  memory memory (
      .clk(clk),
      .rst(rst),
      // instruction memory stage
      .instruction_memory_valid_input(fetch_valid_output),
      .instruction_memory_stall_input(decode_stall_output),
      .pc_input(fetch_pc),
      .instruction_memory_valid_output(instruction_memory_valid_output),
      .instruction_memory_stall_output(instruction_memory_stall_output),
      .pc_output(instruction_memory_pc),
      .instruction_data(instruction_data),
      // data memory stage
      .data_memory_valid_input(execution_valid_output),
      .data_memory_stall_input(write_back_stall_output),
      .read_data_enable(execution_read_memory),
      .read_data_address(execution_read_memory_address),
      .write_data_enable(execution_write_memory),
      .write_data(execution_write_memory_address),
      .new_register_value_input(execution_new_register_value),
      .rd_addr_input(execution_rd_addr),
      .write_register_input(execution_write_register),
      .instr_kind_input(execution_instr_kind),
      .data_memory_valid_output(data_memory_valid_output),
      .data_memory_stall_output(data_memory_stall_output),
      .read_data(data_memory_new_register_value),
      .rd_addr_output(data_memory_rd_addr),
      .write_register_output(data_memory_write_register),
      .instr_kind_output(data_memory_instr_kind)
  );

  decode decode (
      .clk(clk),
      .rst(rst),
      .valid_input(instruction_memory_valid_output),
      .stall_input(execution_stall_output),
      .instruction(instruction_data),
      .valid_output(decode_valid_output),
      .stall_output(decode_stall_output),
      .instr_kind(decode_instr_kind),
      .rs1_addr(decode_rs1_addr),
      .rs2_addr(decode_rs2_addr),
      .rd_addr(deocde_rd_addr),
      .pred(decode_pred),
      .succ(decode_succ),
      .csr(decode_csr),
      .zimm(decode_zimm),
      .immediate_data(decode_immediate_data),
      .write_reserve(decode_write_reserve)
  );

  global_register reg_file (
      .clk(clk),
      .rst(rst),
      .write_reserve_input(decode_write_reserve),
      .register_operand0_input(decode_rs1_addr),
      .register_operand1_input(decode_rs2_addr),
      .register_operand0_output(reg_file_rs1_data),
      .register_operand1_output(reg_file_rs2_data),
      .reserved_output(reg_file_reserved),
      .write_back_input(write_back_register_input),
      .write_back_register_input(),
      .result_input()
  );

  execution execution (
      .clk(clk),
      .rst(rst),
      .valid_input(decode_valid_output),
      .stall_input(write_back_stall_output),
      .instr_kind_input(decode_instr_kind),
      .rs1_data(reg_file_rs1_data),
      .rs2_data(reg_file_rs2_data),
      .rd_addr_input(decode_rd_addr),
      .shamt(decode_shamt),
      .pred(decode_pred),
      .succ(decode_succ),
      .csr(decode_csr),
      .zimm(decode_zimm),
      .immediate_data(decode_immediate_data),
      .pc(),  // fetchから流す
      .valid_output(execution_valid_output),
      .stall_output(execution_stall_output),
      .instr_kind_output(execution_instr_kind),
      .new_register_value(execution_new_register_value),
      .read_memory_address(execution_read_memory_address),
      .write_memory_address(execution_write_memory_address),
      .new_memory_value(execution_new_memory_value),
      .rd_addr_output(execution_rd_addr),
      .write_register(execution_write_register),
      .read_memory(execution_read_memory),
      .write_memory(execution_write_memory),
      .branch(execution_branch),
      .branch_dest_address(execution_branch_dest_address)
  );

  write_back write_back (
      .clk(clk),
      .rst(rst),
      .valid_input(data_memory_valid_output),
      .instr_kind(data_memory_instr_kind),
      .write_register(data_memory_write_register),
      .new_register_value(data_memory_new_register_value),
      .rd_addr(data_memory_rd_addr),
      .stall_output(write_back_stall_output)
  );

  always_ff @(posedge clk or negedge rst) begin
    if (~rst) begin
    end
  end

endmodule
