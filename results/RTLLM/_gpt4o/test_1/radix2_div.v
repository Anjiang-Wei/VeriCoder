module radix2_div(
    input wire clk,
    input wire rst,
    input wire [7:0] dividend,
    input wire [7:0] divisor,
    input wire sign,
    input wire opn_valid,
    output reg res_valid,
    input wire res_ready,
    output wire [15:0] result
);

    // Registers and wires
    reg [15:0] shift_reg;       // Shift register to store intermediate result
    reg [7:0] abs_dividend;     // Absolute value of dividend
    reg [7:0] abs_divisor;      // Absolute value of divisor
    reg [7:0] neg_divisor;      // Negative absolute value of divisor for complement subtraction
    reg [3:0] cnt;              // Counter for iterations
    reg start_cnt;              // Indicates division is ongoing
    reg dividend_sign;          // Sign of the dividend
    reg divisor_sign;           // Sign of the divisor
    
    wire [7:0] quotient;        // Lower 8-bits of the shift_reg (Quotient)
    wire [7:0] remainder;       // Upper 8-bits of the shift_reg (Remainder)
    reg op_valid_d;             // Latched opn_valid
    reg result_sign;            // Sign of the final result (for signed operations)

    assign quotient = shift_reg[7:0];    // Lower part of shift_reg is the quotient
    assign remainder = shift_reg[15:8]; // Upper part of shift_reg is the remainder
    assign result = {remainder, quotient}; // Final result as {remainder, quotient}

    // Reset and initialization
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 16'b0;
            abs_dividend <= 8'b0;
            abs_divisor <= 8'b0;
            neg_divisor <= 8'b0;
            cnt <= 4'b0;
            start_cnt <= 1'b0;
            res_valid <= 1'b0;
            op_valid_d <= 1'b0;
            dividend_sign <= 1'b0;
            divisor_sign <= 1'b0;
            result_sign <= 1'b0;
        end else begin
            op_valid_d <= opn_valid;

            // Start operation
            if (opn_valid && !start_cnt && !res_valid) begin
                // Save signs for signed operation
                if (sign) begin
                    dividend_sign <= dividend[7]; // MSB is sign bit
                    divisor_sign <= divisor[7];   // MSB is sign bit
                end else begin
                    dividend_sign <= 1'b0;
                    divisor_sign <= 1'b0;
                end

                // Compute absolute values of inputs
                abs_dividend <= sign && dividend[7] ? (~dividend + 1) : dividend;
                abs_divisor <= sign && divisor[7] ? (~divisor + 1) : divisor;

                neg_divisor <= ~((sign && divisor[7] ? (~divisor + 1) : divisor)) + 1;

                // Initialize shift register and counters
                shift_reg <= {8'b0, sign && dividend[7] ? (~dividend + 1) : dividend};
                cnt <= 4'b1;
                start_cnt <= 1'b1;
                res_valid <= 1'b0;
            end
            // Handle division through successive iterations
            else if (start_cnt) begin
                if (cnt == 4'd8) begin
                    // Final iteration
                    start_cnt <= 1'b0;
                    res_valid <= 1'b1;
                    
                    // Compute signed result if necessary
                    if (sign && (dividend_sign ^ divisor_sign))
                        shift_reg[7:0] <= ~shift_reg[7:0] + 1; // Invert quotient for signed division
                    
                    if (sign && dividend_sign)
                        shift_reg[15:8] <= ~shift_reg[15:8] + 1; // Invert remainder for signed division
                    
                end else begin
                    // Subtract divisor and shift left
                    if (shift_reg[15:8] >= abs_divisor)
                        shift_reg <= {shift_reg[14:0], 1'b1} - {abs_divisor, 8'b0};
                    else
                        shift_reg <= {shift_reg[14:0], 1'b0};
                    cnt <= cnt + 1;
                end
            end
            
            // Clear result when consumed
            if (res_ready && res_valid) begin
                res_valid <= 1'b0;
            end
        end
    end
endmodule