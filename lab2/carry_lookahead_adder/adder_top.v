module adder_top (clk, A_in, B_in, S_out);

input clk;
input [31:0] A_in, B_in;

output reg [31:0] S_out;

reg [31:0] A, B;

wire [31:0] S;
wire Cin, Cout;


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


always @( posedge clk )
begin
	A = A_in;
	B = B_in;
	S_out = S;
end


endmodule
