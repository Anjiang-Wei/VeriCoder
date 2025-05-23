module accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in    ,
 
    output  reg         valid_out   ,
    output  reg [9:0]   data_out
);

    // Internal registers:
    // accum_reg: summing accumulator (10 bits wide, since 4×255=1020 maximum)
    // count_reg: counts the number of valid data received (values 0~3)
    reg [9:0] accum_reg;
    reg [1:0] count_reg;

    // Sequential logic: Accumulate with each valid data_in. 
    // When four valid inputs have been received, output the accumulated sum
    // (including the current data_in added to the previous accumulation)
    // valid_out is pulsed high for one cycle.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accum_reg <= 10'd0;
            count_reg <= 2'd0;
            data_out  <= 10'd0;
            valid_out <= 1'b0;
        end else begin
            if (valid_in) begin
                // If we are receiving the fourth valid input 
                if (count_reg == 2'd3) begin
                    // The output sum is the accumulator plus the current input.
                    data_out  <= accum_reg + data_in;
                    valid_out <= 1'b1;
                    // Reset the accumulation and counter after output.
                    accum_reg <= 10'd0;
                    count_reg <= 2'd0;
                end else begin
                    // Otherwise, accumulate the data and increment count
                    accum_reg <= accum_reg + data_in;
                    count_reg <= count_reg + 2'd1;
                    valid_out <= 1'b0;
                end
            end else begin
                // If valid_in is not asserted, no accumulation and valid_out remains 0.
                valid_out <= 1'b0;
            end
        end
    end

endmodule