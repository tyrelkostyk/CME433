module program_sequencer(
	input clk, sync_reset, jmp, jmp_nz, dont_jmp,
	input NOPC8, NOPCF, NOPD8, NOPDF,	// inputs; will probably need in exam
	input [3:0] jmp_addr,
	output reg [7:0] pm_addr,
	output reg [7:0] pc,						// made output for final exam (instead of internal)
	output reg [7:0] from_PS,				// made specifically for final exam scrambler
	output reg run			// CME 433 Lab 4
	);


//// CME 433 LAB 4 CHANGES START ////
reg [1:0] pc_count;

always @ ( posedge clk )
if ( sync_reset == 1'b1 )
	pc_count = 2'd0;
else
	pc_count = pc_count + 2'd1;

always @ *
if ( pc_count == 2'd2 )
	run = 1'b1;
else
	run = 1'b0;

//// CME 433 LAB 4 CHANGES END ////

always @ *
//from_PS = 8'h0;  // in exam
from_PS = pc;		// testing prior to exam

always @ (posedge clk)
pc <= pm_addr;

always @ *
if (sync_reset == 1'b1) 
	pm_addr = 8'd0;
else if ( pc_count != 2'd3 )
	pm_addr = pc;
else if (jmp == 1'b1) 
	pm_addr = {jmp_addr, 4'd0};
else if ((jmp_nz == 1'b1) && (dont_jmp == 1'b0)) 
	pm_addr = {jmp_addr, 4'd0};
else 
	pm_addr = pc + 8'd1;

endmodule
