module top (
    input logic CLOCK_50,
    input logic [3:0] KEY,
    output logic [7:0] LEDR,
    output logic [6:0] HEX0,
    output logic [6:0] HEX1,
    output logic [6:0] HEX2,
    output logic [6:0] HEX3
);
  assign clk = CLOCK_50;
  assign rst = KEY[0];

  logic fetch_valid_input;
  logic fetch_valid_output;
  logic fetch_stall_input;
  logic fetch_stall_output;
  logic branch;
  logic [31:0] branch_dest_address;
  logic [31:0] pc;

  fetch fetch_inst (
      .clk(clk),
      .rst(rst),
      .valid_input(fetch_valid_input),
      .branch_input(branch),
      .branch_dest_address(branch_dest_address),
      .stall_input(fetch_stall_input),
      .valid_output(fetch_valid_output),
      .stall_output(fetch_stall_output),
      .pc(pc)
  );

  memory mem (
      .clk(clk),
      .rst(rst),
      .addr(instruction_address),
      .write_enable(0),
      .write_data(0),
      .read_data(instruction_data)
  );

  logic decode_valid_output;
  logic decode_stall_output;
  instr_kind_t instr_kind;
  logic [REGISTER_DESCRIPTOR_WIDTH-1:0] rs1_addr;
  logic [REGISTER_DESCRIPTOR_WIDTH-1:0] rs2_addr;
  logic [REGISTER_DESCRIPTOR_WIDTH-1:0] decoder_rd_addr;
  logic [3:0] pred;
  logic [3:0] succ;
  logic [10:0] csr;
  logic [4:0] zimm;
  logic [OPERAND_WIDTH-1:0] immediate_data;
  logic write_reserve;

  decode decode_inst (
      .clk(clk),
      .rst(rst),
      .valid_input(fetch_valid_output),
      .stall_input(fetch_stall_output),
      .instruction(instruction_data),
      .valid_output(decode_valid_output),
      .stall_output(decode_stall_output),
      .instr_kind(instr_kind),
      .rs1_addr(rs1_addr),
      .rs2_addr(rs2_addr),
      .rd_addr(rd_addr),
      .pred(pred),
      .succ(succ),
      .csr(csr),
      .zimm(zimm),
      .immediate_data(immediate_data),
      .write_reserve(write_reserve)
  );

  logic [OPERAND_WIDTH-1:0] rs1_data;
  logic [OPERAND_WIDTH-1:0] rs2_data;
  logic reserved_output;
  logic write_register;
  logic [OPERAND_WIDTH-1:0] result_input;

  logic [OPERAND_WIDTH-1:0] first_register;

  global_register reg_file (
      .clk(clk),
      .rst(rst),
      .write_reserve_input(write_reserve),
      .register_operand0_input(rs1_addr),
      .register_operand1_input(rs2_addr_or_shamt),
      .register_operand0_output(rs1_data),
      .register_operand1_output(rs2_data),
      .reserved_output(reserved_output),
      .write_back_input(write_register),
      .write_back_register_input(rd_addr_from_execution), // 今はdecoderの出力を直接渡しているが、クロックを跨いで描き変わる可能性があるのでexeにも渡して変数を分ける
      .result_input(result_input),
      .debug_first_register(first_register)
  );

  logic write_memory;
  logic execution_valid_output;
  logic execution_stall_output;
  execution execution_inst (
      .clk(clk),
      .rst(rst),
      .valid_input(decode_valid_output),
      .stall_input(decode_stall_output),
      .instr_kind(instr_kind),
      .rs1_data(rs1_data),
      .rs2_data(rs2_data),
      .immediate_data(immediate_data),
      .pc(pc),
      .valid_output(execution_valid_output),
      .stall_output(execution_stall_output),
      .result(result_input),
      .write_register(write_register),
      .write_memory(write_memory),
      .branch(branch),
      .branch_dest_address(branch_dest_address)
  );

  write_back write_back_inst (
      .clk(clk),
      .rst(rst),
      .valid_input(execution_valid_output),
      .stall_input(execution_stall_output)
  );

  integer counter;
  always_ff @(posedge clk or negedge rst) begin
    if (~rst) begin
      counter <= 0;
      fetch_valid_input <= 0;
    end else begin
      counter <= counter + 1;
      if (counter == 50_000_000) begin
        counter <= 0;
        fetch_valid_input <= 1;
      end else begin
        fetch_valid_input <= 0;
      end
    end
  end

  logic [6:0] hex_output [4];
  four_digits_segments four_digits_segments_inst (
      .clk(clk),
      .rst(rst),
      .enable(fetch_valid_input),
      .value(first_register[3:0]),
      .HEX(hex_output),
  );
  assign HEX0 = hex_output[0];
  assign HEX1 = hex_output[1];
  assign HEX2 = hex_output[2];
  assign HEX3 = hex_output[3];
endmodule

