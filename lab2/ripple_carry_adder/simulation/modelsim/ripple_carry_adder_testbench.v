
`timescale 1us / 1us

module ripple_carry_adder_testbench(clk, A, B, S);

output reg clk;
input [31:0] S;

output reg [31:0] A, B;

wire Cin, Cout;

initial begin
clk = 1'b0;
A = 32'b0;
B = 32'b10;
end

initial begin
forever #5 clk = ~clk;
end

initial
#250 $finish;


always @( posedge clk )
begin
	A = A + 1;
end


ripple_carry_adder rpc(
	.A(A),
	.B(B),
	.S(S),
	.Cin(Cin),
	.Cout(Cout)
);


endmodule
