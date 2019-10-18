module tbench_top (clk);

output reg clk;

wire [31:0] A, B, S;
wire Cin, Cout;

initial begin
clk = 1'b0;
forever #5 clk = ~clk;
end

// instantiate testbench
ripple_carry_adder_testbench test (
	.clk(clk),
	.A(A),
	.B(B),
	.S(S),
	.Cin(Cin),
	.Cout(Cout)
);


// instantiate DUT
ripple_carry_adder rpc (
	.A(A),
	.B(B),
	.S(S),
	.Cin(Cin),
	.Cout(Cout)
);


endmodule
