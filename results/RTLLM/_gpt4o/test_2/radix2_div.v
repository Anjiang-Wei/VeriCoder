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

    // Internal registers and wires
    reg [16:0] SR;                    // Shift register to hold intermediate results
    reg [7:0] abs_dividend;           // Absolute value of dividend
    reg [7:0] abs_divisor;            // Absolute value of divisor
    reg [7:0] NEG_DIVISOR;            // 2's complement of absolute divisor
    reg [3:0] cnt;                    // 4-bit counter (to count up to 8)
    reg start_cnt;                    // Start count signal
    reg dividend_neg;                 // Sign of dividend
    reg divisor_neg;                  // Sign of divisor
    wire signed [8:0] subtraction;    // Subtraction result (including carry)
    reg op_done;                      // Operation complete flag
    
    // Step 1: Handle reset and result availability
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res_valid <= 1'b0;
            op_done   <= 1'b0;
            cnt       <= 1'b0;
            SR        <= 17'b0;
            start_cnt <= 1'b0;
        end else begin
            if (opn_valid && !res_valid && !start_cnt) begin
                // Save inputs when operation is valid and not busy
                abs_dividend <= sign ? (dividend[7] ? -dividend : dividend) : dividend;
                abs_divisor <= sign ? (divisor[7] ? -divisor : divisor) : divisor;
                NEG_DIVISOR <= sign ? ((divisor[7] ? -divisor : divisor) ^ 8'hFF) + 8'h01 : (~divisor + 1'b1);
                dividend_neg <= sign ? dividend[7] : 1'b0;
                divisor_neg <= sign ? divisor[7] : 1'b0;
                SR <= {1'b0, (sign ? (dividend[7] ? -dividend : dividend) : dividend), 8'b0}; // Initialize shift register
                cnt <= 4'b1; // Start counting
                start_cnt <= 1'b1;
            end else if (start_cnt) begin
                if (cnt == 4'd8) begin
                    // Finished division
                    cnt <= 4'b0;
                    start_cnt <= 1'b0;
                    op_done <= 1'b1; // Mark operation as done
                    SR <= {SR[16:9], (dividend_neg ^ divisor_neg ? -SR[8:0] : SR[8:0])}; // Apply the sign to the quotient
                end else begin
                    // Perform the division iteration
                    cnt <= cnt + 1'b1;
                    if (SR[16:9] + NEG_DIVISOR[7:0] >= 0) begin
                        // Subtraction with carry-out (non-negative remainder)
                        SR <= {SR[16:9] + NEG_DIVISOR[7:0], SR[8:1], 1'b1};
                    end else begin
                        // No subtraction, shift quotient accordingly
                        SR <= {SR[16:9], SR[8:1], 1'b0};
                    end
                end
            end

            // Manage result validity flag
            if (op_done) begin
                if (res_ready) begin
                    res_valid <= 1'b0;
                    op_done <= 1'b0;
                end else begin
                    res_valid <= 1'b1;
                end
            end else begin
                res_valid <= 1'b0;
            end
        end
    end

    // Output result: {Remainder[15:8], Quotient[7:0]}
    assign result = SR[16:1];

endmodule