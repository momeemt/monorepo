`timescale 1ns / 1ps

import opcode_type::opcode_t;

function automatic void display_error(input string testcase_name, input logic [6:0] opcode,
                                      input opcode_t opcode_type);
  $error(
      "[decode::opcode] %s failed\nopcode: %b | is_lui: %b | is_auipc: %b | is_jal: %b | is_jalr: %b | is_branch_type: %b | is_load_type: %b | is_store_type: %b | is_imm_arith_type: %b | is_reg_arith_type: %b | is_fence_type: %b | is_system_type: %b",
      testcase_name, opcode, opcode_type.is_lui, opcode_type.is_auipc, opcode_type.is_jal,
      opcode_type.is_jalr, opcode_type.is_branch_type, opcode_type.is_load_type,
      opcode_type.is_store_type, opcode_type.is_imm_arith_type, opcode_type.is_reg_arith_type,
      opcode_type.is_fence_type, opcode_type.is_system_type);
endfunction

function automatic void assert_opcode_type(input string testcase_name, input logic [6:0] opcode,
                                           input opcode_t opcode_type,
                                           input logic [10:0] expect_opcode);
  assert (
      opcode_type.is_lui == expect_opcode[0] &&
      opcode_type.is_auipc == expect_opcode[1] &&
      opcode_type.is_jal == expect_opcode[2] &&
      opcode_type.is_jalr == expect_opcode[3] &&
      opcode_type.is_branch_type == expect_opcode[4] &&
      opcode_type.is_load_type == expect_opcode[5] &&
      opcode_type.is_store_type == expect_opcode[6] &&
      opcode_type.is_imm_arith_type == expect_opcode[7] &&
      opcode_type.is_reg_arith_type == expect_opcode[8] &&
      opcode_type.is_fence_type == expect_opcode[9] &&
      opcode_type.is_system_type == expect_opcode[10]
    )
  else display_error(testcase_name, opcode, opcode_type);
endfunction

module opcode_tb;
  logic clk;
  logic rst;
  logic [6:0] opcode;
  opcode_t opcode_type;

  opcode uut (
      .clk(clk),
      .rst(rst),
      .opcode(opcode),
      .opcode_type(opcode_type)
  );

  always #5 clk = ~clk;

  initial begin
    clk = 0;
    rst = 0;
    opcode = 7'b0;
    #10 rst = 1;

    // LUI
    #10 opcode = 7'b0110111;
    #10 assert_opcode_type("Testcase LUI (U-Type) failed", opcode, opcode_type, 11'b00000000001);

    // AUIPC
    #10 opcode = 7'b0010111;
    #10 assert_opcode_type("Testcase AUIPC (U-Type) failed", opcode, opcode_type, 11'b00000000010);

    // JAL
    #10 opcode = 7'b1101111;
    #10 assert_opcode_type("Testcase JAL (J-Type) failed", opcode, opcode_type, 11'b00000000100);

    // JALR
    #10 opcode = 7'b1100111;
    #10 assert_opcode_type("Testcase JALR (I-Type) failed", opcode, opcode_type, 11'b00000001000);

    // BEQ, BNE, BLT, BGE, BLTU, BGEU
    #10 opcode = 7'b1100011;
    #10 assert_opcode_type("Testcase Branch (B-Type) failed", opcode, opcode_type, 11'b00000010000);

    // LD, LH, LW, LBU, LHU
    #10 opcode = 7'b0000011;
    #10 assert_opcode_type("Testcase Load (I-Type) failed", opcode, opcode_type, 11'b00000100000);

    // SB, SH, SW
    #10 opcode = 7'b0100011;
    #10 assert_opcode_type("Testcase Store (S-Type) failed", opcode, opcode_type, 11'b00001000000);

    // ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI
    #10 opcode = 7'b0010011;
    #10
    assert_opcode_type(
        "Testcase Imm Arith (I-Type) failed", opcode, opcode_type, 11'b00010000000);

    // ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND
    #10 opcode = 7'b0110011;
    #10
    assert_opcode_type(
        "Testcase Reg Arith (R-Type) failed", opcode, opcode_type, 11'b00100000000);

    // FENCE, FENCE.I
    #10 opcode = 7'b0001111;
    #10 assert_opcode_type("Testcase Fence-Type failed", opcode, opcode_type, 11'b01000000000);

    // CSRRW, CSRRS, CSRRC, CSRRWI, CSRRSI, CSRRCI, ECALL, EBREAK, URET, SRET,
    // MRET, WFI, SFENCE.VMA
    #10 opcode = 7'b1110011;
    #10 assert_opcode_type("Testcase System-Type failed", opcode, opcode_type, 11'b10000000000);

    $finish;
  end
endmodule

