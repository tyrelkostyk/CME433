module comb_logic(
(*keep*)input [7:0] data,
(*keep*)output [7:0] data_out
);

parameter size = 21;
genvar i;
(*keep*) wire [7:0] data_internal[size];

generate
for(i = 0; i < size-1; i = i + 1)
begin : b1
	assign data_internal[i] = ~data_internal[i+1];
end
endgenerate

assign data_out = ~data_internal[0];
	
assign data_internal[size - 1] = ~data;


endmodule