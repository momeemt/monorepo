module kakacpu(
	input wire i0,
	input wire i1,
	output wire [1:0] q
);

	assign q[0] = i0;
	assign q[1] = i1;
endmodule
