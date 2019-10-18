module thirty_two_bit_cla (A, B, Cin, P, G, S, Cout);

input [31:0] A, B;
input Cin;

output [31:0] S;
output Cout, P, G;

// TODO: remove internal C lines, and just use Cout's from 4-bit adder
// and only need P, G from final 4bit adder

wire [7:1] c;				// internal carry bits

// instantiate 4 bit cla adders
four_bit_cla cla0 (
	.A(A[3:0]),
	.B(B[3:0]),
	.Cin(Cin),
	.S(S[3:0]),
	.Cout(c[1])
);

// assign c[1] = g[0] | ( p[0] & Cin );

four_bit_cla cla1 (
	.A(A[7:4]),
	.B(B[7:4]),
	.Cin(c[1]),	// Cin instead??
	.S(S[7:4]),
	.Cout(c[2])
);

// assign c[2] = g[1] | ( p[1] & c[1] );
// assign c[2] = g[1] | ( p[1] & ( g[0] | ( p[0] & Cin ) ) );

four_bit_cla cla2 (
	.A(A[11:8]),
	.B(B[11:8]),
	.Cin(c[2]),
	.S(S[11:8]),
	.Cout(c[3])
);

// assign c[3] = g[2] | ( p[2] & c[2] );
// assign c[3] = g[2] | ( p[2] & ( g[1] | ( p[1] & ( g[0] | ( p[0] & Cin ) ) ) ) );

four_bit_cla cla3 (
	.A(A[15:12]),
	.B(B[15:12]),
	.Cin(c[3]),
	.S(S[15:12]),
	.Cout(c[4])
);

// assign c[4] = g[3] | ( p[3] & c[3] );
// assign Cout = g[3] | ( p[3] & ( g[2] | ( p[2] & ( g[1] | ( p[1] & ( g[0] | ( p[0] & Cin ) ) ) ) ) ) );

four_bit_cla cla4 (
	.A(A[19:16]),
	.B(B[19:16]),
	.Cin(c[4]),
	.S(S[19:16]),
	.Cout(c[5])
);

// assign c[5] = g[4] | ( p[4] & c[4] );

four_bit_cla cla5 (
	.A(A[23:20]),
	.B(B[23:20]),
	.Cin(c[5]),
	.S(S[23:20]),
	.Cout(c[6])
);

// assign c[6] = g[5] | ( p[5] & c[5] );

four_bit_cla cla6 (
	.A(A[27:24]),
	.B(B[27:24]),
	.Cin(c[6]),
	.S(S[27:24]),
	.Cout(c[7])
);

// assign c[7] = g[6] | ( p[6] & c[6] );

four_bit_cla cla7 (
	.A(A[31:28]),
	.B(B[31:28]),
	.Cin(c[7]),
	.S(S[31:28]),
	.Cout(Cout),
	.P(P),
	.G(G)
);

// assign Cout = g[7] | ( p[7] & c[7] );

endmodule
