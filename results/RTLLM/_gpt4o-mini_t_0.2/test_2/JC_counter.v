module JC_counter(
   input                clk,
   input                rst_n,
 
   output reg [63:0]    Q  
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0; // Reset to 0
    end else begin
        if (Q[0] == 0) begin
            Q <= {Q[62:0], 1'b1}; // Shift right and append a 1
        end else begin
            Q <= {Q[62:0], 1'b0}; // Shift right and append a 0
        end
    end
end

endmodule