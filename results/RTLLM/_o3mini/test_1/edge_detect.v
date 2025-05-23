module edge_detect(
    input clk,
    input rst_n,
    input a,
    
    output reg rise,
    output reg down
);

    // Register to hold the previous value of 'a'
    reg a_d;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers to 0
            a_d  <= 1'b0;
            rise <= 1'b0;
            down <= 1'b0;
        end
        else begin
            // Detect rising and falling edges
            // Rising edge: previous a was 0 and current a is 1
            // Falling edge: previous a was 1 and current a is 0
            rise <= (~a_d) & a;
            down <= a_d & (~a);
            
            // Update delayed version of 'a' for next cycle
            a_d <= a;
        end
    end

endmodule