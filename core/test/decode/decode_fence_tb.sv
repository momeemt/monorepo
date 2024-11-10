`timescale 1ns / 1ps

import instr_type::*;

function automatic void display_error(input string testcase_name, input logic [2:0] funct3,
                                      input fence_kind_t kind);
  $error("[decode::decode_fence] %s failed\nfunct3: %b | kind: %p", testcase_name, funct3, kind);
endfunction

module decode_fence_tb;
  logic clk;
  logic rst;
  logic [2:0] funct3;
  fence_kind_t kind;

  decode_fence uut (
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

    // FENCE
    #10 funct3 = 3'b000;
    #10
    assert (kind == fk_fence)
    else display_error("Testcase FENCE failed", funct3, kind);

    // FENCE_I
    #10 funct3 = 3'b001;
    #10
    assert (kind == fk_fence_i)
    else display_error("Testcase FENCE_I failed", funct3, kind);

    // Invalid
    for (funct3 = 3'b010; funct3 >= 3'b010 && funct3 <= 3'b111; funct3++) begin
      #10;
      #10
      assert (kind == fk_invalid)
      else display_error("Testcase Invalid failed", funct3, kind);
    end

    $finish;
  end
endmodule
