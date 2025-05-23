module multi_pipe_4bit#(parameter size = 4)(
    input 						clk,
    input 						rst_n,
    input	[size-1:0]		mul_a,
    input	[size-1:0]		mul_b,
    output	reg	[size*2-1:0] mul_out
);

parameter N = 2 * size;

// Extension of input signals to include zero bits at the most significant bit positions
input [N-1:0] mul_a_extended = {size{1'b0}, mul_a};
input [N-1:0] mul_b_extended = {size{1'b0}, mul_b};

// Multiplication operation
generate
    for (int i = 0; i < size; i++) begin
        reg [N-1:0] partial_product = {size{1'b0}, mul_a_extended[i] * mul_b_extended[i]};
        if (mul_b_extended[i])
            partial_product = {partial_product, size{1'b0}};
    end
endgenerate

// Add of partial products
always@(posedge clk or negedge rst_n) begin
    if (rst_n == 0) begin
        mul_out <= {N{1'b0}, 0};
    end else begin
        mul_out <= mul_out + {N{1'b0}, partial_product};
    end
end

// Final product calculation
always@(posedge clk or negedge rst_n) begin
    if (rst_n == 0) begin
        mul_out <= 0;
    end else begin
        mul_out <= mul_out + partial_product;
    end
end