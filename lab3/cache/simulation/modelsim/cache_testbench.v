
`timescale 1us/1ns

module cache_testbench();

// DUT (cache) inputs
reg clk;
reg [7:0] data;
reg [4:0] rdoffset, wroffset;
reg wren;

// DUT (cache) outputs
wire [7:0] q;

initial begin
  clk = 1'b0;
  data = 8'b0;
  rdoffset = 5'b0;
  wroffset = 5'b0;
  wren = 1'b0;
  forever #5 clk = ~clk;
end


initial begin
  #400 $stop;
end


initial begin
// TEST WRITING 22 TO PTR 2 - WREN DISABLED
@( posedge clk );			// 5us
@( posedge clk ) begin			// 15us
  wren = 1'b0;
  wroffset = 5'd2;
  data = 8'd22;
end

// TEST WRITING 25 TO PTR 2 - WREN ENABLED
@( posedge clk );			// 25us
@( posedge clk ) begin			// 35us
  wren = 1'b1;
  wroffset = 5'd2;
  data = 8'd25;
end

// TEST READING 25 FROM PTR 2
@( posedge clk );			// 45us
@( posedge clk ) begin			// 55us
  wren = 1'b0;
  rdoffset = 5'd2;
end

// TEST WRITING 10,15,20,... TO PTR 3,4,5,... - WREN ENABLED
@( posedge clk ) begin			// 65us
  wren = 1'b1;
  data = 8'd10;
  wroffset = 5'd3;
end
repeat(15) begin
  @( posedge clk );			// 75us,85us,...,215us
  data = data + 8'd5;
  wroffset = wroffset + 5'd1;
end

// TEST READING 10,15,20,... FROM PTR 3,4,5,...
@( posedge clk ) begin			// 225us
  wren = 1'b0;
  rdoffset = 5'd3;
end
repeat(15) begin
  @( posedge clk );			// 235us,245us,...,375us
  rdoffset = rdoffset + 5'd1;
end


end


cache dual_port_ram (
  .clk(clk),
  .data(data),
  .rdoffset(rdoffset),
  .wroffset(wroffset),
  .wren(wren),
  .q(q)
);

endmodule
