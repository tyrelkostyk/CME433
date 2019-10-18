module four_bit_cla (A, B, Cin, S, P, G, Cout);

input [3:0] A, B;		// inputs to add; sent to 1 bit adders
input Cin;					// carry in to be propagated

output Cout;
output G, P;				// 1 bit outputs after propagation
output [3:0] S;			// outputs from 1 bit adders + propagation

wire [3:1] c;				// internal carry bits
wire [3:0] g, p;		// internal propogation signals


// instantiate 1 bit cla adders
one_bit_cla cla0 (
	.A(A[0]),
	.B(B[0]),
	.Cin(Cin),
	.S(S[0]),
	.P(p[0]),
	.G(g[0])
);

assign c[1] = g[0] | ( p[0] & Cin );

one_bit_cla cla1 (
	.A(A[1]),
	.B(B[1]),
	.Cin(c[1]),
	.S(S[1]),
	.P(p[1]),
	.G(g[1])
);

// assign c[2] = g[1] | ( p[1] & c[1] );
assign c[2] = g[1] | ( p[1] & ( g[0] | ( p[0] & Cin ) ) );

one_bit_cla cla2 (
	.A(A[2]),
	.B(B[2]),
	.Cin(c[2]),
	.S(S[2]),
	.P(p[2]),
	.G(g[2])
);

// assign c[3] = g[2] | ( p[2] & c[2] );
assign c[3] = g[2] | ( p[2] & ( g[1] | ( p[1] & ( g[0] | ( p[0] & Cin ) ) ) ) );

one_bit_cla cla3 (
	.A(A[3]),
	.B(B[3]),
	.Cin(c[3]),
	.S(S[3]),
	.P(p[3]),
	.G(g[3])
);

// assign Cout = g[3] | ( p[3] & c[3] );
assign Cout = g[3] | ( p[3] & ( g[2] | ( p[2] & ( g[1] | ( p[1] & ( g[0] | ( p[0] & Cin ) ) ) ) ) ) );

assign P = p[3];
assign G = g[3];

endmodule
