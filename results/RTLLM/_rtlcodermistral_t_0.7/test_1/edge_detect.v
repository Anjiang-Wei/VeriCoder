// Synchronize inputs with the clock
reg a_sync;
always @(posedge clk) begin
	if (~rst_n) begin
		a_sync <= 1'b0;
	end
	else begin
		a_sync <= a;
	end
end

// Detect rising edge
reg rise_sync;
always @(posedge clk) begin
	if (~rst_n) begin
		rise_sync <= 1'b0;
	end
	else begin
		if (a_sync && !a) begin
			rise_sync <= 1'b1;
		end
		else begin
			rise_sync <= 1'b0;
		end
	end
end

// Detect falling edge
reg down_sync;
always @(posedge clk) begin
	if (~rst_n) begin
		down_sync <= 1'b0;
	end
	else begin
		if (!a_sync && a) begin
			down_sync <= 1'b1;
		end
		else begin
			down_sync <= 1'b0;
		end
	end
end

// Assign outputs
assign rise = rise_sync;
assign down = down_sync;

endmodule