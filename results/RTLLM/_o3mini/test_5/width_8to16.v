module width_8to16(
    input               clk       ,   // Clock signal
    input               rst_n     ,   // Active-low reset: 0 resets the circuit
    input               valid_in  ,   // Indicates validity of the input data
    input       [7:0]   data_in   ,   // 8-bit input data
 
    output  reg       valid_out ,   // Indicates validity of the output data
    output  reg [15:0] data_out     // 16-bit output data (converted from 8-bit data inputs)
);
    
    // Internal registers to hold the first valid data and flag to indicate if data_lock is valid.
    reg [7:0] data_lock;
    reg       flag; // When set (1), it indicates that a previous valid data has been stored.

    // Sequential block triggered by clk (synchronous operation) or negedge rst_n (asynchronous reset)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Asynchronous reset: clear the registers.
            data_lock  <= 8'b0;
            data_out   <= 16'b0;
            valid_out  <= 1'b0;
            flag       <= 1'b0;
        end 
        else begin
            if (valid_in) begin
                if (!flag) begin
                    // First valid data: store the 8-bit data into data_lock and set flag.
                    data_lock <= data_in;
                    flag      <= 1'b1;
                    // Do not output any data yet.
                    valid_out <= 1'b0;
                end 
                else begin
                    // Second valid data: concatenate data_lock (first data) and current data_in.
                    data_out  <= {data_lock, data_in}; // data_lock in high bits, current data in low bits.
                    valid_out <= 1'b1;   // The output is now valid.
                    // Reset the flag to be ready for the next pair.
                    flag      <= 1'b0;
                end
            end else begin
                // When valid_in is not asserted: no output valid signal.
                valid_out <= 1'b0;
            end
        end
    end

endmodule