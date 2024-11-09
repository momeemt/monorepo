import instr_type::*;

// The `decode_load` module receives three bits funct3.
// It outputs and instr kind, but it can only process RV32I instructions.
module decode_load (
    input logic clk,
    input logic rst,
    input logic [2:0] funct3,
    output load_kind_t kind
);
  always @(posedge clk or negedge rst) begin
    if (~rst) begin
      kind <= lk_invalid;
    end else begin
      kind <= lk_invalid;
      case (funct3)
        3'b000:  kind <= lk_lb;
        3'b001:  kind <= lk_lh;
        3'b010:  kind <= lk_lw;
        3'b100:  kind <= lk_lbu;
        3'b101:  kind <= lk_lhu;
        default: ;
      endcase
    end
  end
endmodule
