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

    // Internal registers
    reg [size-1:0] mul_a_reg;
    reg [size-1:0] mul_b_reg;
    reg [size-1:0] mul_en_out_reg;
    reg [size*2-1:0] mul_out_reg;

    // Wires for partial products
    wire [size*2-1:0] temp [0:size-1];

    // Registers for partial sums
    reg [size*2-1:0] sum [0:size-1];

    // Pipeline stages
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 0;
            mul_b_reg <= 0;
            mul_en_out_reg <= 0;
            mul_out_reg <= 0;
            for (int i = 0; i < size; i = i + 1) begin
                sum[i] <= 0;
            end
        end else begin
            // Input control and registers
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
            mul_en_out_reg <= mul_en_in;
            mul_en_out <= mul_en_out_reg[0];

            // Partial product generation
            for (int i = 0; i < size; i = i + 1) begin
                temp[i] = (mul_b_reg[i] == 1) ? {mul_a_reg, {size-1{1'b0}}} : {size*2{1'b0}};
            end

            // Partial sum calculation
            for (int i = 0; i < size; i = i + 1) begin
                if (i == 0) begin
                    sum[i] <= temp[i];
                end else begin
                    sum[i] <= sum[i-1] + temp[i];
                end
            end

            // Final product calculation
            mul_out_reg <= sum[size-1];
        end
    end

    // Output assignment
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 0;
        end else if (mul_en_out_reg[0]) begin
            mul_out <= mul_out_reg;
        end else begin
            mul_out <= 0;
        end
    end

endmodule