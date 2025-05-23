module radix2_div(
    input wire clk,
    input wire rst,
    input wire [7:0] dividend,    
    input wire [7:0] divisor,    
    input wire sign,       

    input wire opn_valid,   
    output reg res_valid,   
    input wire res_ready,   
    output reg [15:0] result
);

    reg [7:0] abs_dividend;
    reg [7:0] abs_divisor;
    reg [7:0] neg_divisor;
    reg [8:0] sr; // Shift register with one extra bit for carry
    reg [3:0] cnt; // 4-bit counter to count the division steps
    reg start_cnt;

    // Determine absolute values and negation based on signed/unsigned operation
    wire [7:0] final_dividend = sign && dividend[7] ? ~dividend + 1 : dividend;
    wire [7:0] final_divisor = sign && divisor[7] ? ~divisor + 1 : divisor;
    wire divisor_is_zero = (divisor == 0);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res_valid <= 0;
            cnt <= 0;
            start_cnt <= 0;
            result <= 0;
        end else begin
            if (opn_valid && !res_valid) begin
                if (!divisor_is_zero) begin
                    abs_dividend <= final_dividend;
                    abs_divisor <= final_divisor;
                    neg_divisor <= ~abs_divisor + 1; // Negate the absolute value of the divisor
                    sr <= {1'b0, abs_dividend}; // Initialize shift register with dividend
                    cnt <= 0;
                    start_cnt <= 1; // Start the division process
                    res_valid <= 0; // Reset the result valid flag
                end else begin
                    // Division by zero case handling if necessary
                    result <= 16'hFFFF; // Indicating invalid operation (custom behavior)
                    res_valid <= 1; // Mark result as valid immediately even for error
                end
            end else if (start_cnt) begin
                if (cnt == 8) begin
                    start_cnt <= 0;
                    res_valid <= 1; // Mark result as valid
                    // Capture final result with quotient and remainder
                    result <= {sr[8:1], sr[0]}; // Upper 8 bits for remainder, lower for quotient
                end else begin
                    cnt <= cnt + 1;
                    // Perform division process here
                    sr <= {sr[7:0], 1'b0}; // Shift left
                    if (sr[8:1] >= abs_divisor) begin
                        sr[8:1] <= sr[8:1] + neg_divisor; // Subtract neg_divisor
                        sr[0] <= 1; // Set quotient bit
                    end else begin
                        sr[0] <= 0; // Clear quotient bit
                    end
                end
            end

            // If result is ready and consumed, clear the valid flag
            if (res_ready && res_valid) begin
                res_valid <= 0; // Clear res_valid for the next operation
            end
        end
    end
endmodule