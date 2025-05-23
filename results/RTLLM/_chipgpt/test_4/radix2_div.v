localparam NEGATIVE = 2**8 - 1; // NEGATIVE: Negative value of the divisor.
localparam SIZE = 9;            // Size of the shift register SR which is used for division.

reg [SIZE-1:0] SR;
wire neg_divisor;
reg cnt, start_cnt;
reg sub;

always @(posedge clk)
    if (rst) begin
        SR <= {SIZE{1'b0}}; // Shift register is initialized with 0 to the right.
        cnt <= 0;
        start_cnt <= 0;
        sub <= 1'b0;
        res_valid <= 0;
    end
    else if (opn_valid && res_ready) begin // When opn_valid and res_ready are true, the register SR is saved into result.
        if (!res_ready) SR <= {SIZE{1'b0}}; // Reset shift register to 0 to the right so that next time it will be used for division operation.
    end
    else if (opn_valid && !res_ready) begin   // When opn_valid and res_ready are true, but result is not yet ready, then the register SR is saved into the result.
        SR <= {SIZE{dividend[7:0]}};         // Absolute value of dividend will be used in division operation if it is a signed type.
    end 
// Negative Divisor NEGATIVE: This array contains the negative values of the divisor from [12:8].
always @* begin
        neg_divisor = {SIZE{1'b0}}; // Negative value of the divisor is initialized to all 1s.
        start_cnt <= cnt + 1;         // Sets cnt and start_cnt such that it will only divide by 2 if counter starts from 8 (most significant bit).
        case (start_cnt)
            2**(SIZE-1:0) : sub = 1'b0;
            default : begin
                sub = {SIZE{1'b1}} - divisor[7:0]; // Subtracts the divisor from the shift register SR.
            end
        endcase
end
// Divide by two is performed on a multiplexer based on the carry-out of the sub operation. 
always @* begin
    res_valid <= start_cnt ? 1 : 0;   // Reset res_valid to zero if cnt is not equal to 8 (most significant bit).
    result[SIZE-1:0] = SR[SIZE-1:0]; // Shift left and insert the carry-out.
end

endmodule