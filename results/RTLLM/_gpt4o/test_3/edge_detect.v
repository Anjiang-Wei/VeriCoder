module edge_detect(
    input clk,
    input rst_n,
    input a,
    
    output reg rise,
    output reg down
);

    // Register for storing the previous value of the input signal 'a'
    reg a_prev;

    // Sequential block: Detect changes on the positive edge of the clock or reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Active-low reset: clear all registers
            a_prev <= 1'b0;
            rise   <= 1'b0;
            down   <= 1'b0;
        end else begin
            // Default: reset outputs
            rise <= 1'b0;
            down <= 1'b0;

            // Edge detection logic: compare the current value of 'a' with its previous value
            if (a == 1'b1 && a_prev == 1'b0) begin
                // Rising edge detected
                rise <= 1'b1;
            end else if (a == 1'b0 && a_prev == 1'b1) begin
                // Falling edge detected
                down <= 1'b1;
            end

            // Update the previous value of 'a' for the next clock cycle
            a_prev <= a;
        end
    end

endmodule