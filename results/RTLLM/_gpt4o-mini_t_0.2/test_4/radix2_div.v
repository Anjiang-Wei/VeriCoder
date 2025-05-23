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
    reg [7:0] shift_reg;
    reg [7:0] negative_divisor;
    reg [3:0] cnt;
    reg start_cnt;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res_valid <= 0;
            cnt <= 0;
            start_cnt <= 0;
            result <= 0;
            negative_divisor <= 0;
            shift_reg <= 0;
        end else if (opn_valid && !res_valid) begin
            // Save the dividend and divisor
            abs_dividend <= dividend;
            abs_divisor <= divisor;
            negative_divisor <= ~abs_divisor + 1; // Two's complement for negative
            shift_reg <= abs_dividend << 1; // Initialize the shift register
            cnt <= 1;
            start_cnt <= 1;
            res_valid <= 0;
        end else if (start_cnt) begin
            if (cnt >= 8) begin
                // Final result assignment
                result <= {shift_reg, abs_dividend[7:0]} + (shift_reg > 0 ? 1 : 0);
                if (sign) begin
                    // Adjust sign for signed division
                    if ((dividend[7] ^ divisor[7]) == 1) result[15:8] = ~result[15:8] + 1; // Negate remainder
                end
                res_valid <= 1; // Result is valid now
                start_cnt <= 0; // Stop counting
            end else begin
                // Division process
                shift_reg = {shift_reg[6:0], 1'b0}; // Left shift
                if (shift_reg >= abs_divisor) begin
                    shift_reg = shift_reg + negative_divisor; // Subtract divisor
                    result[7:0] = result[7:0] + 1; // Increment quotient
                end
                cnt <= cnt + 1; // Increment counter
            end
        end else if (res_ready) begin
            res_valid <= 0; // Reset valid when ready for new operation
        end
    end

endmodule