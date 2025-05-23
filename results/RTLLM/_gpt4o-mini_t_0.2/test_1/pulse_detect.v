module pulse_detect(    
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

    // State encoding
    reg [1:0] state; // 2-bit state register
    localparam IDLE     = 2'b00, // Idle state
               HIGH     = 2'b01, // Intermediate state (data_in = 1)
               LOW      = 2'b10; // Intermediate state (data_in = 0)

    // State update and output logic
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            // Reset state and output
            state <= IDLE;
            data_out <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (data_in) begin
                        state <= HIGH; // Move to HIGH state on data_in = 1
                        data_out <= 0; // Ensure output is 0 while transitioning
                    end else begin
                        state <= IDLE; // Stay in IDLE if data_in = 0
                    end
                end

                HIGH: begin
                    if (~data_in) begin
                        state <= LOW; // Move to LOW state on data_in = 0
                    end else begin
                        state <= HIGH; // Stay in HIGH state if data_in remains 1
                    end
                end

                LOW: begin
                    data_out <= 1; // Output 1 at the end of a pulse
                    state <= IDLE; // Move back to IDLE state after producing data_out
                end

                default: begin
                    state <= IDLE; // Default case to prevent latches
                end
            endcase
        end
    end
endmodule