module width_8to16(
    input                  clk         ,  // Clock signal
    input                  rst_n       ,  // Active-low reset signal
    input                  valid_in    ,  // Input data validity signal
    input      [7:0]       data_in     ,  // 8-bit input data

    output reg             valid_out   ,  // Output data validity signal
    output reg [15:0]      data_out       // 16-bit output data
);

    // Internal registers
    reg        flag;           // Used to track first or second 8-bit data input
    reg [7:0]  data_lock;      // Temporary register to hold the first 8-bit input

    // Always block triggered by clock or active-low reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all outputs and internal registers
            valid_out <= 0;
            data_out  <= 16'b0;
            data_lock <= 8'b0;
            flag      <= 1'b0;
        end else begin
            if (valid_in) begin
                if (!flag) begin
                    // First 8-bit input: Store it in `data_lock`, and wait for second input
                    data_lock <= data_in;
                    flag      <= 1'b1;
                    valid_out <= 1'b0;
                end else begin
                    // Second 8-bit input: Concatenate with `data_lock` and output the result
                    data_out  <= {data_lock, data_in}; // Higher 8-bits = data_lock, lower 8-bits = data_in
                    valid_out <= 1'b1;                 // Output is valid
                    flag      <= 1'b0;                 // Reset flag for next set of inputs
                end
            end else begin
                // No valid input; clear valid_out
                valid_out <= 1'b0;
            end
        end
    end

endmodule