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

    reg [15:0] SR;
    reg [7:0] cnt;
    reg start_cnt;
    reg [15:0] NEG_DIVISOR;
    reg [7:0] abs_dividend;
    reg [7:0] abs_divisor;
    wire [15:0] subtraction_result;
    wire carry_out;

    // Assign absolute values to registers
    assign abs_dividend = sign ? -dividend : dividend;
    assign abs_divisor = sign ? -divisor : divisor;

    // Initialize shift register SR and NEG_DIVISOR with absolute values of dividend and negated divisor
    initial begin
        SR = {1'b0, abs_dividend};
        NEG_DIVISOR = {1'b0, abs_divisor};
    end

    // Subtraction logic
    assign subtraction_result = SR - NEG_DIVISOR;
    assign carry_out = SR[7:0] >= NEG_DIVISOR[7:0];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR <= 0;
            cnt <= 0;
            start_cnt <= 0;
            res_valid <= 0;
        end else if (opn_valid && !res_valid) begin
            SR <= {1'b0, abs_dividend};
            cnt <= 1;
            start_cnt <= 1;
            res_valid <= 0;
        end else if (start_cnt && cnt < 8) begin
            if (carry_out) begin
                SR <= {1'b0, SR[15:8], carry_out};
            end else begin
                SR <= {1'b0, subtraction_result};
            end
            cnt <= cnt + 1;
        end else if (start_cnt && cnt == 8) begin
            start_cnt <= 0;
            if (!sign || (sign && abs_dividend >= abs_divisor)) begin
                result <= {abs_dividend, 8'b0};
            end else begin
                result <= {abs_divisor, 8'b0};
            end
            res_valid <= res_ready;
        end
    end
endmodule