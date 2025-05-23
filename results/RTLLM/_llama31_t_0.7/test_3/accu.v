module accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in     ,

    output  reg         valid_out     ,
    output  reg [9:0]   data_out
);
    // Register to hold the accumulated sum
    reg [9:0] accum_sum;

    // Counter to track the number of valid inputs received
    reg [1:0] count;

    always @ (posedge clk) begin
        if (!rst_n) begin
            accum_sum <= '0;
            count     <= '0;
        end else if (valid_in) begin
            // If we have 4 valid inputs, output the sum and reset the counter
            if (count == 3) begin
                data_out <= accum_sum;
                valid_out <= 1'b1;
                count     <= 2'd0;  // Reset the counter
            end else begin
                // Accumulate the input data
                accum_sum <= accum_sum + data_in;
                count     <= count + 1;
            end
        end else begin
            // If valid_in is not asserted, reset the counter
            count <= '0;
        end
    end

    always_comb begin
        if (valid_out)
            valid_out <= 1'b0;  // Pulse the valid_out signal for one cycle
        else
            valid_out <= 1'b0;
    end
endmodule