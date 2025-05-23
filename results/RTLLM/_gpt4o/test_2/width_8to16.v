module width_8to16(
    input                  clk,       // Clock signal
    input                  rst_n,     // Active-low reset signal
    input                  valid_in,  // Input signal indicating the validity of the input data
    input       [7:0]      data_in,   // 8-bit input data
 
    output  reg            valid_out, // Output signal indicating validity of output data
    output  reg [15:0]     data_out   // 16-bit output data resulting from concatenation
);

    // Internal register to store the first 8-bit data
    reg [7:0] data_lock;     
    reg       flag;          // Flag to indicate whether we are waiting for the second byte to complete concatenation

    // Always block triggered on the positive edge of the clock or negative edge of reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset logic
            data_out  <= 16'b0;     // Clear 16-bit output
            valid_out <= 1'b0;      // Set valid_out signal low
            data_lock <= 8'b0;      // Clear data_lock
            flag      <= 1'b0;      // Reset flag
        end else begin
            // Main logic
            if (valid_in) begin
                if (flag) begin
                    // On receiving the second data, concatenate and set output
                    data_out  <= {data_lock, data_in}; // Concatenate previous data (data_lock) and current data (data_in)
                    valid_out <= 1'b1;                // Valid output is ready
                    flag      <= 1'b0;                // Reset the flag after concatenation is complete
                end else begin
                    // Store the first valid data in data_lock and raise the flag
                    data_lock <= data_in; // Store the first byte
                    valid_out <= 1'b0;    // Output is not valid yet
                    flag      <= 1'b1;    // Set flag indicating first byte is stored
                end
            end else begin
                // If valid_in is not asserted, keep outputs unchanged
                valid_out <= 1'b0;        // Output is not valid
            end
        end
    end

endmodule