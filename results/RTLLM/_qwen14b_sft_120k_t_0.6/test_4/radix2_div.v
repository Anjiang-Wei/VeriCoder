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
    reg [15:0] SR; // Shift register
    reg [7:0] NEG_DIVISOR; // Negated divisor
    reg [3:0] cnt; // Counter
    reg start_cnt; // Start counter flag
    reg [7:0] dividend_abs, divisor_abs; // Absolute values

    // Combinational logic to compute absolute values
    always @(*) begin
        dividend_abs = sign ? -dividend : dividend;
        divisor_abs = divisor;
    end

    // Sequential logic for division process
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR <= 16'b0;
            NEG_DIVISOR <= 8'b0;
            cnt <= 4'b0;
            start_cnt <= 1'b0;
            res_valid <= 1'b0;
        end else begin
            if (opn_valid && !res_valid) begin
                // Save inputs and initialize
                SR <= {dividend_abs, 1'b0}; // Shift left by 1
                NEG_DIVISOR <= -divisor_abs;
                cnt <= 4'b0001;
                start_cnt <= 1'b1;
            end else if (res_ready && res_valid) begin
                res_valid <= 1'b0;
            end else if (start_cnt) begin
                if (cnt == 4'b1000) begin
                    // Division complete
                    start_cnt <= 1'b0;
                    cnt <= 4'b0;
                    res_valid <= 1'b1;
                end else begin
                    cnt <= cnt + 1'b1;
                    // Perform subtraction and update SR
                    SR <= {{1'b0, SR[15:1]}, SR[0] ^ (SR[15] ^ SR[14] ^ SR[13] ^ SR[12] ^ SR[11] ^ SR[10] ^ SR[9] ^ SR[8])};
                end
            end
        end
    end

    // Assign result
    assign result = SR;

endmodule