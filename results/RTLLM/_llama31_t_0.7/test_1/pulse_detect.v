module pulse_detect(    
    input clk,         // Clock signal
    input rst_n,       // Reset signal (active low)
    input data_in,     // One-bit input signal
    output reg data_out  // Output signal indicating the presence of pulses
);

// Define the state register
reg [2:0] state = 'b000;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 'b000;
        data_out <= 1'b0; // Reset data_out to 0 on reset
    end else begin
        case (state)
            3'b000: begin // Initial state
                if (data_in == 1'b1) begin
                    state <= 3'b001;
                end else begin
                    state <= 3'b000;
                end
            end

            3'b001: begin // First rising edge of the pulse
                if (data_in == 1'b0 && data_out != 1'b1) begin
                    state <= 3'b010;
                end else begin
                    state <= 3'b001;
                end
            end

            3'b010: begin // Second falling edge of the pulse
                if (data_in == 1'b0 && data_out != 1'b1) begin
                    state <= 3'b011;
                end else begin
                    state <= 3'b010;
                end
            end

            3'b011: begin // End of the pulse, set data_out to 1
                if (data_in == 1'b0 && data_out != 1'b1) begin
                    data_out <= 1'b1; // Set data_out to 1 when the pulse ends
                    state <= 3'b000;
                end else begin
                    data_out <= 1'b0; // Clear data_out if not a new pulse
                    state <= 3'b011;
                end
            end

            default: begin
                state <= 'b000;
                data_out <= 1'b0;
            end
        endcase
    end
end

endmodule