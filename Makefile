RAPIDCHECK_SRCS=$(shell find rapidcheck/src -name '*.cpp')
RAPIDCHECK_INCLUDE=$(shell realpath rapidcheck/include)

obj_dir/byte_adder_test: byte_adder_test.cc byte_adder.sv
	verilator -Wall --cc --exe --build --CFLAGS -g --CFLAGS -I${RAPIDCHECK_INCLUDE} --top-module byte_adder ${RAPIDCHECK_SRCS} byte_adder_test.cc byte_adder.sv -o byte_adder_test && obj_dir/byte_adder_test 

.PHONY: test_byte_adder
test_byte_adder: obj_dir/byte_adder_test
	./obj_dir/byte_adder_test

.PHONY: clean
clean:
	rm -rf obj_dir/
