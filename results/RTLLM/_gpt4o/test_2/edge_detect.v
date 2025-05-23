module edge_detect(
    input clk,
    input rst_n,
    input a,
    
    output reg rise,
    output reg down
);

    // Internal signal to store the previous state of input `a`
    reg a_prev;

    // Sequential logic for edge detection
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset logic
            rise <= 0;
            down <= 0;
            a_prev <= 0;
        end else begin
            // Detect edges based on changes in the signal `a` and previous state `a_prev`
            if (a && !a_prev) begin
                // Rising edge detected
                rise <= 1;
                down <= 0;
            end else if (!a && a_prev) begin
                // Falling edge detected
                rise <= 0;
                down <= 1;
            end else begin
                // No edge detected
                rise <= 0;
                down <= 0;
            end

            // Update the previous state of `a`
            a_prev <= a;
        end
    end

endmodule