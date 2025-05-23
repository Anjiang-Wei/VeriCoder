module JC_counter(
    input                clk ,
    input                rst_n,
    output reg [63:0]   Q  
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Q <= 64'b0; // Reset the counter to 0
        end else begin
            if (Q[0] == 0) begin
                // If the least significant bit is 0, shift right and append 1
                Q <= {Q[62:0], 1'b1};
            end else begin
                // If the least significant bit is 1, shift right and append 0
                Q <= {Q[62:0], 1'b0};
            end
        end
    end

endmodule