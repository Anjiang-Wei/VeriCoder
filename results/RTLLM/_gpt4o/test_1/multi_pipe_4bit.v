module multi_pipe_4bit#(
    parameter size = 4
)(
    input                       clk,       
    input                       rst_n,       
    input   [size-1:0]          mul_a,      
    input   [size-1:0]          mul_b,      
    output  reg [size*2-1:0]    mul_out    
);

    parameter N = 2 * size;

    // Registers to hold partial results and intermediate sums
    reg [N-1:0] partial_products [size-1:0];
    reg [N-1:0] sum_stage1 [size/2-1:0];
    reg [N-1:0] sum_stage2;

    integer i;

    // Generate partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < size; i = i + 1) begin
                partial_products[i] <= 'd0;
            end
        end else begin
            for (i = 0; i < size; i = i + 1) begin
                if (mul_b[i]) begin
                    partial_products[i] <= mul_a << i; // left-shift multiplicand by i
                end else begin
                    partial_products[i] <= 'd0;
                end
            end
        end
    end

    // First stage: Add partial products in pairs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < size / 2; i = i + 1) begin
                sum_stage1[i] <= 'd0;
            end
        end else begin
            for (i = 0; i < size / 2; i = i + 1) begin
                sum_stage1[i] <= partial_products[2*i] + partial_products[2*i+1];
            end
        end
    end

    // Second stage: Sum the results of the first stage
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage2 <= 'd0;
        end else begin
            sum_stage2 <= sum_stage1[0] + sum_stage1[1];
        end
    end

    // Final product output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 'd0;
        end else begin
            mul_out <= sum_stage2;
        end
    end

endmodule