module four_digits_segments (
    input logic clk,
    input logic rst,
    input logic enable,
    input integer value,
    output logic [6:0] HEX [4]
);
  function automatic logic [6:0] digit_to_7seg;
    input logic [3:0] digit;
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

  function automatic logic [3:0] get_decimal_digit;
    input logic [9:0] bits;
    input logic [1:0] digit;

    integer decimal_value;
    logic [3:0] tens;
    logic [3:0] unit;
    logic [3:0] hunds;
    logic [3:0] thous;
    begin
      decimal_value = bits;
      thous = (decimal_value / 1000) % 10;
      hunds = (decimal_value / 100) % 10;
      tens = (decimal_value / 10) % 10;
      unit = decimal_value % 10;

      case (digit)
        1: return unit;
        2: return tens;
        3: return hunds;
        4: return thous;
        default: return 4'b0000;
      endcase
    end
  endfunction

  always_ff @(posedge clk or negedge rst) begin
    if (~rst) begin
      HEX[0] <= 6'b0;
      HEX[1] <= 6'b0;
      HEX[2] <= 6'b0;
      HEX[3] <= 6'b0;
    end else if (enable) begin
      HEX[0] <= digit_to_7seg(get_decimal_digit(value, 1));
      HEX[1] <= digit_to_7seg(get_decimal_digit(value, 2));
      HEX[2] <= digit_to_7seg(get_decimal_digit(value, 3));
      HEX[3] <= digit_to_7seg(get_decimal_digit(value, 4));
    end
  end
endmodule
