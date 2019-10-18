module instruction_decoder(
	input [7:0] next_instr,
	input clk, sync_reset,
	output reg jmp, jmp_nz,
	output reg i_sel, y_sel, x_sel,
	output reg [3:0] source_sel,
	output reg [3:0] ir_nibble,
	output reg [8:0] reg_en
	);

reg [7:0] ir;

// loading the ir reg from the next instr (from the ROM's pm_addr)
always @ (posedge clk)
ir = next_instr;


// ir_nibble output
always @ *
ir_nibble = ir[3:0];



// logic for decoding instruction type (jmp or jmp_nz outputs)
//  jmp  //
always @ *
if (sync_reset == 1'b1) 
	// don't jump when reset
	jmp = 1'b0;
else if (ir[7:4] == 4'b1110)
	// unconditional jump;
	jmp = 1'b1;
else
	// else; don't jump
	jmp = 1'b0;

	
//  jmp_nz  //
always @ *
if (sync_reset == 1'b1)
	// don't jump when reset
	jmp_nz = 1'b0;
else if (ir[7:4] == 4'b1111)
	// conditional jump;
	jmp_nz = 1'b1;
else 
	// else; don't jump
	jmp_nz = 1'b0;


	
// logic for decoding source_sel ouput (bits 10-15 tied to GND)
//  source_sel  //
always @ *
if (sync_reset == 1'b1) source_sel = 4'd10;
else if (ir[7] == 1'b0)
	//	load; data_bus = ir_nibble 
	source_sel = 4'd8;
else if ( (ir[7:6] == 2'b10) && (ir[5:3] == ir[2:0]) && (ir[2:0] == 3'd4) )
	// mov; data_bus = r (moving to o_reg)
	source_sel = 4'd4;
else if ( (ir[7:6] == 2'b10) && (ir[5:3] == ir[2:0]) )
	// mov; data_bus = i_pins
	source_sel = 4'd9;
else if ( (ir[7:6] == 2'b10) )
	// mov; data_bus = src (0-7, data registers)
	source_sel = {1'b0, ir[2:0]};  // concat, to make 4-bit
else
	source_sel = {1'b0, ir[2:0]};



	
// logic for decoding i, x, y selects
//  i_sel  //
always @ *
if (sync_reset == 1'b1) i_sel = 1'b0;
else if ( (ir[7] == 1'b0) && (ir[6:4] == 3'd6) )
	// load; i is dst (from data_bus)
	i_sel = 1'b0;
else if ( (ir[7:6] == 2'b10) && (ir[5:3] == 3'd6) )
	// mov; i is dst
	i_sel = 1'b0;
else
	// else; increment i
	i_sel = 1'b1;

	
//  x_sel  //
always @ *
if (sync_reset == 1'b1) x_sel = 1'b0;
else if (ir[7:5] == 3'b110)
	// alu; assign proper x val
	x_sel = ir[4];
else
	// else; default to zero
	x_sel = 1'b0;

	
//  y_sel  //
always @ *
if (sync_reset == 1'b1) y_sel = 1'b0;
else if (ir[7:5] == 3'b110)
	// alu; assign proper y val
	y_sel = ir[3];
else
	// else; default to zero
	y_sel = 1'b0;

	

// logic for decoding register enables (9, each seperate 1bit outputs)
//  reg_en[0], x0  //
always @ *
if (sync_reset == 1'b1) 
	// enable all registers during reset, to clear them
	reg_en[0] = 1'b1;
else if (ir[7:4] == 4'd0)
	// load; x0 is dst
	reg_en[0] = 1'b1;
else if ( (ir[7:6] == 2'b10) && (ir[5:3] == 3'd0) )
	// mov; x0 is dst
	reg_en[0] = 1'b1;
else
	reg_en[0] = 1'b0;


//  reg_en[1], x1  //
always @ *
if (sync_reset == 1'b1) 
	// enable all registers during reset, to clear them
	reg_en[1] = 1'b1;
else if (ir[7:4] == 4'd1)
	// load; x1 is dst
	reg_en[1] = 1'b1;
else if ( (ir[7:6] == 2'b10) && (ir[5:3] == 3'd1) )
	// mov; x1 is dst
	reg_en[1] = 1'b1;
else
	reg_en[1] = 1'b0;


//  reg_en[2], y0  //
always @ *
if (sync_reset == 1'b1) 
	// enable all registers during reset, to clear them
	reg_en[2] = 1'b1;
else if (ir[7:4] == 4'd2)
	// load; y0 is dst
	reg_en[2] = 1'b1;
else if ( (ir[7:6] == 2'b10) && (ir[5:3] == 3'd2) )
	// mov; y0 is dst
	reg_en[2] = 1'b1;
else
	reg_en[2] = 1'b0;


//  reg_en[3], y1  //
always @ *
if (sync_reset == 1'b1) 
	// enable all registers during reset, to clear them
	reg_en[3] = 1'b1;
else if (ir[7:4] == 4'd3)
	// load; y1 is dst
	reg_en[3] = 1'b1;
else if ( (ir[7:6] == 2'b10) && (ir[5:3] == 3'd3) )
	// mov; y0 is dst
	reg_en[3] = 1'b1;
else
	reg_en[3] = 1'b0;


//  reg_en[4], r  //
always @ *
if (sync_reset == 1'b1) 
	// enable all registers during reset, to clear them
	reg_en[4] = 1'b1;
else if (ir[7:5] == 3'b110)
	// alu; r is enabled
	reg_en[4] = 1'b1;
else
	reg_en[4] = 1'b0;


//  reg_en[5], m  //
always @ *
if (sync_reset == 1'b1) 
	// enable all registers during reset, to clear them
	reg_en[5] = 1'b1;
else if (ir[7:4] == 4'd5)
	// load; m is dst
	reg_en[5] = 1'b1;
else if ( (ir[7:6] == 2'b10) && (ir[5:3] == 3'd5) )
	// mov; m is dst
	reg_en[5] = 1'b1;
else
	reg_en[5] = 1'b0;



//  reg_en[6], i  //
always @ *
if (sync_reset == 1'b1) 
	// enable all registers during reset, to clear them
	reg_en[6] = 1'b1;
else if ( (ir[7] == 1'b0) && (ir[6:4] == 3'd6) )
	// load; i is a dst
	reg_en[6] = 1'b1;
else if ( (ir[7] == 1'b0) && (ir[6:4] == 3'd7) )
	// load; dm is a dst (increment i)
	reg_en[6] = 1'b1;
else if (ir[7:6] == 2'b10)
	if (ir[5:3] == 3'd6)
		// mov; i is a dst
		reg_en[6] = 1'b1;
	else if (ir[5:3] == 3'd7)
		// mov; dm is a dst (increment i)
		reg_en[6] = 1'b1;
	else if (ir[2:0] == 3'd7)
		// mov; dm is a src (increment i or mov into i)
		reg_en[6] = 1'b1;
	else
		reg_en[6] = 1'b0;
else
	// no other mov or load cases where i is modified
	reg_en[6] = 1'b0;


//  reg_en[7], dm  //
always @ *
if (sync_reset == 1'b1) 
	// enable all registers during reset, to clear them
	reg_en[7] = 1'b1;
else if (ir[7:4] == 4'd7)
	// load; dm is dst
	reg_en[7] = 1'b1;
else if ( (ir[7:6] == 2'b10) && (ir[5:3] == 3'd7) )
	// mov; dm is dst
	reg_en[7] = 1'b1;
else
	reg_en[7] = 1'b0;


//  reg_en[8], o_reg  //
always @ *
if (sync_reset == 1'b1) 
	// enable all registers during reset, to clear them
	reg_en[8] = 1'b1;
else if (ir[7:4] == 4'd4)
	// load; o_reg is dst
	reg_en[8] = 1'b1;
else if ( (ir[7:6] == 2'b10) && (ir[5:3] == 3'd4) )
	// mov; o_reg is dst
	reg_en[8] = 1'b1;
else
	reg_en[8] = 1'b0;


endmodule

