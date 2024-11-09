`timescale 1ns / 1ps

import instr_type::*;

function automatic void display_error(input string testcase_name, input logic [2:0] funct3, input load_kind_t kind);
  $error("[decode::decode_load] %s failed\nfunct3: %b | kind: %p"m testcase_name, funct3, kind);
endfunction

module decode_load_tb;
logic clk;
logic rst;
logic [2:0] funct3;
load_kind_t kind;

decode_load uut (
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

    // LB
    #10 funct3 = 3'b000;
    #10
    assert (kind == lk_lb)
    else display_error("Testcase LB failed", funct3, kind);

    // LH
    #10 funct3 = 3'b001;
    #10
    assert (kind == lk_lh)
    else display_error("Testcase LH failed", funct3, kind);

    // LW
    #10 funct3 = 3'b010;
    #10
    assert (kind == lk_lw)
    else display_error("Testcase LW failed", funct3, kind);

    // Invalid
    #10 funct3 = 3'b011;
    #10
    assert (kind == lk_invalid)
    else display_error("Testcase Invalid failed", funct3, kind);

    // LBU
    #10 funct3 = 3'b100;
    #10
    assert (kind == lk_lbu)
    else display_error("Testcase LBU failed", funct3, kind);

    // LHU
    #10 funct3 = 3'b101;
    #10
    assert (kind == lk_lhu)
    else display_error("Testcase LHU failed", funct3, kind);

    // Invalid
    #10 funct3 = 3'110;
    #10
    assert (kind == lk_invalid)
    else display_error("Testcase Invalid failed", funct3, kind);

    // Invalid
    #10 funct3 = 3'b111;
    #10
    assert (kind == lk_invalid)
    else display_error("Testcase Invalid failed", funct3, kind);
  end
endmodule
