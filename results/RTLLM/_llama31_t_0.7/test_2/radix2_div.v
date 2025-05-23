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

reg signed [9:0] SR;
reg signed [7:0] NEG_DIVISOR;
reg signed [8:0] cnt;
reg start_cnt;

reg signed [7:0] remainder;
reg signed [8:0] quotient;

always @(posedge clk) begin
    if (rst) begin
        res_valid <= 1'b0;
        SR <= '0;
        NEG_DIVISOR <= '0;
        cnt <= '0;
        start_cnt <= '0;
        remainder <= '0;
        quotient <= '0;
    end else if (opn_valid && !res_valid) begin
        // Save the inputs
        dividend_saved <= dividend;
        divisor_saved <= divisor;

        // Initialize the shift register SR with the absolute value of the dividend shifted left by one bit
        SR <= {dividend_saved[7], dividend_saved};

        // Set NEG_DIVISOR to the negated absolute value of the divisor
        NEG_DIVISOR <= ~divisor_saved;

        // Set the counter cnt to 1 and start_cnt to 1 to begin the division process
        cnt <= 9'b000000001;
        start_cnt <= 1'b1;
    end else if (start_cnt) begin
        if (cnt == 9'b100000001) begin
            // Division is complete
            res_valid <= 1'b1;

            // Update the shift register SR with the final remainder and quotient
            remainder <= SR[7:0];
            quotient <= SR[8];

            cnt <= '0;
            start_cnt <= '0;
        end else begin
            // Increment the counter cnt
            cnt <= cnt + 9'b000000001;

            // Update the shift register SR based on the subtraction result:
            // Computes the subtraction of NEG_DIVISOR.
            reg signed [8:0] sub_result = {SR[7:0]} - {NEG_DIVISOR,1'b0};

            // Uses a multiplexer to select the appropriate result based on the carry-out.
            wire signed [8:0] mux_out;
            case (sub_result[9])
                1'b0 : mux_out = sub_result;
                default : mux_out = sub_result + {NEG_DIVISOR,1'b1};
            endcase

            // Updates SR by shifting left and inserting the carry-out.
            SR <= {mux_out[8],mux_out[7:0]};
        }
    end
end

// Management of result validity
always @(posedge clk) begin
    if (rst) res_valid <= 1'b0;
    else if (!res_ready && cnt == 'b0) res_valid <= 1'b0;
end

assign result = {remainder, quotient};

endmodule