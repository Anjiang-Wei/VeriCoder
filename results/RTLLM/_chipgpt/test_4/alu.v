module alu(
	input [31:0] a,
	input [31:0] b,
	input [5:0] aluc,
	output [31:0] r,
	output zero,
	output carry,
	output negative,
	output overflow,
	output flag
    );
	 // 4-bit signed number
	 wire [23:0] res;
	 // 4 bit register for result (r) and flag (flag)
	 reg [23:0] r;
	 // zero output
	 assign {zero, overflow} = r[31]?1'b1:1'b0;
	 
	 always @* begin
		zero=1'b0;
		carry=1'b0;
		overflow=1'b0;
		flag=1'b0;
		res<=23'd0; // default value
		case(aluc)
		// 1-bit signed number
		6'b000: r[0] = a[23] ^ b[23];
		6'b001: r[0] = a[23]&~b[23] | a[23]|~b[23];
		// 2-bit signed number
		6'b010: r[1] = a[22:12] ^ b[22:12];
		6'b011: r[1] = a[22:12]&~b[22:11] | a[22:12]|~b[22:11];  // addition
		6'b100: r[2] = a[11:0] ^ b[11:0];
		// 3-bit signed number
		6'b101: r[3] = a[7:0] ^ b[7:0]; // subtraction
		6'b110: r[3] = a[7:0]+b[7:0];
		// 4-bit signed number
		6'b111: if(aluc==5'b00000) // addition and carry
			r[3]=a[23:0] + b[23:0]+{res[23:1],carry};
			else if(aluc==5'b00001)  // subtraction and carry
			r[3]=a[23:0] - b[23:0]-{res[23:1],carry};
			else if(aluc==5'b00010 || aluc==5'b00011) // left shifts and carry 
			r[3]=a[23:0]<<{res[23:1],aluc} - b[23:0];
			else if(aluc==5'b00100 || aluc==5'b00101) // left shifts and borrow 
			r[3]=a[23:0]<<{res[23:1],aluc} - b[23:0]+1'b1;
			else if(aluc==5'b00110 || aluc==5'b00111) // right shifts and carry 
			r[3]=a[23:0]>>{res[23:1],aluc} - b[23:0];
			else if(aluc==5'b01000 || aluc==5'b01001) // right shifts and borrow 
			r[3]=a[23:0]>>{res[23:1],aluc} - b[23:0]+1'b1;
		default: r<=23'd0;
		endcase
	 end
endmodule