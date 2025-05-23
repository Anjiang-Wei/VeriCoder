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

// Initialize variables and shift register
always @(posedge clk or negedge rst) begin
    if (rst) begin
        dividend <= 0;
        divisor <= 0;
        sign <= 0;
        opn_valid <= 0;
        res_valid <= 0;
    end else begin
        if (opn_valid && res_ready) begin
            // Save inputs and update shift register
            dividend <= {dividend, divisor};
            sign <= sign;
            opn_valid <= 0;
            res_valid <= 1;
        end
    end
end

// Division process
always @* begin
    // Initialize counter and start counter
    cnt <= 1;
    start_cnt <= 1;

    // Loop until division is complete
    while (cnt > 0) begin
        // Update shift register based on carry-out
        if (start_cnt) begin
            // Subtraction of NEG_DIVISOR
            result <= {result[7:0], neg_divisor};
            start_cnt <= 0;
        end else begin
            // Shift left and insert carry-out
            result <= {result[7:0], carry_out};
            cnt <= cnt - 1;
        end

        // Update counter and start counter
        if (cnt == 8) begin
            cnt <= 0;
            start_cnt <= 0;
        end else begin
            cnt <= cnt + 1;
            start_cnt <= start_cnt + 1;
        end
    end
end

// Result validity management
always @(posedge clk or negedge rst) begin
    if (rst) begin
        res_valid <= 0;
    end else begin
        if (opn_valid && res_ready) begin
            res_valid <= 1;
        end
    end
end

// Output signal for result
output wire [15:0] result;