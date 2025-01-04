module memory (
    input logic clk,
    input logic rst,
    input logic [31:0] addr,
    input logic write_enable,
    input logic [31:0] write_data,
    output logic [31:0] read_data
);
  altsyncram #(
      .operation_mode("SINGLE_PORT"),
      .width_a(32),
      .widthad_a(16),
      .numwords_a(256),
      .lpm_type("altsyncram"),
      .outdata_reg_a("UNREGISTERED"),
      .address_aclr_a("NONE"),
      .outdata_aclr_a("NONE"),
      .indata_aclr_a("NONE"),
      .wrcontrol_aclr_a("NONE"),
      .byte_size(8),
      .read_during_write_mode_mixed_ports("DONT_CARE"),
      .init_file("memory.mif")
  ) ram (
      .clock0(clk),
      .wren_a(write_enable),
      .address_a(addr),
      .data_a(write_data),
      .q_a(read_data)
  );
endmodule
