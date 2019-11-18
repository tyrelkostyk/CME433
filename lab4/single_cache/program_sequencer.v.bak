module program_sequencer(
	input clk, sync_reset, jmp, jmp_nz, dont_jmp,
	input NOPC8, NOPCF, NOPD8, NOPDF,		// inputs; will probably need in exam
	input [3:0] jmp_addr,
	output reg [7:0] pm_addr,
	output reg [7:0] pc,							// made output for final exam (instead of internal)
	output reg [7:0] from_PS,					// made specifically for final exam scrambler
	output reg hold_out, start_hold, end_hold, hold,
	output reg [4:0] hold_count
	);



//// BEGIN CHANGES FROM CME 433 LAB 3 ////
//reg start_hold, end_hold, hold;			made output
//reg [7:0] hold_count; 						made output

always @ *
if ( pc[7:5] != pm_addr[7:5] )
	start_hold = 1'b1;
else
	start_hold = 1'b0;

always @ ( posedge clk )
if ( sync_reset == 1'b1 ) 
	hold_count = 8'd0;
else if ( end_hold == 1'b1 )
	hold_count = 1'b0;
else if ( hold == 1'b1 )
	hold_count = hold_count + 8'd1;
else
	hold_count = hold_count;

always @ *
if ( ( hold_count >= 8'd31 ) && ( hold == 1'b1 ) )
	end_hold = 1'b1;
else
	end_hold = 1'b0;

always @ ( posedge clk )
if ( sync_reset == 1'b1 ) 
	hold = 1'b0;
else if ( start_hold == 1'b1 )
	hold = 1'b1;
else if ( end_hold == 1'b1 )
	hold = 1'b0;
else
	hold = hold;

always @ *
if ( ( ( start_hold == 1'b1 ) || ( hold == 1'b1 ) ) && ( end_hold != 1'b1 ) )
	hold_out = 1'b1;
else
	hold_out = 1'b0;

//// END CHANGES FROM CME 433 LAB 3 ////


always @ *
//from_PS = 8'h0;  // in exam
from_PS = pc;		// testing prior to exam

always @ (posedge clk)
if ( hold == 1'b1 )				// CME 433
	pc = pc;
else
	pc = pm_addr;

always @ *
if (sync_reset == 1'b1) 
	pm_addr = 8'd0;
else if ( hold == 1'b1 )
	pm_addr = pc; 
else if (jmp == 1'b1) 
	pm_addr = {jmp_addr, 4'd0};
else if ((jmp_nz == 1'b1) && (dont_jmp == 1'b0)) 
	pm_addr = {jmp_addr, 4'd0};
else 
	pm_addr = pc + 8'd1;

endmodule
