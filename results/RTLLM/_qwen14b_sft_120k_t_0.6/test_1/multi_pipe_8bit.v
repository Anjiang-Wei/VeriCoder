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

    // Registers for input control
    reg [1:0] mul_en_out_reg;
    wire mul_en_out_wire = mul_en_out_reg[1];
    wire [size-1:0] mul_a_reg, mul_b_reg;

    // Partial product generation
    wire [size*2-1:0] temp [0:size-1];

    // Partial sum calculation
    reg [size*2-1:0] sum [0:((size-1)/2)];

    // Final product calculation
    reg [size*2-1:0] mul_out_reg;

    // Input registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= {size{1'b0}};
            mul_b_reg <= {size{1'b0}};
            mul_en_out_reg <= 2'b00;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
            mul_en_out_reg <= {mul_en_out_reg[0], mul_en_in};
        end
    end

    // Generate partial products
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_temp
            assign temp[i] = (mul_b_reg[i]) ? {mul_a_reg, {size{1'b0}}} : {size*2{1'b0}};
        end
    endgenerate

    // Calculate partial sums
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < ((size-1)/2); i = i + 1) begin
                sum[i] <= {size*2{1'b0}};
            end
        end else begin
            sum[0] <= temp[0] + temp[1];
            for (i = 1; i < ((size-1)/2); i = i + 1) begin
                sum[i] <= sum[i-1] + temp[2*i+1] + temp[2*i+2];
            end
        end
    end

    // Calculate final product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= {size*2{1'b0}};
        end else begin
            mul_out_reg <= sum[(size-1)/2];
        end
    end

    // Output assignment
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out <= 1'b0;
            mul_out <= {size*2{1'b0}};
        end else begin
            mul_en_out <= mul_en_out_wire;
            if (mul_en_out_wire) begin
                mul_out <= mul_out_reg;
            end else begin
                mul_out <= {size*2{1'b0}};
            end
        end
    end

endmodule