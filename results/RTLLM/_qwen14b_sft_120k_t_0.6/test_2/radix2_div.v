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

    reg [7:0] SR; // Shift register
    reg [7:0] NEG_DIVISOR; // Negated divisor
    reg [3:0] cnt; // Counter
    reg start_cnt; // Start counter flag
    reg [15:0] temp_result; // Temporary result storage

    // Combinational logic to handle division operation
    always @(*) begin
        if (start_cnt) begin
            if (cnt == 4'b1000) begin // Counter reaches 8
                temp_result[15:8] = SR; // Store remainder in upper 8 bits
                temp_result[7:0] = SR[7]; // Store quotient in lower 8 bits
                res_valid = 1'b1; // Set result valid
                start_cnt = 1'b0; // Stop counter
            end else begin
                cnt <= cnt + 1'b1; // Increment counter
                SR = SR << 1; // Shift left
                SR[0] = SR[7] ^ (SR[7] & (SR[7] ^ NEG_DIVISOR[7])); // Update based on subtraction result
            end
        end
    end

    // Sequential logic to manage operation and reset
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR <= 8'b0; // Reset shift register
            NEG_DIVISOR <= 8'b0; // Reset negated divisor
            cnt <= 4'b0; // Reset counter
            start_cnt <= 1'b0; // Reset start counter
            res_valid <= 1'b0; // Reset result valid
            result <= 16'b0; // Reset result
        end else if (opn_valid && !res_valid) begin
            SR <= sign ? $signed(dividend) << 1 : dividend << 1; // Shift dividend left
            NEG_DIVISOR <= sign ? -$signed(divisor) : ~divisor + 1; // Negate divisor
            cnt <= 4'b0; // Reset counter
            start_cnt <= 1'b1; // Start counter
        end else if (res_valid && res_ready) begin
            res_valid <= 1'b0; // Clear result valid
        end
    end

    assign result = temp_result; // Assign result

endmodule