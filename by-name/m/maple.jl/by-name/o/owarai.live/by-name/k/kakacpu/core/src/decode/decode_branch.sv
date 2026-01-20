import instr_type::*;

// The `decode_branch` module receives three bits funct3.
// It outputs and instr kind, but it can only process RV32I instructions.
module decode_branch (
    input logic rst,
    input logic [2:0] funct3,
    output branch_kind_t kind
);
  always_comb begin
    if (~rst) begin
      kind = bk_invalid;
    end else begin
      kind = bk_invalid;
      case (funct3)
        3'b000:  kind = bk_beq;
        3'b001:  kind = bk_bne;
        3'b100:  kind = bk_blt;
        3'b101:  kind = bk_bge;
        3'b110:  kind = bk_bltu;
        3'b111:  kind = bk_bgeu;
        default: ;
      endcase
    end
  end
endmodule
