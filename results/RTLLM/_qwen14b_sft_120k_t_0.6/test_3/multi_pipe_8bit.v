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

    reg [size-1:0] mul_a_reg, mul_b_reg;
    wire [size-1:0] temp [size-1:0];
    reg [size-1:0] sum [size-1:0];
    reg [size*2-1:0] mul_out_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= {size{1'b0}};
            mul_b_reg <= {size{1'b0}};
            mul_en_out_reg <= 1'b0;
            mul_out_reg <= {size*2{1'b0}};
            sum[0] <= {size{1'b0}};
            sum[1] <= {size{1'b0}};
            sum[2] <= {size{1'b0}};
            sum[3] <= {size{1'b0}};
            sum[4] <= {size{1'b0}};
            sum[5] <= {size{1'b0}};
            sum[6] <= {size{1'b0}};
            sum[7] <= {size{1'b0}};
        end else begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
            mul_en_out_reg <= mul_en_in;
            sum[0] <= (mul_b_reg[0] ? mul_a_reg : {size{1'b0}});
            sum[1] <= (mul_b_reg[1] ? mul_a_reg : {size{1'b0}});
            sum[2] <= (mul_b_reg[2] ? mul_a_reg : {size{1'b0}});
            sum[3] <= (mul_b_reg[3] ? mul_a_reg : {size{1'b0}});
            sum[4] <= (mul_b_reg[4] ? mul_a_reg : {size{1'b0}});
            sum[5] <= (mul_b_reg[5] ? mul_a_reg : {size{1'b0}});
            sum[6] <= (mul_b_reg[6] ? mul_a_reg : {size{1'b0}});
            sum[7] <= (mul_b_reg[7] ? mul_a_reg : {size{1'b0}});
        end
    end

    genvar i;
    generate
        for (i = 1; i < size; i = i + 1) begin : sum_generation
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n)
                    sum[i] <= {size{1'b0}};
                else
                    sum[i] <= sum[i-1] + sum[i];
            end
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out_reg <= {size*2{1'b0}};
        else
            mul_out_reg <= sum[size-1];
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out <= 1'b0;
            mul_out <= {size*2{1'b0}};
        end else begin
            mul_en_out <= mul_en_out_reg[0];
            mul_out <= mul_en_out_reg[0] ? mul_out_reg : {size*2{1'b0}};
        end
    end

endmodule