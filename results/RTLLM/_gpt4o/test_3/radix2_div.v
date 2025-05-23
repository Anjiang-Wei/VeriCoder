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

    // Internal registers
    reg [15:0] SR;           // Shift register to store intermediate state
    reg [7:0] abs_dividend;  // Absolute value of the dividend
    reg [7:0] abs_divisor;   // Absolute value of the divisor
    reg [7:0] NEG_DIVISOR;   // Negated absolute value of the divisor
    reg op_sign;             // Sign of the output result
    reg [3:0] cnt;           // 4-bit counter for 8 iterations (radix-2 division requires 8 steps)
    reg start_cnt;           // Indicates if division process is ongoing

    // Wires for intermediate calculations
    wire [15:0] SR_sub;      // Subtraction result (Shift register - NEG_DIVISOR)
    wire carry_out;          // Carry out of subtraction operation

    // Compute absolute values (avoid overflow for signed numbers)
    assign abs_dividend = (sign && dividend[7]) ? (~dividend + 1'b1) : dividend;
    assign abs_divisor  = (sign && divisor[7]) ? (~divisor + 1'b1) : divisor;

    // Perform subtraction (SR[15:8] - NEG_DIVISOR)
    assign SR_sub = {SR[14:7], 1'b0} - {1'b0, NEG_DIVISOR};
    assign carry_out = ~SR_sub[15];  // Carry out is valid if MSB of result is 0

    // Result output (Lower 8 bits = quotient, Upper 8 bits = remainder)
    assign result = SR;

    // Main process
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset state
            SR <= 16'b0;
            NEG_DIVISOR <= 8'b0;
            cnt <= 4'b0;
            start_cnt <= 1'b0;
            res_valid <= 1'b0;
        end else begin
            if (opn_valid && !res_valid && !start_cnt) begin
                // Start of operation: Initialize state on operation valid signal
                if (divisor != 8'b0) begin
                    SR <= {8'b0, abs_dividend, 1'b0}; // Load shifted dividend (1 left shift)
                    NEG_DIVISOR <= ~abs_divisor + 1'b1; // Negated divisor
                    op_sign <= sign && (dividend[7] ^ divisor[7]); // Compute output sign
                    cnt <= 4'b1; // Initialize counter to first step
                    start_cnt <= 1'b1; // Start the operation
                end else begin
                    // Division by zero case (optional)
                    SR <= 16'b0;
                    res_valid <= 1'b1;
                end
            end else if (start_cnt) begin
                // Division process
                if (&cnt) begin // If cnt reaches 8 (all ones for a 4-bit counter)
                    start_cnt <= 1'b0; // Stop the process
                    cnt <= 4'b0;
                    res_valid <= 1'b1; // Result ready

                    // Combine final remainder and quotient and apply sign if signed division
                    if (op_sign) begin
                        // Add signs to both quotient/remainder results
                        SR[7:0]   <= ~SR[7:0] + 1'b1;    // Signed quotient
                        SR[15:8]  <= ~SR[15:8] + 1'b1;   // Signed remainder
                    end
                end else begin
                    // Intermediate step of division process
                    cnt <= cnt + 4'b1;

                    // Perform radix-2 update
                    if (carry_out) begin
                        SR <= {SR_sub[14:0], 1'b1};
                    end else begin
                        SR <= {SR[14:0], 1'b0};
                    end
                end
            end else if (res_valid && res_ready) begin
                // Result has been consumed, clear res_valid
                res_valid <= 1'b0;
            end
        end
    end

endmodule