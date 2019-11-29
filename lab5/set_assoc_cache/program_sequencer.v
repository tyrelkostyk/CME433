module program_sequencer(
	input clk, sync_reset, jmp, jmp_nz, dont_jmp,
	input NOPC8, NOPCF, NOPD8, NOPDF,		// inputs; will probably need in exam
	input [3:0] jmp_addr,
//	output reg [7:0] pm_addr,									// CME 433 Lab 4 (just an internal signal now, not output)
	output reg [7:0] rom_address,								// CME 433 Lab 4 (replaces pm_addr output)
	output reg [7:0] pc,							// made output for final exam (instead of internal)
	output reg [7:0] from_PS,					// made specifically for final exam scrambler
	output reg hold_out, start_hold, end_hold, hold,	// CME 433 Lab 3
	output reg [2:0] hold_count,								// CME 433 Lab 3
	output reg [2:0] cache_wroffset, cache_rdoffset,	// CME 433 Lab 5
	output reg cache_wren,										// CME 433 Lab 4
	output reg [0:0] cache_wrline, cache_rdline,					// CME 433 Lab 5
	output reg cache_wrentry, cache_rdentry				// CME 433 Lab 5
	);



//// BEGIN CHANGES FROM CME 433 LAB 3 ////
//reg start_hold, end_hold, hold;			made output
//reg [7:0] hold_count; 						made output

always @ *
//if ( pc[7:5] != pm_addr[7:5] )		// CME 433 Lab 5
//	start_hold = 1'b1;					// CME 433 Lab 5
if ( tagID[pm_addr[3]][currentry] != pm_addr[7:4] )	// CME 433 Lab 5
	start_hold = 1'b1;									// CME 433 Lab 5
else if ( ( valid[pm_addr[3]][currentry] == 1'b0 ) && ( hold == 1'b0 ) )	// CME 433 Lab 5
	start_hold = 1'b1;															// CME 433 Lab 5
else if ( reset_1shot == 1'b1 )		// CME 433 Lab 4
	start_hold = 1'b1;					// CME 433 Lab 4
else
	start_hold = 1'b0;

always @ ( posedge clk )
//if ( sync_reset == 1'b1 )			// CME 433 Lab 4 
if ( reset_1shot == 1'b1 ) 			// CME 433 Lab 4
	hold_count = 3'd0;
else if ( end_hold == 1'b1 )
	hold_count = 1'b0;
else if ( hold == 1'b1 )
	hold_count = hold_count + 3'd1;
else
	hold_count = hold_count;

always @ *
if ( ( hold_count >= 3'd7 ) && ( hold == 1'b1 ) )	// CME 433 Lab 5 (7 from 31)
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
else
	reset_1shot = 1'b0;


always @ *
cache_wroffset = hold_count;

// CME 433 Lab 5
//always @ *
//cache_rdoffset = pm_addr[4:0];

always @ *
cache_wren = hold;

always @ *
if ( reset_1shot == 1'b1 )
	rom_address = 8'd0;
else if ( start_hold == 1'b1 )
	rom_address = {pm_addr[7:3],3'd0};
else if ( sync_reset == 1'b1 )
	rom_address = {5'd0,hold_count+3'd1};
else
	rom_address = {tagID[pc[3]][~last_used[pc[3]]],pc[3],hold_count+3'd1};	// CME 433 LAB 5

////  END CHANGES FROM CME 433 LAB 4  ////


//// BEGIN CHANGES FROM CME 433 LAB 5 ////

reg [3:0] tagID [0:1][0:1];
reg 		 valid [0:1][0:1];

always @ ( posedge clk )
if ( reset_1shot == 1'b1 ) begin
	tagID[0][0] <= 4'd0;
	tagID[0][1] <= 4'd0;
	tagID[1][0] <= 4'd0;
	tagID[1][1] <= 4'd0;
	end
else if ( start_hold == 1'b1 )
	tagID[pm_addr[3]][~last_used[pm_addr[3]]] <= pm_addr[7:4];
else begin
	tagID[0][0] <= tagID[0][0];
	tagID[0][1] <= tagID[0][1];
	tagID[1][0] <= tagID[1][0];
	tagID[1][1] <= tagID[1][1];
	end


always @ ( posedge clk )
if ( reset_1shot == 1'b1 ) begin
	valid[0][0] <= 1'b0;
	valid[0][1] <= 1'b0;
	valid[1][0] <= 1'b0;
	valid[1][1] <= 1'b0;
	end
else if ( end_hold == 1'b1 )
	valid[pm_addr[3]][~last_used[pm_addr[3]]] <= 1'b1;
else begin
	valid[0][0] = valid[0][0];
	valid[0][1] = valid[0][1];
	valid[1][0] = valid[1][0];
	valid[1][1] = valid[1][1];
	end


(* keep *)reg currentry;
always @ *
if ( pm_addr[3] == 1'b0 )
	if ( tagID[0][0] == pm_addr[7:4] )
		currentry <= 1'b0;
	else
		currentry <= 1'b1;
else
	if ( tagID[1][0] == pm_addr[7:4] )
		currentry <= 1'b0;
	else
		currentry <= 1'b1;


// last used
(* noprune *)reg last_used[0:1];
always @ ( posedge clk )
if ( reset_1shot == 1'b1 )
	last_used[0] = 1'b1;
else if ( ( pm_addr[3] == 1'b0 ) && ( hold == 1'b0 ) && ( start_hold == 1'b0 ) )
	last_used[0] = currentry;
else if ( ( pm_addr[3] == 1'b0 ) && ( end_hold == 1'b1 ) )
	last_used[0] <= ~last_used[0];
else
	last_used[0] <= last_used[0];

always @ ( posedge clk )
if( reset_1shot == 1'b1 )
	last_used[1] <= 1'b1;
else if( pm_addr[3] == 1'b1 && hold == 1'b0 && start_hold == 1'b0 )
	last_used[1] <= currentry;
else if( pm_addr[3] == 1'b1 && end_hold == 1'b1 )
	last_used[1] <= ~last_used[1];
else
	last_used[1] <= last_used[1];


always @ *
cache_wrline = pc[3:3];

always @ *
cache_rdline = pm_addr[3:3];		// [3:3] ??

always @ *
cache_rdoffset = pm_addr[2:0];

always @ *
cache_rdentry = currentry;

always @ *
cache_wrentry = ~last_used[pm_addr[3]];

////  END CHANGES FROM CME 433 LAB 5  ////


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
