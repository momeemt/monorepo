module fetch (
    input logic clk,
    input logic rst,
    input logic branch_input,
    input logic [31:0] branch_dest_address,
    input logic stall_input,
    output logic valid_output,
    output logic [31:0] pc
);
  logic [31:0] internal_pc;
  logic valid;

  assign pc = internal_pc;
  assign valid_output = valid;

  always_ff @(posedge clk or negedge rst) begin
    if (~rst) begin
      internal_pc <= 32'b0;
      valid <= 1;
    end else if (stall_input) begin
      internal_pc <= internal_pc;
    end else if (branch_input) begin
      internal_pc <= branch_dest_address;
      valid <= 1;
    end else begin
      internal_pc <= internal_pc + 4;
      valid <= 1;
    end
  end
endmodule
