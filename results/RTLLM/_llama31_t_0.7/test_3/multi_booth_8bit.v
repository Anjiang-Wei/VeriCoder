`timescale 1ns / 1ps

module multi_booth_8bit (
    output reg signed [15:0] p,     // Product of a and b
    output rdy,                     // Ready signal indicating completion of multiplication operation
    input clk,                      // Clock signal used for synchronous operation
    input reset                     // Reset signal used to initialize the multiplier module
);

reg [7:0] multiplicand;           // 8-bit multiplicand register
reg signed [15:0] multiplier;     // 16-bit multiplier register with Booth encoding

reg [4:0] ctr;                    // Counter for Radix-4 Booth algorithm (5 bits)
reg [3:0] current_multiplier_bit; // Current bit of the multiplier register used in Booth encoding

wire rdy_sig;                     // Internal ready signal indicating completion of multiplication operation
wire sign_multiplier, sign_multiplicand;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        multiplicand <= {{8{1'b0}}, a};  // Initialize multiplicand register with input 'a' on reset
        multiplier <= {{8{1'b0}}, b};   // Initialize multiplier register with input 'b' on reset
        ctr <= 5'd0;                     // Reset counter to 0 on reset
    end else begin
        case (ctr)
            5'h3: begin
                if (multiplier[4]) begin
                    p = {p[14:0], multiplicand, 1'b0};   // Accumulate value of multiplicand register when positive Booth encoding is encountered
                end else begin
                    p = {p[14:0], -multiplicand, 1'b0};  // Accumulate negated value of multiplicand register when negative Booth encoding is encountered
                end
            end

            5'h2: begin
                if (multiplier[3]) begin
                    p = {p[14:0], multiplicand, 1'b0};   // Accumulate value of multiplicand register when positive Booth encoding is encountered
                end else begin
                    p = {p[14:0], -multiplicand, 1'b0};  // Accumulate negated value of multiplicand register when negative Booth encoding is encountered
                end

            end

            default: begin
                if (multiplier[ctr]) begin
                    p = {p[15:0] + multiplicand, 1'b0};   // Accumulate value of multiplicand register when positive Booth encoding is encountered
                end else begin
                    p = {p[15:0] - multiplicand, 1'b0};  // Accumulate negated value of multiplicand register when negative Booth encoding is encountered
                end

            end
        endcase

        current_multiplier_bit <= multiplier[ctr];
        ctr <= ctr + 5'd1;

        if (ctr == 15) begin
            rdy_sig <= 1'b1;           // Set internal ready signal to indicate completion of multiplication operation when counter reaches 16
        end else begin
            rdy_sig <= 1'b0;
        end

        multiplicand <= {multiplicand[7:0], multiplicand[15:8]}; // Left shift the multiplicand register by 1 bit for Booth algorithm's shifting operation
    end
end

assign p = multiplier; // Assign product from multiplier register to output port
assign rdy = rdy_sig;   // Assign internal ready signal to output port