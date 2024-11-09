import instr_type::*;

// The `decode_store` module receives three bits funct3.
// It outputs and instr kind, but it can only process RV32I instructions.
module decode_store (
    input logic clk,
    input logic rst,
    input logic [2:0] funct3,
    output store_kind_t kind
);
  always @(posedge clk or negedge rst) begin
    if (~rst) begin
      kind <= sk_invalid;
    end else begin
      kind <= sk_invalid;
      case (funct3)
        3'b000:  kind <= sk_sb;
        3'b010:  kind <= sk_sh;
        3'b011:  kind <= sk_sw;
        default: ;
      endcase
    end
  end
endmodule
