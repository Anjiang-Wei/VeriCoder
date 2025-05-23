module multi_pipe_4bit#(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] mul_intermediate [size-1:0];

genvar i;
generate
    for(i=0; i<size; i=i+1) begin : mul_gen
        assign mul_intermediate[i] = mul_a << i;
    end
endgenerate

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 1'b0;
    end
    else begin
        mul_out <= 1'b0;
        for(int i=0; i<size; i=i+1) begin
            if(mul_b[i]) begin
                mul_out <= mul_out + mul_intermediate[i];
            end
        end
    end
end

endmodule