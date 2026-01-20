`timescale 1ns / 1ps

import instr_type::*;
import register_params::*;

module decode_tb;
  // input
  logic clk;
  logic rst;
  logic [31:0] instruction;

  // output
  instr_kind_t instr_kind;
  logic [REGISTER_DESCRIPTOR_WIDTH-1:0] rs1_addr;
  logic [REGISTER_DESCRIPTOR_WIDTH-1:0] rs2_addr;
  logic [REGISTER_DESCRIPTOR_WIDTH-1:0] rd_addr;
  logic [3:0] pred;
  logic [3:0] succ;
  logic [10:0] csr;
  logic [4:0] zimm;
  logic [4:0] shamt;
  logic [OPERAND_WIDTH-1:0] immediate_data;
  logic write_reserve;

  // expect_output
  instr_kind_t expect_instr_kind;
  logic [REGISTER_DESCRIPTOR_WIDTH-1:0] expect_rs1_addr;
  logic [REGISTER_DESCRIPTOR_WIDTH-1:0] expect_rs2_addr;
  logic [REGISTER_DESCRIPTOR_WIDTH-1:0] expect_rd_addr;
  logic [3:0] expect_pred;
  logic [3:0] expect_succ;
  logic [10:0] expect_csr;
  logic [4:0] expect_zimm;
  logic [4:0] expect_shamt;
  logic [OPERAND_WIDTH-1:0] expect_immediate_data;
  logic expect_write_reserve;

  task automatic display_error;
    input string Testcase_name;
    input logic check_immediate_data;
    input logic check_rs1_addr;
    input logic check_rs2_addr;
    input logic check_rd_addr;
    input logic check_pred;
    input logic check_succ;
    input logic check_csr;
    input logic check_zimm;
    input logic check_shamt;
    input logic check_write_reserve;

    int errors = 0;

    $display("\n== TESTCASE: %s ==", Testcase_name);

    if (expect_instr_kind !== instr_kind) begin
      errors++;
      $display("\033[1;31m[ERROR]\033[0m Instr kind mismatch! Expected: %p, Got: %p",
               expect_instr_kind, instr_kind);
    end else begin
      $display("\033[1;32m[OK]\033[0m Instr kind: %p", instr_kind);
    end

    if (check_immediate_data) begin
      if (expect_immediate_data !== immediate_data) begin
        errors++;
        $display("\033[1;31m[ERROR]\033[0m Immediate data mismatch! Expected: %h, Got: %h",
                 expect_immediate_data, immediate_data);
      end else begin
        $display("\033[1;32m[OK]\033[0m Immediate data: %h", immediate_data);
      end
    end

    if (check_rs1_addr) begin
      if (expect_rs1_addr !== rs1_addr) begin
        errors++;
        $display("\033[1;31m[ERROR]\033[0m RS1 address mismatch! Expected: %b, Got: %b",
                 expect_rs1_addr, rs1_addr);
      end else begin
        $display("\033[1;32m[OK]\033[0m RS1 address: %b", rs1_addr);
      end
    end

    if (check_rs2_addr) begin
      if (expect_rs2_addr !== rs2_addr) begin
        errors++;
        $display("\033[1;31m[ERROR]\033[0m RS2 address mismatch! Expected: %b, Got: %b",
                 expect_rs2_addr, rs2_addr);
      end else begin
        $display("\033[1;32m[OK]\033[0m RS2 address: %b", rs2_addr);
      end
    end

    if (check_rd_addr) begin
      if (expect_rd_addr !== rd_addr) begin
        errors++;
        $display("\033[1;31m[ERROR]\033[0m RD address mismatch! Expected: %b, Got: %b",
                 expect_rd_addr, rd_addr);
      end else begin
        $display("\033[1;32m[OK]\033[0m RD address: %b", rd_addr);
      end
    end

    if (check_pred) begin
      if (expect_pred !== pred) begin
        errors++;
        $display("\033[1;31m[ERROR]\033[0m Predicate mismatch! Expected: %b, Got: %b", expect_pred,
                 pred);
      end else begin
        $display("\033[1;32m[OK]\033[0m Predicate: %b", pred);
      end
    end

    if (check_succ) begin
      if (expect_succ !== succ) begin
        errors++;
        $display("\033[1;31m[ERROR]\033[0m Successor mismatch! Expected: %b, Got: %b", expect_succ,
                 succ);
      end else begin
        $display("\033[1;32m[OK]\033[0m Successor: %b", succ);
      end
    end

    if (check_csr) begin
      if (expect_csr !== csr) begin
        errors++;
        $display("\033[1;31m[ERROR]\033[0m CSR mismatch! Expected: %b, Got: %b", expect_csr, csr);
      end else begin
        $display("\033[1;32m[OK]\033[0m CSR: %b", csr);
      end
    end

    if (check_zimm) begin
      if (expect_zimm !== zimm) begin
        errors++;
        $display("\033[1;31m[ERROR]\033[0m ZIMM mismatch! Expected: %b, Got: %b", expect_zimm,
                 zimm);
      end else begin
        $display("\033[1;32m[OK]\033[0m ZIMM: %b", zimm);
      end
    end

    if (check_shamt) begin
      if (expect_shamt !== shamt) begin
        errors++;
        $display("\033[1;31m[ERROR]\033[0m shamt mismatch! Expected: %b, Got: %b", expect_shamt,
                 shamt);
      end else begin
        $display("\033[1;32m[OK]\033[0m shamt: %b", shamt);
      end
    end

    if (check_write_reserve) begin
      if (expect_write_reserve !== write_reserve) begin
        errors++;
        $display("\033[1;31m[ERROR]\033[0m Write reserve mismatch! Expected: %b, Got: %b",
                 expect_write_reserve, write_reserve);
      end else begin
        $display("\033[1;32m[OK]\033[0m Write reserve: %b", write_reserve);
      end
    end

    if (errors == 0) begin
      $display("\033[1;32m[TESTCASE PASSED]\033[0m %s", Testcase_name);
    end else begin
      $error("\033[1;31m[TESTCASE FAILED]\033[0m %s with %d error(s)", Testcase_name, errors);
    end
  endtask

  decode uut (
      .rst(rst),
      .instruction(instruction),
      .instr_kind(instr_kind),
      .rs1_addr(rs1_addr),
      .rs2_addr(rs2_addr),
      .rd_addr(rd_addr),
      .shamt(shamt),
      .pred(pred),
      .succ(succ),
      .csr(csr),
      .zimm(zimm),
      .immediate_data(immediate_data),
      .write_reserve(write_reserve)
  );

  always #5 clk = ~clk;

  initial begin
    clk = 0;
    rst = 0;
    instruction = 31'b0;
    #10 rst = 1;

    // LUI
    #10 instruction = 32'b00001111000011110000_01010_0110111;
    expect_instr_kind = LUI;
    expect_rd_addr = 5'b01010;
    expect_immediate_data = 32'b000000000000_00001111000011110000;
    expect_write_reserve = 1;
    #10
    assert (
      instr_kind == expect_instr_kind
      && rd_addr == expect_rd_addr
      && immediate_data == expect_immediate_data
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase LUI failed", 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // AUIPC
    #10 instruction = 32'b11110000111100001111_10101_0010111;
    expect_instr_kind = AUIPC;
    expect_rd_addr = 5'b10101;
    expect_immediate_data = 32'b000000000000_11110000111100001111;
    expect_write_reserve = 1;
    #10
    assert (
      instr_kind == expect_instr_kind
      && rd_addr == expect_rd_addr
      && immediate_data == expect_immediate_data
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase AUIPC failed", 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // JAL
    #10 instruction = 32'b00001111000011110000_01110_1101111;
    expect_instr_kind = JAL;
    expect_rd_addr = 5'b01110;
    expect_immediate_data = 32'b000000000000_00011110000000011110;
    expect_write_reserve = 1;
    #10
    assert (
      instr_kind == expect_instr_kind
      && rd_addr == expect_rd_addr
      && immediate_data == expect_immediate_data
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase JAL failed", 1, 0, 0, 1, 0, 0, 0, 0, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // JALR
    #10 instruction = 32'b000011110000_01010_000_10101_1100111;
    expect_instr_kind = JALR;
    expect_rs1_addr = 5'b01010;
    expect_rd_addr = 5'b10101;
    expect_immediate_data = 32'b00000000000000000000_000011110000;
    expect_write_reserve = 1;
    #10
    assert (
      instr_kind == expect_instr_kind
      && rs1_addr == expect_rs1_addr
      && rd_addr == expect_rd_addr
      && immediate_data == expect_immediate_data
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase JALR failed", 1, 1, 0, 1, 0, 0, 0, 0, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // BEQ
    #10 instruction = 32'b0101010_10101_01010_000_10101_1100011;
    expect_instr_kind = BEQ;
    expect_rs1_addr = 5'b01010;
    expect_rs2_addr = 5'b10101;
    expect_immediate_data = 32'b00000000000000000000_011010101010;
    expect_write_reserve = 0;
    #10
    assert (
      instr_kind == expect_instr_kind
      && rs1_addr == expect_rs1_addr
      && rs2_addr == expect_rs2_addr
      && immediate_data == expect_immediate_data
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase BEQ failed", 1, 1, 1, 0, 0, 0, 0, 0, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // BNE
    #10 instruction = 32'b1010101_00110_11001_001_01010_1100011;
    expect_instr_kind = BNE;
    expect_rs1_addr = 5'b11001;
    expect_rs2_addr = 5'b00110;
    expect_immediate_data = 32'b11111111111111111111_100101010101;
    expect_write_reserve = 0;
    #10
    assert (
      instr_kind == expect_instr_kind
      && rs1_addr == expect_rs1_addr
      && rs2_addr == expect_rs2_addr
      && immediate_data == expect_immediate_data
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase BNE failed", 1, 1, 1, 0, 0, 0, 0, 0, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // BLT
    #10 instruction = 32'b0011001_11110_00001_100_11111_1100011;
    expect_instr_kind = BLT;
    expect_rs1_addr = 5'b00001;
    expect_rs2_addr = 5'b11110;
    expect_immediate_data = 32'b00000000000000000000_010110011111;
    expect_write_reserve = 0;
    #10
    assert (
      instr_kind == expect_instr_kind
      && rs1_addr == expect_rs1_addr
      && rs2_addr == expect_rs2_addr
      && immediate_data == expect_immediate_data
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase BLT failed", 1, 1, 1, 0, 0, 0, 0, 0, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // BGE
    #10 instruction = 32'b1111111_10001_00100_101_00000_1100011;
    expect_instr_kind = BGE;
    expect_rs1_addr = 5'b00100;
    expect_rs2_addr = 5'b10001;
    expect_immediate_data = 32'b11111111111111111111_101111110000;
    expect_write_reserve = 0;
    #10
    assert (
      instr_kind == expect_instr_kind
      && rs1_addr == expect_rs1_addr
      && rs2_addr == expect_rs2_addr
      && immediate_data == expect_immediate_data
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase BGE failed", 1, 1, 1, 0, 0, 0, 0, 0, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // BLTU
    #10 instruction = 32'b0110001_11000_00110_110_10110_1100011;
    expect_instr_kind = BLTU;
    expect_rs1_addr = 5'b00110;
    expect_rs2_addr = 5'b11000;
    expect_immediate_data = 32'b00000000000000000000_001100011011;
    expect_write_reserve = 0;
    #10
    assert (
      instr_kind == expect_instr_kind
      && rs1_addr == expect_rs1_addr
      && rs2_addr == expect_rs2_addr
      && immediate_data == expect_immediate_data
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase BLTU failed", 1, 1, 1, 0, 0, 0, 0, 0, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // BGEU
    #10 instruction = 32'b1000101_10101_11001_111_10010_1100011;
    expect_instr_kind = BGEU;
    expect_rs1_addr = 5'b11001;
    expect_rs2_addr = 5'b10101;
    expect_immediate_data = 32'b11111111111111111111_100001011001;
    expect_write_reserve = 0;
    #10
    assert (
      instr_kind == expect_instr_kind
      && rs1_addr == expect_rs1_addr
      && rs2_addr == expect_rs2_addr
      && immediate_data == expect_immediate_data
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase BGEU failed", 1, 1, 1, 0, 0, 0, 0, 0, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // LB
    #10 instruction = 32'b100010101001_10101_000_01010_0000011;
    expect_instr_kind = LB;
    expect_rs1_addr = 5'b10101;
    expect_rd_addr = 5'b01010;
    expect_immediate_data = 32'b11111111111111111111_100010101001;
    expect_write_reserve = 1;
    #10
    assert (
      instr_kind == expect_instr_kind
      && rs1_addr == expect_rs1_addr
      && rd_addr == expect_rd_addr
      && immediate_data == expect_immediate_data
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase LB failed", 1, 1, 0, 1, 0, 0, 0, 0, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // LH
    #10 instruction = 32'b101010101010_00001_001_11110_0000011;
    expect_instr_kind = LH;
    expect_rs1_addr = 5'b00001;
    expect_rd_addr = 5'b11110;
    expect_immediate_data = 32'b11111111111111111111_101010101010;
    expect_write_reserve = 1;
    #10
    assert (
      instr_kind == expect_instr_kind
      && rs1_addr == expect_rs1_addr
      && rd_addr == expect_rd_addr
      && immediate_data == expect_immediate_data
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase LH failed", 1, 1, 0, 1, 0, 0, 0, 0, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // LW
    #10 instruction = 32'b010101010101_10001_010_01110_0000011;
    expect_instr_kind = LW;
    expect_rs1_addr = 5'b10001;
    expect_rd_addr = 5'b01110;
    expect_immediate_data = 32'b00000000000000000000_010101010101;
    expect_write_reserve = 1;
    #10
    assert (
      instr_kind == expect_instr_kind
      && rs1_addr == expect_rs1_addr
      && rd_addr == expect_rd_addr
      && immediate_data == expect_immediate_data
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase LW failed", 1, 1, 0, 1, 0, 0, 0, 0, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // LBU
    #10 instruction = 32'b000011110000_11001_100_00110_0000011;
    expect_instr_kind = LBU;
    expect_rs1_addr = 5'b11001;
    expect_rd_addr = 5'b00110;
    expect_immediate_data = 32'b00000000000000000000_000011110000;
    expect_write_reserve = 1;
    #10
    assert (
      instr_kind == expect_instr_kind
      && rs1_addr == expect_rs1_addr
      && rd_addr == expect_rd_addr
      && immediate_data == expect_immediate_data
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase LBU failed", 1, 1, 0, 1, 0, 0, 0, 0, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // LHU
    #10 instruction = 32'b001100110011_00010_101_00110_0000011;
    expect_instr_kind = LHU;
    expect_rs1_addr = 5'b00010;
    expect_rd_addr = 5'b00110;
    expect_immediate_data = 32'b00000000000000000000_001100110011;
    expect_write_reserve = 1;
    #10
    assert (
      instr_kind == expect_instr_kind
      && rs1_addr == expect_rs1_addr
      && rd_addr == expect_rd_addr
      && immediate_data == expect_immediate_data
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase LHU failed", 1, 1, 0, 1, 0, 0, 0, 0, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // SB
    #10 instruction = 32'b1111000_10101_01010_000_11001_0100011;
    expect_instr_kind = SB;
    expect_rs1_addr = 5'b01010;
    expect_rs2_addr = 5'b10101;
    expect_immediate_data = 32'b11111111111111111111_111100011001;
    expect_write_reserve = 0;
    #10
    assert (
      instr_kind == expect_instr_kind
      && rs1_addr == expect_rs1_addr
      && rs2_addr == expect_rs2_addr
      && immediate_data == expect_immediate_data
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase SB failed", 1, 1, 1, 0, 0, 0, 0, 0, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // SH
    #10 instruction = 32'b0101010_11111_00000_001_01010_0100011;
    expect_instr_kind = SH;
    expect_rs1_addr = 5'b00000;
    expect_rs2_addr = 5'b11111;
    expect_immediate_data = 32'b00000000000000000000_010101001010;
    expect_write_reserve = 0;
    #10
    assert (
      instr_kind == expect_instr_kind
      && rs1_addr == expect_rs1_addr
      && rs2_addr == expect_rs2_addr
      && immediate_data == expect_immediate_data
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase SH failed", 1, 1, 1, 0, 0, 0, 0, 0, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // SW
    #10 instruction = 32'b1110001_00000_00000_010_11111_0100011;
    expect_instr_kind = SW;
    expect_rs1_addr = 5'b00000;
    expect_rs2_addr = 5'b00000;
    expect_immediate_data = 32'b11111111111111111111_111000111111;
    expect_write_reserve = 0;
    #10
    assert (
      instr_kind == expect_instr_kind
      && rs1_addr == expect_rs1_addr
      && rs2_addr == expect_rs2_addr
      && immediate_data == expect_immediate_data
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase SW failed", 1, 1, 1, 0, 0, 0, 0, 0, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // ADDI
    #10 instruction = 32'b111111111111_00000_000_11110_0010011;
    expect_instr_kind = ADDI;
    expect_rs1_addr = 5'b00000;
    expect_rd_addr = 5'b11110;
    expect_immediate_data = 32'b11111111111111111111_111111111111;
    expect_write_reserve = 1;
    #10
    assert (
      instr_kind == expect_instr_kind
      && rs1_addr == expect_rs1_addr
      && rd_addr == expect_rd_addr
      && immediate_data == expect_immediate_data
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase ADDI failed", 1, 1, 0, 1, 0, 0, 0, 0, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // SLTI
    #10 instruction = 32'b000111000111_10101_010_11111_0010011;
    expect_instr_kind = SLTI;
    expect_rs1_addr = 5'b10101;
    expect_rd_addr = 5'b11111;
    expect_immediate_data = 32'b00000000000000000000_000111000111;
    expect_write_reserve = 1;
    #10
    assert (
      instr_kind == expect_instr_kind
      && rs1_addr == expect_rs1_addr
      && rd_addr == expect_rd_addr
      && immediate_data == expect_immediate_data
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase SLTI failed", 1, 1, 0, 1, 0, 0, 0, 0, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // SLTIU
    #10 instruction = 32'b011000111100_11101_011_00100_0010011;
    expect_instr_kind = SLTIU;
    expect_rs1_addr = 5'b11101;
    expect_rd_addr = 5'b00100;
    expect_immediate_data = 32'b00000000000000000000_011000111100;
    expect_write_reserve = 1;
    #10
    assert (
      instr_kind == expect_instr_kind
      && rs1_addr == expect_rs1_addr
      && rd_addr == expect_rd_addr
      && immediate_data == expect_immediate_data
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase SLTIU failed", 1, 1, 0, 1, 0, 0, 0, 0, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // XORI
    #10 instruction = 32'b000000011111_01010_100_10101_0010011;
    expect_instr_kind = XORI;
    expect_rs1_addr = 5'b01010;
    expect_rd_addr = 5'b10101;
    expect_immediate_data = 32'b00000000000000000000_000000011111;
    expect_write_reserve = 1;
    #10
    assert (
      instr_kind == expect_instr_kind
      && rs1_addr == expect_rs1_addr
      && rd_addr == expect_rd_addr
      && immediate_data == expect_immediate_data
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase XORI failed", 1, 1, 0, 1, 0, 0, 0, 0, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // ORI
    #10 instruction = 32'b000111111111_00000_110_11111_0010011;
    expect_instr_kind = ORI;
    expect_rs1_addr = 5'b00000;
    expect_rd_addr = 5'b11111;
    expect_immediate_data = 32'b00000000000000000000_000111111111;
    expect_write_reserve = 1;
    #10
    assert (
      instr_kind == expect_instr_kind
      && rs1_addr == expect_rs1_addr
      && rd_addr == expect_rd_addr
      && immediate_data == expect_immediate_data
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase ORI failed", 1, 1, 0, 1, 0, 0, 0, 0, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // ANDI
    #10 instruction = 32'b011111111111_01010_111_10101_0010011;
    expect_instr_kind = ANDI;
    expect_rs1_addr = 5'b01010;
    expect_rd_addr = 5'b10101;
    expect_immediate_data = 32'b00000000000000000000_011111111111;
    expect_write_reserve = 1;
    #10
    assert (
      instr_kind == expect_instr_kind
      && rs1_addr == expect_rs1_addr
      && rd_addr == expect_rd_addr
      && immediate_data == expect_immediate_data
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase ANDI failed", 1, 1, 0, 1, 0, 0, 0, 0, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // SLLI
    #10 instruction = 32'b0000000_11111_00000_001_00000_0010011;
    expect_instr_kind = SLLI;
    expect_rs1_addr = 5'b00000;
    expect_rd_addr = 5'b00000;
    expect_shamt = 5'b11111;
    expect_write_reserve = 1;
    #10
    assert (
      instr_kind == expect_instr_kind
      && rs1_addr == expect_rs1_addr
      && rd_addr == expect_rd_addr
      && shamt == expect_shamt
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase SLLI failed", 0, 1, 0, 1, 0, 0, 0, 0, 1, 1);

    #10 rst = 0;
    #10 rst = 1;

    // SRLI
    #10 instruction = 32'b0000000_00000_10101_101_01010_0010011;
    expect_instr_kind = SRLI;
    expect_rs1_addr = 5'b10101;
    expect_rd_addr = 5'b01010;
    expect_shamt = 5'b00000;
    expect_write_reserve = 1;
    #10
    assert (
      instr_kind == expect_instr_kind
      && rs1_addr == expect_rs1_addr
      && rd_addr == expect_rd_addr
      && shamt == expect_shamt
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase SRLI failed", 0, 1, 0, 1, 0, 0, 0, 0, 1, 1);

    #10 rst = 0;
    #10 rst = 1;

    // SRAI
    #10 instruction = 32'b0100000_10101_11001_101_00110_0010011;
    expect_instr_kind = SRAI;
    expect_rs1_addr = 5'b11001;
    expect_rd_addr = 5'b00110;
    expect_shamt = 5'b10101;
    expect_write_reserve = 1;
    #10
    assert (
      instr_kind == expect_instr_kind
      && rs1_addr == expect_rs1_addr
      && rd_addr == expect_rd_addr
      && shamt == expect_shamt
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase SRAI failed", 0, 1, 0, 1, 0, 0, 0, 0, 1, 1);

    #10 rst = 0;
    #10 rst = 1;

    // ADD
    #10 instruction = 32'b0000000_11111_00000_000_10101_0110011;
    expect_instr_kind = ADD;
    expect_rs1_addr = 5'b00000;
    expect_rs2_addr = 5'b11111;
    expect_rd_addr = 5'b10101;
    expect_write_reserve = 1;
    #10
    assert (
      instr_kind == expect_instr_kind
      && rs1_addr == expect_rs1_addr
      && rs2_addr == expect_rs2_addr
      && rd_addr == expect_rd_addr
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase ADD failed", 0, 1, 1, 1, 0, 0, 0, 0, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // SUB
    #10 instruction = 32'b0100000_01011_11110_000_00101_0110011;
    expect_instr_kind = SUB;
    expect_rs1_addr = 5'b11110;
    expect_rs2_addr = 5'b01011;
    expect_rd_addr = 5'b00101;
    expect_write_reserve = 1;
    #10
    assert (
      instr_kind == expect_instr_kind
      && rs1_addr == expect_rs1_addr
      && rs2_addr == expect_rs2_addr
      && rd_addr == expect_rd_addr
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase SUB failed", 0, 1, 1, 1, 0, 0, 0, 0, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // SLL
    #10 instruction = 32'b0000000_11011_00100_001_11100_0110011;
    expect_instr_kind = SLL;
    expect_rs1_addr = 5'b00100;
    expect_rs2_addr = 5'b11011;
    expect_rd_addr = 5'b11100;
    expect_write_reserve = 1;
    #10
    assert (
      instr_kind == expect_instr_kind
      && rs1_addr == expect_rs1_addr
      && rs2_addr == expect_rs2_addr
      && rd_addr == expect_rd_addr
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase SLL failed", 0, 1, 1, 1, 0, 0, 0, 0, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // SLT
    #10 instruction = 32'b0000000_00011_11100_010_00000_0110011;
    expect_instr_kind = SLT;
    expect_rs1_addr = 5'b11100;
    expect_rs2_addr = 5'b00011;
    expect_rd_addr = 5'b00000;
    expect_write_reserve = 1;
    #10
    assert (
      instr_kind == expect_instr_kind
      && rs1_addr == expect_rs1_addr
      && rs2_addr == expect_rs2_addr
      && rd_addr == expect_rd_addr
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase SLT failed", 0, 1, 1, 1, 0, 0, 0, 0, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // SLTU
    #10 instruction = 32'b0000000_10001_10010_011_10011_0110011;
    expect_instr_kind = SLTU;
    expect_rs1_addr = 5'b10010;
    expect_rs2_addr = 5'b10001;
    expect_rd_addr = 5'b10011;
    expect_write_reserve = 1;
    #10
    assert (
      instr_kind == expect_instr_kind
      && rs1_addr == expect_rs1_addr
      && rs2_addr == expect_rs2_addr
      && rd_addr == expect_rd_addr
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase SLTU failed", 0, 1, 1, 1, 0, 0, 0, 0, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // XOR
    #10 instruction = 32'b0000000_11111_00000_100_11111_0110011;
    expect_instr_kind = XOR;
    expect_rs1_addr = 5'b00000;
    expect_rs2_addr = 5'b11111;
    expect_rd_addr = 5'b11111;
    expect_write_reserve = 1;
    #10
    assert (
      instr_kind == expect_instr_kind
      && rs1_addr == expect_rs1_addr
      && rs2_addr == expect_rs2_addr
      && rd_addr == expect_rd_addr
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase XOR failed", 0, 1, 1, 1, 0, 0, 0, 0, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // SRL
    #10 instruction = 32'b0000000_01100_11110_101_10011_0110011;
    expect_instr_kind = SRL;
    expect_rs1_addr = 5'b11110;
    expect_rs2_addr = 5'b01100;
    expect_rd_addr = 5'b10011;
    expect_write_reserve = 1;
    #10
    assert (
      instr_kind == expect_instr_kind
      && rs1_addr == expect_rs1_addr
      && rs2_addr == expect_rs2_addr
      && rd_addr == expect_rd_addr
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase SRL failed", 0, 1, 1, 1, 0, 0, 0, 0, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // SRA
    #10 instruction = 32'b0100000_00000_00000_101_00011_0110011;
    expect_instr_kind = SRA;
    expect_rs1_addr = 5'b00000;
    expect_rs2_addr = 5'b00000;
    expect_rd_addr = 5'b00011;
    expect_write_reserve = 1;
    #10
    assert (
      instr_kind == expect_instr_kind
      && rs1_addr == expect_rs1_addr
      && rs2_addr == expect_rs2_addr
      && rd_addr == expect_rd_addr
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase SRA failed", 0, 1, 1, 1, 0, 0, 0, 0, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // OR
    #10 instruction = 32'b0000000_11110_01111_110_01101_0110011;
    expect_instr_kind = OR;
    expect_rs1_addr = 5'b01111;
    expect_rs2_addr = 5'b11110;
    expect_rd_addr = 5'b01101;
    expect_write_reserve = 1;
    #10
    assert (
      instr_kind == expect_instr_kind
      && rs1_addr == expect_rs1_addr
      && rs2_addr == expect_rs2_addr
      && rd_addr == expect_rd_addr
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase OR failed", 0, 1, 1, 1, 0, 0, 0, 0, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // AND
    #10 instruction = 32'b0000000_01101_10010_111_11111_0110011;
    expect_instr_kind = AND;
    expect_rs1_addr = 5'b10010;
    expect_rs2_addr = 5'b01101;
    expect_rd_addr = 5'b11111;
    expect_write_reserve = 1;
    #10
    assert (
      instr_kind == expect_instr_kind
      && rs1_addr == expect_rs1_addr
      && rs2_addr == expect_rs2_addr
      && rd_addr == expect_rd_addr
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase AND failed", 0, 1, 1, 1, 0, 0, 0, 0, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // FENCE
    #10 instruction = 32'b0000_1111_0000_00000_000_00000_0001111;
    expect_instr_kind = FENCE;
    expect_pred = 4'b1111;
    expect_succ = 4'b0000;
    expect_write_reserve = 0;
    #10
    assert (
      instr_kind == expect_instr_kind
      && pred == expect_pred
      && succ == expect_succ
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase FENCE failed", 0, 0, 0, 0, 1, 1, 0, 0, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // FENCE.I
    #10 instruction = 32'b0000_0000_0000_00000_001_00000_0001111;
    expect_instr_kind = FENCE_I;
    expect_write_reserve = 0;
    #10
    assert (instr_kind == expect_instr_kind && write_reserve == expect_write_reserve)
    else display_error("Testcase FENCE.I failed", 0, 0, 0, 0, 0, 0, 0, 0, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // ECALL
    #10 instruction = 32'b000000000000_00000_000_00000_1110011;
    expect_instr_kind = ECALL;
    expect_write_reserve = 0;
    #10
    assert (instr_kind == expect_instr_kind && write_reserve == expect_write_reserve)
    else display_error("Testcase ECALL failed", 0, 0, 0, 0, 0, 0, 0, 0, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // EBREAK
    #10 instruction = 32'b000000000001_00000_000_00000_1110011;
    expect_instr_kind = EBREAK;
    expect_write_reserve = 0;
    #10
    assert (instr_kind == expect_instr_kind && write_reserve == expect_write_reserve)
    else display_error("Testcase EBREAK failed", 0, 0, 0, 0, 0, 0, 0, 0, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // CSRRW
    #10 instruction = 32'b010101010101_11111_001_00000_1110011;
    expect_instr_kind = CSRRW;
    expect_csr = 12'b010101010101;
    expect_rs1_addr = 5'b11111;
    expect_rd_addr = 5'b00000;
    expect_write_reserve = 1;
    #10
    assert (
      instr_kind == expect_instr_kind
      && csr == expect_csr
      && rs1_addr == expect_rs1_addr
      && rd_addr == expect_rd_addr
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase CSRRW failed", 0, 1, 0, 1, 0, 0, 1, 0, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // CSRRS
    #10 instruction = 32'b101010101010_00000_010_11111_1110011;
    expect_instr_kind = CSRRS;
    expect_csr = 12'b101010101010;
    expect_rs1_addr = 5'b00000;
    expect_rd_addr = 5'b11111;
    expect_write_reserve = 1;
    #10
    assert (
      instr_kind == expect_instr_kind
      && csr == expect_csr
      && rs1_addr == expect_rs1_addr
      && rd_addr == expect_rd_addr
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase CSRRS failed", 0, 1, 0, 1, 0, 0, 1, 0, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // CSRRC
    #10 instruction = 32'b000000111111_00001_011_11110_1110011;
    expect_instr_kind = CSRRC;
    expect_csr = 12'b000000111111;
    expect_rs1_addr = 5'b00001;
    expect_rd_addr = 5'b11110;
    expect_write_reserve = 1;
    #10
    assert (
      instr_kind == expect_instr_kind
      && csr == expect_csr
      && rs1_addr == expect_rs1_addr
      && rd_addr == expect_rd_addr
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase CSRRC failed", 0, 1, 0, 1, 0, 0, 1, 0, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // CSRRWI
    #10 instruction = 32'b000011110000_00000_101_11111_1110011;
    expect_instr_kind = CSRRWI;
    expect_csr = 12'b000011110000;
    expect_zimm = 5'b00000;
    expect_rd_addr = 5'b11111;
    expect_write_reserve = 1;
    #10
    assert (
      instr_kind == expect_instr_kind
      && csr == expect_csr
      && zimm == expect_zimm
      && rd_addr == expect_rd_addr
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase CSRRWI failed", 0, 0, 0, 1, 0, 0, 1, 1, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // CSRRSI
    #10 instruction = 32'b111000111000_01011_110_10100_1110011;
    expect_instr_kind = CSRRSI;
    expect_csr = 12'b111000111000;
    expect_zimm = 5'b01011;
    expect_rd_addr = 5'b10100;
    expect_write_reserve = 1;
    #10
    assert (
      instr_kind == expect_instr_kind
      && csr == expect_csr
      && zimm == expect_zimm
      && rd_addr == expect_rd_addr
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase CSRRSI failed", 0, 0, 0, 1, 0, 0, 1, 1, 0, 1);

    #10 rst = 0;
    #10 rst = 1;

    // CSRRCI
    #10 instruction = 32'b001100110011_10001_111_00000_1110011;
    expect_instr_kind = CSRRCI;
    expect_csr = 12'b001100110011;
    expect_zimm = 5'b10001;
    expect_rd_addr = 5'b00000;
    expect_write_reserve = 1;
    #10
    assert (
      instr_kind == expect_instr_kind
      && csr == expect_csr
      && zimm == expect_zimm
      && rd_addr == expect_rd_addr
      && write_reserve == expect_write_reserve
    )
    else display_error("Testcase CSRRCI failed", 0, 0, 0, 1, 0, 0, 1, 1, 0, 1);

    $finish;
  end
endmodule
