.PHONY: build
build:
	quartus_sh --flow compile kakacpu

.PHONY: run
run: build
	quartus_pgm -m jtag -o "p;output_files/kakacpu.sof"

.PHONY: test
test:
	vlog src/decode/opcode_type.sv src/decode/opcode.sv src/decode/test_bench/opcode_tb.sv
	vlog src/decode/opcode_type.sv src/decode/r_type.sv src/decode/test_bench/r_type_tb.sv
	vlog src/decode/opcode_type.sv src/decode/imm_arith_type.sv src/decode/test_bench/imm_arith_type_tb.sv
	vsim -c opcode_tb -do "run -all; quit"
	vsim -c r_type_tb -do "run -all; quit"
	vsim -c imm_arith_type_tb -do "run -all; quit"

.PHONY: test_register_file
test_register_file:
	vlog src/register_file/register_params.sv \
			 src/register_file/register_cell.sv \
			 src/register_file/test_bench/register_cell_tb.sv
	vsim -c register_cell_tb -do "run -all; quit"
	
	vlog src/register_file/register_params.sv \
			 src/register_file/register_cell.sv \
			 src/register_file/global_register.sv \
			 src/register_file/test_bench/global_register_tb.sv
	vsim -c global_register_tb -do "run -all; quit"
