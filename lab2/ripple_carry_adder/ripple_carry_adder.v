module ripple_carry_adder (A, B, Cin, Cout, S);

input [31:0] A, B;
input Cin;

output [31:0] S;
output Cout;

wire [30:0] C;


one_bit_rpc_adder adder0(
	.A(A[0]),
	.B(B[0]),
	.Cin(Cin),
	.Cout(C[0]),
	.S(S[0])
);


genvar i;
generate
	for ( i=0; i<30; i=i+1 ) begin : gen_block_id
		one_bit_rpc_adder adder(
			.A(A[i+1]),
			.B(B[i+1]),
			.Cin(C[i]),
			.Cout(C[i+1]),
			.S(S[i+1])
		);
	end
endgenerate


one_bit_rpc_adder adder31(
	.A(A[31]),
	.B(B[31]),
	.Cin(C[30]),
	.Cout(Cout),
	.S(S[31])
);


endmodule
