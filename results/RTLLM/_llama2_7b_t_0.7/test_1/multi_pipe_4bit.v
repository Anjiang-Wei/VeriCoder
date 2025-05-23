module multi_pipe_4bit#(
    parameter size = 4
)(
    input 						clk 		,
    input 						rst_n		,
    input	[size-1:0]			mul_a		,
    input	[size-1:0]			mul_b		,
    output	reg	[size*2-1:0]	mul_out		
);

parameter N = 2 * size;

// Extension of input signals
assign mul_a = {size{1'b0}} & mul_a;
assign mul_b = {size{1'b0}} & mul_b;

// Multiplication operation
generate
    for (int i = 0; i < size; i++) begin : gen_mul
        reg [N-1:0] partial_product;
        
        // Calculate partial product
        if (mul_b[i]) begin
            mul_a <<= i;
            partial_product = 1;
        end else begin
            partial_product = 0;
        end
        
        assign mul_out[i*2-1:i] = partial_product;
    endclass
endgenerate

// Add of partial products
always @(posedge clk or negedge rst_n) begin
    if (rst_n == 0) begin
        // Reset registers to 0
        mul_out <= {N{1'b0}};
    end else begin
        // Add partial products
        for (int i = 0; i < size; i++) begin
            mul_out[i*2-1:i] += partial_product[i];
        end
    end
end

// Final product calculation
always @(posedge clk or negedge rst_n) begin
    if (rst_n == 0) begin
        // Reset product output to 0
        mul_out <= {N{1'b0}};
    end else begin
        // Add registers to product output
        for (int i = 0; i < size*2-1; i++) begin
            mul_out[i] += mul_out[i];
        end
    end
end