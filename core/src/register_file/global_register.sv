import register_file_params::*;

function automatic logic [REGISTER_SIZE-1:0] decode(input logic [REGISTER_DESCRIPTOR_WIDTH-1:0] in);
  logic [REGISTER_SIZE-1:0] result = 'b0;
  result[in] = 1'b1;
  return result;
endfunction

module global_register (
    input logic clk,
    input logic rst,
    input logic write_reserve_input,
    input logic [REGISTER_DESCRIPTOR_WIDTH-1:0] register_operand0_input,
    input logic [REGISTER_DESCRIPTOR_WIDTH-1:0] register_operand1_input,
    output logic [OPERAND_WIDTH-1:0] register_operand0_output,
    output logic [OPERAND_WIDTH-1:0] register_operand1_output,
    output logic reserved_output,
    input logic write_back_input,
    input logic [REGISTER_DESCRIPTOR_WIDTH-1:0] write_back_register_input,
    input logic [OPERAND_WIDTH-1:0] result_input
);
  logic [REGISTER_SIZE-1:0] write_reserve_vector;
  logic [REGISTER_SIZE-1:0] write_reserved_vector;
  logic [REGISTER_SIZE-1:0] write_back_register_vector;
  logic [OPERAND_WIDTH-1:0] register_data[REGISTER_SIZE];

  assign register_operand0_output = register_data[register_operand0_input];
  assign register_operand1_output = register_data[register_operand1_input];
  assign reserved_output = |((decode(
      register_operand0_input
  ) | decode(
      register_operand1_input
  )) & write_reserved_vector);
  assign write_reserve_vector = decode(
      write_back_register_input
  ) & {REGISTER_SIZE{write_reserve_input}};
  assign write_back_register_vector = decode(
      write_back_register_input
  ) & {REGISTER_SIZE{write_back_input}};

  always_ff @(negedge rst) begin
    write_reserved_vector <= '0;
    for (int i = 0; i < REGISTER_SIZE; i++) begin
        register_data[i] <= '0;
    end
  end

  generate
    genvar index;
    for (index = 1; index < REGISTER_SIZE; index++) begin : g_register_cell
      register_cell reg_cell (
          .clk(clk),
          .rst(rst),
          .data_input(result_input),
          .data_output(register_data[index]),
          .write_reserve_input(write_reserve_vector[index]),
          .write_reserve_output(write_reserved_vector[index]),
          .write_back_input(write_back_register_vector[index])
      );
    end
  endgenerate
endmodule
