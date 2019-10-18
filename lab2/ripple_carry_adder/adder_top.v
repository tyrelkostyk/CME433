module adder_top (clk, A_in, B_in, S_out);

input clk;
input [31:0] A_in, B_in;

output reg [31:0] S_out;

reg [31:0] A, B;

wire [31:0] S;
wire Cin, Cout;


ripple_carry_adder rpc(
	.A(A),
	.B(B),
	.S(S),
	.Cin(Cin),
	.Cout(Cout)
);


always @( posedge clk )
begin
	A = A_in;
	B = B_in;
	S_out = S;
end


endmodule
