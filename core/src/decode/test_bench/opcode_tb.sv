`timescale 1ns / 1ps

function automatic void display_error(
    input string testcase_name, input logic [6:0] opcode, input logic is_r_type,
    input logic is_i_type, input logic is_s_type, input logic is_b_type, input logic is_u_type,
    input logic is_j_type, input logic is_fence_type, input logic is_system_type);
  $error(
      "decode::opcode - " + "%s failed\nopcode: %b | is_r_type: %b | is_i_type: %b | is_s_type: %b | is_b_type: %b | is_u_type: %b | is_j_type: %b | is_fence_type: %b | is_system_type: %b",
      testcase_name, opcode, is_r_type, is_i_type, is_s_type, is_b_type, is_u_type, is_j_type,
      is_fence_type, is_system_type);
endfunction

module opcode_tb;
  logic clk;
  logic rst;
  logic [6:0] opcode;
  logic is_r_type;
  logic is_i_type;
  logic is_s_type;
  logic is_b_type;
  logic is_u_type;
  logic is_j_type;
  logic is_fence_type;
  logic is_system_type;

  opcode uut (
      .clk(clk),
      .rst(rst),
      .opcode(opcode),
      .is_r_type(is_r_type),
      .is_i_type(is_i_type),
      .is_s_type(is_s_type),
      .is_b_type(is_b_type),
      .is_u_type(is_u_type),
      .is_j_type(is_j_type),
      .is_fence_type(is_fence_type),
      .is_system_type(is_system_type)
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
    assert(
      is_r_type == 0 &&
      is_i_type == 0 &&
      is_s_type == 0 &&
      is_b_type == 0 &&
      is_u_type == 1 &&
      is_j_type == 0 &&
      is_fence_type == 0 &&
      is_system_type == 0
    )
    else
      display_error("Testcase LUI (U-Type) failed", opcode, is_r_type, is_i_type, is_s_type,
                    is_b_type, is_u_type, is_j_type, is_fence_type, is_system_type);

    // AUIPC
    #10 opcode = 7'b0010111;
    #10
    assert(
      is_r_type == 0 &&
      is_i_type == 0 &&
      is_s_type == 0 &&
      is_b_type == 0 &&
      is_u_type == 1 &&
      is_j_type == 0 &&
      is_fence_type == 0 &&
      is_system_type == 0
    )
    else
      display_error("Testcase AUIPC (U-Type) failed", opcode, is_r_type, is_i_type, is_s_type,
                    is_b_type, is_u_type, is_j_type, is_fence_type, is_system_type);

    // ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI
    #10 opcode = 7'b0010011;
    #10
    assert(
      is_r_type == 0 &&
      is_i_type == 1 &&
      is_s_type == 0 &&
      is_b_type == 0 &&
      is_u_type == 0 &&
      is_j_type == 0 &&
      is_fence_type == 0 &&
      is_system_type == 0
      )
    else
      display_error("Testcase I-Type failed", opcode, is_r_type, is_i_type, is_s_type, is_b_type,
                    is_u_type, is_j_type, is_fence_type, is_system_type);

    // ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND
    #10 opcode = 7'b0110011;
    #10
    assert(
      is_r_type == 1 &&
      is_i_type == 0 &&
      is_s_type == 0 &&
      is_b_type == 0 &&
      is_u_type == 0 &&
      is_j_type == 0 &&
      is_fence_type == 0 &&
      is_system_type == 0
      )
    else
      display_error("Testcase R-Type failed", opcode, is_r_type, is_i_type, is_s_type, is_b_type,
                    is_u_type, is_j_type, is_fence_type, is_system_type);

    // FENCE, FENCE.I
    #10 opcode = 7'b0001111;
    #10
    assert(
      is_r_type == 0 &&
      is_i_type == 0 &&
      is_s_type == 0 &&
      is_b_type == 0 &&
      is_u_type == 0 &&
      is_j_type == 0 &&
      is_fence_type == 1 &&
      is_system_type == 0
      )
    else
      display_error("Testcase Fence-Type failed", opcode, is_r_type, is_i_type, is_s_type,
                    is_b_type, is_u_type, is_j_type, is_fence_type, is_system_type);

    // CSRRW, CSRRS, CSRRC, CSRRWI, CSRRSI, CSRRCI, ECALL, EBREAK, URET, SRET,
    // MRET, WFI, SFENCE.VMA
    #10 opcode = 7'b1110011;
    #10
    assert(
      is_r_type == 0 &&
      is_i_type == 0 &&
      is_s_type == 0 &&
      is_b_type == 0 &&
      is_u_type == 0 &&
      is_j_type == 0 &&
      is_fence_type == 0 &&
      is_system_type == 1
      )
    else
      display_error("Testcase System-Type failed", opcode, is_r_type, is_i_type, is_s_type,
                    is_b_type, is_u_type, is_j_type, is_fence_type, is_system_type);

    // LD, LH, LW, LBU, LHU
    #10 opcode = 7'b0000011;
    #10
    assert(
      is_r_type == 0 &&
      is_i_type == 1 &&
      is_s_type == 0 &&
      is_b_type == 0 &&
      is_u_type == 0 &&
      is_j_type == 0 &&
      is_fence_type == 0 &&
      is_system_type == 0
      )
    else
      display_error("Testcase I-Type failed", opcode, is_r_type, is_i_type, is_s_type, is_b_type,
                    is_u_type, is_j_type, is_fence_type, is_system_type);

    // SB, SH, SW
    #10 opcode = 7'b0100011;
    #10
    assert(
      is_r_type == 0 &&
      is_i_type == 0 &&
      is_s_type == 1 &&
      is_b_type == 0 &&
      is_u_type == 0 &&
      is_j_type == 0 &&
      is_fence_type == 0 &&
      is_system_type == 0
      )
    else
      display_error("Testcase S-Type failed", opcode, is_r_type, is_i_type, is_s_type, is_b_type,
                    is_u_type, is_j_type, is_fence_type, is_system_type);

    // JAL
    #10 opcode = 7'b1101111;
    #10
    assert(
      is_r_type == 0 &&
      is_i_type == 0 &&
      is_s_type == 0 &&
      is_b_type == 0 &&
      is_u_type == 0 &&
      is_j_type == 1 &&
      is_fence_type == 0 &&
      is_system_type == 0
      )
    else
      display_error("Testcase JAL (J-Type) failed", opcode, is_r_type, is_i_type, is_s_type,
                    is_b_type, is_u_type, is_j_type, is_fence_type, is_system_type);

    // JALR
    #10 opcode = 7'b1100111;
    #10
    assert(
      is_r_type == 0 &&
      is_i_type == 1 &&
      is_s_type == 0 &&
      is_b_type == 0 &&
      is_u_type == 0 &&
      is_j_type == 0 &&
      is_fence_type == 0 &&
      is_system_type == 0
      )
    else
      display_error("Testcase JALR (I-Type) failed", opcode, is_r_type, is_i_type, is_s_type,
                    is_b_type, is_u_type, is_j_type, is_fence_type, is_system_type);

    // BEQ, BNE, BLT, BGE, BLTU, BGEU
    #10 opcode = 7'b1100011;
    #10
    assert(
      is_r_type == 0 &&
      is_i_type == 0 &&
      is_s_type == 0 &&
      is_b_type == 1 &&
      is_u_type == 0 &&
      is_j_type == 0 &&
      is_fence_type == 0 &&
      is_system_type == 0
      )
    else
      display_error("Testcase B-Type failed", opcode, is_r_type, is_i_type, is_s_type, is_b_type,
                    is_u_type, is_j_type, is_fence_type, is_system_type);

    $finish;
  end
endmodule

