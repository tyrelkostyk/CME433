module tbench_top (clk);

output reg clk;

wire [31:0] A, B, S;
wire P, G;
wire Cin, Cout;

initial begin
clk = 1'b0;
forever #5 clk = ~clk;
end

// instantiate testbench
cla_adder_testbench test (
	.clk(clk),
	.A(A),
	.B(B),
	.S(S),
	.P(P),
	.G(G),
	.Cin(Cin),
	.Cout(Cout)
);


// instantiate DUT
thirty_two_bit_cla cla (
	.A(A),				// in
	.B(B),				// in
	.S(S),				// out
	.P(P),				// out
	.G(G),				// out
	.Cin(Cin),		// in
	.Cout(Cout)		// out
);


endmodule
