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
    // Internal signals and registers
    reg [size-1:0] mul_a_reg;
    reg [size-1:0] mul_b_reg;
    reg [size-1:0] mul_en_out_reg;
    reg [size*2-1:0] temp [0:size-1];
    reg [size*2-1:0] sum [0:size-1];
    reg [size*2-1:0] mul_out_reg;

    // Input control and registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 0;
            mul_b_reg <= 0;
            mul_en_out_reg <= 0;
        end else begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
            mul_en_out_reg <= mul_en_out_reg | mul_en_in;
        end
    end

    // Output enable signal
    assign mul_en_out = mul_en_out_reg[size-1];

    // Partial product generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (int i = 0; i < size; i = i + 1) begin
                temp[i] <= 0;
            end
        end else if (mul_en_in) begin
            for (int i = 0; i < size; i = i + 1) begin
                if (mul_b_reg[i]) begin
                    temp[i] <= mul_a_reg << i;
                end else begin
                    temp[i] <= 0;
                end
            end
        end
    end

    // Partial sum calculation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (int i = 0; i < size; i = i + 1) begin
                sum[i] <= 0;
            end
        end else if (mul_en_in) begin
            sum[0] <= temp[0];
            for (int i = 1; i < size; i = i + 1) begin
                sum[i] <= sum[i-1] + temp[i];
            end
        end
    end

    // Final product calculation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 0;
        end else if (mul_en_in) begin
            mul_out_reg <= sum[size-1];
        end
    end

    // Output assignment
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 0;
        end else if (mul_en_out) begin
            mul_out <= mul_out_reg;
        end else begin
            mul_out <= 0;
        end
    end
endmodule