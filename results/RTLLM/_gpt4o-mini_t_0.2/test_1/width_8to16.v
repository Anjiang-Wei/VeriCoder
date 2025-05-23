module width_8to16(
    input                   clk        ,   
    input                   rst_n      ,
    input                   valid_in    ,
    input       [7:0]      data_in    ,
 
    output  reg            valid_out   ,
    output  reg [15:0]     data_out    
);

    reg [7:0] data_lock;  // Register to hold the first 8-bit input data
    reg flag;              // Flag to indicate if the first data has been received

    // Sequential logic to handle data input and state transitions
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset state
            data_out <= 16'b0;
            valid_out <= 1'b0;
            data_lock <= 8'b0;
            flag <= 1'b0; // Reset flag
        end else begin
            // If new valid input data is received
            if (valid_in) begin
                if (!flag) begin
                    // First data input
                    data_lock <= data_in; // Store first 8-bit data
                    flag <= 1'b1;         // Set flag to indicate first data is stored
                end else begin
                    // Second data input, concatenate and produce output
                    data_out <= {data_lock, data_in};
                    valid_out <= 1'b1;   // Set valid output
                    flag <= 1'b0;        // Reset flag for next input
                end
            end else begin
                // If no valid data, do not create output
                valid_out <= 1'b0; // Reset valid output when there's no valid input
            end
        end
    end

endmodule