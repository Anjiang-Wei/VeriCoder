module edge_detect(
    input clk,
    input rst_n,
    input a,
    
    output reg rise,
    output reg down
);

    // Register to store the previous value of 'a'
    reg a_d;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // On active-low reset, initialize outputs and delayed register to 0
            a_d   <= 1'b0;
            rise  <= 1'b0;
            down  <= 1'b0;
        end else begin
            // Detect rising edge: previous value is 0 and current value is 1.
            rise  <= (~a_d & a) ? 1'b1 : 1'b0;
            // Detect falling edge: previous value is 1 and current value is 0.
            down  <= (a_d & ~a) ? 1'b1 : 1'b0;
            
            // Update the delayed signal for the next comparison
            a_d   <= a;
        end
    end

endmodule