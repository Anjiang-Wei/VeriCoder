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

    reg [15:0] SR; // Shift Register
    reg [7:0] NEG_DIVISOR; // Negated divisor
    reg [3:0] cnt; // Counter for division
    reg start_cnt; // Start counter initialization

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR <= 16'b0;
            cnt <= 4'b0;
            NEG_DIVISOR <= 8'b0;
            res_valid <= 1'b0;
            start_cnt <= 1'b0;
            result <= 16'b0;
        end else begin
            if (opn_valid && !res_valid) begin
                // Initialize for division operation
                SR <= {8'b0, dividend}; // Shift left the dividend
                NEG_DIVISOR <= sign ? ~divisor + 1'b1 : divisor; // Negate if signed
                cnt <= 4'b1; // Start counter
                start_cnt <= 1'b1; // Indicate that counter is starting
            end
            
            if (start_cnt) begin
                if (cnt == 4'b1000) begin // When counter reaches 8
                    // Division complete, set result and clear counters
                    result <= {SR[15:8], SR[7:0]}; // Upper 8 bits as remainder, lower 8 bits as quotient
                    res_valid <= 1'b1; // Result is valid
                    cnt <= 4'b0; // Clear counter
                    start_cnt <= 1'b0; // Stop counting
                end else begin
                    // Perform subtraction and shift
                    if (SR[15:8] >= NEG_DIVISOR) begin
                        SR[15:8] <= SR[15:8] - NEG_DIVISOR; // Remainder
                        SR <= {SR[14:0], 1'b1}; // Shift left and set quotient bit
                    end else begin
                        SR <= {SR[14:0], 1'b0}; // Shift left without changing remainder
                    end
                    
                    cnt <= cnt + 1; // Increment counter
                end
            end
            
            // Manage res_valid flag
            if (res_valid && res_ready) begin
                res_valid <= 1'b0; // Reset valid flag when the result is consumed
            end
        end
    end

endmodule