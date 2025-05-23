module serial2parallel(
    input  wire         clk,     // Clock signal.
    input  wire         rst_n,   // Reset signal (active low).
    input  wire         din_serial, // Serial input data.
    input  wire         din_valid,  // Validity signal for input data.
    output reg          [7:0] dout_parallel, // Parallel output data (8 bits wide).
    output reg          dout_valid // Validity signal for the output data
);

// Synchronous reset logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 8'd0;
        din_cnt <= 8'd0;
        dout_parallel <= 8'h00;
        dout_valid <= 1'b0;
    end else begin
        // Update counters and output registers based on input signals.
        case (din_valid)
            1'b1: begin
                if (~din_serial) cnt <= cnt + 1'd1;
                din_cnt <= din_cnt + 1'd1;
            end
            default: cnt <= cnt;
        endcase
        
        // Output data is valid when all 8 serial input bits have been received.
        if (din_valid && din_cnt == 8'd8) begin
            dout_parallel[7 downto 0] <= {din_serial, cnt[3], cnt[2], cnt[1], cnt[0]};
            dout_valid <= 1'b1;
        end else if (cnt == 8'd8) begin // Reset output when all bits received.
            dout_parallel <= 8'h00;
            dout_valid <= 1'b0;
        end
    end
end

// Local variables to keep track of the number of serial input data bits received.
reg [3:0] cnt; // Counter for the total number of bits received.
reg [3:0] din_cnt; // Temporary counter for counting consecutive valid inputs.

endmodule