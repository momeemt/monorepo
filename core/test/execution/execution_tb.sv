`timescale 1ns / 1ps

import instr_type::*;
import register_file_params::*;

module execution_tb;
  // input
  logic clk;
  logic rst;
  logic valid_input;
  logic stall_input;
  instr_kind_t instr_kind;
  logic [OPERAND_WIDTH-1:0] rs1_data;
  logic [OPERAND_WIDTH-1:0] rs2_data;
  logic [OPERAND_WIDTH-1:0] immediate_data;
  logic [REGISTER_DESCRIPTOR_WIDTH-1:0] rd_addr_input;
  logic [31:0] pc;

  // output
  logic valid_output;
  logic stall_output;
  logic [OPERAND_WIDTH-1:0] result;
  logic [REGISTER_DESCRIPTOR_WIDTH-1:0] rd_addr_output;
  logic write_register;
  logic write_memory;
  logic branch;
  logic [REGISTER_DESCRIPTOR_WIDTH-1:0] branch_dest_address;

  // expect_output
  logic expect_valid_output;
  logic expect_stall_output;
  logic [OPERAND_WIDTH-1:0] expect_result;
  logic expect_write_register;
  logic expect_write_memory;
  logic expect_branch;
  logic [REGISTER_DESCRIPTOR_WIDTH-1:0] expect_branch_dest_address;

  execution uut (
      .clk(clk),
      .rst(rst),
      .valid_input(valid_input),
      .stall_input(stall_input),
      .instr_kind(instr_kind),
      .rs1_data(rs1_data),
      .rs2_data(rs2_data),
      .immediate_data(immediate_data),
      .rd_addr_input(rd_addr_input),
      .pc(pc),
      .valid_output(valid_output),
      .stall_output(stall_output),
      .result(result),
      .rd_addr_output(rd_addr_output),
      .write_register(write_register),
      .write_memory(write_memory),
      .branch(branch),
      .branch_dest_address(branch_dest_address)
  );

  task automatic display_error;
    input string testcase_name;
    int errors = 0;

    $display("\n== TESTCASE: %s ==", testcase_name);
    if (expect_valid_output !== valid_output) begin
      errors++;
      $display("\033[1;31m[ERROR]\033[0m valid_output mismatch! Expected: %b, Got: %b",
               expect_valid_output, valid_output);
    end else begin
      $display("\033[1;32m[OK]\033[0m valid_output: %b", valid_output);
    end

    if (expect_stall_output !== stall_output) begin
      errors++;
      $display("\033[1;31m[ERROR]\033[0m stall_output mismatch! Expected: %b, Got: %b",
               expect_stall_output, stall_output);
    end else begin
      $display("\033[1;32m[OK]\033[0m stall_output: %b", stall_output);
    end

    if (expect_result !== result) begin
      errors++;
      $display("\033[1;31m[ERROR]\033[0m result mismatch! Expected: %h, Got: %h", expect_result,
               result);
    end else begin
      $display("\033[1;32m[OK]\033[0m result: %h", result);
    end

    if (expect_write_register !== write_register) begin
      errors++;
      $display("\033[1;31m[ERROR]\033[0m write_register mismatch! Expected: %b, Got: %b",
               expect_write_register, write_register);
    end else begin
      $display("\033[1;32m[OK]\033[0m write_register: %b", write_register);
    end

    if (expect_write_memory !== write_memory) begin
      errors++;
      $display("\033[1;31m[ERROR]\033[0m write_memory mismatch! Expected: %b, Got: %b",
               expect_write_memory, write_memory);
    end else begin
      $display("\033[1;32m[OK]\033[0m write_memory: %b", write_memory);
    end

    if (expect_branch !== branch) begin
      errors++;
      $display("\033[1;31m[ERROR]\033[0m branch mismatch! Expected: %b, Got: %b", expect_branch,
               branch);
    end else begin
      $display("\033[1;32m[OK]\033[0m branch: %b", branch);
    end

    if (branch) begin
      if (expect_branch_dest_address !== branch_dest_address) begin
        errors++;
        $display("\033[1;31m[ERROR]\033[0m branch_dest_address mismatch! Expected: %h, Got: %h",
                 expect_branch_dest_address, branch_dest_address);
      end else begin
        $display("\033[1;32m[OK]\033[0m branch_dest_address: %h", branch_dest_address);
      end
    end

    if (errors == 0) begin
      $display("\033[1;32m[TESTCASE PASSED]\033[0m %s", testcase_name);
    end else begin
      $error("\033[1;31m[TESTCASE FAILED]\033[0m %s with %d error(s)", testcase_name, errors);
    end
  endtask

  always #5 clk = ~clk;

  initial begin
    clk = 0;
    rst = 0;
    valid_input = 1;
    stall_input = 0;
    instr_kind = Invalid;
    rs1_data = 'b0;
    rs2_data = 'b0;
    immediate_data = 'b0;
    rd_addr_input = 'b0;
    pc = 0;
    #10 rst = 1;

    // LUI
    #10 instr_kind <= LUI;
    immediate_data = 'hDEADBE00;
    rd_addr_input = 5'b01010;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_result = 'hDEADBE00;
    expect_write_register = 1;
    expect_write_memory = 0;
    expect_branch = 0;
    expect_branch_dest_address = 'b0;
    #10
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && result == expect_result
      && write_register == expect_write_register
      && write_memory == expect_write_memory
      && branch == expect_branch
    )
    else display_error("Testcase LUI failed");

    $finish;
  end
endmodule
