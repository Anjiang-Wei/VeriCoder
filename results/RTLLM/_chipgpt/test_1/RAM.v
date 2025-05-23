module RAM(
	input clk,
	input rst_n,
	
	input write_en,
	input[7:0]write_addr,
	input[5:0]write_data,
	
	input read_en,
	input [7:0]read_addr,
	output reg[5:0]read_data
); 
	 // RAM array declaration.
	 reg [DEPTH-1 : 0] RAM [2**WIDTH-1:0]; // register RAM of DEPTH words with each word having width WIDTH bits.
	 // Array declarations of write and read operations.
	 integer i;
	 always @(posedge clk or negedge rst_n) begin  // If rst_n is high, all registers are reset to zero value.
	 if(!rst_n) begin
	 RAM <= 'd0; // all the RAM locations start with 0 (as per array declaration).
	 end
	 else begin
		if(write_en) begin // Write operation.
			for(i=0; i<DEPTH; i=i+1) if(write_addr[i] == write_addr[i+1]) // Read and write operations are carried out at the same time, so a loop is used to access the RAM locations.
				RAM[i]=write_data; // Write data to the RAM location i.
			end
		 end
	 end
	 
	 always @(posedge clk or negedge rst_n) begin // Read operation.
	 if(!rst_n) read_data <= 'd0; // All registers are reset to zero value.
	 else if(read_en) read_data[read_addr] <= RAM[read_addr]; // Copy the data from the address location in memory to the read_data register.
	 end
endmodule