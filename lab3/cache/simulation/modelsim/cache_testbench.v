
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
  #100 $stop;
end


initial begin
// TEST WRITING - WREN DISABLED
@( posedge clk );			// 5ns
@( posedge clk ) begin			// 15ns
  wren = 1'b0;
  wroffset = 5'd1;
  data = 8'd22;
end

// TEST WRITING - WREN ENABLED
@( posedge clk );			// 25ns
@( posedge clk ) begin			// 35ns
  wren = 1'b1;
  wroffset = 5'd2;
  data = 8'd25;
end

// TEST READING
@( posedge clk );			// 45ns
@( posedge clk ) begin			// 55ns
  rdoffset = 5'd2;
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
