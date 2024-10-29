.PHONY: build
build:
	quartus_sh --flow compile kakacpu

.PHONY: run
run: build
	quartus_pgm -m jtag -o "p;output_files/kakacpu.sof"

.PHONY: test
test:
	vlog src/decode/opcode.sv src/decode/test_bench/opcode_tb.sv
	vlog src/decode/r_type.sv src/decode/test_bench/r_type_tb.sv
	vsim -c opcode_tb -do "run -all; quit"
	vsim -c r_type_tb -do "run -all; quit"
