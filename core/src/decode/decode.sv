import opcode_type::*;

module decode (
    input logic clk,
    input logic rst,
    input logic [31:0] instruction,
    output instr_kind_t instr_kind,
    output logic [31:0] rs1_data,
    output logic [31:0] rs2_data,
    output logic [31:0] immidiate_data
);
  opcode_t opcode_type;
  branch_kind_t branch_kind;
  load_kind_t load_kind;
  store_kind_t store_kind;
  imm_arith_kind_t imm_arith_kind;
  reg_arith_kind_t reg_arith_kind;
  fence_kind_t fence_kind;
  system_kind_t system_kind;

  logic [4:0] rs1, rs2, rd;
  logic [6:0] funct7, opcode;
  logic [2:0] funct3;

  // decode opcode
  opcode opcode (
      .clk(clk),
      .rst(rst),
      .opcode(opcode),
      .opcode_type(opcode_type)
  );

  // decode reg_arith instrs
  r_type r_type (
      .clk(clk),
      .rst(rst),
      .funct3(funct3),
      .funct7(funct7),
      .kind(reg_arith_kind)
  );

  // decode imm_arith instrs
  imm_arith_type imm_arith_type (
      .clk(clk),
      .rst(rst),
      .funct3(funct3),
      .funct7(funct7),
      .kind(imm_arith_kind)
  );

  always @(posedge clk or negedge rst) begin
    opcode = instruction[6:0];
    rd = instruction[11:7];
    funct3 = instruction[14:12];
    rs1 = instruction[19:15];
    rs2 = instruction[24:20];
    funct7 = instruction[31:25];

    case (opcode_type)
      lui: instr_kind <= LUI;
      auipc: instr_kind <= AUIPC;
      jal: instr_kind <= JAL;
      jalr: instr_kind <= JALR;
      branch_type: begin
        case (branch_kind)
          bk_beq:  instr_kind <= BEQ;
          bk_bne:  instr_kind <= BNE;
          bk_blt:  instr_kind <= BLT;
          bk_bge:  instr_kind <= BGE;
          bk_bltu: instr_kind <= BLTU;
          bk_bgeu: instr_kind <= BGEU;
          default: ;
        endcase
      end
      load_type: begin
        case (load_kind)
          lk_lb:   instr_kind <= LB;
          lk_lh:   instr_kind <= LH;
          lk_lw:   instr_kind <= LW;
          lk_lbu:  instr_kind <= LBU;
          lk_lhu:  instr_kind <= LHU;
          default: ;
        endcase
      end
      store_type: begin
        case (store_kind)
          sk_sb:   instr_kind <= SB;
          sk_sh:   instr_kind <= SH;
          sk_sw:   instr_kind <= SW;
          default: ;
        endcase
      end
      imm_arith_type: begin
        case (imm_arith_kind)
          iak_addi:  instr_kind <= ADDI;
          iak_slti:  instr_kind <= SLTI;
          iak_sltiu: instr_kind <= SLTIU;
          iak_xori:  instr_kind <= XORI;
          iak_ori:   instr_kind <= ORI;
          iak_andi:  instr_kind <= ANDI;
          iak_slli:  instr_kind <= SLLI;
          iak_srli:  instr_kind <= SRLI;
          iak_srai:  instr_kind <= SRAI;
          default:   ;
        endcase
      end
      reg_arith_type: begin
        case (reg_arith_kind)
          rak_add:  instr_kind <= ADD;
          rak_sub:  instr_kind <= SUB;
          rak_sll:  instr_kind <= SLL;
          rak_slt:  instr_kind <= SLT;
          rak_sltu: instr_kind <= SLTU;
          rak_xor:  instr_kind <= XOR;
          rak_srl:  instr_kind <= SRL;
          rak_sra:  instr_kind <= SRA;
          rak_or:   instr_kind <= OR;
          rak_and:  instr_kind <= AND;
          default:  ;
        endcase
      end
      fence_type: begin
        case (fence_kind)
          fk_fence: instr_kind <= FENCE;
          fk_fence_i: instr_kind <= FENCE_I;
          default: ;
        endcase
      end
      system_type: begin
        case (system_kind)
          sk_ecall:  instr_kind <= ECALL;
          sk_ebreak: instr_kind <= EBREAK;
          sk_csrrw:  instr_kind <= CSRRW;
          sk_csrrs:  instr_kind <= CSRRS;
          sk_csrrc:  instr_kind <= CSRRC;
          sk_csrrwi: instr_kind <= CSRRWI;
          sk_csrrsi: instr_kind <= CSRRSI;
          sk_csrrci: instr_kind <= CSRRCI;
          default:   ;
        endcase
      end
      default: ;
    endcase
  end
endmodule
