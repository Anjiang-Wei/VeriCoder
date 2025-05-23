module accu(
    input               clk,         // Clock input
    input               rst_n,       // Active-low reset signal
    input       [7:0]   data_in,     // 8-bit input data
    input               valid_in,    // Valid input signal indicating readiness for new input data
    
    output  reg         valid_out,   // Valid output signal
    output  reg [9:0]   data_out     // 10-bit accumulated result
);

    // Internal signals
    reg [1:0]           count;       // Counter to keep track of input data numbers (mod-4)
    reg [9:0]           sum_acc;     // Accumulator register
    
    // Sequential logic for the accumulations and control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all signals
            count <= 2'b0;
            sum_acc <= 10'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end
        else begin
            if (valid_in) begin
                // Accumulate input data into sum_acc
                sum_acc <= sum_acc + data_in;
                count <= count + 1'b1;

                // When 4 inputs have been accumulated
                if (count == 2'b11) begin
                    data_out <= sum_acc + data_in;   // Sum and output
                    valid_out <= 1'b1;              // Signal a valid output
                    sum_acc <= 10'b0;               // Clear the accumulator for the next group
                    count <= 2'b0;                  // Reset the counter
                end
                else begin
                    valid_out <= 1'b0;              // Keep valid_out low until 4 data have been accumulated
                end
            end
            else begin
                valid_out <= 1'b0;                  // valid_out stays low if valid_in is not set
            end
        end
    end

endmodule