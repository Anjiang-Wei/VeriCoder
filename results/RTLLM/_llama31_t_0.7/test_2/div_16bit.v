module div_16bit(
    input wire [15:0] A, // dividend
    input wire [7:0] B, // divisor
    output wire [15:0] result, // quotient
    output wire [15:0] odd // remainder
    );

reg [15:0] a_reg; // internal register for dividend
reg [7:0] b_reg; // internal register for divisor

wire [7:0] diff; // difference between dividend and divisor
wire [7:0] new_a; // updated dividend after subtraction
wire [7:0] carry; // carry out of subtraction operation
wire [15:0] quotient_temp; // temporary result of division
reg [7:0] temp_divisor; // temporary value for divisor

always_comb begin // combinational block triggered by input changes
    a_reg <= A;
    b_reg <= B;

    // Calculate difference between dividend and divisor
    diff = a_reg[15:8] - b_reg;

    // Update dividend after subtraction
    new_a = {a_reg[7:0], diff};

    // Determine if carry out is 1 or not
    carry = (diff > b_reg) ? 1'b1 : 1'b0;
end

always_comb begin // combinational block triggered by input changes
    temp_divisor = b_reg;

    // Calculate quotient and remainder using division algorithm
    if (a_reg[15:8] >= temp_divisor) begin
        result <= {1'b1, a_reg[7:0]};
        odd <= new_a;
    end else begin
        result <= {1'b0, a_reg};
        odd <= a_reg;
    end

    // Decrement dividend by divisor until it is less than the divisor
    if (a_reg >= temp_divisor) begin
        quotient_temp = {result[7:0], 1'b0}; // Initialize quotient for next iteration
        a_reg = new_a; // Update dividend with difference and carry out

        // Perform subtraction to get remainder
        diff = a_reg[15:8] - temp_divisor;

        new_a = {a_reg[7:0], diff};

        // Determine if carry out is 1 or not
        carry = (diff > temp_divisor) ? 1'b1 : 1'b0;
    end else begin
        quotient_temp = result; // No further iterations required
    end

    // Update odd with the final remainder
    odd <= {quotient_temp[15:8], a_reg[7:0]};
end
endmodule