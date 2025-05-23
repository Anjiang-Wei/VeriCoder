module edge_detect(
    input clk,          // Clock signal
    input rst_n,        // Reset signal (active low)
    input a,            // Input signal
    
    output reg rise,    // Rising edge detect output
    output reg down     // Falling edge detect output
);

    // Internal signal to hold the previous state of 'a'
    reg a_prev;

    // Sequential logic to detect edges
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all outputs and internal state when reset is active
            rise <= 1'b0;
            down <= 1'b0;
            a_prev <= 1'b0;
        end else begin
            // Detect rising edge
            if ((a == 1'b1) && (a_prev == 1'b0)) begin
                rise <= 1'b1;  // Set rise on rising edge
                down <= 1'b0;  // Clear down
            end 
            // Detect falling edge
            else if ((a == 1'b0) && (a_prev == 1'b1)) begin
                rise <= 1'b0;  // Clear rise
                down <= 1'b1;  // Set down on falling edge
            end 
            // No edge detected
            else begin
                rise <= 1'b0;
                down <= 1'b0;
            end

            // Update the previous state of 'a'
            a_prev <= a;
        end
    end

endmodule