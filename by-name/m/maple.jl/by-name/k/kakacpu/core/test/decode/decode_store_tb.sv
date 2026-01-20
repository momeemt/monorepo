`timescale 1ns / 1ps

import instr_type::*;

function automatic void display_error(input string testcase_name, input logic [2:0] funct3,
                                      input store_kind_t kind);
  $error("[decode::decode_store] %s failed\nfunct3: %b | kind: %p", testcase_name, funct3, kind);
endfunction

module decode_store_tb;
  logic clk;
  logic rst;
  logic [2:0] funct3;
  store_kind_t kind;

  decode_store uut (
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

    // SB
    #10 funct3 = 3'b000;
    #10
    assert (kind == sk_sb)
    else display_error("Testcase SB failed", funct3, kind);

    // Invalid
    #10 funct3 = 3'b001;
    #10
    assert (kind == sk_invalid)
    else display_error("Testcase Invalid failed", funct3, kind);

    // SH
    #10 funct3 = 3'b010;
    #10
    assert (kind == sk_sh)
    else display_error("Testcase SH failed", funct3, kind);

    // SW
    #10 funct3 = 3'b011;
    #10
    assert (kind == sk_sw)
    else display_error("Testcase SW failed", funct3, kind);

    // Invalid
    for (funct3 = 3'b100; funct3 >= 3'b100 && funct3 <= 3'b111; funct3++) begin
      #10;
      #10
      assert (kind == sk_invalid)
      else display_error("Testcase Invalid failed", funct3, kind);
    end

    $finish;
  end
endmodule
