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
    reg [7:0] shift_reg; // Shift register (SR)
    reg [7:0] quotient;
    reg [7:0] remainder;
    reg [8:0] neg_divisor; // For signed division
    reg [3:0] cnt;
    reg start_cnt;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res_valid <= 0;
            cnt <= 0;
            start_cnt <= 0;
            result <= 0;
            shift_reg <= 0;
            quotient <= 0;
            remainder <= 0;
        end else if (opn_valid && !res_valid) begin
            // Load input values
            abs_dividend <= (sign && dividend[7]) ? ~dividend + 1 : dividend; // Absolute value
            abs_divisor <= (sign && divisor[7]) ? ~divisor + 1 : divisor; // Absolute value
            neg_divisor <= (sign && divisor[7]) ? {1'b1, ~abs_divisor + 1} : {1'b0, abs_divisor}; // For signed division
            
            // Initialize shift register and start counters
            shift_reg <= abs_dividend << 1; // Shift left once
            cnt <= 0;
            start_cnt <= 1;
            res_valid <= 0;
        end else if (start_cnt) begin
            if (cnt < 8) begin
                // Determine if we can subtract
                if (shift_reg[8:1] >= neg_divisor) begin
                    shift_reg[8:1] <= shift_reg[8:1] + neg_divisor; // Subtract
                    quotient[cnt] <= 1; // Set quotient bit
                end else begin
                    quotient[cnt] <= 0; // Don't set quotient bit
                end
                
                // Shift left for the next iteration
                shift_reg <= {shift_reg[7:0], 1'b0}; // Shift left
                cnt <= cnt + 1;
            end else begin
                // Division complete
                start_cnt <= 0;
                remainder <= shift_reg[8:1]; // Final remainder
                if (sign && (dividend[7] ^ divisor[7])) begin
                    quotient <= ~quotient + 1; // Negate quotient if signs are different
                end
                result <= {remainder, quotient}; // Store result
                res_valid <= 1; // Set result valid
            end
        end else if (res_ready && res_valid) begin
            res_valid <= 0; // Indicate result has been consumed
        end
    end

endmodule