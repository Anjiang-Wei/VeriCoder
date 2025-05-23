module edge_detect(
    input clk,
    input rst_n,
    input a,
    
    output reg rise,
    output reg down
);

    // State to hold the previous value of the input signal 'a'
    reg a_prev;

    // Always block triggered by the clock's positive edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset the output signals and previous state
            rise <= 0;
            down <= 0;
            a_prev <= 0;
        end else begin
            // Detect rising edge
            if (a_prev == 0 && a == 1) begin
                rise <= 1;  // Set rise signal
            end else begin
                rise <= 0;  // Clear rise signal
            end
            
            // Detect falling edge
            if (a_prev == 1 && a == 0) begin
                down <= 1;  // Set down signal
            end else begin
                down <= 0;  // Clear down signal
            end

            // Update the previous state of 'a'
            a_prev <= a;
        end
    end

endmodule