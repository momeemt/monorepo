module memory (
  input logic clk,
  input logic we,
  input logic [31:0] addr,
  input logic [31:0] wdata,
  output logic [31:0] rdata
);

altsyncram #(
  .operation_mode("SINGLE_PORT"),
  .width_a(32),
  .widthad_a(8),
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
  .wren_a(we),
  .address_a(addr[7:0]),
  .data_a(wdata),
  .q_a(rdata)
);

endmodule
