module right_shifter(clk, d, q);  

    input clk;  
    input d;  
    output reg [7:0] q;  

    // Initialize q to 0
    initial begin
        q = 8'b00000000;
    end

    always @(posedge clk) begin
        q <= {d, q[7:1]}; // Shift right and insert new input bit d
    end

endmodule