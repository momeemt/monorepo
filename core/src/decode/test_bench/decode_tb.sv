`timescale 1ns / 1ps

import opcode_type::*;

module decode_tb;
  logic clk;
  logic rst;
  logic [31:0] instruction;
  instr_kind_t instr_kind;

  decode uut (
      .clk(clk),
      .rst(rst),
  );

  always #5 clk = ~clk;

  initial begin
    clk = 0;
    rst = 0;
    instruction = 31'b0;
    #10 rst = 1;

    // LUI
    #10 instruction = 31'b00001111000011110000000000110111;
    #10
    assert (instr_kind == LUI)
    else display_error("Testcase LUI failed", instruction, instr_kind);
  end
endmodule
