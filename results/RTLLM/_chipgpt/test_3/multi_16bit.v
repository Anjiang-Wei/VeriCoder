module multi_16bit(
	input clk,          // Chip clock signal.
	input rst_n,        // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
	input start,        // Chip enable signal.
	input [15:0] ain,   // Input a (multiplicand) with a data width of 16 bits.
	input [15:0] bin,   // Input b (multiplier) with a data width of 16 bits.
	output [31:0] yout, // Product output with a data width of 32 bits.
	output done         // Chip output flag signal. Defined as 1 indicates multiplication operation completion.
);

// Data bit control
reg[15:0] i;  // Shift count register
always @(posedge clk or negedge rst_n) begin : data_bit_control
	if(!rst_n) i <= 0;
	else if(!start && (i < 17)) i <= i + 1;
	else i <= 0;
end

// Multiplication completion flag generation
reg[1:0] done_r; // Multiplication completion flag. Defined as 1 indicates the completion of the multiplication operation.
always @(posedge clk or negedge rst_n) begin : done_flag
	if(!rst_n) done_r <= 0;
	else if(i == 16) done_r[0] <= 1;
	else done_r[0] <= 0;
	if (done_r[1:0] == 2'd3 && i >= 17) done_r <= 0; // done flag is active when the completion of multiplication operation occurs
end

// Shift and accumulate operation
wire [31:0] areg, breg, yout_r;
always @(posedge clk or negedge rst_n) begin : shift_accumulator
	if(!rst_n) begin // Register reset.
		areg <= 'd0; 
		breg <= 'd0;
		yout_r <= 'd0;
	end
	else if(start && !done_r[1:0] && (i < 17)) begin // Shift and accumulate operation.
		if(!(i == 16)) areg <= bin; // Multiplicand register is updated.
		yout_r <= yout_r + {breg[{31:2]}, bin[7:0]}; // Product register is updated by shifting the multiplier and appending zeros at the least significant bit positions.
	end 
	else if(start && done_r[1:0]) begin // Shift count register updates before multiplication completion flag active.
		areg <= ain;  
		breg <= bin;   
		yout_r <= yout_r; 
	end
end

endmodule