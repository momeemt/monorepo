`timescale 1ns / 1ps

import opcode_type::*;

function automatic void display_error(input string testcase_name, input logic [2:0] funct3,
                                      input logic [6:0] funct7, input reg_arith_kind_t kind);
  $error("decode::r_type - %s failed\nfunct3: %b | funct7: %b\nkind: %p", testcase_name, funct3,
         funct7, kind);
endfunction

module r_type_tb;
  logic clk;
  logic rst;
  logic [2:0] funct3;
  logic [6:0] funct7;
  reg_arith_kind_t kind;

  r_type uut (
      .clk(clk),
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

    // ADD
    #10 funct3 = 3'b0;
    #10 funct7 = 7'b0;
    #10
    assert (kind == rak_add)
    else display_error("Testcase ADD failed", funct3, funct7, kind);

    // SUB
    #10 funct3 = 3'b0;
    #10 funct7 = 7'b0100000;
    #10
    assert (kind == rak_sub)
    else display_error("Testcase SUB failed", funct3, funct7, kind);

    // SLL
    #10 funct3 = 3'b001;
    #10 funct7 = 7'b0;
    #10
    assert (kind == rak_sll)
    else display_error("Testcase SLL failed", funct3, funct7, kind);

    // SLT
    #10 funct3 = 3'b010;
    #10 funct7 = 7'b0;
    #10
    assert (kind == rak_slt)
    else display_error("Testcase SLT failed", funct3, funct7, kind);

    // SLTU
    #10 funct3 = 3'b011;
    #10 funct7 = 7'b0;
    #10
    assert (kind == rak_sltu)
    else display_error("Testcase SLTU failed", funct3, funct7, kind);

    // XOR
    #10 funct3 = 3'b100;
    #10 funct7 = 7'b0;
    #10
    assert (kind == rak_xor)
    else display_error("Testcase XOR failed", funct3, funct7, kind);

    // SRL
    #10 funct3 = 3'b101;
    #10 funct7 = 7'b0;
    #10
    assert (kind == rak_srl)
    else display_error("Testcase SRL failed", funct3, funct7, kind);

    // SRA
    #10 funct3 = 3'b101;
    #10 funct7 = 7'b0100000;
    #10
    assert (kind == rak_sra)
    else display_error("Testcase SRA failed", funct3, funct7, kind);

    // OR
    #10 funct3 = 3'b110;
    #10 funct7 = 7'b0;
    #10
    assert (kind == rak_or)
    else display_error("Testcase OR failed", funct3, funct7, kind);

    // AND
    #10 funct3 = 3'b111;
    #10 funct7 = 7'b0;
    #10
    assert (kind == rak_and)
    else display_error("Testcase AND failed", funct3, funct7, kind);

    $finish;
  end
endmodule

