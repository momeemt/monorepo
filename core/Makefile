SRCS_DIR := src
TEST_DIR := test
PACKAGES_DIR := packages

SRCS := $(wildcard $(SRCS_DIR)/**/*.sv)
PACKAGE_FILES := $(shell find $(PACKAGES_DIR) -name "*.sv")
PACKAGE_FLAGS := $(addprefix -L ,$(PACKAGES_DIR))
TESTS := $(shell find $(TEST_DIR) -name "*.sv")

.PHONY: build
build:
	quartus_sh --flow compile kakacpu

.PHONY: run
run: build
	quartus_pgm -m jtag -o "p;output_files/kakacpu.sof"

.PHONY: test
test: $(TESTS)

$(TEST_DIR)/%.sv: compile_packages compile_srcs
	vlog $@
	vsim -c work.$(basename $(@F)) -do "run -all; quit"

.PHONY: compile_packages
compile_packages: $(PACKAGE_FILES)
	vlog $(PACKAGE_FILES)

.PHONY: compile_srcs
compile_srcs: $(SRCS)
	vlog $(SRCS)

.PHONY: clean
clean:
	rm -rf work transcript
