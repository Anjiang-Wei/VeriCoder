module radix2_div (
    input wire clk,
    input wire rst,
    input wire [7:0] dividend,
    input wire [7:0] divisor,
    input wire sign,        // 1 for signed division, 0 for unsigned

    input wire opn_valid,
    output reg res_valid,
    input wire res_ready,
    output wire [15:0] result
);

    // Internal registers
    reg [15:0] sr;               // Shift Register
    reg [8:0] neg_divisor;       // 1-bit extended NEG_DIVISOR
    reg [8:0] abs_divisor;       // 1-bit extended absolute divisor
    reg [8:0] temp_result;       // Temporary subtraction result
    reg [3:0] cnt;               // 4-bit counter for cycle count (to support 8 cycles)
    reg sign_dividend, sign_divisor;  // Tracks the signs of inputs
    reg res_sign;                // Sign of the result, applicable if sign == 1
    reg start_cnt;               // Control signal to start the division process
    reg [7:0] quotient;          // Calculated quotient
    reg [7:0] remainder;         // Calculated remainder

    // Absolute value computation
    wire [7:0] abs_dividend = sign ? (dividend[7] ? -dividend : dividend) : dividend;
    wire [7:0] abs_divisor_init = sign ? (divisor[7] ? -divisor : divisor) : divisor;

    // Internal logic signals
    wire [8:0] abs_dividend_shifted = {1'b0, abs_dividend} << 1;  // Initial shifted dividend
    wire [7:0] final_quotient = (res_sign && sign) ? -quotient : quotient;
    wire [7:0] final_remainder = (sign_dividend && sign) ? -remainder : remainder;

    // Output assignment
    assign result = {final_remainder, final_quotient};

    // Process logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset logic
            sr <= 16'b0;
            neg_divisor <= 9'b0;
            abs_divisor <= 9'b0;
            temp_result <= 9'b0;
            cnt <= 4'b0;
            res_valid <= 1'b0;
            res_sign <= 1'b0;
            start_cnt <= 1'b0;
            quotient <= 8'b0;
            remainder <= 8'b0;
            sign_dividend <= 1'b0;
            sign_divisor <= 1'b0;
        end else if (opn_valid & ~start_cnt) begin
            // Latching inputs on operation valid signal
            res_valid <= 1'b0;
            sign_dividend <= dividend[7] & sign;
            sign_divisor <= divisor[7] & sign;
            res_sign <= (sign_dividend ^ sign_divisor) & sign;  // Result sign based on input signs
            sr <= abs_dividend_shifted;                         // Initialize shift register
            abs_divisor <= {1'b0, abs_divisor_init};            // Store extended absolute divisor
            neg_divisor <= ~{1'b0, abs_divisor_init} + 9'b1;    // Compute negative divisor
            cnt <= 4'b1;                                       // Initialize counter
            start_cnt <= 1'b1;                                 // Start division process
        end else if (start_cnt) begin
            // Perform the division process
            if (cnt == 4'd8) begin
                // Final step of division
                start_cnt <= 1'b0;  // Clear start signal
                cnt <= 4'b0;        // Reset counter
                remainder <= sr[15:8];  // Capture the final remainder
                quotient <= sr[7:0];   // Capture the final quotient
                res_valid <= 1'b1;     // Indicate result is ready
            end else begin
                // Division iterations
                cnt <= cnt + 4'b1;                          // Increment the counter
                temp_result = sr[15:8] + neg_divisor;       // Subtract divisor from MSBs of SR
                if (temp_result[8] == 1) begin
                    // MSBs < divisor case
                    sr <= {sr[14:0], 1'b0};                // Shift left and insert 0 as LSB
                end else begin
                    // MSBs >= divisor case
                    sr <= {temp_result[7:0], sr[7:0], 1'b1};  // Subtract, shift left, and insert 1
                end
            end
        end else if (res_valid && res_ready) begin
            // Result has been consumed
            res_valid <= 1'b0;      // Clear valid flag until next operation
        end
    end

endmodule