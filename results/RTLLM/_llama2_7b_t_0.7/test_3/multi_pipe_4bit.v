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

// Extend input signals to add leading zeros
assign mul_a_extended = {size{1'b0}} mul_a;
assign mul_b_extended = {size{1'b0}} mul_b;

// Generate block for multiplication
generate
    for (int i = 0; i < size; i++) begin : gen_mul
        reg	[N-1:0] partial_product;
        assign partial_product = ({size{1'b0}} mul_b [i]) ? mul_a_extended[i] : 0;
    end
endgenerate

// Add of partial products
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset registers to 0
        for (int i = 0; i < N; i++) {
            mul_out[i] <= 0;
        }
    end else begin
        // Add partial products
        for (int i = 0; i < N; i++) begin
            mul_out[i] <= partial_product;
        end
    end
end

// Final product calculation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset final product to 0
        mul_out <= 0;
    end else begin
        // Add registers to final product
        for (int i = 0; i < N; i++) begin
            mul_out[i] <= mul_out[i] + partial_product;
        end
    end
end