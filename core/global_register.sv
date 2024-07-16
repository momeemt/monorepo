`include "include/params.sv"

module global_register(
  input logic clk,
  input logic rst,
  input logic write_reserve_input,
  input logic [REGISTER_DESCRIPTOR_WIDTH-1:0] reg_operand0_input,
  input logic [REGISTER_DESCRIPTOR_WIDTH-1:0] reg_operand1_input,
  output logic [OPERAND_WIDTH-1:0] reg_operand0_output,
  output logic [OPERAND_WIDTH-1:0] reg_operand1_output,
  output logic reserved_output,
  input logic write_back_input,
  input logic [REGISTER_DESCRIPTOR_WIDTH-1:0] write_back_register_input,
  input logic [OPERAND_WIDTH-1:0] result_input
);

logic [REGISTER_SIZE-1:0] write_reserve_vector;
logic [REGISTER_SIZE-1:0] write_reserved_vector;
logic [REGISTER_SIZE-1:0] write_back_register_vector;

logic [OPERAND_WIDTH-1:0] register_data_0;
logic [OPERAND_WIDTH-1:0] register_data_1;
logic [OPERAND_WIDTH-1:0] register_data_2;
logic [OPERAND_WIDTH-1:0] register_data_3;
logic [OPERAND_WIDTH-1:0] register_data_4;
logic [OPERAND_WIDTH-1:0] register_data_5;
logic [OPERAND_WIDTH-1:0] register_data_6;
logic [OPERAND_WIDTH-1:0] register_data_7;
logic [OPERAND_WIDTH-1:0] register_data_8;
logic [OPERAND_WIDTH-1:0] register_data_9;
logic [OPERAND_WIDTH-1:0] register_data_10;
logic [OPERAND_WIDTH-1:0] register_data_11;
logic [OPERAND_WIDTH-1:0] register_data_12;
logic [OPERAND_WIDTH-1:0] register_data_13;
logic [OPERAND_WIDTH-1:0] register_data_14;
logic [OPERAND_WIDTH-1:0] register_data_15;

function [OPERAND_WIDTH-1:0] select16;
  input [3:0] select;
  input [OPERAND_WIDTH-1:0] data0, data1, data2, data3;
  input [OPERAND_WIDTH-1:0] data4, data5, data6, data7;
  input [OPERAND_WIDTH-1:0] data8, data9, data10, data11;
  input [OPERAND_WIDTH-1:0] data12, data13, data14, data15;
  begin
    case (select)
      4'b0000: select16 = data0;
      4'b0001: select16 = data1;
      4'b0010: select16 = data2;
      4'b0011: select16 = data3;
      4'b0100: select16 = data4;
      4'b0101: select16 = data5;
      4'b0110: select16 = data6;
      4'b0111: select16 = data7;
      4'b1000: select16 = data8;
      4'b1001: select16 = data9;
      4'b1010: select16 = data10;
      4'b1011: select16 = data11;
      4'b1100: select16 = data12;
      4'b1101: select16 = data13;
      4'b1110: select16 = data14;
      4'b1111: select16 = data15;
    endcase
  end
endfunction

function [15:0] decode16;
  input [3:0] d;
  begin
    case (d)
      4'b0000: decode16 = 16'b0000000000000001;
      4'b0001: decode16 = 16'b0000000000000010;
      4'b0010: decode16 = 16'b0000000000000100;
      4'b0011: decode16 = 16'b0000000000001000;
      4'b0100: decode16 = 16'b0000000000010000;
      4'b0101: decode16 = 16'b0000000000100000;
      4'b0110: decode16 = 16'b0000000001000000;
      4'b0111: decode16 = 16'b0000000010000000;
      4'b1000: decode16 = 16'b0000000100000000;
      4'b1001: decode16 = 16'b0000001000000000;
      4'b1010: decode16 = 16'b0000010000000000;
      4'b1011: decode16 = 16'b0000100000000000;
      4'b1100: decode16 = 16'b0001000000000000;
      4'b1101: decode16 = 16'b0010000000000000;
      4'b1110: decode16 = 16'b0100000000000000;
      4'b1111: decode16 = 16'b1000000000000000;
    endcase
  end
endfunction

assign reg_operand0_output = select16(
  reg_operand0_input,
  register_data_0, register_data_1, register_data_2, register_data_3,
  register_data_4, register_data_5, register_data_6, register_data_7,
  register_data_8, register_data_9, register_data_10, register_data_11,
  register_data_12, register_data_13, register_data_14, register_data_15
);

assign reg_operand1_output = select16(
  reg_operand1_input,
  register_data_0, register_data_1, register_data_2, register_data_3,
  register_data_4, register_data_5, register_data_6, register_data_7,
  register_data_8, register_data_9, register_data_10, register_data_11,
  register_data_12, register_data_13, register_data_14, register_data_15
);

assign reserved_output = |((decode16(reg_operand0_input) | decode16(reg_operand1_input)) & write_reserved_vector);

assign write_reserve_vector = decode16(write_back_register_input) & {REGISTER_SIZE{write_back_input}};

register_cell reg_cell_0 (
  .clk(clk),
  .rst(rst),
  .data_input(result_input),
  .data_output(register_data_0),
  .write_reserve_input(write_reserve_vector[0]),
  .write_reserve_output(write_reserved_vector[0]),
  .write_back_input(write_back_register_vector[0])
);

register_cell reg_cell_1 (
  .clk(clk),
  .rst(rst),
  .data_input(result_input),
  .data_output(register_data_1),
  .write_reserve_input(write_reserve_vector[1]),
  .write_reserve_output(write_reserved_vector[1]),
  .write_back_input(write_back_register_vector[1])
);

register_cell reg_cell_2 (
  .clk(clk),
  .rst(rst),
  .data_input(result_input),
  .data_output(register_data_2),
  .write_reserve_input(write_reserve_vector[2]),
  .write_reserve_output(write_reserved_vector[2]),
  .write_back_input(write_back_register_vector[2])
);

register_cell reg_cell_3 (
  .clk(clk),
  .rst(rst),
  .data_input(result_input),
  .data_output(register_data_3),
  .write_reserve_input(write_reserve_vector[3]),
  .write_reserve_output(write_reserved_vector[3]),
  .write_back_input(write_back_register_vector[3])
);

register_cell reg_cell_4 (
  .clk(clk),
  .rst(rst),
  .data_input(result_input),
  .data_output(register_data_4),
  .write_reserve_input(write_reserve_vector[4]),
  .write_reserve_output(write_reserved_vector[4]),
  .write_back_input(write_back_register_vector[4])
);

register_cell reg_cell_5 (
  .clk(clk),
  .rst(rst),
  .data_input(result_input),
  .data_output(register_data_5),
  .write_reserve_input(write_reserve_vector[5]),
  .write_reserve_output(write_reserved_vector[5]),
  .write_back_input(write_back_register_vector[5])
);

register_cell reg_cell_6 (
  .clk(clk),
  .rst(rst),
  .data_input(result_input),
  .data_output(register_data_6),
  .write_reserve_input(write_reserve_vector[6]),
  .write_reserve_output(write_reserved_vector[6]),
  .write_back_input(write_back_register_vector[6])
);

register_cell reg_cell_7 (
  .clk(clk),
  .rst(rst),
  .data_input(result_input),
  .data_output(register_data_7),
  .write_reserve_input(write_reserve_vector[7]),
  .write_reserve_output(write_reserved_vector[7]),
  .write_back_input(write_back_register_vector[7])
);

register_cell reg_cell_8 (
  .clk(clk),
  .rst(rst),
  .data_input(result_input),
  .data_output(register_data_8),
  .write_reserve_input(write_reserve_vector[8]),
  .write_reserve_output(write_reserved_vector[8]),
  .write_back_input(write_back_register_vector[8])
);

register_cell reg_cell_9 (
  .clk(clk),
  .rst(rst),
  .data_input(result_input),
  .data_output(register_data_9),
  .write_reserve_input(write_reserve_vector[9]),
  .write_reserve_output(write_reserved_vector[9]),
  .write_back_input(write_back_register_vector[9])
);

register_cell reg_cell_10 (
  .clk(clk),
  .rst(rst),
  .data_input(result_input),
  .data_output(register_data_10),
  .write_reserve_input(write_reserve_vector[10]),
  .write_reserve_output(write_reserved_vector[10]),
  .write_back_input(write_back_register_vector[10])
);

register_cell reg_cell_11 (
  .clk(clk),
  .rst(rst),
  .data_input(result_input),
  .data_output(register_data_11),
  .write_reserve_input(write_reserve_vector[11]),
  .write_reserve_output(write_reserved_vector[11]),
  .write_back_input(write_back_register_vector[11])
);

register_cell reg_cell_12 (
  .clk(clk),
  .rst(rst),
  .data_input(result_input),
  .data_output(register_data_12),
  .write_reserve_input(write_reserve_vector[12]),
  .write_reserve_output(write_reserved_vector[12]),
  .write_back_input(write_back_register_vector[12])
);

register_cell reg_cell_13 (
  .clk(clk),
  .rst(rst),
  .data_input(result_input),
  .data_output(register_data_13),
  .write_reserve_input(write_reserve_vector[13]),
  .write_reserve_output(write_reserved_vector[13]),
  .write_back_input(write_back_register_vector[13])
);

register_cell reg_cell_14 (
  .clk(clk),
  .rst(rst),
  .data_input(result_input),
  .data_output(register_data_14),
  .write_reserve_input(write_reserve_vector[14]),
  .write_reserve_output(write_reserved_vector[14]),
  .write_back_input(write_back_register_vector[14])
);

register_cell reg_cell_15 (
  .clk(clk),
  .rst(rst),
  .data_input(result_input),
  .data_output(register_data_15),
  .write_reserve_input(write_reserve_vector[15]),
  .write_reserve_output(write_reserved_vector[15]),
  .write_back_input(write_back_register_vector[15])
);

endmodule

