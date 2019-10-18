`timescale 1us/1us

module cla_adder_testbench (clk, S, P, G, Cout, A, B, Cin);

input clk, P, G, Cout;
input [31:0] S;

output reg Cin;
output reg [31:0] A, B;


initial begin
A = 32'd0;
B = 32'd10;
Cin = 1'b0;
end


initial
#550 $finish;

initial begin
	repeat (20) begin
		@( posedge clk );
		A = A + 1;
	end

	repeat (20) begin
		@( posedge clk );
		B = B + 1;
	end

	repeat (2) begin
		@( posedge clk );
	end

	@( posedge clk ) Cin = 1'b1;

	repeat (2) begin
		@( posedge clk );
	end

	@( posedge clk ) Cin = 1'b0;

	repeat (2) begin
		@( posedge clk );
	end

	// 4,294,967,295
	@( negedge clk ) B = 32'b0;
	@( posedge clk ) A = 32'b11111111111111111111111111111100;

	repeat (25) begin
		@( posedge clk );
		B = B + 1;
	end

end

endmodule
