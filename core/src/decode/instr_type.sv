package instr_type;
  typedef enum {
    invalid,
    lui,
    auipc,
    jal,
    jalr,
    branch_type,
    load_type,
    store_type,
    imm_arith_type,
    reg_arith_type,
    fence_type,
    system_type
  } opcode_t;

  typedef enum {
    bk_invalid,
    bk_beq,
    bk_bne,
    bk_blt,
    bk_bge,
    bk_bltu,
    bk_bgeu
  } branch_kind_t;

  typedef enum {
    lk_invalid,
    lk_lb,
    lk_lh,
    lk_lw,
    lk_lbu,
    lk_lhu
  } load_kind_t;

  typedef enum {
    sk_invalid,
    sk_sb,
    sk_sh,
    sk_sw
  } store_kind_t;

  typedef enum {
    iak_invalid,
    iak_addi,
    iak_slti,
    iak_sltiu,
    iak_xori,
    iak_ori,
    iak_andi,
    iak_slli,
    iak_srli,
    iak_srai
  } imm_arith_kind_t;

  typedef enum {
    rak_invalid,
    rak_add,
    rak_sub,
    rak_sll,
    rak_slt,
    rak_sltu,
    rak_xor,
    rak_srl,
    rak_sra,
    rak_or,
    rak_and
  } reg_arith_kind_t;

  typedef enum {
    fk_invalid,
    fk_fence,
    fk_fence_i
  } fence_kind_t;

  typedef enum {
    sysk_invalid,
    sysk_ecall,
    sysk_ebreak,
    sysk_csrrw,
    sysk_csrrs,
    sysk_csrrc,
    sysk_csrrwi,
    sysk_csrrsi,
    sysk_csrrci
  } system_kind_t;

  typedef enum {
    LUI,
    AUIPC,
    JAL,
    JALR,
    BEQ,
    BNE,
    BLT,
    BGE,
    BLTU,
    BGEU,
    LB,
    LH,
    LW,
    LBU,
    LHU,
    SB,
    SH,
    SW,
    ADDI,
    SLTI,
    SLTIU,
    XORI,
    ORI,
    ANDI,
    SLLI,
    SRLI,
    SRAI,
    ADD,
    SUB,
    SLL,
    SLT,
    SLTU,
    XOR,
    SRL,
    SRA,
    OR,
    AND,
    FENCE,
    FENCE_I,
    ECALL,
    EBREAK,
    CSRRW,
    CSRRS,
    CSRRC,
    CSRRWI,
    CSRRSI,
    CSRRCI
  } instr_kind_t;
endpackage

