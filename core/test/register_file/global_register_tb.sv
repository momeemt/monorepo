`timescale 1ns / 1ps

import register_params::*;

module global_register_tb;
  // input
  logic clk;
  logic rst;
  logic write_reserve_input;
  logic [REGISTER_DESCRIPTOR_WIDTH-1:0] register_operand0_input;
  logic [REGISTER_DESCRIPTOR_WIDTH-1:0] register_operand1_input;
  logic write_back_input;
  logic [REGISTER_DESCRIPTOR_WIDTH-1:0] write_back_register_input;
  logic [OPERAND_WIDTH-1:0] result_input;

  // output
  logic [OPERAND_WIDTH-1:0] register_operand0_output;
  logic [OPERAND_WIDTH-1:0] register_operand1_output;
  logic reserved_output;

  task automatic display_error;
    input string testcase_name;
    $display("=== ERROR REPORT ===");
    $display("Testcase Name     : %s", testcase_name);
    $display("-----------------------------");
    $display("Inputs:");
    $display("  write_reserve_input       : %b", write_reserve_input);
    $display("  register_operand0_input   : %b", register_operand0_input);
    $display("  register_operand1_input   : %b", register_operand1_input);
    $display("  write_back_input          : %b", write_back_input);
    $display("  write_back_register_input : %b", write_back_register_input);
    $display("  result_input              : %h", result_input);
    $display("-----------------------------");
    $display("Outputs:");
    $display("  register_operand0_output : %h", register_operand0_output);
    $display("  register_operand1_output : %h", register_operand1_output);
    $display("  reserved_output          : %b", reserved_output);
    $error("Testcase %s failed. Check inputs and outputs for details.", testcase_name);
  endtask

  global_register uut (
      .clk(clk),
      .rst(rst),
      .write_reserve_input(write_reserve_input),
      .register_operand0_input(register_operand0_input),
      .register_operand1_input(register_operand1_input),
      .register_operand0_output(register_operand0_output),
      .register_operand1_output(register_operand1_output),
      .reserved_output(reserved_output),
      .write_back_input(write_back_input),
      .write_back_register_input(write_back_register_input),
      .result_input(result_input)
  );

  always #5 clk = ~clk;

  initial begin
    // initialize
    clk = 0;
    rst = 0;
    write_reserve_input = 0;
    register_operand0_input = 'b0;
    register_operand1_input = 'b0;
    write_back_input = 0;
    write_back_register_input = 'b0;
    result_input = 'b0;
    register_operand0_output = 'b0;
    register_operand1_output = 'b0;
    reserved_output = 0;

    #10 rst = 1;

    // check to success initialize
    #10 register_operand0_input = 5'b00001;  // first register
    #10 assert (register_operand0_output == 32'b0)
    else display_error("check to success initialize");
    #10 register_operand0_input = 'b0;

    // reg[1] = ABCDABCD
    #10 write_back_register_input = 5'b00001;  // first register
    result_input = 32'hABCDABCD;
    #10 write_back_input = 1;
    #10 write_back_register_input = 'b0;

    // Testcase1
    #10 register_operand0_input = 5'b00000;  // zero register
    #10 assert (register_operand0_output == 32'b0)
    else display_error("check the zero register");
    #10 write_back_input = 0;

    // Testcase2
    #10 register_operand0_input = 5'b00001;
    #10 assert (register_operand0_output == 32'hABCDABCD)
    else display_error("check to read the value from the first register");

    // reg[2] = BCDEBCDE;
    #10 write_back_register_input = 5'b00010;
    result_input = 32'hBCDEBCDE;
    #10 write_back_input = 1;
    #10 write_back_input = 0;

    // reg[3] = CDEFCDEF;
    #10 write_back_register_input = 5'b00011;
    result_input = 32'hCDEFCDEF;
    #10 write_back_input = 1;
    #10 write_back_input = 0;

    // Testcase3
    #10 register_operand0_input = 5'b00010;
    register_operand1_input = 5'b00011;
    #10 assert(register_operand0_output == 32'hBCDEBCDE && register_operand1_output == 32'hCDEFCDEF)
    else display_error("check to read both register operand0 and register operand1");

    // Testcase4
    #10 register_operand0_input = 5'b00001;
    #10 assert(register_operand0_output == 32'hABCDABCD)
    else display_error("check to maintain the previously stored value");

    $finish;
  end
endmodule
