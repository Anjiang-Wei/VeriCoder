module edge_detect(
    input clk,
    input rst_n,
    input a,
    
    output reg rise,
    output reg down
);

// Internal register to hold the previous state of 'a'
reg a_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset the outputs and the registered input signal
        rise <= 0;
        down <= 0;
        a_reg <= 0;
    end else begin
        // Edge detection logic
        if (a && !a_reg) begin
            // Rising edge detected
            rise <= 1;
            down <= 0;
        end else if (!a && a_reg) begin
            // Falling edge detected
            rise <= 0;
            down <= 1;
        end else begin
            // No edge detected
            rise <= 0;
            down <= 0;
        end
        // Update the registered input signal for the next clock cycle
        a_reg <= a;
    end
end

endmodule