//generate block for multiplication operation
genvar i;
generate for (i=0;i<N;i=i+1) begin : generate_mul
    if(~{mul_a[i-1:0], mul_b[i-1:0]}) 
        mul_out[i*size+:(size/2)] = {mul_a[(i-1)*size+7:((i-1)*size)+1], mul_b[(i-1)*size+7:((i-1)*size)+1]} ? mul_a[(i-1)*size+7:((i-1)*size)+1] : {d0,d0};
    else 
        mul_out[i*size+:(size/2)] = {mul_a[i*size+7:i*size+1], mul_b[i*size+7:i*size+1]} ? (mul_a[i*size+7:i*size+1] << i) : {d0,d0};
end
endgenerate

//register file for add operation
reg [size-1:0]		sum;  //size bits
always @(posedge clk or posedge rst_n) begin : add_file
    if(!rst_n)
        sum<=0; 
    else
        sum<=sum + mul_out[N+:(size/2)];  
end

//final product calculation
assign mul_out = (~rst_n)? {d0,d0} : (sum[size*2-1:size]); //output is a 4bit number

endmodule