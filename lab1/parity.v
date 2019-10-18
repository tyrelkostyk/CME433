module parity( D, F_conv, F_davio );

input [6:0] D;
output F_conv, F_davio;

parity_conventional conv (
	D,
	F_conv
);

parity_davio_template davio (
	D,
	F_davio
);

endmodule
