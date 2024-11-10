import instr_type::*;
import register_file_params::*;

module decode (
    input logic rst,
    input logic [31:0] instruction,
    output instr_kind_t instr_kind,
    output logic [REGISTER_DESCRIPTOR_WIDTH-1:0] rs1_addr,
    output logic [REGISTER_DESCRIPTOR_WIDTH-1:0] rs2_addr,
    output logic [REGISTER_DESCRIPTOR_WIDTH-1:0] rd_addr,
    output logic [4:0] shamt,
    output logic [3:0] pred,
    output logic [3:0] succ,
    output logic [10:0] csr,
    output logic [4:0] zimm,
    output logic [OPERAND_WIDTH-1:0] immediate_data,
    output logic write_reserve
);
  opcode_t opcode_type;
  branch_kind_t branch_kind;
  load_kind_t load_kind;
  store_kind_t store_kind;
  imm_arith_kind_t imm_arith_kind;
  reg_arith_kind_t reg_arith_kind;
  fence_kind_t fence_kind;
  system_kind_t system_kind;

  logic [REGISTER_DESCRIPTOR_WIDTH-1:0] rs1, rs2, rd;  // an address for a register file
  logic [6:0] funct7, opcode;
  logic [ 2:0] funct3;
  logic [10:0] ecall_ebreak_sel;

  assign rs1_addr = rs1;
  assign rs2_addr = rs2;
  assign rd_addr  = rd;

  decode_opcode decode_opcode_inst (
      .rst(rst),
      .opcode(opcode),
      .opcode_type(opcode_type)
  );

  decode_branch decode_branch_inst (
      .rst(rst),
      .funct3(funct3),
      .kind(branch_kind)
  );

  decode_load decode_load_inst (
      .rst(rst),
      .funct3(funct3),
      .kind(load_kind)
  );

  decode_store decode_store_inst (
      .rst(rst),
      .funct3(funct3),
      .kind(store_kind)
  );

  decode_reg_arith decode_reg_arith_inst (
      .rst(rst),
      .funct3(funct3),
      .funct7(funct7),
      .kind(reg_arith_kind)
  );

  decode_imm_arith decode_imm_arith_inst (
      .rst(rst),
      .funct3(funct3),
      .funct7(funct7),
      .kind(imm_arith_kind)
  );

  decode_fence decode_fence_inst (
      .rst(rst),
      .funct3(funct3),
      .kind(fence_kind)
  );

  decode_system decode_system_inst (
      .rst(rst),
      .funct3(funct3),
      .rs1(rs1),
      .rd(rd),
      .ecall_ebreak_sel(csr),
      .kind(system_kind)
  );

  always_comb begin
    instr_kind = Invalid;
    rs1 = 'b0;
    rs2 = 'b0;
    rd = 'b0;
    pred = 'b0;
    succ = 'b0;
    csr = 'b0;
    zimm = 'b0;
    immediate_data = 'b0;
    write_reserve = 0;
    opcode = instruction[6:0];
    rd = instruction[11:7];
    funct3 = instruction[14:12];
    rs1 = instruction[19:15];
    rs2 = instruction[24:20];
    funct7 = instruction[31:25];
    zimm = instruction[19:15];
    shamt = instruction[24:20];
    pred = instruction[27:24];
    succ = instruction[23:20];
    csr = instruction[31:20];
    immediate_data = 32'b0;

    case (opcode_type)
      lui: begin
        instr_kind = LUI;
        write_reserve = 1;
        immediate_data = {12'b0, instruction[31:12]};
      end
      auipc: begin
        instr_kind = AUIPC;
        write_reserve = 1;
        immediate_data = {12'b0, instruction[31:12]};
      end
      jal: begin
        instr_kind = JAL;
        write_reserve = 1;
        immediate_data = {
          12'b0, instruction[31], instruction[21:12], instruction[22], instruction[30:23]
        };
      end
      jalr: begin
        instr_kind = JALR;
        write_reserve = 1;
        immediate_data = {20'b0, instruction[31:20]};
      end
      branch_type: begin
        case (branch_kind)
          bk_beq:  instr_kind = BEQ;
          bk_bne:  instr_kind = BNE;
          bk_blt:  instr_kind = BLT;
          bk_bge:  instr_kind = BGE;
          bk_bltu: instr_kind = BLTU;
          bk_bgeu: instr_kind = BGEU;
          default: ;
        endcase
        immediate_data = {
          {20{instruction[31]}},
          instruction[31],
          instruction[7],
          instruction[30:25],
          instruction[11:8]
        };
        write_reserve = 0;
      end
      load_type: begin
        case (load_kind)
          lk_lb:   instr_kind = LB;
          lk_lh:   instr_kind = LH;
          lk_lw:   instr_kind = LW;
          lk_lbu:  instr_kind = LBU;
          lk_lhu:  instr_kind = LHU;
          default: ;
        endcase
        immediate_data = {{20{instruction[31]}}, instruction[31:20]};
        write_reserve  = 1;
      end
      store_type: begin
        case (store_kind)
          sk_sb:   instr_kind = SB;
          sk_sh:   instr_kind = SH;
          sk_sw:   instr_kind = SW;
          default: ;
        endcase
        immediate_data = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
        write_reserve  = 0;
      end
      imm_arith_type: begin
        case (imm_arith_kind)
          iak_addi:  instr_kind = ADDI;
          iak_slti:  instr_kind = SLTI;
          iak_sltiu: instr_kind = SLTIU;
          iak_xori:  instr_kind = XORI;
          iak_ori:   instr_kind = ORI;
          iak_andi:  instr_kind = ANDI;
          iak_slli:  instr_kind = SLLI;
          iak_srli:  instr_kind = SRLI;
          iak_srai:  instr_kind = SRAI;
          default:   ;
        endcase
        immediate_data = {{20{instruction[31]}}, instruction[31:20]};
        write_reserve  = 1;
      end
      reg_arith_type: begin
        case (reg_arith_kind)
          rak_add:  instr_kind = ADD;
          rak_sub:  instr_kind = SUB;
          rak_sll:  instr_kind = SLL;
          rak_slt:  instr_kind = SLT;
          rak_sltu: instr_kind = SLTU;
          rak_xor:  instr_kind = XOR;
          rak_srl:  instr_kind = SRL;
          rak_sra:  instr_kind = SRA;
          rak_or:   instr_kind = OR;
          rak_and:  instr_kind = AND;
          default:  ;
        endcase
        write_reserve = 1;
      end
      fence_type: begin
        case (fence_kind)
          fk_fence: instr_kind = FENCE;
          fk_fence_i: instr_kind = FENCE_I;
          default: ;
        endcase
        write_reserve = 0;
      end
      system_type: begin
        write_reserve = 1;
        case (system_kind)
          sysk_ecall: begin
            instr_kind = ECALL;
            write_reserve = 0;
          end
          sysk_ebreak: begin
            instr_kind = EBREAK;
            write_reserve = 0;
          end
          sysk_csrrw: instr_kind = CSRRW;
          sysk_csrrs: instr_kind = CSRRS;
          sysk_csrrc: instr_kind = CSRRC;
          sysk_csrrwi: instr_kind = CSRRWI;
          sysk_csrrsi: instr_kind = CSRRSI;
          sysk_csrrci: instr_kind = CSRRCI;
          default: ;
        endcase
      end
      default: ;
    endcase
  end
endmodule
