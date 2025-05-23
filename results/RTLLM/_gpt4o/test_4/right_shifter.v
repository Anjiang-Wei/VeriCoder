module right_shifter(clk, q, d);  

    input clk;  
    input d;  
    output reg [7:0] q;  
    
    // Initialize the register 'q' to 0
    initial begin
        q = 8'b00000000;
    end

    // Synchronous process triggered by clock's rising edge
    always @(posedge clk) begin
        // Shift q to the right by one bit and assign d to the most significant bit (MSB)
        q <= {d, q[7:1]};
    end
    
endmodule