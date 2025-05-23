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

// Signals used for division process management
reg signed [7:0] abs_dividend;
reg signed [7:0] neg_divisor;
reg signed [8:0] shift_register; // Includes remainder and quotient bits
reg signed cnt, start_cnt;
reg signed shift_in;

// Result signal preparation
reg signed [15:0] temp_result;

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        abs_dividend <= 0;
        neg_divisor <= 0;
        shift_register <= 0;
        cnt <= 1'b0;
        start_cnt <= 1'b0;
        res_valid <= 1'b0;
    end else if (opn_valid && !res_valid) begin // Operation Start
        abs_dividend <= (sign == 1'b1 ? -dividend : dividend);
        neg_divisor <= (sign == 1'b1 ? -divisor : divisor);
        shift_register <= {abs_dividend, 1'b0};
        cnt <= 9'd1;
        start_cnt <= 1'b1;
    end else if (start_cnt) begin // Division Process
        if (cnt[7]) begin // Most significant bit of cnt set means division complete
            res_valid <= 1'b1; // Result is valid and ready to be consumed
            result <= {shift_register[8:1], shift_register[0]};
            cnt <= 9'd0;
            start_cnt <= 1'b0;
        end else begin
            reg signed [7:0] sub_result;
            sub_result = (neg_divisor - shift_register) & (~neg_divisor);
            shift_in <= (sub_result > neg_divisor); // Carry-out for multiplexer selection
            shift_register <= {shift_in, shift_register[8:1]} << 1; // Shift left and insert carry-out
            cnt <= cnt + 9'd1;
        end
    end
end

// Manage res_valid based on result consumption
always_comb begin
    if (res_ready && res_valid) begin
        res_valid <= 1'b0;
    end else if (!opn_valid || !start_cnt) begin
        res_valid <= 1'b0;
    end
end

endmodule