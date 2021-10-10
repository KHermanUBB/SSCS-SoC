	CC = iverilog 

	FLAGS =	-Wall -Winfloop 

	library_input: optFIR.v testbench.v

	$(CC)	$(FLAGS) 	-o	FilterTest	optFIR.v	testbench.v

	vvp FilterTest
	gtkwave dump.vcd 
