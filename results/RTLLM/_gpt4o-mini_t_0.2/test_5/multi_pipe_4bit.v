module multi_pipe_4bit#(
    parameter size = 4
)(
    input                       clk         ,   
    input                       rst_n       ,
    input   [size-1:0]         mul_a        ,
    input   [size-1:0]         mul_b        ,
 
    output  reg [2*size-1:0]   mul_out       
);

parameter N = 2 * size;

// Internal signals
reg [size-1:0] a, b;
reg [N-1:0] partial_prod [size-1:0]; // Array to store partial products
reg [N-1:0] sum_reg [size-1:0];      // Array to accumulate sums
reg [N-1:0] product;

// Extending inputs
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a <= 0;
        b <= 0;
    end else begin
        a <= {size{1'b0}} | mul_a; // Extend mul_a
        b <= {size{1'b0}} | mul_b; // Extend mul_b
    end
end

// Generate partial products
integer i;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < size; i = i + 1) begin
            partial_prod[i] <= 0;
        end
    end else begin
        for (i = 0; i < size; i = i + 1) begin
            if (b[i]) begin
                partial_prod[i] <= {a, i'b0}; // Left shift multiplicand by i bits
            end else begin
                partial_prod[i] <= 0; // If bit is 0, set partial product to 0
            end
        end
    end
end

// Add partial products together
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_reg[0] <= 0;
        sum_reg[1] <= 0;
        sum_reg[2] <= 0;
        sum_reg[3] <= 0;
    end else begin
        // Start accumulation of sums
        sum_reg[0] <= partial_prod[0];

        for (i = 1; i < size; i = i + 1) begin
            sum_reg[i] <= sum_reg[i-1] + partial_prod[i];
        end
    end
end

// Final product calculation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 0;
    end else begin
        mul_out <= sum_reg[size-1]; // Output the final product
    end
end

endmodule