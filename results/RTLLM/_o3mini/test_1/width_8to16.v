module width_8to16(
    input              clk,
    input              rst_n,
    input              valid_in,
    input      [7:0]   data_in,
 
    output reg         valid_out,
    output reg [15:0]  data_out
);

    // Internal register to temporarily store the first valid 8-bit data.
    reg [7:0] data_lock;
    // Flag to indicate that the first data has been received.
    reg       valid_lock;

    // Sequential logic on posedge clk or asynchronous active-low reset.
    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n) begin
            // Clear registers on reset.
            data_lock  <= 8'd0;
            valid_lock <= 1'b0;
            data_out   <= 16'd0;
            valid_out  <= 1'b0;
        end
        else begin
            // Default valid_out is de-asserted unless a valid pair is ready.
            valid_out <= 1'b0;
            
            // Process incoming data only when valid_in is high.
            if (valid_in) begin
                if (!valid_lock) begin
                    // First valid data: save it into data_lock and set the flag.
                    data_lock  <= data_in;
                    valid_lock <= 1'b1;
                end
                else begin
                    // Second valid data arrives: concatenate the stored data (upper 8 bits)
                    // and the current data (lower 8 bits) to form the 16-bit output.
                    data_out  <= {data_lock, data_in};
                    valid_out <= 1'b1;
                    // Clear the flag for the next pair of inputs.
                    valid_lock <= 1'b0;
                end
            end
        end
    end

endmodule