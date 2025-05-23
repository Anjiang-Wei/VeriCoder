module RAM(
	input clk,
	input rst_n,
	
	input write_en,
	input[7:0]write_addr,
	input[5:0]write_data,
	
	input read_en,
	input[7:0]read_addr,
	output reg[5:0]read_data
    );
	  //Array declarations. The array is declared using the reg type in the declaration "reg [DEPTH-1:0] RAM[2**WIDTH-1:0]". This is because the array has a width of (6 bits) and so each element will have the bit width of (6 bits). Also, the declaration uses the unsigned operator to make it an array of size 2^(width), which is equal to 2^5 or 32.
	  reg[DEPTH-1:0] RAM [2**WIDTH-1:0];
	 //Write enable signal (write_en). The write operation occurs only when the signal "write_en" is high. So, it should be set as a register and not an input to make it active high instead of low.
	  reg write_en;
	 //Address used for writing data in the RAM array
	  reg[7:0] write_addr;
	 //Data that will be written in the RAM array. The write operation occurs only when "write_en" is high and so should be a register. 
	  reg[5:0] write_data;  
	//Register used for reading data from the RAM array
	  reg[DEPTH-1:0] ram_rd; 
	 //Register used for reading the data read from the RAM array(read_addr)
	  reg read_en;
	 
	 //Clock generator
	  parameter WIDTH = 6;
	  parameter DEPTH = 8;  
		integer i;  //Used in register declaration to reset every bit. 
	  always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			write_en <= 1'b0;//Set write_en as inactive at the start of simulation since it will be active high. 
		end
		else if(write_en) begin
			write_addr <= write_data[7:0];
			write_data <= {1'b0, write_data[WIDTH-1:0]};//Clear the write data to 1 by default and then use this to write the data. 
		end
	  end
	  
	always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin //reset to zero on reset
		ram_rd <= 0;
		read_en <= 1'b0;//Set read_en as inactive at the start of simulation since it will be active high.  
	end
	else if(read_en) begin //enable reading from RAM
		if((write_addr == read_addr)) ram_rd <= write_data;//Read from the correct memory location that was written by the write operation
		else ram_rd <= 0;//Otherwise, just read all zeroes
	end
	end

	always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin //reset to zero on reset
		read_data <= 8'b0;
	end
	else if(read_en) begin //enable reading from RAM
		read_data[5:0] = ram_rd[6:0];//Read the correct data from the memory location that was written by the write operation.
	end
	end 
	
	

endmodule