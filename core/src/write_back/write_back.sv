module write_back (
    input logic clk,
    input logic rst,
    input logic valid_input,
    input instr_kind_t instr_kind,
    input logic write_register,
    input logic [OPERAND_WIDTH-1:0] new_register_value,
    input logic [REGISTER_DESCRIPTOR_WIDTH-1:0] rd_addr,
    output logic stall_output
);
endmodule

