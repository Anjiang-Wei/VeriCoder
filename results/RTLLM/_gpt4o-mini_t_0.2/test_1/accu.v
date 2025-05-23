module accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in     ,
 
    output  reg         valid_out     ,
    output  reg [9:0]   data_out
);

// State variables
reg [9:0] accumulator; // Accumulator for the sum of data
reg [1:0] count; // Counter to keep track of number of valid inputs

// Combinational logic / sequential logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset logic
        accumulator <= 10'b0;
        count <= 2'b0;
        valid_out <= 1'b0;
        data_out <= 10'b0;
    end else begin
        if (valid_in) begin
            // Accumulate data if valid_in is high
            accumulator <= accumulator + data_in;
            count <= count + 1;

            // When 4 data have been accumulated
            if (count == 2'b11) begin
                valid_out <= 1'b1; // Set valid_out for one cycle
                data_out <= accumulator; // Output the accumulated sum
                // Reset for next accumulation
                accumulator <= 10'b0;
                count <= 2'b0;
            end else begin
                valid_out <= 1'b0; // valid_out remains low until the 4th accumulation
            end
        end else begin
            // If valid_in is not asserted, maintain current state
            valid_out <= 1'b0;
        end
    end
end

endmodule