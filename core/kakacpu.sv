module kakacpu (
    input logic CLOCK_50,
	  input logic [3:0] KEY,
    output logic [7:0] LEDR
);

logic [31:0] counter;
logic [31:0] pipeline_data;
logic valid_input;
logic if_valid_output;
logic [31:0] if_data_output;
logic stall_input;
logic stall_output;

logic branch_input;
logic [31:0] branch_dest_address;

logic [31:0] instruction_address;
logic [31:0] instruction_data;

instruction_fetch fetch (
  .clk(CLOCK_50),
  .rst(KEY[0]),
  .valid_input(valid_input),
  .valid_output(if_valid_output),
  .data_output(if_data_output),
  .branch_input(branch_input),
  .branch_dest_address(branch_dest_address),
  .stall_input(stall_input),
  .pc(instruction_address),
  .fetched_instruction(instruction_data)
);

memory mem(
  .clk(CLOCK_50),
  .we(1'b0),
  .addr(instruction_address),
  .wdata(32'b0),
  .rdata(instruction_data)
);

function [6:0] digit_to_7seg;
  input [3:0] digit;
  case (digit)
    4'd0: digit_to_7seg = 7'b1000000;
    4'd1: digit_to_7seg = 7'b1111001;
    4'd2: digit_to_7seg = 7'b0100100;
    4'd3: digit_to_7seg = 7'b0110000;
    4'd4: digit_to_7seg = 7'b0011001;
    4'd5: digit_to_7seg = 7'b0010010;
    4'd6: digit_to_7seg = 7'b0000010;
    4'd7: digit_to_7seg = 7'b1111000;
    4'd8: digit_to_7seg = 7'b0000000;
    4'd9: digit_to_7seg = 7'b0010000;
    default: digit_to_7seg = 7'b1111111;
  endcase
endfunction

always_ff @(posedge CLOCK_50 or negedge KEY[0]) begin
    if (!KEY[0]) begin
        counter <= 0;
        valid_input <= 0;
    end else begin
        counter <= counter + 1;
        if (counter == 50_000_000) begin
            counter <= 0;
            valid_input <= 1;
        end else begin
            valid_input <= 0;
        end
    end
end

always_ff @(posedge CLOCK_50 or negedge KEY[0]) begin
  if (!KEY[0]) begin
    LEDR <= 8'b00000000;
  end else if (if_valid_output) begin
    LEDR <= if_data_output[7:0];
  end
end

endmodule

