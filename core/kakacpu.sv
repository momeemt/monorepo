module kakacpu (
    input logic CLOCK_50,
	  input logic [3:0] KEY,
    output logic [7:0] LEDR
);

logic [31:0] counter;
logic [31:0] pipeline_data;
logic valid_input;

logic valid_output_stage1;
logic valid_output_stage2;
logic valid_output_stage3;

logic [31:0] data_output_stage1;
logic [31:0] data_output_stage2;
logic [31:0] data_output_stage3;

logic stall_input_stage1;
logic stall_output_stage1;
logic stall_input_stage2;
logic stall_output_stage2;
logic stall_input_stage3;
logic stall_output_stage3;

pipeline_stage stage1 (
    .clk(CLOCK_50),
    .rst(KEY[0]),
    .valid_input(valid_input),
    .valid_output(valid_output_stage1),
    .data_input(pipeline_data),
    .data_output(data_output_stage1),
    .stall_input(stall_input_stage1),
    .stall_output(stall_output_stage1)
);

pipeline_stage stage2 (
    .clk(CLOCK_50),
    .rst(KEY[0]),
    .valid_input(valid_output_stage1),
    .valid_output(valid_output_stage2),
    .data_input(data_output_stage1),
    .data_output(data_output_stage2),
    .stall_input(stall_input_stage2),
    .stall_output(stall_output_stage2)
);

pipeline_stage stage3 (
    .clk(CLOCK_50),
    .rst(KEY[0]),
    .valid_input(valid_output_stage2),
    .valid_output(valid_output_stage3),
    .data_input(data_output_stage2),
    .data_output(data_output_stage3),
    .stall_input(stall_input_stage3),
    .stall_output(stall_output_stage3)
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
        pipeline_data <= 0;
        valid_input <= 0;
    end else begin
        counter <= counter + 1;
        if (counter == 50_000_000) begin
            counter <= 0;
            pipeline_data <= pipeline_data + 1;
            valid_input <= 1;
        end else begin
            valid_input <= 0;
        end
    end
end

always_ff @(posedge CLOCK_50 or negedge KEY[0]) begin
  if (!KEY[0]) begin
    LEDR <= 8'b00000000;
  end else if (valid_output_stage3) begin
    LEDR <= data_output_stage3[7:0];
  end
end

endmodule

