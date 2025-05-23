// Generation block for multiplication
genvar i;
generate for(i=0;i<N;i=i+1) begin : gen_mul
	if(!rst_n) {
		mul_out[i*size-1:i*size] = 0; //register init to zero
	}
	else if(rst_n == 1 && i<N-1) {//reset condition, next register init with the previous sum value (positive edge of clk or falling edge of rst_n)
		mul_out[i*size-1:i*size] = mul_out[(i-1)*size:i*size]; //copy next value from the left to this position
	} 
	else if(rst_n == 0 && i>=N-1) {//no reset condition, init with the partial product at the last index
		mul_out[i*size-1:i*size] = mul_b[i*size-1:i*size]; //sum of all previous registers except this one and 0 for leftmost bit
	} 
	else if(rst_n == 0 && i>=N-2) {//no reset condition, add with the partial product at the last index
		mul_out[i*size-1:i*size] = mul_a[i*size-1:i*size] + {{reg[i*size+:size], 0}}; //left shift for each bit except leftmost one, and add with the previous register
	} 
	else if(rst_n == 0 && i>=N-3) {//no reset condition, add with the partial product at the last index
		mul_out[i*size-1:i*size] = mul_a[i*size-1:i*size] + reg[(i-1)*size+:size]; //sum of all previous registers except this one and 0 for leftmost bit
	} 
endgenerate
endmodule