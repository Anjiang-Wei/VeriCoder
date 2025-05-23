module width_8to16(
    input  clk,   
    input  rst_n,  
    input     valid_in, 
    input [7:0] data_in,

    output reg        valid_out,
    output reg [15:0] data_out
);

// Register to hold the first valid data
reg [7:0] data_lock;

// Flag to indicate that a second valid data has been received
reg is_second_valid = 1'b0;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // On reset, clear all registers
        data_out <= 'd0;
        data_lock <= 'd0;
        valid_out <= 'd0;
    end else begin
        // If the input data is valid and we have a second valid data,
        // update the output with the concatenated data
        if (valid_in && is_second_valid) begin
            data_out <= {data_lock, data_in};
            valid_out <= 1'b1;
        end
        
        // If this is the first valid data, store it in the lock register
        if (valid_in && !is_second_valid) begin
            data_lock <= data_in;
            is_second_valid <= 'd1;
        end
        
        // Reset the flag when we receive a new valid data
        else if (!valid_in && is_second_valid) begin
            is_second_valid <= 'd0;
        end
    end
end

endmodule