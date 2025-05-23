module width_8to16(
    input              clk,       // Clock
    input              rst_n,     // Asynchronous active‐low reset
    input              valid_in,  // Input data valid
    input      [7:0]   data_in,   // 8‐bit input data
    output reg         valid_out, // Output data valid
    output reg [15:0]  data_out   // 16‐bit output data
);

    // Internal storage for the first byte
    reg        byte_flag;
    reg [7:0]  data_lock;

    // Synchronous logic: pack two bytes into one 16‐bit word
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            byte_flag  <= 1'b0;
            data_lock  <= 8'b0;
            data_out   <= 16'b0;
            valid_out  <= 1'b0;
        end else begin
            // Default: clear valid_out each cycle
            valid_out <= 1'b0;

            if (valid_in) begin
                if (!byte_flag) begin
                    // First byte arrives: store it, set flag
                    data_lock <= data_in;
                    byte_flag <= 1'b1;
                end else begin
                    // Second byte arrives: concatenate and output
                    data_out  <= {data_lock, data_in};
                    valid_out <= 1'b1;
                    byte_flag <= 1'b0;
                end
            end
        end
    end

endmodule