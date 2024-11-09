`timescale 1ns / 1ps

import instr_type::*;

function automatic void display_error(input string testcase_name, input logic [2:0] funct3,
                                      input branch_kind_t kind);
  $error("[decode::decode_branch] %s failed\nfunct3: %b | kind: %p", testcase_name, funct3, kind);
endfunction

module decode_branch_tb;
  logic clk;
  logic rst;
  logic [2:0] funct3;
  branch_kind_t kind;

  decode_branch uut (
      .clk(clk),
      .rst(rst),
      .funct3(funct3),
      .kind(kind)
  );

  always #5 clk = ~clk;

  initial begin
    clk = 0;
    rst = 0;
    funct3 = 3'b0;
    #10 rst = 1;

    // BEQ
    #10 funct3 = 3'b000;
    #10
    assert (kind == bk_beq)
    else display_error("Testcase BEQ failed", funct3, kind);

    // BNE
    #10 funct3 = 3'b001;
    #10
    assert (kind == bk_bne)
    else display_error("Testcase BNE failed", funct3, kind);

    // Invalid
    #10 funct3 = 3'b010;
    #10
    assert (kind == bk_invalid)
    else display_error("Testcase Invalid (010) failed", funct3, kind);

    // Invalid
    #10 funct3 = 3'b011;
    #10
    assert (kind == bk_invalid)
    else display_error("Testcase Invalid (011) failed", funct3, kind);

    // BLT
    #10 funct3 = 3'b100;
    #10
    assert (kind == bk_blt)
    else display_error("Testcase BLT failed", funct3, kind);

    // BGE
    #10 funct3 = 3'b101;
    #10
    assert (kind == bk_bge)
    else display_error("Testcase BGE failed", funct3, kind);

    // BLTU
    #10 funct3 = 3'b110;
    #10
    assert (kind == bk_bltu)
    else display_error("Testcase BLTU failed", funct3, kind);

    // BGEU
    #10 funct3 = 3'b111;
    #10
    assert (kind == bk_bgeu)
    else display_error("Testcase BGEU failed", funct3, kind);
  end
endmodule
