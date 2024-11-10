`timescale 1ns / 1ps

import instr_type::*;

function automatic void display_error(input string testcase_name, input logic [2:0] funct3,
                                      input logic [6:0] funct7, input imm_arith_kind_t kind);
  $error("[decode::decode_imm_arith] %s failed\nfunct3: %b | funct7: %b | kind: %p", testcase_name,
         funct3, funct7, kind);
endfunction

module decode_imm_arith_tb;
  logic clk;
  logic rst;
  logic [2:0] funct3;
  logic [6:0] funct7;
  imm_arith_kind_t kind;

  decode_imm_arith uut (
      .rst(rst),
      .funct3(funct3),
      .funct7(funct7),
      .kind(kind)
  );

  always #5 clk = ~clk;

  initial begin
    clk = 0;
    rst = 0;
    funct3 = 3'b0;
    funct7 = 7'b0;
    #10 rst = 1;

    // ADDI
    #10 funct3 = 3'b000;
    #10 funct7 = 7'b0000000;
    #10
    assert (kind == iak_addi)
    else display_error("Testcase ADDI failed", funct3, funct7, kind);

    // SLLI
    #10 funct3 = 3'b001;
    #10 funct7 = 7'b0000000;
    #10
    assert (kind == iak_slli)
    else display_error("Testcase SLLI failed", funct3, funct7, kind);

    // Invalid
    #10 funct3 = 3'b001;
    #10 funct7 = 7'b0101010;
    #10
    assert (kind == iak_invalid)
    else display_error("Testcase Invalid failed", funct3, funct7, kind);

    // SLTI
    #10 funct3 = 3'b010;
    #10 funct7 = 7'b0000000;
    #10
    assert (kind == iak_slti)
    else display_error("Testcase SLTI failed", funct3, funct7, kind);

    // SLTIU
    #10 funct3 = 3'b011;
    #10 funct7 = 7'b0000000;
    #10
    assert (kind == iak_sltiu)
    else display_error("Testcase SLTIU failed", funct3, funct7, kind);

    // XORI
    #10 funct3 = 3'b100;
    #10 funct7 = 7'b0000000;
    #10
    assert (kind == iak_xori)
    else display_error("Testcase XORI failed", funct3, funct7, kind);

    // SRLI
    #10 funct3 = 3'b101;
    #10 funct7 = 7'b0000000;
    #10
    assert (kind == iak_srli)
    else display_error("Testcase SRLI failed", funct3, funct7, kind);

    // SRAI
    #10 funct3 = 3'b101;
    #10 funct7 = 7'b0100000;
    #10
    assert (kind == iak_srai)
    else display_error("Testcase SRAI failed", funct3, funct7, kind);

    // Invalid
    #10 funct3 = 3'b101;
    #10 funct7 = 7'b0101010;
    #10
    assert (kind == iak_invalid)
    else display_error("Testcase Invalid failed", funct3, funct7, kind);

    // ORI
    #10 funct3 = 3'b110;
    #10 funct7 = 7'b0000000;
    #10
    assert (kind == iak_ori)
    else display_error("Testcase ORI failed", funct3, funct7, kind);

    // ANDI
    #10 funct3 = 3'b111;
    #10 funct7 = 7'b0000000;
    #10
    assert (kind == iak_andi)
    else display_error("Testcase ANDI failed", funct3, funct7, kind);

    $finish;
  end
endmodule

