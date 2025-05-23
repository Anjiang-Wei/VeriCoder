reg [size-1:0] mul_a_reg; 
    reg [size-1:0] mul_b_reg; 
    reg mul_en_out_reg; 
    wire [size-1:0] partial_product[size-1:0]; 
    wire [size*2-1:0] partial_sum[size-1:0]; 
    reg [size*2-1:0] mul_out_reg; 

    assign mul_en_out = mul_en_out_reg; 

    // Input Control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out_reg <= 0;
        end else if (mul_en_in) begin
            mul_en_out_reg <= 1;
        end
    end

    // Input Registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 0;
            mul_b_reg <= 0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // Partial Product Generation
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : partial_product_gen
            assign partial_product[i] = mul_a_reg & {size*{mul_b_reg[i]}};
        end
    endgenerate

    // Partial Sum Calculation
    generate
        for (i = 0; i < size; i = i + 1) begin : partial_sum_gen
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    partial_sum[i] <= 0;
                end else if (mul_en_in) begin
                    partial_sum[i] <= partial_product[i];
                end
            end
        end
    endgenerate

    // Final Product Calculation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 0;
        end else if (mul_en_in) begin
            mul_out_reg <= partial_sum[0];
            for (i = 1; i < size; i = i + 1) begin
                mul_out_reg <= mul_out_reg + partial_sum[i];
            end
        end
    end

    // Output Assignment
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 0;
        end else if (mul_en_out_reg) begin
            mul_out <= mul_out_reg;
        end
    end
endmodule