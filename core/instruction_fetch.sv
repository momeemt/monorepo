module instruction_fetch(
  input logic clk,
  input logic rst,

  input logic valid_input, // if (valid_input == 1) valid
  output logic valid_output, // if (valid_output == 1) valid
  output logic [31:0] data_output,
  input logic branch_input, // if (branch_input == 1) branch
  input logic [31:0] branch_dest_address,
  input logic stall_input, // if (stall_input == 1) stall
  output logic stall_output, // if (stall_output == 1) stall
  output logic [31:0] pc,
  input logic [31:0] fetched_instruction
);

logic [31:0] internal_pc;

always_ff @(posedge clk or negedge rst) begin
  if (~rst) begin
    internal_pc <= 32'b0;
  end else if (stall_input | ~valid_input) begin
    internal_pc <= internal_pc;
  end else if (branch_input) begin
    internal_pc <= branch_dest_address;
  end else begin
    internal_pc <= internal_pc + 1;
  end
end

assign pc = internal_pc;
assign data_output = fetched_instruction;

always_ff @(posedge clk) begin
  if (valid_input) begin
    valid_output <= 1;
  end else begin
    valid_output <= 0;
  end
end

endmodule
