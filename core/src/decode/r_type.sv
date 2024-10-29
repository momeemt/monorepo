// The `r_type` module receives three bits funct3 and seven bits funct7.
// It outputs an instr kind, but it can only process RV32I instructions.
module r_type (
    input logic clk,
    input logic rst,
    input logic [2:0] funct3,
    input logic [6:0] funct7,
    output logic is_add,
    output logic is_sub,
    output logic is_sll,
    output logic is_slt,
    output logic is_sltu,
    output logic is_xor,
    output logic is_srl,
    output logic is_sra,
    output logic is_or,
    output logic is_and
);
  always @(posedge rst) begin
    is_add  <= 0;
    is_sub  <= 0;
    is_sll  <= 0;
    is_slt  <= 0;
    is_sltu <= 0;
    is_xor  <= 0;
    is_srl  <= 0;
    is_sra  <= 0;
    is_or   <= 0;
    is_and  <= 0;
  end

  always @(posedge clk or negedge rst) begin
    is_add  <= 0;
    is_sub  <= 0;
    is_sll  <= 0;
    is_slt  <= 0;
    is_sltu <= 0;
    is_xor  <= 0;
    is_srl  <= 0;
    is_sra  <= 0;
    is_or   <= 0;
    is_and  <= 0;

    case (funct3)
      3'b000: begin
        is_add <= (funct7 == 7'b0000000);
        is_sub <= (funct7 == 7'b0100000);
      end
      3'b001:  is_sll <= 1;
      3'b010:  is_slt <= 1;
      3'b011:  is_sltu <= 1;
      3'b100:  is_xor <= 1;
      3'b101: begin
        is_srl <= (funct7 == 7'b0000000);
        is_sra <= (funct7 == 7'b0100000);
      end
      3'b110:  is_or <= 1;
      3'b111:  is_and <= 1;
      default: ;
    endcase
  end
endmodule

