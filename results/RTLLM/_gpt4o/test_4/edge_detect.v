module edge_detect(
    input clk,
    input rst_n,
    input a,
    
    output reg rise,
    output reg down
);
    // Internal signal to store the previous value of `a`
    reg a_prev;

    // Sequential logic to detect rising and falling edges
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Asynchronous reset: clear all outputs and internal state
            a_prev <= 1'b0;
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            // Detect rising edge: 0 -> 1
            if (a_prev == 1'b0 && a == 1'b1) begin
                rise <= 1'b1;
            end else begin
                rise <= 1'b0;
            end

            // Detect falling edge: 1 -> 0
            if (a_prev == 1'b1 && a == 1'b0) begin
                down <= 1'b1;
            end else begin
                down <= 1'b0;
            end

            // Update `a_prev` to the current value of `a`
            a_prev <= a;
        end
    end
endmodule