module right_shifter(clk, q, d);  

    input clk;  
    input d;  
    output reg [7:0] q;  

    // Initial block to set q to 0 at the start
    initial begin
        q = 8'b00000000; // Initialize q to 0
    end

    // Always block for synchronous operation on the rising edge of clk
    always @(posedge clk) begin
        q <= {d, q[7:1]}; // Shift right and insert new input bit d
    end

endmodule