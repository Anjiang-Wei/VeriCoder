module edge_detect(
    input clk,
    input rst_n,
    input a,
    
    output reg rise,
    output reg down
);

// Internal register to hold the previous state of the input signal
reg a_reg;

// Asynchronous reset and edge detection logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset the outputs and registered state
        rise <= 0;
        down <= 0;
        a_reg <= 0;
    end else begin
        // Edge detection
        rise <= 0; // Default to 0
        down <= 0; // Default to 0

        // Detect rising edge
        if (a == 1 && a_reg == 0) begin
            rise <= 1;
        end
        
        // Detect falling edge
        if (a == 0 && a_reg == 1) begin
            down <= 1;
        end
        
        // Update the registered state
        a_reg <= a;
    end
end

endmodule