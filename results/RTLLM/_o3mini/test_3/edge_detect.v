module edge_detect(
    input clk,
    input rst_n,
    input a,
    
    output reg rise,
    output reg down
);

    // Register to hold the previous state of 'a'
    reg a_dly;

    // Always block sensitive to the clock and asynchronous reset
    // It detects edges and updates outputs accordingly.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Asynchronous reset: initialize a_dly, rise, and down registers
            a_dly <= 1'b0;
            rise  <= 1'b0;
            down  <= 1'b0;
        end else begin
            // Detect a rising edge: previous 'a' low and current 'a' high
            rise <= (~a_dly & a);
            // Detect a falling edge: previous 'a' high and current 'a' low
            down <= (a_dly & ~a);
            
            // Update the delayed version of 'a' for next cycle edge detection
            a_dly <= a;
        end
    end

endmodule