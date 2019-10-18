module one_bit_rpc_adder (A, B, Cin, S, Cout);

input A, B, Cin;

output S, Cout;

wire xor1, and1, and2;

assign xor1 = ( A ^ B);
assign S = ( xor1 ^ Cin );

assign and1 = xor1 & Cin;
assign and2 = A & B;

assign Cout = and1 | and2;

endmodule
