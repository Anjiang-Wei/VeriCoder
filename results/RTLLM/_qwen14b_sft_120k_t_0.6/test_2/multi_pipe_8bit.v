module multi_pipe_8bit#(
    parameter size = 8
)(
    input clk,      
    input rst_n,       
    input mul_en_in,      
    input [size-1:0] mul_a,       
    input [size-1:0] mul_b,       
 
    output reg mul_en_out,      
    output reg [size*2-1:0] mul_out    
);
    // Input registers for multiplicand and multiplier
    reg [size-1:0] mul_a_reg, mul_b_reg;
    // Registers for storing partial sums
    reg [size*2-1:0] sum [0:size-1];
    // Register for storing the output product
    reg [size*2-1:0] mul_out_reg;

    // Input control: Sample the input enable signal and store it
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out_reg <= 0;
        end else begin
            mul_en_out_reg <= mul_en_in;
        end
    end

    // Output enable signal based on the most significant bit of mul_en_out_reg
    assign mul_en_out = mul_en_out_reg[size-1];

    // Input registers for multiplicand and multiplier
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 0;
            mul_b_reg <= 0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // Partial products generation
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : pp_generation
            wire [size-1:0] temp = (mul_b_reg[i] == 1'b1) ? mul_a_reg : 0;
            assign sum[i][i+size-1:i] = temp;
        end
    endgenerate

    // Partial sum calculation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum[0] <= 0;
            for (i = 1; i < size; i = i + 1) begin
                sum[i] <= 0;
            end
        end else if (mul_en_in) begin
            sum[0] <= sum[0] + sum[1];
            for (i = 1; i < size-1; i = i + 1) begin
                sum[i] <= sum[i] + sum[i+1];
            end
            sum[size-1] <= sum[size-1] + sum[0];
        end
    end

    // Final product calculation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 0;
        end else if (mul_en_in) begin
            mul_out_reg <= sum[0];
        end
    end

    // Output assignment
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 0;
        end else begin
            mul_out <= mul_en_out ? mul_out_reg : 0;
        end
    end
endmodule