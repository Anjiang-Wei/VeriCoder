// Extend input signals
wire [2*size-1:0] mul_a_ext = {size{1'b0}} + mul_a;
wire [2*size-1:0] mul_b_ext = {size{1'b0}} + mul_b;

// Intermediate sum registers
reg [2*size-1:0] sum [size-1:0];

// Multiplication operation
generate
genvar i;
for(i = 0; i < size; i = i + 1) begin : multi_gen
    assign sum[i] = (mul_b_ext[i] == 1'b1) ? mul_a_ext << i : 0;
end
endgenerate

// Addition of partial products
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for(int j = 0; j < size; j = j + 1) begin
            sum[j] <= 0;
        end
    end else begin
        for(int j = 0; j < size; j = j + 1) begin
            sum[j] <= sum[j] + (j < size-1 ? sum[j+1] : 0);
        end
    end
end

// Final product calculation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 0;
    end else begin
        mul_out <= sum[0];
    end
end

endmodule