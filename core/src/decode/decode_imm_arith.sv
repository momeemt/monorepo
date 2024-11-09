import instr_type::*;

// The `decode_imm_arith` module receives three bits func3.
// It outputs and instr kind, but it can only process RV32I instructions.
module decode_imm_arith (
    input logic clk,
    input logic rst,
    input logic [2:0] funct3,
    input logic [6:0] funct7,
    output imm_arith_kind_t kind
);
  always @(posedge rst) begin
    kind <= iak_invalid;
  end

  always @(posedge clk or negedge rst) begin
    kind <= iak_invalid;

    case (funct3)
      3'b000:  kind <= iak_addi;
      3'b001: begin
        case (funct7)
          7'b0000000: kind <= iak_slli;
          default: ;
        endcase
      end
      3'b010:  kind <= iak_slti;
      3'b011:  kind <= iak_sltiu;
      3'b100:  kind <= iak_xori;
      3'b101: begin
        case (funct7)
          7'b0000000: kind <= iak_srli;
          7'b0100000: kind <= iak_srai;
          default: ;
        endcase
      end
      3'b110:  kind <= iak_ori;
      3'b111:  kind <= iak_andi;
      default: ;
    endcase
  end
endmodule
