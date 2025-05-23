module width_8to16(
    input                  clk,          // Clock signal
    input                  rst_n,        // Active-low reset
    input                  valid_in,     // Validity of input data
    input       [7:0]      data_in,      // 8-bit input data

    output reg             valid_out,    // Validity of output data
    output reg [15:0]      data_out      // 16-bit output data
);

    // Internal registers
    reg [7:0] data_lock;  // Temporary register to hold the first 8-bit input
    reg       flag;       // A flag to indicate whether the first 8-bit input has been stored

    // Sequential logic block (triggered on posedge clk or negedge rst_n)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset logic: clear all registers and flags
            data_out  <= 16'b0;
            valid_out <= 1'b0;
            data_lock <= 8'b0;
            flag      <= 1'b0;
        end else begin
            if (valid_in) begin
                if (flag) begin
                    // Second input arrives; concatenate with the first input
                    data_out  <= {data_lock, data_in};
                    valid_out <= 1'b1;      // Set valid_out after concatenation
                    flag      <= 1'b0;      // Clear the flag after processing
                end else begin
                    // Store the first input in data_lock; set the flag
                    data_lock <= data_in;
                    flag      <= 1'b1;      // Indicate we are waiting for the second input
                    valid_out <= 1'b0;
                end
            end else begin
                // No valid input: maintain outputs and flags
                valid_out <= 1'b0;
            end
        end
    end

endmodule