module width_8to16(
    input              clk,
    input              rst_n,
    input              valid_in,
    input       [7:0]  data_in,
 
    output reg         valid_out,
    output reg [15:0]  data_out
);

    // Internal registers:
    // flag indicates that a first valid data has been captured.
    reg        flag;
    // data_lock holds the first received 8-bit data (which will become the upper byte).
    reg [7:0]  data_lock;
    // pending_data stores the concatenated 16-bit result that will be output in the next cycle.
    reg [15:0] pending_data;
    // pending indicates that there is a valid result pending for output.
    reg        pending;

    // Synchronous process for state and output pipelining.
    // The output signals 'valid_out' and 'data_out' are updated with the values stored in
    // {pending, pending_data} from the previous cycle.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            flag         <= 1'b0;
            data_lock    <= 8'b0;
            pending      <= 1'b0;
            pending_data <= 16'b0;
            valid_out    <= 1'b0;
            data_out     <= 16'b0;
        end else begin
            // Output stage: on each cycle we update the outputs from the pending registers.
            valid_out <= pending;
            data_out  <= pending_data;
            
            // Clear pending flag after transferring the output.
            pending   <= 1'b0;

            // Capture input data when valid_in is high.
            if (valid_in) begin
                // If no previous data is stored, capture the first one.
                if (!flag) begin
                    data_lock <= data_in;
                    flag      <= 1'b1;
                end 
                // Otherwise (flag asserted) we have already stored the first data.
                // Generate the concatenation here and mark that output is pending.
                else begin
                    pending_data <= {data_lock, data_in};
                    pending      <= 1'b1;
                    flag         <= 1'b0; // clear flag to restart the pairing process
                end
            end
            // If valid_in is not asserted, nothing is done (the pending outputs
            // are delivered then naturally clear according to the above logic).
        end
    end

endmodule