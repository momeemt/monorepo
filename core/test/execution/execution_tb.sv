`timescale 1ns / 1ps

import instr_type::*;
import register_file_params::*;

module execution_tb;
  // input
  logic clk;
  logic rst;
  logic valid_input;
  logic stall_input;
  instr_kind_t instr_kind_input;
  logic [OPERAND_WIDTH-1:0] rs1_data;
  logic [OPERAND_WIDTH-1:0] rs2_data;
  logic [REGISTER_DESCRIPTOR_WIDTH-1:0] rd_addr_input;
  logic [4:0] shamt;
  logic [3:0] pred;
  logic [3:0] succ;
  logic [10:0] csr;
  logic [4:0] zimm;
  logic [OPERAND_WIDTH-1:0] immediate_data;
  logic [31:0] pc;

  // output
  logic valid_output;
  logic stall_output;
  instr_kind_t instr_kind_output;
  logic [OPERAND_WIDTH-1:0] new_register_value;
  logic [OPERAND_WIDTH-1:0] read_memory_address;
  logic [OPERAND_WIDTH-1:0] write_memory_address;
  logic [OPERAND_WIDTH-1:0] new_memory_value;
  logic [REGISTER_DESCRIPTOR_WIDTH-1:0] rd_addr_output;
  logic write_register;
  logic read_memory;
  logic write_memory;
  logic branch;
  logic [OPERAND_WIDTH-1:0] branch_dest_address;

  // expect_output
  logic expect_valid_output;
  logic expect_stall_output;
  logic [OPERAND_WIDTH-1:0] expect_new_register_value;
  logic [OPERAND_WIDTH-1:0] expect_read_memory_address;
  logic [OPERAND_WIDTH-1:0] expect_write_memory_address;
  logic [OPERAND_WIDTH-1:0] expect_new_memory_value;
  logic expect_write_register;
  logic expect_read_memory;
  logic expect_write_memory;
  logic expect_branch;
  logic [OPERAND_WIDTH-1:0] expect_branch_dest_address;

  execution uut (
      .clk(clk),
      .rst(rst),
      .valid_input(valid_input),
      .stall_input(stall_input),
      .instr_kind_input(instr_kind_input),
      .rs1_data(rs1_data),
      .rs2_data(rs2_data),
      .rd_addr_input(rd_addr_input),
      .shamt(shamt),
      .pred(pred),
      .succ(succ),
      .csr(csr),
      .zimm(zimm),
      .immediate_data(immediate_data),
      .pc(pc),
      .valid_output(valid_output),
      .stall_output(stall_output),
      .instr_kind_output(instr_kind_output),
      .new_register_value(new_register_value),
      .read_memory_address(read_memory_address),
      .write_memory_address(write_memory_address),
      .new_memory_value(new_memory_value),
      .rd_addr_output(rd_addr_output),
      .write_register(write_register),
      .read_memory(read_memory),
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

    if (expect_write_register !== write_register) begin
      errors++;
      $display("\033[1;31m[ERROR]\033[0m write_register mismatch! Expected: %b, Got: %b",
               expect_write_register, write_register);
    end else begin
      $display("\033[1;32m[OK]\033[0m write_register: %b", write_register);
    end

    if (expect_write_register) begin
      if (expect_new_register_value !== new_register_value) begin
        errors++;
        $display("\033[1;31m[ERROR]\033[0m new_register_value mismatch! Expected: %h, Got: %h",
                 expect_new_register_value, new_register_value);
      end else begin
        $display("\033[1;32m[OK]\033[0m new_register_value: %h", new_register_value);
      end
    end

    if (expect_read_memory !== read_memory) begin
      errors++;
      $display("\033[1;31m[ERROR]\033[0m read_memory mismatch! Expected: %b, Got: %b",
               expect_read_memory, read_memory);
    end else begin
      $display("\033[1;32m[OK]\033[0m read_memory: %b", read_memory);
    end

    if (expect_read_memory) begin
      if (expect_read_memory_address !== read_memory_address) begin
        errors++;
        $display("\033[1;31m[ERROR]\033[0m read_emmory_address mismatch! Expected: %h, Got: %h",
                 expect_read_memory_address, read_memory_address);
      end else begin
        $display("\033[1;32m[OK]\033[0m read_memory_address: %h", read_memory_address);
      end
    end

    if (expect_write_memory !== write_memory) begin
      errors++;
      $display("\033[1;31m[ERROR]\033[0m write_memory mismatch! Expected: %b, Got: %b",
               expect_write_memory, write_memory);
    end else begin
      $display("\033[1;32m[OK]\033[0m write_memory: %b", write_memory);
    end

    if (expect_write_memory) begin
      if (expect_write_memory_address !== write_memory_address) begin
        errors++;
        $display("\033[1;31m[ERROR]\033[0m write_memory_address mismatch! Expected: %h, Got: %h",
                 expect_write_memory_address, write_memory_address);
      end else begin
        $display("\033[1;32m[OK]\033[0m write_memory_address: %h", write_memory_address);
      end

      if (expect_new_memory_value !== new_memory_value) begin
        errors++;
        $display("\033[1;31m[ERROR]\033[0m new_memory_value mismatch! Expected: %h, Got: %h",
                 expect_new_memory_value, new_memory_value);
      end else begin
        $display("\033[1;32m[OK]\033[0m new_memory_value: %h", new_memory_value);
      end
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
    instr_kind_input = Invalid;
    rs1_data = 'b0;
    rs2_data = 'b0;
    immediate_data = 'b0;
    rd_addr_input = 'b0;
    pc = 0;
    #10 rst = 1;

    // LUI
    #5 instr_kind_input = LUI;
    immediate_data = 'hDEADBE00;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_new_register_value = 'hDEADBE00;
    expect_write_register = 1;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 0;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && new_register_value == expect_new_register_value
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
    )
    else display_error("Testcase LUI failed");

    // AUIPC
    #5 instr_kind_input = AUIPC;
    immediate_data = 'hDEADBE00;
    pc = 'h000000EF;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_new_register_value = 'hDEADBEEF;
    expect_write_register = 1;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 0;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && new_register_value == expect_new_register_value
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
    )
    else display_error("Testcase AUIPC failed");

    // JAL
    #5 instr_kind_input = JAL;
    immediate_data = 'h00000008;
    pc = 'h00000000;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_new_register_value = 'h00000004;
    expect_write_register = 1;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 1;
    expect_branch_dest_address = 'h00000008;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && new_register_value == expect_new_register_value
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && branch_dest_address == expect_branch_dest_address
    )
    else display_error("Testcase JAL failed");

    // JALR
    #5 instr_kind_input = JALR;
    immediate_data = 'h8;
    rs1_data = 'hC8;
    pc = 'h0;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_new_register_value = 'h4;
    expect_write_register = 1;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 1;
    expect_branch_dest_address = 'hD0;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && new_register_value == expect_new_register_value
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && branch_dest_address == expect_branch_dest_address
    )
    else display_error("Testcase JALR failed");

    // BEQ (rs1_data == rs2_data)
    #5 instr_kind_input = BEQ;
    rs1_data = 'h12345678;
    rs2_data = 'h12345678;
    immediate_data = 'h8;
    pc = 'hABCD1230;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 0;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 1;
    expect_branch_dest_address = 'hABCD1238;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && branch_dest_address == expect_branch_dest_address
    )
    else display_error("Testcase BEQ (rs1_data == rs2_data) failed");

    // BEQ (rs1_data != rs2_data)
    #5 instr_kind_input = BEQ;
    rs1_data = 'h12345678;
    rs2_data = 'h567890AB;
    immediate_data = 'h8;
    pc = 'hABCD1230;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 0;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 1;
    expect_branch_dest_address = 'hABCD1234;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && branch_dest_address == expect_branch_dest_address
    )
    else display_error("Testcase BEQ (rs1_data != rs2_data) failed");

    // BNE (rs1_data != rs2_data)
    #5 instr_kind_input = BNE;
    rs1_data = 'h12345678;
    rs2_data = 'h567890AB;
    immediate_data = 'h8;
    pc = 'hABCD1230;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 0;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 1;
    expect_branch_dest_address = 'hABCD1238;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && branch_dest_address == expect_branch_dest_address
    )
    else display_error("Testcase BNE (rs1_data != rs2_data) failed");

    // BNE (rs1_data == rs2_data)
    #5 instr_kind_input = BNE;
    rs1_data = 'h12345678;
    rs2_data = 'h12345678;
    immediate_data = 'h8;
    pc = 'hABCD1230;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 0;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 1;
    expect_branch_dest_address = 'hABCD1234;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && branch_dest_address == expect_branch_dest_address
    )
    else display_error("Testcase BNE (rs1_data == rs2_data) failed");

    // BLT (rs1_data < rs2_data)
    #5 instr_kind_input = BLT;
    rs1_data = 'h12345678;
    rs2_data = 'h12345679;
    immediate_data = 'h8;
    pc = 'hABCD1230;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 0;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 1;
    expect_branch_dest_address = 'hABCD1238;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && branch_dest_address == expect_branch_dest_address
    )
    else display_error("Testcase BLT (rs1_data < rs2_data) failed");

    // BLT (rs1_data == rs2_data)
    #5 instr_kind_input = BLT;
    rs1_data = 'h12345678;
    rs2_data = 'h12345678;
    immediate_data = 'h8;
    pc = 'hABCD1230;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 0;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 1;
    expect_branch_dest_address = 'hABCD1234;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && branch_dest_address == expect_branch_dest_address
    )
    else display_error("Testcase BLT (rs1_data == rs2_data) failed");

    // BLT (rs1_data > rs2_data)
    #5 instr_kind_input = BLT;
    rs1_data = 'h12345678;
    rs2_data = 'hF2345678;
    immediate_data = 'h8;
    pc = 'hABCD1230;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 0;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 1;
    expect_branch_dest_address = 'hABCD1234;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && branch_dest_address == expect_branch_dest_address
    )
    else display_error("Testcase BLT (rs1_data > rs2_data) failed");

    // BGE (rs1_data > rs2_data)
    #5 instr_kind_input = BGE;
    rs1_data = 'h12345679;
    rs2_data = 'h12345678;
    immediate_data = 'h8;
    pc = 'hABCD1230;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 0;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 1;
    expect_branch_dest_address = 'hABCD1238;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && branch_dest_address == expect_branch_dest_address
    )
    else display_error("Testcase BGE (rs1_data > rs2_data) failed");

    // BGE (rs1_data == rs2_data)
    #5 instr_kind_input = BGE;
    rs1_data = 'h12345678;
    rs2_data = 'h12345678;
    immediate_data = 'h8;
    pc = 'hABCD1230;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 0;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 1;
    expect_branch_dest_address = 'hABCD1238;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && branch_dest_address == expect_branch_dest_address
    )
    else display_error("Testcase BGE (rs1_data == rs2_data) failed");

    // BGE (rs1_data < rs2_data)
    #5 instr_kind_input = BGE;
    rs1_data = 'hF2345678;
    rs2_data = 'h12345678;
    immediate_data = 'h8;
    pc = 'hABCD1230;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 0;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 1;
    expect_branch_dest_address = 'hABCD1234;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && branch_dest_address == expect_branch_dest_address
    )
    else display_error("Testcase BGE (rs1_data < rs2_data) failed");

    // BLTU (rs1_data < rs2_data)
    #5 instr_kind_input = BLTU;
    rs1_data = 'h12345678;
    rs2_data = 'h12345679;
    immediate_data = 'h8;
    pc = 'hABCD1230;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 0;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 1;
    expect_branch_dest_address = 'hABCD1238;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && branch_dest_address == expect_branch_dest_address
    )
    else display_error("Testcase BLTU (rs1_data < rs2_data) failed");

    // BLTU (rs1_data == rs2_data)
    #5 instr_kind_input = BLTU;
    rs1_data = 'h12345678;
    rs2_data = 'h12345678;
    immediate_data = 'h8;
    pc = 'hABCD1230;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 0;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 1;
    expect_branch_dest_address = 'hABCD1234;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && branch_dest_address == expect_branch_dest_address
    )
    else display_error("Testcase BLTU (rs1_data == rs2_data) failed");

    // BLTU (rs1_data > rs2_data)
    #5 instr_kind_input = BLTU;
    rs1_data = 'hF2345678;
    rs2_data = 'h12345678;
    immediate_data = 'h8;
    pc = 'hABCD1230;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 0;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 1;
    expect_branch_dest_address = 'hABCD1234;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && branch_dest_address == expect_branch_dest_address
    )
    else display_error("Testcase BLTU (rs1_data > rs2_data) failed");

    // BGEU (rs1_data > rs2_data)
    #5 instr_kind_input = BGEU;
    rs1_data = 'h12345679;
    rs2_data = 'h12345678;
    immediate_data = 'h8;
    pc = 'hABCD1230;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 0;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 1;
    expect_branch_dest_address = 'hABCD1238;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && branch_dest_address == expect_branch_dest_address
    )
    else display_error("Testcase BGEU (rs1_data > rs2_data) failed");

    // BGEU (rs1_data == rs2_data)
    #5 instr_kind_input = BGEU;
    rs1_data = 'h12345678;
    rs2_data = 'h12345678;
    immediate_data = 'h8;
    pc = 'hABCD1230;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 0;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 1;
    expect_branch_dest_address = 'hABCD1238;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && branch_dest_address == expect_branch_dest_address
    )
    else display_error("Testcase BGEU (rs1_data == rs2_data) failed");

    // BGEU (rs1_data < rs2_data)
    #5 instr_kind_input = BGEU;
    rs1_data = 'h12345678;
    rs2_data = 'hF2345678;
    immediate_data = 'h8;
    pc = 'hABCD1230;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 0;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 1;
    expect_branch_dest_address = 'hABCD1234;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && branch_dest_address == expect_branch_dest_address
    )
    else display_error("Testcase BGEU (rs1_data < rs2_data) failed");

    // LB
    #5 instr_kind_input = LB;
    rs1_data = 'h11111111;
    immediate_data = 'h22222222;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 1;
    expect_new_register_value = 'b0;
    expect_read_memory = 1;
    expect_write_memory = 0;
    expect_branch = 0;
    expect_read_memory_address = 'h33333333;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && read_memory_address == expect_read_memory_address
    )
    else display_error("Testcase LB failed");

    // LH
    #5 instr_kind_input = LH;
    rs1_data = 'h11112222;
    immediate_data = 'h33334444;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 1;
    expect_new_register_value = 'b0;
    expect_read_memory = 1;
    expect_write_memory = 0;
    expect_branch = 0;
    expect_read_memory_address = 'h44446666;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && read_memory_address == expect_read_memory_address
    )
    else display_error("Testcase LH failed");

    // LW
    #5 instr_kind_input = LW;
    rs1_data = 'hAAAAAAAA;
    immediate_data = 'h11111111;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 1;
    expect_new_register_value = 'b0;
    expect_read_memory = 1;
    expect_write_memory = 0;
    expect_branch = 0;
    expect_read_memory_address = 'hBBBBBBBB;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && read_memory_address == expect_read_memory_address
    )
    else display_error("Testcase LW failed");

    // LBU
    #5 instr_kind_input = LBU;
    rs1_data = 'h55555555;
    immediate_data = 'h66666666;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 1;
    expect_new_register_value = 'b0;
    expect_read_memory = 1;
    expect_write_memory = 0;
    expect_branch = 0;
    expect_read_memory_address = 'hBBBBBBBB;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && read_memory_address == expect_read_memory_address
    )
    else display_error("Testcase LBU failed");

    // LHU
    #5 instr_kind_input = LHU;
    rs1_data = 'h99999999;
    immediate_data = 'h33333333;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 1;
    expect_new_register_value = 'b0;
    expect_read_memory = 1;
    expect_write_memory = 0;
    expect_branch = 0;
    expect_read_memory_address = 'hCCCCCCCC;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && read_memory_address == expect_read_memory_address
    )
    else display_error("Testcase LHU failed");

    // SB
    #5 instr_kind_input = SB;
    rs1_data = 'h11111111;
    rs2_data = 'h22222222;
    immediate_data = 'h33333333;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 0;
    expect_read_memory = 0;
    expect_write_memory = 1;
    expect_branch = 0;
    expect_write_memory_address = 'h44444444;
    expect_new_memory_value = 'h22222222;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && write_memory_address == expect_write_memory_address
      && new_memory_value == expect_new_memory_value
    )
    else display_error("Testcase SB failed");

    // SH
    #5 instr_kind_input = SH;
    rs1_data = 'h44444444;
    rs2_data = 'h55555555;
    immediate_data = 'h66666666;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 0;
    expect_read_memory = 0;
    expect_write_memory = 1;
    expect_branch = 0;
    expect_write_memory_address = 'hAAAAAAAA;
    expect_new_memory_value = 'h55555555;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && write_memory_address == expect_write_memory_address
      && new_memory_value == expect_new_memory_value
    )
    else display_error("Testcase SH failed");

    // SW
    #5 instr_kind_input = SW;
    rs1_data = 'h77777777;
    rs2_data = 'h99999999;
    immediate_data = 'h88888888;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 0;
    expect_read_memory = 0;
    expect_write_memory = 1;
    expect_branch = 0;
    expect_write_memory_address = 'hFFFFFFFF;
    expect_new_memory_value = 'h99999999;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && write_memory_address == expect_write_memory_address
      && new_memory_value == expect_new_memory_value
    )
    else display_error("Testcase SW failed");

    // ADDI
    #5 instr_kind_input = ADDI;
    rs1_data = 'h12345678;
    immediate_data = 'h87654321;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 1;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 0;
    expect_new_register_value = 'h99999999;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && new_register_value == expect_new_register_value
    )
    else display_error("Testcase ADDI failed");

    // SLTI (rs1_data < immediate_data)
    #5 instr_kind_input = SLTI;
    rs1_data = 'h12345678;
    immediate_data = 'h23456789;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 1;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 0;
    expect_new_register_value = 'b1;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && new_register_value == expect_new_register_value
    )
    else display_error("Testcase SLTI (rs1_data < immediate_data) failed");

    // SLTI (rs1_data == immediate_data)
    #5 instr_kind_input = SLTI;
    rs1_data = 'h12345678;
    immediate_data = 'h12345678;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 1;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 0;
    expect_new_register_value = 'b0;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && new_register_value == expect_new_register_value
    )
    else display_error("Testcase SLTI (rs1_data == immediate_data) failed");

    // SLTI (rs1_data > immediate_data)
    #5 instr_kind_input = SLTI;
    rs1_data = 'h12345678;
    immediate_data = 'h87654321;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 1;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 0;
    expect_new_register_value = 'b0;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && new_register_value == expect_new_register_value
    )
    else display_error("Testcase SLTI (rs1_data > immediate_data) failed");

    // SLTIU (rs1_data < immediate_data)
    #5 instr_kind_input = SLTIU;
    rs1_data = 'h12345678;
    immediate_data = 'h87654321;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 1;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 0;
    expect_new_register_value = 'b1;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && new_register_value == expect_new_register_value
    )
    else display_error("Testcase SLTIU (rs1_data < immediate_data) failed");

    // SLTIU (rs1_data == immediate_data)
    #5 instr_kind_input = SLTIU;
    rs1_data = 'h12345678;
    immediate_data = 'h12345678;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 1;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 0;
    expect_new_register_value = 'b0;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && new_register_value == expect_new_register_value
    )
    else display_error("Testcase SLTIU (rs1_data == immediate_data) failed");

    // SLTIU (rs1_data > immediate_data)
    #5 instr_kind_input = SLTIU;
    rs1_data = 'h87654321;
    immediate_data = 'h12345678;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 1;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 0;
    expect_new_register_value = 'b0;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && new_register_value == expect_new_register_value
    )
    else display_error("Testcase SLTIU (rs1_data > immediate_data) failed");

    // XORI
    #5 instr_kind_input = XORI;
    rs1_data = 'h12345678;
    immediate_data = 'h87654321;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 1;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 0;
    expect_new_register_value = 'h95511559;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && new_register_value == expect_new_register_value
    )
    else display_error("Testcase XORI failed");

    // ORI
    #5 instr_kind_input = ORI;
    rs1_data = 'h12345678;
    immediate_data = 'h87654321;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 1;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 0;
    expect_new_register_value = 'h97755779;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && new_register_value == expect_new_register_value
    )
    else display_error("Testcase ORI failed");

    // ANDI
    #5 instr_kind_input = ANDI;
    rs1_data = 'h12345678;
    immediate_data = 'h87654321;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 1;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 0;
    expect_new_register_value = 'h02244220;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && new_register_value == expect_new_register_value
    )
    else display_error("Testcase ANDI failed");

    // SLLI
    #5 instr_kind_input = SLLI;
    rs1_data = 'h00000002;
    shamt = 'h00000003;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 1;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 0;
    expect_new_register_value = 'h00000010;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && new_register_value == expect_new_register_value
    )
    else display_error("Testcase SLLI failed");

    // SRLI
    #5 instr_kind_input = SRLI;
    rs1_data = 'h00000100;
    shamt = 'h00000005;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 1;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 0;
    expect_new_register_value = 'h00000008;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && new_register_value == expect_new_register_value
    )
    else display_error("Testcase SRLI failed");

    // SRAI
    #5 instr_kind_input = SRAI;
    rs1_data = 'h80000100;
    shamt = 'h00000005;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 1;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 0;
    expect_new_register_value = 'hFC000008;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && new_register_value == expect_new_register_value
    )
    else display_error("Testcase SRAI failed");

    // ADD
    #5 instr_kind_input = ADD;
    rs1_data = 'h11111111;
    rs2_data = 'h22222222;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 1;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 0;
    expect_new_register_value = 'h33333333;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && new_register_value == expect_new_register_value
    )
    else display_error("Testcase ADD failed");

    // SUB
    #5 instr_kind_input = SUB;
    rs1_data = 'hAAAAAAAA;
    rs2_data = 'h66666666;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 1;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 0;
    expect_new_register_value = 'h44444444;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && new_register_value == expect_new_register_value
    )
    else display_error("Testcase SUB failed");

    // SLL
    #5 instr_kind_input = SLL;
    rs1_data = 'h00001111;
    rs2_data = 'h00000010;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 1;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 0;
    expect_new_register_value = 'h11110000;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && new_register_value == expect_new_register_value
    )
    else display_error("Testcase SLL failed");

    // SLL
    #5 instr_kind_input = SLL;
    rs1_data = 'h00001111;
    rs2_data = 'hFFFFFF10;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 1;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 0;
    expect_new_register_value = 'h11110000;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && new_register_value == expect_new_register_value
    )
    else display_error("Testcase SLL failed");

    // SLT (rs1_data < rs2_data)
    #5 instr_kind_input = SLT;
    rs1_data = 'h00000001;
    rs2_data = 'h0FFFFFFF;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 1;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 0;
    expect_new_register_value = 'h00000001;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && new_register_value == expect_new_register_value
    )
    else display_error("Testcase SLT (rs1_data < rs2_data) failed");

    // SLT (rs1_data == rs2_data)
    #5 instr_kind_input = SLT;
    rs1_data = 'h55555555;
    rs2_data = 'h55555555;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 1;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 0;
    expect_new_register_value = 'h00000000;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && new_register_value == expect_new_register_value
    )
    else display_error("Testcase SLT (rs1_data == rs2_data) failed");

    // SLT (rs1_data > rs2_data)
    #5 instr_kind_input = SLT;
    rs1_data = 'h05555555;
    rs2_data = 'hF5555555;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 1;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 0;
    expect_new_register_value = 'h00000000;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && new_register_value == expect_new_register_value
    )
    else display_error("Testcase SLT (rs1_data > rs2_data) failed");

    // SLTU (rs1_data < rs2_data)
    #5 instr_kind_input = SLTU;
    rs1_data = 'h00000001;
    rs2_data = 'hFFFFFFFF;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 1;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 0;
    expect_new_register_value = 'h00000001;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && new_register_value == expect_new_register_value
    )
    else display_error("Testcase SLTU (rs1_data < rs2_data) failed");

    // SLTU (rs1_data == rs2_data)
    #5 instr_kind_input = SLTU;
    rs1_data = 'h55555555;
    rs2_data = 'h55555555;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 1;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 0;
    expect_new_register_value = 'h00000000;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && new_register_value == expect_new_register_value
    )
    else display_error("Testcase SLTU (rs1_data == rs2_data) failed");

    // SLTU (rs1_data > rs2_data)
    #5 instr_kind_input = SLTU;
    rs1_data = 'hFFFFFFFF;
    rs2_data = 'h11111111;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 1;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 0;
    expect_new_register_value = 'h00000000;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && new_register_value == expect_new_register_value
    )
    else display_error("Testcase SLTU (rs1_data > rs2_data) failed");

    // XOR
    #5 instr_kind_input = XOR;
    rs1_data = 'hF0F0F0F0;
    rs2_data = 'h0F0F0F0F;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 1;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 0;
    expect_new_register_value = 'hFFFFFFFF;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && new_register_value == expect_new_register_value
    )
    else display_error("Testcase XOR failed");

    // SRL
    #5 instr_kind_input = SRL;
    rs1_data = 'h00010000;
    rs2_data = 'h00000010;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 1;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 0;
    expect_new_register_value = 'h00000001;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && new_register_value == expect_new_register_value
    )
    else display_error("Testcase SRL failed");

    // SRL
    #5 instr_kind_input = SRL;
    rs1_data = 'h00010000;
    rs2_data = 'hFFFFFF10;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 1;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 0;
    expect_new_register_value = 'h00000001;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && new_register_value == expect_new_register_value
    )
    else display_error("Testcase SRL failed");

    // SRA
    #5 instr_kind_input = SRA;
    rs1_data = 'hF0010000;
    rs2_data = 'h00000010;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 1;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 0;
    expect_new_register_value = 'hFFFF8001;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && new_register_value == expect_new_register_value
    )
    else display_error("Testcase SRA failed");

    // SRL
    #5 instr_kind_input = SRA;
    rs1_data = 'hF0010000;
    rs2_data = 'hFFFFFF10;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 1;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 0;
    expect_new_register_value = 'hFFFF8001;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && new_register_value == expect_new_register_value
    )
    else display_error("Testcase SRA failed");

    // OR
    #5 instr_kind_input = OR;
    rs1_data = 'hF0F0F0F0;
    rs2_data = 'h8F8F8F8F;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 1;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 0;
    expect_new_register_value = 'hFFFFFFFF;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && new_register_value == expect_new_register_value
    )
    else display_error("Testcase 0R failed");

    // AND
    #5 instr_kind_input = AND;
    rs1_data = 'hA5A5A5A5;
    rs2_data = 'h5A5A5A5A;
    expect_valid_output = 1;
    expect_stall_output = 0;
    expect_write_register = 1;
    expect_read_memory = 0;
    expect_write_memory = 0;
    expect_branch = 0;
    expect_new_register_value = 'h00000000;
    #5
    assert (
      valid_output == expect_valid_output
      && stall_output == expect_stall_output
      && write_register == expect_write_register
      && read_memory == expect_read_memory
      && write_memory == expect_write_memory
      && branch == expect_branch
      && new_register_value == expect_new_register_value
    )
    else display_error("Testcase AND failed");

    $finish;
  end
endmodule
