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

    // Internal signals
    reg [15:0] sr; // Shift register
    reg [7:0] neg_divisor;
    reg [3:0] cnt;
    reg start_cnt;
    reg [7:0] abs_dividend;
    reg [7:0] abs_divisor;

    // Determine absolute values
    always @(*) begin
        abs_dividend = sign ? $signed(dividend) : dividend;
        abs_divisor = sign ? $signed(divisor) : divisor;
        neg_divisor = sign ? -abs_divisor : -divisor;
    end

    // State machine for division process
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sr <= 16'b0;
            cnt <= 4'b0;
            start_cnt <= 1'b0;
            res_valid <= 1'b0;
        end else begin
            if (opn_valid && !res_valid) begin
                // Initialize shift register and other variables
                sr <= {abs_dividend, 1'b0}; // Shift left by one bit
                cnt <= 4'b0;
                start_cnt <= 1'b1;
            end else if (start_cnt) begin
                if (cnt == 4'b1111) begin
                    // Division is complete
                    start_cnt <= 1'b0;
                    res_valid <= 1'b1;
                    result <= {sr[15:8], sr[7:0]};
                end else begin
                    // Perform division steps
                    cnt <= cnt + 1;
                    sr <= {sr[14:0], sr[15] ^ (sr[15:8] + neg_divisor[7:0] == 8'b0)};
                end
            end else if (res_valid && res_ready) begin
                res_valid <= 1'b0;
            end
        end
    end

endmodule