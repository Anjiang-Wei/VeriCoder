module multi_pipe_4bit#(
	parameter size = 4
)(
	input 						clk 		,   
	input 						rst_n		,
	input	[size-1:0]			mul_a		,
	input	[size-1:0]			mul_b		,
 
	output	reg	[2*size-1:0]	mul_out		
);

parameter N = 2 * size;

reg [N-1:0] partial_products [size-1:0];

always @(posedge clk or negedge rst_n)
begin
	if (~rst_n) // reset condition
	begin
		for (int i=0; i<size; i++)
			partial_products[i][N-1:0] <= 'd0;
	end
	else
	begin
		for (int i=0; i<size; i++)
		begin
			if (mul_b[i])
				partial_products[i][N-1:0] <= mul_a[N-i-1 : 0];
			else
				partial_products[i][N-1:0] <= 'd0;
		end
	end
end

reg [2*size-1:0] sum;
always @(posedge clk or negedge rst_n)
begin
	if (~rst_n) // reset condition
		sum <= 'd0;
	else
	begin
		for (int i=0; i<size; i++)
			sum = sum + partial_products[i][N-1 : 0];
	end
end

always @(posedge clk or negedge rst_n)
begin
	if (~rst_n) // reset condition
		mul_out <= 'd0;
	else
		mul_out <= sum[2*size-1:0];
end