`timescale 1ns / 1ps

import opcode_type::*;

function automatic void display_error(input string testcase_name, input logic [6:0] opcode,
                                      input opcode_t opcode_type);
  $error("[decode::opcode] %s failed\nopcode: %b | kind: %p", testcase_name, opcode, opcode_type);
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
    #10
    assert (opcode_type == lui)
    else display_error("Testcase LUI (U-Type) failed", opcode, opcode_type);

    // AUIPC
    #10 opcode = 7'b0010111;
    #10
    assert (opcode_type == auipc)
    else display_error("Testcase AUIPC (U-Type) failed", opcode, opcode_type);

    // JAL
    #10 opcode = 7'b1101111;
    #10
    assert (opcode_type == jal)
    else display_error("Testcase JAL (J-Type) failed", opcode, opcode_type);

    // JALR
    #10 opcode = 7'b1100111;
    #10
    assert (opcode_type == jalr)
    else display_error("Testcase JALR (I-Type) failed", opcode, opcode_type);

    // BEQ, BNE, BLT, BGE, BLTU, BGEU
    #10 opcode = 7'b1100011;
    #10
    assert (opcode_type == branch_type)
    else display_error("Testcase Branch (B-Type) failed", opcode, opcode_type);

    // LD, LH, LW, LBU, LHU
    #10 opcode = 7'b0000011;
    #10
    assert (opcode_type == load_type)
    else display_error("Testcase Load (I-Type) failed", opcode, opcode_type);

    // SB, SH, SW
    #10 opcode = 7'b0100011;
    #10
    assert (opcode_type == store_type)
    else display_error("Testcase Store (S-Type) failed", opcode, opcode_type);

    // ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI
    #10 opcode = 7'b0010011;
    #10
    assert (opcode_type == imm_arith_type)
    else display_error("Testcase Imm Arith (I-Type) failed", opcode, opcode_type);

    // ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND
    #10 opcode = 7'b0110011;
    #10
    assert (opcode_type == reg_arith_type)
    else display_error("Testcase Reg Arith (R-Type) failed", opcode, opcode_type);

    // FENCE, FENCE.I
    #10 opcode = 7'b0001111;
    #10
    assert (opcode_type == fence_type)
    else display_error("Testcase Fence-Type failed", opcode, opcode_type);

    // CSRRW, CSRRS, CSRRC, CSRRWI, CSRRSI, CSRRCI, ECALL, EBREAK, URET, SRET,
    // MRET, WFI, SFENCE.VMA
    #10 opcode = 7'b1110011;
    #10
    assert (opcode_type == system_type)
    else display_error("Testcase System-Type failed", opcode, opcode_type);

    $finish;
  end
endmodule

