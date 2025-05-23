module width_8to16(
    input                  clk        ,   
    input                  rst_n      ,
    input                  valid_in   ,
    input       [7:0]      data_in    ,
 
    output reg             valid_out   ,
    output reg [15:0]      data_out    
);

// Internal registers
reg [7:0] data_lock; // Register to hold the first valid 8-bit data
reg flag; // Flag to indicate whether the first data has been received

// Sequential logic for data processing
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset conditions
        data_out <= 16'd0;
        valid_out <= 1'b0;
        data_lock <= 8'd0;
        flag <= 1'b0; // Reset the flag
    end else begin
        if (valid_in) begin
            if (!flag) begin
                // First valid data input
                data_lock <= data_in;
                flag <= 1'b1; // Set flag to indicate the first data is ready
            end else begin
                // Second valid data input, both data are ready
                data_out <= {data_lock, data_in}; // Concatenate the previous data with current data
                valid_out <= 1'b1; // Output becomes valid
                flag <= 1'b0; // Reset flag for the next pair of inputs
            end
        end else begin
            // If valid_in is low, we will not produce output
            valid_out <= 1'b0;
        end
    end
end

endmodule