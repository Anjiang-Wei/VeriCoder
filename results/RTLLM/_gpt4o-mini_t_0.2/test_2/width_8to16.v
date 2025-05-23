module width_8to16(
    input                   clk         ,   
    input                   rst_n      ,
    input                   valid_in    ,
    input       [7:0]      data_in     ,
 
    output  reg            valid_out    ,
    output  reg [15:0]     data_out     
);

    reg [7:0] data_lock; // Register to hold the first 8-bit data
    reg flag;             // Flag to indicate whether the first data is stored

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out    <= 16'b0;      // Clear output on reset
            valid_out   <= 1'b0;       // Clear valid output on reset
            data_lock   <= 8'b0;       // Clear data lock on reset
            flag         <= 1'b0;       // Clear flag on reset
        end else if (valid_in) begin
            if (!flag) begin
                // First valid input, store it
                data_lock <= data_in;   // Lock first 8 bits
                flag <= 1'b1;            // Set flag to indicate first data is stored
            end else begin
                // Second valid input, concatenate and output
                data_out <= {data_lock, data_in}; // Concatenate data_lock and data_in
                valid_out <= 1'b1;        // Set valid output high
                flag <= 1'b0;             // Reset flag for the next set of data
            end
        end else if (flag) begin
            // If no valid input but first data is locked, don't output anything
            valid_out <= 1'b0;            // Maintain valid_out as low
        end else begin
            valid_out <= 1'b0;             // Ensure valid_out is low when no valid input
        end
    end

endmodule