module fetch (
    input logic clk,
    input logic rst,
    input logic valid_input,
    input logic branch_input,
    input logic [31:0] branch_dest_address,
    input logic stall_input,
    output logic valid_output,
    output logic stall_output,
    output logic [31:0] pc
);
  logic [31:0] internal_pc;

  assign pc = internal_pc;

  always_ff @(posedge clk or negedge rst) begin
    if (~rst) begin
      internal_pc <= 32'b0;
    end else if (stall_input | ~valid_input) begin
      internal_pc <= internal_pc;
    end else if (branch_input) begin
      internal_pc <= branch_dest_address;
    end else begin
      internal_pc <= internal_pc + 4;
    end

    valid_output <= valid_input;
  end
endmodule
