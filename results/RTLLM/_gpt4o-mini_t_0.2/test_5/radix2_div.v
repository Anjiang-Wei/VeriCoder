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

    reg [8:0] SR; // Shift register (9 bits for remainder and quotient)
    reg [7:0] neg_divisor;
    reg [3:0] cnt, start_cnt; // Counter for bit shifts
    reg [7:0] A; // Remainder
    reg [7:0] Q; // Quotient
    reg operation; // Indicates operation start (1 for start, 0 for not started)

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR <= 9'b0;
            neg_divisor <= 8'b0;
            cnt <= 4'b0;
            start_cnt <= 4'b0;
            result <= 16'b0;
            res_valid <= 1'b0;
            operation <= 1'b0;
        end else begin
            if (opn_valid && !res_valid) begin
                // Load inputs
                SR <= {1'b0, dividend[7:0]} << 1; // Load dividend in SR (shift left)
                neg_divisor <= ~divisor + 1; // Negate divisor for signed case handling
                Q <= 8'b0; // Initialize quotient
                A <= 8'b0; // Initialize remainder
                cnt <= 4'b1; // Start counter
                start_cnt <= 4'b1; // Start processing
                operation <= 1'b1; // Operation is now started
                res_valid <= 1'b0; // Reset result valid flag
            end
            
            if (start_cnt) begin
                if (cnt == 8) begin
                    // Division completed
                    result <= {A, Q}; // Store result in output
                    res_valid <= 1'b1; // Set result valid
                    start_cnt <= 4'b0; // Clear start counter
                end else begin
                    // Perform division process
                    A <= SR[8:1]; // Get current remainder
                    if (A >= (sign ? (~divisor + 1) : divisor)) begin
                        A <= A + neg_divisor; // Subtract divisor from remainder
                        Q <= {Q[6:0], 1'b1}; // Set current bit of quotient
                    end else begin
                        Q <= {Q[6:0], 1'b0}; // No subtraction
                    end

                    // Shift left SR
                    SR <= {A[7:0], 1'b0}; // Shift remainder and quotient left
                    cnt <= cnt + 1; // Update counter
                end
            end
            
            // Reset res_valid when result is consumed
            if (res_ready) begin
                res_valid <= 1'b0; // Ready to accept new operation
            end
        end
    end
endmodule