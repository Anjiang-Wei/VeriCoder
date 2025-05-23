localparam BITS = size*8;
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) mul_out <= 'd0;
	else if(~mul_b[N-1]) 
		mul_out[2*size-1:size*2-1] <= { ~mul_a[N-1], mul_a[N-1:0]};
	else if(~mul_b[N-2]) 
		mul_out[size*2-3:size*2-1] <= { ~mul_a[N-2], mul_a[N-2:0]};
	else if(~mul_b[N-3]) 
		mul_out[size*2-7:size*2-4] <= { ~mul_a[N-3], mul_a[N-3:0]};
	else if(~mul_b[N-4]) 
		mul_out[size*2-11:size*2-8] <= { ~mul_a[N-4], mul_a[N-4:0]};
	else if(~mul_b[N-5]) 
		mul_out[size*2-15:size*2-12] <= { ~mul_a[N-5], mul_a[N-5:0]};
	else if(~mul_b[N-6]) 
		mul_out[size*2-21:size*2-19] <= { ~mul_a[N-6], mul_a[N-6:0]};
	else if(~mul_b[N-7]) 
		mul_out[size*2-25:size*2-22] <= { ~mul_a[N-7], mul_a[N-7:0]};
	else begin
		mul_out[2*size-1:size*2-1] <= 'd0;
		mul_out[size*2-3:size*2-1] <= 'd0;
		mul_out[size*2-7:size*2-8] <= 'd0;
		mul_out[size*2-11:size*2-12] <= 'd0;
		mul_out[size*2-15:size*2-19] <= 'd0;
		mul_out[size*2-21:size*2-22] <= 'd0;
	end
end
 

endmodule