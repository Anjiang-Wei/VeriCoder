module JC_counter(
   input                clk ,
   input                rst_n,

   output reg [63:0]     Q  
);

// Reset value of Q
initial begin
    Q = 0;
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        Q <= 0;
    end else begin
        case (Q[0])
            1'b0: begin // Increment counter
                Q <= {1'b1, Q[63:1]};
            end
            1'b1: begin // Decrement counter
                Q <= {{63{1'b0}}, ~Q[63], Q[62:0]};
            end
        endcase
    end
end

endmodule