module edge_detect(
    input  wire          clk,        // Clock signal
    input  wire          rst_n,      // Reset signal (active low)
    input  wire          a,           // Input signal
    
    output reg           rise,       // Output signal indicating a rising edge
    output reg           down         // Output signal indicating a falling edge
);

// Rising edge detection
reg [1:0] prev_a;

always @(posedge clk) begin
    if (~rst_n) begin
        rise <= 0;
        down <= 0;
        prev_a <= 0;
    end else begin
        case (prev_a)
            2'b00: begin // previous two clock cycles were both low
                if (a == 1'b1)
                    rise <= 1; // rising edge detected
            end
            2'b10: begin // previous cycle was low, current is high
                down <= 1; // falling edge detected
            end
            default: begin
                prev_a <= {prev_a[0], a};
                rise <= 0;
                down <= 0;
            end
        endcase
    end
end

// Reset the state when rst_n is low
always @(posedge clk) begin
    if (~rst_n)
        prev_a <= 0;
end

endmodule // edge_detect