module width_8to16(
    input                   clk      ,   // Clock signal
    input                   rst_n    ,   // Active-low reset signal
    input                   valid_in ,   // Valid input signal
    input       [7:0]       data_in  ,   // 8-bit input data

    output  reg             valid_out,   // Valid output signal
    output  reg [15:0]      data_out     // 16-bit output data
);

    // Internal register to temporarily store the first 8-bit data
    reg [7:0] data_lock;
    reg       flag; // Flag to indicate waiting for second 8-bit input

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all signals when rst_n is asserted
            data_lock  <= 8'b0;
            data_out   <= 16'b0;
            valid_out  <= 1'b0;
            flag       <= 1'b0;
        end 
        else begin
            if (valid_in) begin
                if (!flag) begin
                    // First valid 8-bit data is latched
                    data_lock <= data_in;
                    flag      <= 1'b1;
                end 
                else begin
                    // Second valid 8-bit data: concatenate data_lock and data_in
                    data_out  <= {data_lock, data_in};
                    valid_out <= 1'b1; // Output is valid
                    flag      <= 1'b0; // Reset flag after forming 16-bit data
                end
            end 
            else begin
                // If valid_in is not asserted, output remains invalid
                valid_out <= 1'b0;
            end
        end
    end

endmodule