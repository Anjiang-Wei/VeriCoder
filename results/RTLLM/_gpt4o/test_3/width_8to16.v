module width_8to16(
    input                clk       ,   
    input                rst_n     ,
    input                valid_in  ,
    input      [7:0]     data_in   ,

    output reg           valid_out ,
    output reg [15:0]    data_out  
);

    // Internal register to hold the first 8-bit data temporarily
    reg [7:0] data_lock;
    reg       flag; // To track if the first 8-bit data has been received

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset logic
            data_out  <= 16'b0;
            valid_out <= 1'b0;
            data_lock <= 8'b0;
            flag      <= 1'b0;
        end else begin
            if (valid_in) begin
                if (flag == 1'b0) begin
                    // First valid input: store in data_lock
                    data_lock <= data_in;
                    flag      <= 1'b1;
                    valid_out <= 1'b0; // Output not valid yet (waiting for second byte)
                end else begin
                    // Second valid input: combine and output
                    data_out  <= {data_lock, data_in}; // Concatenate stored and new data
                    valid_out <= 1'b1;                 // Mark output as valid
                    flag      <= 1'b0;                 // Reset flag after output
                end
            end else begin
                // No valid input, clear valid_out
                valid_out <= 1'b0;
            end
        end
    end

endmodule