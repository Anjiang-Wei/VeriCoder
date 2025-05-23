module RAM (
	input clk,
	input rst_n,
	
	input write_en,
	input [7:0]write_addr,
	input [5:0]write_data,
	
	input read_en,
	input [7:0]read_addr,
	output reg [5:0]read_data
);

reg [5:0] RAM [255:0]; // 2^8 memory locations, each with a width of 6 bits

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) 
		for(integer i=0; i<256; i++)
			RAM[i] <= 6'b0;
	else if (write_en)
		RAM[write_addr] <= write_data;
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n)
		read_data <= 6'b0;
	else if (read_en)
		read_data <= RAM[read_addr];
end
endmodule