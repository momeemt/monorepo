import instr_type::*;

// The `decode_system` module receives three bits funct3.
// It outputs and instr kind, but it can only process RV32I instructions.
module decode_system (
    input logic clk,
    input logic rst,
    input logic [2:0] funct3,
    input logic [10:0] ecall_ebreak_sel,
    output system_kind_t kind
);
  always @(posedge rst) begin
    kind <= sysk_invalid;
  end

  always @(posedge clk or negedge rst) begin
    kind <= sysk_invalid;

    case (funct3)
      3'b000: begin
        case (ecall_ebreak_sel)
          11'b00000000000: kind <= sysk_ecall;
          11'b00000000001: kind <= sysk_ebreak;
          default: ;
        endcase
      end
      3'b001:  kind <= sysk_csrrw;
      3'b010:  kind <= sysk_csrrs;
      3'b011:  kind <= sysk_csrrc;
      3'b101:  kind <= sysk_csrrwi;
      3'b110:  kind <= sysk_csrrsi;
      3'b111:  kind <= sysk_csrrci;
      default: ;
    endcase
  end
endmodule
