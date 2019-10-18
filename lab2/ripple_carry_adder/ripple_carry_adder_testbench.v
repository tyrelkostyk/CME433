`timescale 1us/1us

module ripple_carry_adder_testbench (clk, A, B, S, Cin, Cout);

input clk, Cout;
input [31:0] S;

output reg Cin;
output reg [31:0] A, B;


initial begin
A = 32'd0;
B = 32'd10;
Cin = 1'b0;
end


initial
#300 $finish;

initial begin
	repeat (10) begin
		@( posedge clk );
		A = A + 1;
	end

	repeat (10) begin
		@( posedge clk );
		B = B + 1;
	end

	// 4,294,967,295
	@( negedge clk ) B = 32'b0;
	@( posedge clk ) A = 32'b11111111111111111111111111111100;

	repeat (10) begin
		@( posedge clk );
		B = B + 1;
	end

end

endmodule
