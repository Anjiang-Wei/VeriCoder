module multi_pipe_8bit#(
    parameter size = 8,
    parameter num_pipeline_stages = 4 // Number of pipeline stages to use
)(
          input clk,      
          input rst_n,       
          input mul_en_in,   
          input [size-1:0] mul_a,       
          input [size-1:0] mul_b,       

          output reg mul_en_out,      
          output reg [size*2-1:0] mul_out    
);

// Pipeline registers
reg mul_en_out_reg; // Output enable signal

reg [size-1:0] mul_a_reg; // Input multiplicand register
reg [size-1:0] mul_b_reg; // Input multiplier register

reg [$clog2(num_pipeline_stages)-1:0] partial_sum_regs[num_pipeline_stages]; // Partial sum registers

// Intermediate product register
reg [num_pipeline_stages*size-1:0] intermediate_product;

always @(posedge clk)
begin
    if (~rst_n) // Reset signal is active-low
    begin
        mul_en_out <= 1'b0;
        mul_a_reg <= 'b0;
        mul_b_reg <= 'b0;
        partial_sum_regs <= '{default: 0};
        intermediate_product <= 0;
    end

    else
    begin
        // Input control and sampling
        if (mul_en_in)
        begin
            mul_en_out_reg <= mul_en_in;

            // Sample input values
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
        else
        begin
            mul_en_out_reg <= 1'b0;
        end

        // Generate partial products
        for (genvar i = num_pipeline_stages-1; i >= 0; i--)
        begin
            if (i == num_pipeline_stages - 1) // First stage, use original multiplier bits
            begin
                partial_sum_regs[i] <= mul_b_reg;
            end

            else
            begin
                partial_sum_regs[i] <= partial_sum_regs[i+1];
            end
        end

        // Partial sum calculation
        intermediate_product = 0;
        for (genvar i = num_pipeline_stages-1; i >= 0; i--)
        begin
            case (partial_sum_regs[i])
                1'b0: intermediate_product <= intermediate_product;
                default: intermediate_product[num_pipeline_stages*size-2-i*(size+1)] <= mul_a_reg[partial_sum_regs[i]-1];
            endcase
        end

        // Final product calculation
        if (~mul_en_in) // Input enable signal is inactive
        begin
            intermediate_product <= 0;
        end

        else
        begin
            casez (intermediate_product[num_pipeline_stages*size-2:])
            // Handle partial sum overflow by propagating the sign bit to all bits in mul_out_reg
            // This is a simplified approach for demonstration purposes, a more efficient method may be required
            default: mul_out <= intermediate_product;
        endcase

        // Output enable signal derivation
        mul_en_out <= |mul_en_out_reg[0];
    end
end

endmodule