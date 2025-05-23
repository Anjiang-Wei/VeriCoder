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

reg [5:0] RAM [0:255];

initial begin
	for (int i = 0; i < 256; i = i + 1) begin
		RAM[i] = 6'b000000;
	end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		read_data <= 6'b000000;
		for (int i = 0; i < 256; i = i + 1) begin
			RAM[i] <= 6'b000000;
		end
	end else begin
		if (write_en) begin
			RAM[write_addr] <= write_data;
		end
		if (read_en) begin
			read_data <= RAM[read_addr];
		end
	end
end

endmodule