module right_shifter(clk, d, q);  

    input clk;  
    input d;  
    output reg [7:0] q;  

    always @(posedge clk) begin
        // Initialize q to 0 at the beginning
        initial q <= 8'b0;
        
        // Perform right shift and insert new input bit into the MSB
        q <= {d, q[7:1]};
    end

endmodule