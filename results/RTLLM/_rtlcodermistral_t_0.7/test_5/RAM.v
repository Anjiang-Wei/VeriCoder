```verilog
parameter WIDTH = 6;
parameter DEPTH = 8;

reg [DEPTH - 1 : 0] RAM [2**WIDTH-1:0];

always @(posedge clk, negedge rst_n) begin
	if (!rst_n) begin
		for (i = 0; i < 2**WIDTH; i = i + 1) begin
			RAM[i] <= 0;
		end
	end else begin
		if (write_en) begin
			RAM[write_addr] <= write_data;
		end
		if (read_en) begin
			read_data <= RAM[read_addr];
		end else begin
			read_data <= 0;
		end
	end
end

endmodule