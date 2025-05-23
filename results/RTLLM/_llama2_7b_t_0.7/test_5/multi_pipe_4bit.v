module multi_pipe_4bit#(parameter size = 4)(
    input 							clk 		,
    input 							rst_n		,
    input	[size-1:0]			mul_a		,
    input	[size-1:0]			mul_b		,
    output	reg	[size*2-1:0]	mul_out		
);

parameter N = 2 * size;

// Extend input signals to match the data width of the multiplier
input [size*2-1:0] extended_mul_a = {mul_a, 0{size*2-1}};
input [size*2-1:0] extended_mul_b = {mul_b, 0{size*2-1}};

// Generate block for multiplication
generate
    for (int i = 0; i < size; i++) begin
        // Calculate partial product
        reg [size*2-1:0] partial_product = {
            if (extended_mul_b[i]) {
                mul_a << i;
            } else {
                partial_product = 0;
            }
        };

        // Add partial products
        if (rst_n == 0) begin
            for (int j = 0; j < size; j++) begin
                mul_out[j*2 +: size] = partial_product[j];
            end
        else begin
            for (int j = 0; j < size; j++) begin
                mul_out[j*2 +: size] = partial_product[j] + mul_out[j*2 +: size];
            end
        end
    end
endmodule