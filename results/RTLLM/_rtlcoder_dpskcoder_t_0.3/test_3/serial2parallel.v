module serial2parallel(
	input clk,
	input rst_n,
	input din_serial,
	input din_valid,
	output reg [7:0]dout_parallel,
	output reg dout_valid
);

	reg [3:0] cnt;
	reg [7:0] dout_parallel_reg;
	reg dout_valid_reg;

	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			cnt <= 4'b0;
			dout_parallel_reg <= 8'b0;
			dout_valid_reg <= 1'b0;
		end
		else begin
			if (din_valid) begin
				cnt <= cnt + 1;
				dout_parallel_reg <= {dout_parallel_reg[6:0], din_serial};
				if (cnt == 4'b1111) begin
					dout_valid_reg <= 1'b1;
				end
				else begin
					dout_valid_reg <= 1'b0;
				end
			end
		end
	end

	assign dout_parallel = dout_parallel_reg;
	assign dout_valid = dout_valid_reg;

endmodule