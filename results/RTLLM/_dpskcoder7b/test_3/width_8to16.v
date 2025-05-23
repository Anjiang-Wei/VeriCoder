// Define the internal register for the 8-bit data
    reg [7:0] data_lock;
    // Define the internal register for the flag
    reg flag;
    
    // Synchronous process for data and flag register
    always @(posedge clk or negedge rst_n) begin
        // Reset action
        if (!rst_n) begin
            data_out <= 16'b0;
            valid_out <= 1'b0;
            data_lock <= 8'b0;
            flag <= 1'b0;
        // Synchronous action
        end else begin
            // When the input data is valid
            if (valid_in) begin
                // When the flag is not active
                if (!flag) begin
                    // Store the input data in the data_lock register
                    data_lock <= data_in;
                    // Activate the flag
                    flag <= 1'b1;
                // When the flag is active
                end else begin
                    // Concatenate the data_lock and data_in registers to form a 16-bit data output
                    data_out <= {data_lock, data_in};
                    // Activate the valid_out signal
                    valid_out <= 1'b1;
                    // Deactivate the flag
                    flag <= 1'b0;
                end
            // When the input data is not valid
            end else begin
                // Deactivate the valid_out signal
                valid_out <= 1'b0;
            end
        end
    end
endmodule