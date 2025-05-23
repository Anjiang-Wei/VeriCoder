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

reg signed [7:0] dividend_abs; // absolute value of dividend
reg signed [7:0] divisor_neg; // negated absolute value of divisor
reg signed [15:0] shift_register; // 16-bit shift register for division
reg signed [3:0] counter; // 4-bit counter to track bits processed
reg signed [1:0] start_cnt; // 2-bit flag to track whether division is in progress

always @(posedge clk) begin
    if (rst) begin
        res_valid <= 0;
        shift_register <= 0;
        counter <= 0;
        start_cnt <= 0;
    end else if (opn_valid && !res_valid) begin
        // save inputs and initialize state
        dividend_abs <= |dividend;
        divisor_neg <= ~|divisor;
        shift_register <= {1'd0, dividend_abs};
        counter <= 1;
        start_cnt <= 1;
    end else if (start_cnt == 1 && counter < 8) begin
        // division process
        reg signed [15:0] subtraction_result;
        reg signed [15:0] carry_out;

        subtraction_result = shift_register - divisor_neg;
        carry_out = {subtraction_result[15], &subtraction_result};

        shift_register <= {1'b0, (carry_out == 16'd1) ? 1 : 0} << counter | ~shift_register[15];
        counter <= counter + 1;

        if (counter == 8) begin
            // division complete
            res_valid <= 1;
            shift_register <= {result[7:0], result[15:8]};
            counter <= 0;
            start_cnt <= 0;
        end
    end

    // manage result validity
    else if (res_ready && !start_cnt) begin
        res_valid <= 0;
        shift_register <= 0;
        counter <= 0;
        start_cnt <= 1;
    end
end

// output result
assign result = {shift_register[15:8], shift_register[7:0]};

endmodule