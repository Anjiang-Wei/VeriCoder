module width_8to16(
    input             clk,        // system clock
    input             rst_n,      // active‐low reset
    input             valid_in,   // input data valid
    input  [7:0]      data_in,    // 8‐bit input data
    output reg        valid_out,  // output data valid
    output reg [15:0] data_out    // 16‐bit output data
);

    // ----------------------------------------------------------------
    // Internal registers
    // ----------------------------------------------------------------
    reg        byte_stored;       // flag: have we stored the first byte?
    reg  [7:0] data_lock;         // storage for the first incoming byte
    reg  [15:0] data_comb;        // holds the concatenated result
    reg        emit_pending;      // flag: we have data_comb to emit next cycle

    // ----------------------------------------------------------------
    // Sequential logic
    // ----------------------------------------------------------------
    // We use one always block on posedge clk or negedge rst_n
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Asynchronous reset (active low)
            byte_stored   <= 1'b0;
            data_lock     <= 8'h00;
            data_comb     <= 16'h0000;
            emit_pending  <= 1'b0;
            data_out      <= 16'h0000;
            valid_out     <= 1'b0;
        end else begin
            // default deassert output valid each cycle
            valid_out    <= 1'b0;

            // First handle new incoming byte
            if (valid_in) begin
                if (!byte_stored) begin
                    // store first byte
                    data_lock    <= data_in;
                    byte_stored  <= 1'b1;
                end else begin
                    // second byte arrives → form 16‐bit word
                    data_comb     <= { data_lock, data_in };
                    byte_stored   <= 1'b0;
                    emit_pending  <= 1'b1;
                end
            end

            // Now handle emission of concatenated data one cycle later
            if (emit_pending) begin
                data_out     <= data_comb;
                valid_out    <= 1'b1;
                emit_pending <= 1'b0;
            end
        end
    end

endmodule