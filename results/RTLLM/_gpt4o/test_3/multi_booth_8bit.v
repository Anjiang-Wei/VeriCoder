`timescale 1ns / 1ps

module multi_booth_8bit (
    output reg [15:0] p,
    output reg rdy,
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b
);

    // Internal signals and registers
    reg [15:0] multiplicand;   // Holds the multiplicand with sign extension
    reg [15:0] multiplier;     // Holds the multiplier with sign extension
    reg [15:0] product;        // Accumulator for the product
    reg [4:0] ctr;             // 5-bit counter to track iterations
    reg [2:0] booth_group;     // Holds the Booth-encoded group (2 bits)
   
    // Initialize all on reset or start operation
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand <= {{8{a[7]}}, a}; // Sign-extend multiplicand (a)
            multiplier <= {{8{b[7]}}, b};   // Sign-extend multiplier (b)
            product <= 16'h0;               // Initialize the product
            ctr <= 0;                       // Reset counter
            rdy <= 0;                       // Not ready initially
        end else begin
            if (ctr < 8) begin
                // Extract Booth group of multiplier bits [ctr+1, ctr, ctr-1]
                booth_group <= {multiplier[ctr+1], multiplier[ctr], multiplier[ctr-1]};
                
                // Evaluate Booth encoding and update product
                case (booth_group)
                    3'b001, 3'b010: product <= product + multiplicand;         // +Multiplicand
                    3'b011:         product <= product + (multiplicand << 1);  // +2 * Multiplicand
                    3'b100:         product <= product - (multiplicand << 1);  // -2 * Multiplicand
                    3'b101, 3'b110: product <= product - multiplicand;         // -Multiplicand
                    // 3'b000 or 3'b111: Do nothing (0)
                    default: ;
                endcase
                
                // Right shift the multiplier and shift multiplicand left
                multiplicand <= multiplicand << 1;
                multiplier <= {multiplier[15], multiplier[15:1]}; // Arithmetic shift
                
                // Increment the counter
                ctr <= ctr + 1;
            end else begin
                // Process complete; output the result and set ready signal
                p <= product; // Assign product to output
                rdy <= 1;     // Set ready signal
            end
        end
    end

endmodule