module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    reg [15:0] a_reg;
    reg [7:0] b_reg;

    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    always @(*) begin
        reg [15:0] temp_result;
        reg [15:0] temp_odd;
        reg [15:0] temp_a;
        reg [15:0] temp_b;
        reg [3:0] bit_counter;

        temp_result = 16'b0;
        temp_odd = 16'b0;
        temp_a = a_reg;
        temp_b = {8'b0, b_reg};
        bit_counter = 4'd15;

        while (bit_counter >= 0) begin
            if (temp_a[15:8] >= temp_b) begin
                temp_result[bit_counter] = 1'b1;
                temp_odd = temp_a[15:8] - temp_b;
                temp_a = {temp_odd, temp_a[7:0]};
            end else begin
                temp_result[bit_counter] = 1'b0;
                temp_odd = temp_a[15:8];
                temp_a = {temp_odd, temp_a[7:0]};
            end
            bit_counter = bit_counter - 1;
        end

        result = temp_result;
        odd = temp_odd;
    end

endmodule