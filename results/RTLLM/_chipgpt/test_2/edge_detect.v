always@(posedge clk)
    if (rst_n) rise <= 1'b0;
    else if (!rising_edge(a)) {
        rise <= 1'b1; // Rising edge
        down <= 1'b0; // No falling edge
    }
    else down <= 1'b1; // Falling edge
    
endmodule