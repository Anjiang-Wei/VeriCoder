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
    reg [15:0] SR; // Shift register
    reg [7:0] NEG_DIVISOR;
    reg [3:0] cnt; // Counter
    reg start_cnt;
    reg [7:0] abs_dividend;
    reg [7:0] abs_divisor;
    reg [7:0] remainder;
    reg [7:0] quotient;

    // Calculate absolute values
    always @(*) begin
        abs_dividend = sign ? $signed(dividend) : dividend;
        abs_divisor = sign ? $signed(divisor) : divisor;
        if (sign && $signed(dividend) < 0) abs_dividend = -abs_dividend;
        if (sign && $signed(divisor) < 0) abs_divisor = -abs_divisor;
        NEG_DIVISOR = -abs_divisor;
    end

    // Main process
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR <= 16'b0;
            cnt <= 4'b0;
            start_cnt <= 1'b0;
            res_valid <= 1'b0;
            remainder <= 8'b0;
            quotient <= 8'b0;
        end else begin
            if (opn_valid && !res_valid && res_ready) begin
                // Initialize shift register and counter
                SR <= {abs_dividend, 1'b0};
                cnt <= 4'b0;
                start_cnt <= 1'b1;
            end else if (start_cnt) begin
                if (cnt == 4'b1111) begin
                    // Division complete
                    start_cnt <= 1'b0;
                    res_valid <= 1'b1;
                    remainder <= SR[15:8];
                    quotient <= SR[7:0];
                end else begin
                    // Perform division
                    cnt <= cnt + 1;
                    reg [7:0] sub_result;
                    reg carry_out;

                    // Subtraction
                    sub_result = SR[15:8] + NEG_DIVISOR;
                    carry_out = sub_result[7];

                    // Update shift register
                    SR <= {carry_out, SR[15:1]};
                    if (!carry_out) begin
                        SR[7:0] <= SR[7:0] + abs_divisor;
                    end
                end
            end else if (res_valid && res_ready) begin
                res_valid <= 1'b0;
            end
        end
    end

    // Assign result
    assign result = {remainder, quotient};

endmodule