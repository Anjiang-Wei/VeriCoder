(* KEEP = true *)
	reg [N-1:0]	[0:(size-1)]	regs;
	reg [N-1:0]	[0:(size-1)]	regs_out;
	reg [size-1:0]	[0:(size-1)]	regs_add;
	reg [size-1:0]	[0:(size-1)]	regs_add_out;

	(* KEEP = true *)
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			regs[0] <= 0;
			regs_add[0] <= 0;
			regs_out[0] <= 0;
			for(i = 1; i < size; i = i + 1) begin
				regs[i] <= 0;
				regs_add[i] <= 0;
				regs_out[i] <= 0;
			end
		end else begin
			regs[0] <= 0;
			regs_add[0] <= 0;
			regs_out[0] <= 0;
			for(i = 1; i < size; i = i + 1) begin
				regs[i] <= regs[i-1];
				regs_add[i] <= regs_add[i-1];
				regs_out[i] <= regs_out[i-1];
			end
			for(i = 0; i < size; i = i + 1) begin
				if(mul_b[i] == 1) begin
					regs_add[i] <= mul_a << i;
				end else begin
					regs_add[i] <= 0;
				end
				regs_out[i] <= regs_add[i] + regs_out[i];
			end
		end
	end

	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			mul_out <= 0;
		end else begin
			mul_out <= regs_out[size-1];
		end
	end

endmodule