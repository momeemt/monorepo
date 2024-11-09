`timescale 1ns / 1ps

import instr_type::*;

function automatic void display_error(
    input string testcase_name, input logic [2:0] funct3, input logic [4:0] rd,
    input logic [4:0] rs1, input logic [10:0] ecall_ebreak_sel, input system_kind_t kind);
  $error(
      "[decode::decode_system] %s failed\nfunct3: %b | rd: %b | rs1: %b | ecall_ebreak_sel: %p | kind: %p",
      testcase_name, funct3, rd, rs1, ecall_ebreak_sel, kind);
endfunction

module decode_system_tb;
  logic clk;
  logic rst;
  logic [2:0] funct3;
  logic [4:0] rd;
  logic [4:0] rs1;
  logic [10:0] ecall_ebreak_sel;
  system_kind_t kind;

  decode_system uut (
      .clk(clk),
      .rst(rst),
      .funct3(funct3),
      .rd(rd),
      .rs1(rs1),
      .ecall_ebreak_sel(ecall_ebreak_sel),
      .kind(kind)
  );

  always #5 clk = ~clk;

  initial begin
    clk = 0;
    rst = 0;
    funct3 = 3'b0;
    rd = 5'b0;
    rs1 = 5'b0;
    ecall_ebreak_sel = 11'b0;
    #10 rst = 1;

    // ECALL
    #10 funct3 = 3'b000;
    #10 rd = 5'b00000;
    #10 rs1 = 5'b00000;
    #10 ecall_ebreak_sel = 11'b00000000000;
    #10
    assert (kind == sysk_ecall)
    else display_error("Testcase ECALL failed", funct3, rd, rs1, ecall_ebreak_sel, kind);

    // EBREAK
    #10 funct3 = 3'b000;
    #10 rd = 5'b00000;
    #10 rs1 = 5'b00000;
    #10 ecall_ebreak_sel = 11'b00000000001;
    #10
    assert (kind == sysk_ebreak)
    else display_error("Testcase EBREAK failed", funct3, rd, rs1, ecall_ebreak_sel, kind);

    // Invalid
    #10 funct3 = 3'b000;
    #10 rd = 5'b01010;
    #10 rs1 = 5'b01010;
    #10 ecall_ebreak_sel = 11'b00000000000;
    #10
    assert (kind == sysk_invalid)
    else display_error("Testcase Invalid failed", funct3, rd, rs1, ecall_ebreak_sel, kind);

    // CSRRW
    #10 funct3 = 3'b001;
    #10
    assert (kind == sysk_csrrw)
    else display_error("Testcase CSRRW failed", funct3, rd, rs1, ecall_ebreak_sel, kind);

    // CSRRS
    #10 funct3 = 3'b010;
    #10
    assert (kind == sysk_csrrs)
    else display_error("Testcase CSRRS failed", funct3, rd, rs1, ecall_ebreak_sel, kind);

    // CSRRC
    #10 funct3 = 3'b011;
    #10
    assert (kind == sysk_csrrc)
    else display_error("Testcase CSRRC failed", funct3, rd, rs1, ecall_ebreak_sel, kind);

    // Invalid
    #10 funct3 = 3'b100
    #10
    assert (kind == sysk_invalid)
    else display_error("Testcase Invalid failed", funct3, rd, rs1, ecall_ebreak_sel, kind);

    // CSRRWI
    #10 funct3 = 3'b101;
    #10
    assert (kind == sysk_csrrwi)
    else display_error("Testcase CSRRWI failed", funct3, rd, rs1, ecall_ebreak_sel, kind);

    // CSRRSI
    #10 funct3 = 3'b110;
    #10
    assert (kind == sysk_csrrsi)
    else display_error("Testcase CSRRSI failed", funct3, rd, rs1, ecall_ebreak_sel, kind);

    // CSRRCI
    #10 funct3 = 3'b111;
    #10
    assert (kind == sysk_csrrci)
    else display_error("Testcase CSRRCI failed", funct3, rd, rs1, ecall_ebreak_sel, kind);
  end
endmodule
