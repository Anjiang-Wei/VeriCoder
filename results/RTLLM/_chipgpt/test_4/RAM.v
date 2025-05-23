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
	 //Array declarations begin with array name followed by "array" and then the width.
	 wire[7:0]ram[2**WIDTH-1:0]; //Width is equal to 6 in this case
	 wire[WIDTH-1:0]addr;
	 reg[7:0]wr_data;
	 reg[5:0]rd_data;
	 initial begin
		if(!rst_n) ram=0; //All memory locations are initialized to 0 by default.
	 end
	 always @(posedge clk, or negedge rst_n) begin
	 if(!rst_n) wr_data<=0;
	 else if(write_en) wr_data<=write_data; //Write operation is done at the specified memory location.
	 end
	 assign ram[write_addr]=wr_data; //Write operation is performed here at the address write_addr.
	 always @(posedge clk, or negedge rst_n) begin
	 if(!rst_n) rd_data<=0;
	 else if(read_en) rd_data=ram[read_addr]; //Read operation is done here at the address read_addr.
	 end 
	 assign read_data=rd_data;
endmodule