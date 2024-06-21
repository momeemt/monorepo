`include "include/params.sv"

module register_cell (
  input logic clk,
  input logic rst,
  input logic [OPERAND_WIDTH-1:0] data_input;
  output logic [OPERAND_WIDTH-1:0] data_output;
  input logic write_reserve_input;
  output logic write_reserve_output;
  input logic write_back_input;
);

logic [OPERAND_WIDTH-1:0] register_cell;
logic write_reserve_bit;

assign data_output = register_cell;
assign write_reserve_output = write_reserve_bit;

always_ff @(posedge clk or negedge rst) begin
  if (~rst) begin
    write_reserve_bit <= 1'b0;
    register_cell <= {OPERAND_WIDTH{1'b0}};
  end else begin
    if (write_reserve_input) begin
      write_reserve_bit <= 1'b1;
    end else if (write_back_input) begin
      write_reserve_bit <= 1'b0;
      register_cell <= data_input;
    end
  end
end

endmodule

