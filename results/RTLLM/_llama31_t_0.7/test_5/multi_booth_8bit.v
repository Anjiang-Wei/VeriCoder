`timescale 1ns / 1ps

module multi_booth_8bit (
    output reg [15:0] p, // product
    output rdy,          // ready signal
    input clk,           // clock signal
    input reset          // reset signal
);

reg [7:0] a, b;        // multiplicand and multiplier
reg [31:0] multiplier;  // expanded multiplier
reg [15:0] multiplicand;// register for multiplicand

// 5-bit counter to track the number of iterations in Booth algorithm
reg [4:0] ctr;

// Initialize registers on reset
always @(posedge reset)
    begin
        p <= 16'd0;
        ctr <= 5'd0;
        a <= 8'd0;
        b <= 8'd0;
        multiplier <= {{24{1'b0}}, {8'd0}, {8'd0}};
    end

// Perform multiplication on positive edge of clock or reset
always @(posedge clk)
begin
    // Load inputs into registers on reset
    if (reset == 1'b1) begin
        a <= b;
        b <= a;
    end
    
    // Check if counter has reached 16 iterations
    else if (ctr < 16) begin
        // Left shift multiplicand register to simulate Booth algorithm's shifting operation
        multiplicand[15:8] <= {multiplicand[7:0], 1'b0};
        
        // Check current bit of multiplier register for positive Booth encoding
        if (multiplier[(5+ctr)][4:0] == 8'h01) begin
            p[15:0] <= p[15:0] + multiplicand;
        end
        
        // Increment counter and load next bits from multiplier register
        ctr <= ctr + 1'b1;
        
    end
    
    // Set ready signal to 1 when multiplication process completes
    else if (ctr == 16) begin
        rdy <= 1'b1;
    end
end

// Load initial inputs into registers on reset or clock edge
always @(posedge clk)
begin
    multiplier[(5+ctr)][4:0] <= b[7:4];
    a <= a;
    b <= b;
end

endmodule