module kakacpu (
    input logic CLOCK_50,
	  input logic [3:0] KEY,
    input logic [0:0] SW,
    output logic [6:0] HEX0
);

logic [31:0] counter;
logic [3:0] digit;

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
        digit <= 0;
    end else begin
        counter <= counter + 1;
        if (counter == 50_000_000) begin
            counter <= 0;
            if (SW == 0 && digit == 9) begin
                digit <= 0;
            end else if (SW == 0) begin
                digit <= digit + 1;
            end else if (digit == 0) begin
                digit <= 9;
            end else begin
                digit <= digit - 1;
            end
        end
    end
end

assign HEX0 = digit_to_7seg(digit);

endmodule

