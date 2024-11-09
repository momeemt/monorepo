`timescale 1ns / 1ps

import register_params::*;

module register_cell_tb;
  // input
  logic clk;
  logic rst;
  logic [OPERAND_WIDTH-1:0] data_input;
  logic write_reserve_input;
  logic write_back_input;

  // output
  logic [OPERAND_WIDTH-1:0] data_output;
  logic write_reserve_output;

  task automatic display_error;
    input string testcase_name;
    $display("=== ERROR REPORT ===");
    $display("Testcase Name     : %s", testcase_name);
    $display("-----------------------------");
    $display("Inputs:");
    $display("  write_reserve_input       : %b", write_reserve_input);
    $display("  write_back_input          : %b", write_back_input);
    $display("  data_input                : %h", data_input);
    $display("-----------------------------");
    $display("Outputs:");
    $display("  data_output               : %h", data_output);
    $display("  write_reserve_output      : %b", write_reserve_output);
    $error("Testcase %s failed. Check inputs and outputs for details.", testcase_name);
  endtask

  register_cell uut (
      .clk(clk),
      .rst(rst),
      .data_input(data_input),
      .data_output(data_output),
      .write_reserve_input(write_reserve_input),
      .write_reserve_output(write_reserve_output),
      .write_back_input(write_back_input)
  );

  always #5 clk = ~clk;

  initial begin
    // initialize
    clk = 0;
    rst = 0;
    data_input = 'b0;
    write_reserve_input = 0;
    write_back_input = 0;

    #10 rst = 1;

    // Testcase1
    #10
    assert (data_output == 32'b0 && write_reserve_output == 0)
    else display_error("check to success initializing");

    // Testcase2
    #10 data_input = 32'hABCDABCD;
    write_back_input = 1;
    #10
    assert (data_output == 32'hABCDABCD)
    else display_error("check to save data");

    // Testcase2: reset
    #10 data_input = 'b0;
    #10 rst = 0;
    #10 rst = 1;

    // Testcase3
    #10 data_input = 32'hBCDABCDA;
    write_reserve_input = 1;
    write_back_input = 1;
    #10
    assert (data_output == 32'b0 && write_reserve_output == 1)
    else display_error("check not to write data when it is enabled write reservation");

    // Testcase4
    #10 write_reserve_input = 0;
    #10
    assert (data_output == 32'hBCDABCDA && write_reserve_output == 0)
    else display_error("check to write data when it is disabled write reservation");

    $finish;
  end
endmodule
