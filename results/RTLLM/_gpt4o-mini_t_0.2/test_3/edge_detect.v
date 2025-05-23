module edge_detect(
    input clk,
    input rst_n,
    input a,
    
    output reg rise,
    output reg down
);

    reg a_prev; // Register to hold the previous value of a

    // Always block to detect edges on the rising edge of the clock
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 0;      // Reset rise signal
            down <= 0;      // Reset down signal
            a_prev <= 0;    // Reset previous a signal
        end else begin
            // Edge detection logic
            if (a && !a_prev) begin
                rise <= 1;   // Rising edge detected
            end else begin
                rise <= 0;    // No rising edge
            end
            
            if (!a && a_prev) begin
                down <= 1;   // Falling edge detected
            end else begin
                down <= 0;    // No falling edge
            end
            
            // Update previous a value for next cycle
            a_prev <= a;
        end
    end

endmodule