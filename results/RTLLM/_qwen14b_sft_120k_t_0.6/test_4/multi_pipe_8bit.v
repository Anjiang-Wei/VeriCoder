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
    // Input registers
    reg [size-1:0] mul_a_reg, mul_b_reg;
    // Partial product generation wires
    wire [size-1:0] temp0, temp1, temp2, temp3, temp4, temp5, temp6, temp7;
    // Partial sum registers
    reg [size*2-1:0] sum0, sum1, sum2, sum3, sum4, sum5, sum6, sum7;
    // Final product register
    reg [size*2-1:0] mul_out_reg;

    // Input control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out_reg <= 8'b0;
        end else begin
            mul_en_out_reg <= {mul_en_in, mul_en_out_reg[7:1]};
        end
    end
    assign mul_en_out = mul_en_out_reg[7];

    // Input registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // Partial product generation
    assign temp0 = mul_a_reg & {size{mul_b_reg[0]}};
    assign temp1 = mul_a_reg & {size{mul_b_reg[1]}};
    assign temp2 = mul_a_reg & {size{mul_b_reg[2]}};
    assign temp3 = mul_a_reg & {size{mul_b_reg[3]}};
    assign temp4 = mul_a_reg & {size{mul_b_reg[4]}};
    assign temp5 = mul_a_reg & {size{mul_b_reg[5]}};
    assign temp6 = mul_a_reg & {size{mul_b_reg[6]}};
    assign temp7 = mul_a_reg & {size{mul_b_reg[7]}};

    // Partial sum calculation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum0 <= 16'b0;
            sum1 <= 16'b0;
            sum2 <= 16'b0;
            sum3 <= 16'b0;
            sum4 <= 16'b0;
            sum5 <= 16'b0;
            sum6 <= 16'b0;
            sum7 <= 16'b0;
        end else begin
            sum0 <= sum0 + temp0;
            sum1 <= sum1 + temp1;
            sum2 <= sum2 + temp2;
            sum3 <= sum3 + temp3;
            sum4 <= sum4 + temp4;
            sum5 <= sum5 + temp5;
            sum6 <= sum6 + temp6;
            sum7 <= sum7 + temp7;
        end
    end

    // Final product calculation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'b0;
        end else begin
            mul_out_reg <= sum0 + sum1 + sum2 + sum3 + sum4 + sum5 + sum6 + sum7;
        end
    end

    // Output assignment
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 16'b0;
        end else if (mul_en_out) begin
            mul_out <= mul_out_reg;
        end else begin
            mul_out <= 16'b0;
        end
    end
endmodule