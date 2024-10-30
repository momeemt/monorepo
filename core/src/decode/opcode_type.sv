package opcode_type;
  typedef struct {
    logic is_lui;
    logic is_auipc;
    logic is_jal;
    logic is_jalr;
    logic is_branch_type;
    logic is_load_type;
    logic is_store_type;
    logic is_imm_arith_type;
    logic is_reg_arith_type;
    logic is_fence_type;
    logic is_system_type;
  } opcode_t;
endpackage;

