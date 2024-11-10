import instr_type::*;

// The `fence_type` module receives three bits funct3.
// It outputs and instr kind, but it can only process RV32I instructions.
module decode_fence (
    input logic rst,
    input logic [2:0] funct3,
    output fence_kind_t kind
);
  always_comb begin
    if (~rst) begin
      kind = fk_invalid;
    end else begin
      kind = fk_invalid;
      case (funct3)
        3'b000:  kind = fk_fence;
        3'b001:  kind = fk_fence_i;
        default: ;
      endcase
    end
  end
endmodule
