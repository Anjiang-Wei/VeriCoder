module edge_detect(
    input clk,
    input rst_n,
    input a,
    
    output reg rise,
    output reg down
);

    reg a_prev; // Register to hold the previous state of signal 'a'

    // Synchronous process to detect edges on 'a'
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset the outputs and previous state
            rise <= 0;
            down <= 0;
            a_prev <= 0;
        end else begin
            // Edge detection logic
            if (a_prev == 0 && a == 1) begin
                rise <= 1; // Rising edge detected
                down <= 0; // Clear down output
            end else if (a_prev == 1 && a == 0) begin
                rise <= 0; // Clear rise output
                down <= 1; // Falling edge detected
            end else begin
                rise <= 0; // Clear rise output if no edge
                down <= 0; // Clear down output if no edge
            end
            
            // Update previous state of 'a'
            a_prev <= a;
        end
    end

endmodule