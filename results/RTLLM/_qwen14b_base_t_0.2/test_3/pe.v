module pe(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] c
);
    
    // Internal wire to hold the product of a and b
    wire [63:0] product;

    // Assign the product of a and b to the internal wire
    assign product = a * b;

    // Always block to handle the clock and reset signals
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset condition: set c to 0
            c <= 32'b0;
        end else begin
            // Normal operation: accumulate the product into c
            c <= c + product[31:0];
        end
    end
endmodule