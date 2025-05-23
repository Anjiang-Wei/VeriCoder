module width_8to16(
    input                   clk         ,   
    input                   rst_n       ,
    input                   valid_in    ,
    input       [7:0]      data_in     ,
    
    output reg              valid_out    ,
    output reg [15:0]      data_out
);

    reg [7:0]              data_lock;   // To hold the first 8-bit data
    reg                     first_data_received; // Flag to indicate if the first data has been received

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 16'b0;
            valid_out <= 1'b0;
            first_data_received <= 1'b0;
        end else begin
            if (valid_in) begin
                if (!first_data_received) begin
                    // Store the first valid data
                    data_lock <= data_in;
                    first_data_received <= 1'b1; // Indicate that the first data has been received
                end else begin
                    // Concatenate and produce output
                    data_out <= {data_lock, data_in}; // Concatenate the first and second 8-bit data
                    valid_out <= 1'b1; // Set valid_out high
                    first_data_received <= 1'b0; // Reset flag for next pair of inputs
                end
            end else begin
                // If there's no valid input, valid_out should remain low
                valid_out <= 1'b0;
            end
        end
    end

endmodule