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

    // Internal signals
    reg [15:0] shift_reg; // Holds the current shifted remainder and quotient
    reg [7:0] abs_dividend, abs_divisor; // Absolute values of dividend and divisor
    reg [7:0] neg_divisor; // Negated version of the absolute divisor
    reg [3:0] cnt; // Counter for 8 iterations
    reg start_cnt; // Indicates operation is in progress
    reg dividend_sign, divisor_sign; // Signs of the dividend and divisor
    wire signed [7:0] signed_dividend, signed_divisor; // 2's complement signed versions of input
    wire [7:0] subtraction_res; // Result of subtraction
    wire subtraction_carry; // Carry resulting from subtraction
    
    // Assign outputs
    assign result = (sign && dividend_sign ^ divisor_sign) ? 
                    {shift_reg[15:8], ~shift_reg[7:0] + 1} : shift_reg; // If signed, adjust quotient
    assign subtraction_res = shift_reg[15:8] + neg_divisor; // Subtract divisor
    assign subtraction_carry = subtraction_res[7]; // MSB determines subtraction carry (negative or non-negative)
    
    // Reset behavior and pipeline initialization
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 16'd0;
            abs_dividend <= 8'd0;
            abs_divisor <= 8'd0;
            neg_divisor <= 8'd0;
            cnt <= 4'd0;
            start_cnt <= 1'b0;
            res_valid <= 1'b0;
            dividend_sign <= 1'b0;
            divisor_sign <= 1'b0;
        end else begin
            // Begin transaction when opn_valid and operation is not ongoing
            if (opn_valid && !start_cnt) begin
                // Detect input signs and compute absolute values if signed division
                dividend_sign <= (sign && dividend[7]);
                divisor_sign <= (sign && divisor[7]);
                abs_dividend <= sign ? (dividend[7] ? ~dividend + 1 : dividend) : dividend;
                abs_divisor <= sign ? (divisor[7] ? ~divisor + 1 : divisor) : divisor;
                neg_divisor <= ~(sign ? (divisor[7] ? ~divisor + 1 : divisor) : divisor) + 1; // -divisor
                
                // Initialize shift register and counter for 8 iterations
                shift_reg <= {8'd0, abs_dividend}; // Load dividend in lower 8 bits, remainder is zero
                cnt <= 4'd1; // Initialize iteration counter
                start_cnt <= 1'b1; // Signal that operation is ongoing
                res_valid <= 1'b0; // Result is not valid yet
            end

            // Division process
            if (start_cnt) begin
                if (cnt == 4'd9) begin // Completed 8 iterations (cnt reaches 9)
                    cnt <= 4'd0;
                    start_cnt <= 1'b0; // Stop division operation
                    // Final remainder and quotient are in the shift_reg
                    res_valid <= 1'b1; // Result is now valid
                end else begin
                    // Perform one iteration of radix-2 division
                    if (!subtraction_carry) begin
                        // Successful subtraction, update remainder and set quotient bit
                        shift_reg <= {subtraction_res[7:0], shift_reg[7:0], 1'b1};
                    end else begin
                        // Unsuccessful subtraction, shift and keep quotient bit as 0
                        shift_reg <= {shift_reg[14:0], 1'b0};
                    end
                    cnt <= cnt + 1; // Increment iteration counter
                end
            end

            // Reset res_valid if result is consumed
            if (res_ready) begin
                res_valid <= 1'b0;
            end
        end
    end

endmodule