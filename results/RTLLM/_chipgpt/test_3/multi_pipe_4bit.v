genvar i;
generate for(i=0;i<=N-1;i=i+1) begin : gen_sum
	reg sum = 0;
	integer j;
    //Left shift of the multiplicand (mul_a) by "size" bit positions.
	for(j=0;j<size;j=j+1) if(i*2-1 == size-j-1) begin  
        sum = {sum, mul_a[size-1:size*(i+1)-1]} << i; //left shift of the multiplicand by "size" bit positions. 
	end
    else begin
		sum = {sum, mul_a[size-1:0]};
    end  
	//Add the partial product to sum register 
	if(i == N/2) begin
		mul_out[i*2-1:(i+1)*2-1] = sum;
    end
	else begin
        mul_out[i*2-1:(i+1)*2-1] = {sum, mul_a[size-1:0]} + 
			{mul_b[i*2-1:0], sum};
    end  
end
endgenerate // gen_sum 
endmodule