genvar i;
generate 
for(i=0;i<N;i=i+1) begin : generate_sum
	reg	[size*2-1:0] sum				 ;
	if(!rst_n) sum =  0;    //zero out the register on reset condition
	else if(i<size && !rst_n) 
		sum = {size{1'b0}},  //add zero to register for the first i-bit of "size" bits in mul_a and mul_b

		    .& {mul_a[i], mul_b[i]} => sum[N*size+i+1:i*2];   //register for each bit position i from 0 to size-1, the partial product is calculated as follows: If the corresponding bit in the multiplier is 1, the multiplicand is left-shifted by i positions.
		    .& {mul_a[N-1:i+1], mul_b[N-1:i+1]} => sum[N*size+i*2+1:i*2];   //register for each bit position i from 0 to size-1, the partial product is calculated as follows: If the corresponding bit in the multiplier is 1, the multiplicand is left-shifted by i positions.
		    .& {mul_a[N-1], mul_b[N-1]} => sum[N*size+i*2+2:i*2+1];   //register for each bit position i from 0 to size-1, the partial product is calculated as follows: If the corresponding bit in the multiplier is 1, the multiplicand is left-shifted by i positions.
	end
	
mul_out[i*2+N-1:i*2] <= sum; //final product calculation
endgenerate
endgenerate 
endmodule