module program_sequencer(
	input clk, sync_reset, jmp, jmp_nz, dont_jmp,
	input NOPC8, NOPCF, NOPD8, NOPDF,		// inputs; will probably need in exam
	input [3:0] jmp_addr,
//	output reg [7:0] pm_addr,									// CME 433 Lab 4 (just an internal signal now, not output)
	output reg [7:0] rom_address,								// CME 433 Lab 4 (replaces pm_addr output)
	output reg [7:0] pc,							// made output for final exam (instead of internal)
	output reg [7:0] from_PS,					// made specifically for final exam scrambler
	output reg hold_out, start_hold, end_hold, hold,	// CME 433 Lab 3
	output reg [4:0] hold_count								// CME 433 Lab 3
	output reg [4:0] cache_wroffset, cache_rdoffset,	// CME 433 Lab 4
	output reg cache_wren										// CME 433 Lab 4
	);



//// BEGIN CHANGES FROM CME 433 LAB 3 ////
//reg start_hold, end_hold, hold;			made output
//reg [7:0] hold_count; 						made output

always @ *
if ( pc[7:5] != pm_addr[7:5] )
	start_hold = 1'b1;
else if ( reset_1shot == 1'b1 )		// CME 433 Lab 4
	start_hold = 1'b1;					// CME 433 Lab 4
else
	start_hold = 1'b0;

always @ ( posedge clk )
//if ( sync_reset == 1'b1 )			// CME 433 Lab 4 
if ( reset_1shot == 1'b1 ) 			// CME 433 Lab 4
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
//if ( sync_reset == 1'b1 )			// CME 433 Lab 4
//	hold = 1'b0;							// CME 433 Lab 4
//else if ( start_hold == 1'b1 )		// CME 433 Lab 4
if ( start_hold == 1'b1 )				// CME 433 Lab 4
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

////  END CHANGES FROM CME 433 LAB 3  ////


//// BEGIN CHANGES FROM CME 433 LAB 4 ////
reg [7:0] pm_addr;						// (used to be an output)
reg sync_reset_1, reset_1shot;

always @ ( posedge clk )
sync_reset_1 = sync_reset;

always @ *
if ( ( sync_reset_1 == 1'b0 ) && ( sync_reset == 1'b1 ) )
	reset_1shot = 1'b1;

always @ *
cache_wroffset = hold_count;

always @ *
cache_rdoffset = pm_address[4:0];

always @ *
cache_wren = hold;

always @ *
if ( reset_1shot == 1'b1 )
	rom_address = 8'd0;
else if ( start_hold == 1'b1 )
	rom_address = {pm_addr[7:5],5'd0};
else if ( sync_reset == 1'b1 )
	rom_address = {3'd0,hold_count+5'd1};
else
	rom_address = {pc[7:5],hold_count+5'd1};

////  END CHANGES FROM CME 433 LAB 4  ////


always @ *
//from_PS = 8'h0;  // in exam
from_PS = pc;		// testing prior to exam

always @ (posedge clk)
if ( hold == 1'b1 )				// CME 433 Lab 3
	pc = pc;							// CME 433 Lab 3
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
