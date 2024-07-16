module decode(
  input logic clk,
  input logic rst,
  input logic valid_input, // if (valid_input == 1) valid
  output logic valid_output, // if (valid_output == 1) valid
  input logic stall_input, // if (stall_input == 1) stall
  output logic stall_output, // if (stall_output == 1) stall
  input logic [31:0] reg_file [0:31],
  input logic [31:0] instruction,
  output logic [31:0] rs1_data,
  output logic [31:0] rs2_data,
  output logic [31:0] immidiate_data,
  output logic [3:0] inst_type
);
  logic valid_register;

  assign valid_output = valid_register;
  assign stall_output = (valid_register & stall_input);

  localparam ADD_INDEX = 0;
  localparam BEQ_INDEX = 1;
  localparam LW_INDEX = 2;
  localparam SW_INDEX = 3;

  logic [4:0] rs1, rs2, rd;
  logic [6:0] funct7, opcode;
  logic [2:0] funct3;

  always @(posedge clk or negedge rst) begin
    if (~rst) begin
      valid_register <= 0;
    end else if (~stall_input) begin
      valid_register <= valid_input;
    end

    opcode = instruction[6:0];
    rd = instruction[11:7];
    funct3 = instruction[14:12];
    rs1 = instruction[19:15];
    rs2 = instruction[24:20];
    funct7 = instruction[31:25];
    inst_type = 4'b0;

    case (opcode)
      7'b0110011: begin
        case (funct3)
          3'b000: begin
            if (funct7 == 7'b0000000) begin
              inst_type[ADD_INDEX] <= 1'b1;
            end
          end
        endcase
      end

      7'b1100011: begin
        case (funct3)
          3'b000: inst_type[BEQ_INDEX] <= 1'b1;
        endcase
      end

      7'b0000011: inst_type[LW_INDEX] <= 1'b1;
      7'b0100011: inst_type[SW_INDEX] <= 1'b1;
    endcase

    case (opcode)
      7'b00000111, 7'b0010011:
        immidiate_data <= {{20{instruction[31]}}, instruction[31:20]};
      7'b0100011:
        immidiate_data <= {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
      7'b1100011:
        immidiate_data <= {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
      default:
        immidiate_data <= 32'b0;
    endcase

    rs1_data <= reg_file[rs1];
    rs2_data <= reg_file[rs2];
  end
endmodule
