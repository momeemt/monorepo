import instr_type::*;

// The `decode_reg_arith` module receives three bits funct3 and seven bits funct7.
// It outputs an instr kind, but it can only process RV32I instructions.
module decode_reg_arith (
    input logic clk,
    input logic rst,
    input logic [2:0] funct3,
    input logic [6:0] funct7,
    output reg_arith_kind_t kind
);
  always @(posedge clk or negedge rst) begin
    if (~rst) begin
      kind <= rak_invalid;
    end else begin
      kind <= rak_invalid;
      case (funct3)
        3'b000: begin
          case (funct7)
            7'b0000000: kind <= rak_add;
            7'b0100000: kind <= rak_sub;
            default: ;
          endcase
        end
        3'b001:  kind <= rak_sll;
        3'b010:  kind <= rak_slt;
        3'b011:  kind <= rak_sltu;
        3'b100:  kind <= rak_xor;
        3'b101: begin
          case (funct7)
            7'b0000000: kind <= rak_srl;
            7'b0100000: kind <= rak_sra;
            default: ;
          endcase
        end
        3'b110:  kind <= rak_or;
        3'b111:  kind <= rak_and;
        default: ;
      endcase
    end
  end
endmodule

