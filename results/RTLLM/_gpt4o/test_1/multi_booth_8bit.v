`timescale 1ns / 1ps

module multi_booth_8bit (
    output reg [15:0] p,       // 16-bit product output
    output reg rdy,           // Ready signal
    input clk,                // Clock signal
    input reset,              // Reset signal
    input [7:0] a,            // 8-bit multiplicand
    input [7:0] b             // 8-bit multiplier
);

    // Registers for multiplicand, multiplier, and control logic
    reg [15:0] multiplicand;  // Extended multiplicand (16-bit)
    reg [15:0] multiplier;    // Extended multiplier (16-bit)
    reg [4:0] ctr;            // 5-bit counter for 16 cycles (0-15)

    reg [31:0] booth_accum;   // 32-bit accumulator register for Booth's algorithm

    // Initialize on reset
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all registers
            multiplicand <= {{8{a[7]}}, a}; // Sign-extend a to 16 bits
            multiplier <= {{8{b[7]}}, b};   // Sign-extend b to 16 bits
            p <= 16'b0;
            booth_accum <= 32'b0;
            ctr <= 5'b0;
            rdy <= 1'b0;
        end else begin
            // Normal operation
            if (ctr < 16) begin
                // Booth's algorithm step
                case ({multiplier[1:0]})
                    2'b01: booth_accum = booth_accum + {{16{multiplicand[15]}}, multiplicand}; // Add
                    2'b10: booth_accum = booth_accum - {{16{multiplicand[15]}}, multiplicand}; // Subtract
                    default: ; // No operation
                endcase
                
                // Right shift accumulator and multiplier (arithmetic shift for signed handling)
                booth_accum = $signed(booth_accum) >>> 1;
                multiplier = $signed(multiplier) >>> 1;

                // Increment counter
                ctr <= ctr + 1;
            end else begin
                // Multiplication completed
                p <= booth_accum[15:0]; // Assign final product (lower 16 bits)
                rdy <= 1'b1;           // Set ready signal to 1
            end
        end
    end

endmodule