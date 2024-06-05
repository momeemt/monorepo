module pipeline_stage(
  input logic clk,
  input logic rst,
  input logic valid_input, // if (valid_input == 1) valid
  output logic valid_output, // if (valid_output == 1) valid
  input logic [31:0] data_input,
  output logic [31:0] data_output,
  input logic stall_input, // if (stall_input == 1) stall
  output logic stall_output // if (stall_output == 1) stall
);
  logic valid_register;
  logic [31:0] data_register;

  assign valid_output = valid_register;
  assign data_output = data_register;
  assign stall_output = (valid_register & stall_input);

  always @(posedge clk or negedge rst) begin
    if (~rst) begin
      valid_register <= 0;
      data_register <= 0;
    end else if (~stall_input) begin
      valid_register <= valid_input;
      data_register <= data_input;
    end
  end
endmodule

