always @(posedge clk) begin
	if (~rst_n) begin
		rise <= 0;
		down <= 0;
	end
	else begin
		if (a && !a_prev) begin
			rise <= 1;
		end
		else begin
			rise <= 0;
		end
		
		if (!a && a_prev) begin
			down <= 1;
		end
		else begin
			down <= 0;
		end
	end
end