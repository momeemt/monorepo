`timescale 1ns / 1ps

function automatic void display_error(input string testcase_name, input logic [2:0] funct3,
                                      input logic [6:0] funct7, input logic is_add,
                                      input logic is_sub, input logic is_sll, input logic is_slt,
                                      input logic is_sltu, input logic is_xor, input logic is_srl,
                                      input logic is_sra, input logic is_or, input logic is_and);
  $error(
      "decode::r_type - %s failed\nfunct3: %b | funct7: %b\nis_add: %b | is_sub: %b | is_sll: %b | is_slt: %b | is_sltu: %b | is_xor: %b | is_srl: %b | is_sra: %b | is_or: %b | is_and: %b",
      testcase_name, funct3, funct7, is_add, is_sub, is_sll, is_slt, is_sltu, is_xor, is_srl,
      is_sra, is_or, is_and);
endfunction

module r_type_tb;
  logic clk;
  logic rst;
  logic [2:0] funct3;
  logic [6:0] funct7;
  logic is_add;
  logic is_sub;
  logic is_sll;
  logic is_slt;
  logic is_sltu;
  logic is_xor;
  logic is_srl;
  logic is_sra;
  logic is_or;
  logic is_and;

  r_type uut (
      .clk(clk),
      .rst(rst),
      .funct3(funct3),
      .funct7(funct7),
      .is_add(is_add),
      .is_sub(is_sub),
      .is_sll(is_sll),
      .is_slt(is_slt),
      .is_sltu(is_sltu),
      .is_xor(is_xor),
      .is_srl(is_srl),
      .is_sra(is_sra),
      .is_or(is_or),
      .is_and(is_and)
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
    assert(
      is_add == 1 &&
      is_sub == 0 &&
      is_sll == 0 &&
      is_slt == 0 &&
      is_sltu == 0 &&
      is_xor == 0 &&
      is_srl == 0 &&
      is_sra == 0 &&
      is_or == 0 &&
      is_and == 0
      )
    else
      display_error("Testcase ADD failed", funct3, funct7, is_add, is_sub, is_sll, is_slt, is_sltu,
                    is_xor, is_srl, is_sra, is_or, is_and);

    // SUB
    #10 funct3 = 3'b0;
    #10 funct7 = 7'b0100000;
    #10
    assert (
      is_add == 0 &&
      is_sub == 1 &&
      is_sll == 0 &&
      is_slt == 0 &&
      is_sltu == 0 &&
      is_xor == 0 &&
      is_srl == 0 &&
      is_sra == 0 &&
      is_or == 0 &&
      is_and == 0
    )
    else
      display_error("Testcase SUB failed", funct3, funct7, is_add, is_sub, is_sll, is_slt, is_sltu,
                    is_xor, is_srl, is_sra, is_or, is_and);

    // SLL
    #10 funct3 = 3'b001;
    #10 funct7 = 7'b0;
    #10
    assert (
      is_add == 0 &&
      is_sub == 0 &&
      is_sll == 1 &&
      is_slt == 0 &&
      is_sltu == 0 &&
      is_xor == 0 &&
      is_srl == 0 &&
      is_sra == 0 &&
      is_or == 0 &&
      is_and == 0
      )
    else
      display_error("Testcase SLL failed", funct3, funct7, is_add, is_sub, is_sll, is_slt, is_sltu,
                    is_xor, is_srl, is_sra, is_or, is_and);

    // SLT
    #10 funct3 = 3'b010;
    #10 funct7 = 7'b0;
    #10
    assert (
      is_add == 0 &&
      is_sub == 0 &&
      is_sll == 0 &&
      is_slt == 1 &&
      is_sltu == 0 &&
      is_xor == 0 &&
      is_srl == 0 &&
      is_sra == 0 &&
      is_or == 0 &&
      is_and == 0
      )
    else
      display_error("Testcase SLT failed", funct3, funct7, is_add, is_sub, is_sll, is_slt, is_sltu,
                    is_xor, is_srl, is_sra, is_or, is_and);

    // SLTU
    #10 funct3 = 3'b011;
    #10 funct7 = 7'b0;
    #10
    assert (
      is_add == 0 &&
      is_sub == 0 &&
      is_sll == 0 &&
      is_slt == 0 &&
      is_sltu == 1 &&
      is_xor == 0 &&
      is_srl == 0 &&
      is_sra == 0 &&
      is_or == 0 &&
      is_and == 0
      )
    else
      display_error("Testcase SLTU failed", funct3, funct7, is_add, is_sub, is_sll, is_slt, is_sltu,
                    is_xor, is_srl, is_sra, is_or, is_and);

    // XOR
    #10 funct3 = 3'b100;
    #10 funct7 = 7'b0;
    #10
    assert (
      is_add == 0 &&
      is_sub == 0 &&
      is_sll == 0 &&
      is_slt == 0 &&
      is_sltu == 0 &&
      is_xor == 1 &&
      is_srl == 0 &&
      is_sra == 0 &&
      is_or == 0 &&
      is_and == 0
      )
    else
      display_error("Testcase XOR failed", funct3, funct7, is_add, is_sub, is_sll, is_slt, is_sltu,
                    is_xor, is_srl, is_sra, is_or, is_and);

    // SRL
    #10 funct3 = 3'b101;
    #10 funct7 = 7'b0;
    #10
    assert (
      is_add == 0 &&
      is_sub == 0 &&
      is_sll == 0 &&
      is_slt == 0 &&
      is_sltu == 0 &&
      is_xor == 0 &&
      is_srl == 1 &&
      is_sra == 0 &&
      is_or == 0 &&
      is_and == 0
      )
    else
      display_error("Testcase SRL failed", funct3, funct7, is_add, is_sub, is_sll, is_slt, is_sltu,
                    is_xor, is_srl, is_sra, is_or, is_and);

    $finish;
    // SRA
    #10 funct3 = 3'b101;
    #10 funct7 = 7'b0100000;
    #10
    assert (
      is_add == 0 &&
      is_sub == 0 &&
      is_sll == 0 &&
      is_slt == 0 &&
      is_sltu == 0 &&
      is_xor == 0 &&
      is_srl == 0 &&
      is_sra == 1 &&
      is_or == 0 &&
      is_and == 0
      )
    else
      display_error("Testcase SRA failed", funct3, funct7, is_add, is_sub, is_sll, is_slt, is_sltu,
                    is_xor, is_srl, is_sra, is_or, is_and);

    // OR
    #10 funct3 = 3'b110;
    #10 funct7 = 7'b0;
    #10
    assert (
      is_add == 0 &&
      is_sub == 0 &&
      is_sll == 0 &&
      is_slt == 0 &&
      is_sltu == 0 &&
      is_xor == 0 &&
      is_srl == 0 &&
      is_sra == 0 &&
      is_or == 1 &&
      is_and == 0
      )
    else
      display_error("Testcase OR failed", funct3, funct7, is_add, is_sub, is_sll, is_slt, is_sltu,
                    is_xor, is_srl, is_sra, is_or, is_and);

    // AND
    #10 funct3 = 3'b111;
    #10 funct7 = 7'b0;
    #10
    assert (
      is_add == 0 &&
      is_sub == 0 &&
      is_sll == 0 &&
      is_slt == 0 &&
      is_sltu == 0 &&
      is_xor == 0 &&
      is_srl == 0 &&
      is_sra == 0 &&
      is_or == 0 &&
      is_and == 1
      )
    else
      display_error("Testcase AND failed", funct3, funct7, is_add, is_sub, is_sll, is_slt, is_sltu,
                    is_xor, is_srl, is_sra, is_or, is_and);

    $finish;
  end
endmodule

