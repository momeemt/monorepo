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

  typedef enum logic [5:0] {
    Invalid = 6'd0,
    LUI = 6'd1,
    AUIPC = 6'd2,
    JAL = 6'd3,
    JALR = 6'd4,
    BEQ = 6'd5,
    BNE = 6'd6,
    BLT = 6'd7,
    BGE = 6'd8,
    BLTU = 6'd9,
    BGEU = 6'd10,
    LB = 6'd11,
    LH = 6'd12,
    LW = 6'd13,
    LBU = 6'd14,
    LHU = 6'd15,
    SB = 6'd16,
    SH = 6'd17,
    SW = 6'd18,
    ADDI = 6'd19,
    SLTI = 6'd20,
    SLTIU = 6'd21,
    XORI = 6'd22,
    ORI = 6'd23,
    ANDI = 6'd24,
    SLLI = 6'd25,
    SRLI = 6'd26,
    SRAI = 6'd27,
    ADD = 6'd28,
    SUB = 6'd29,
    SLL = 6'd30,
    SLT = 6'd31,
    SLTU = 6'd32,
    XOR = 6'd33,
    SRL = 6'd34,
    SRA = 6'd35,
    OR = 6'd36,
    AND = 6'd37,
    FENCE = 6'd38,
    FENCE_I = 6'd39,
    ECALL = 6'd40,
    EBREAK = 6'd41,
    CSRRW = 6'd42,
    CSRRS = 6'd43,
    CSRRC = 6'd44,
    CSRRWI = 6'd45,
    CSRRSI = 6'd46,
    CSRRCI = 6'd47
  } instr_kind_t;
endpackage

