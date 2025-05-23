module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

    // State register to control the waveform generation
    reg state;

    // Always block for synchronous operation on the clock edge or reset
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            // On reset, clear state and wave
            wave <= 5'b00000;
            state <= 1'b0; // Start with incrementing state
        end else begin
            case (state)
                1'b0: begin
                    // Increment the wave
                    if (wave < 5'b11111) begin
                        wave <= wave + 1;
                    end
                    // Transition to state 1 when wave reaches 31
                    if (wave == 5'b11111) begin
                        state <= 1'b1;
                    end
                end
                
                1'b1: begin
                    // Decrement the wave
                    if (wave > 5'b00000) begin
                        wave <= wave - 1;
                    end
                    // Transition to state 0 when wave reaches 0
                    if (wave == 5'b00000) begin
                        state <= 1'b0;
                    end
                end
                
                default: begin
                    // Default case - should not occur
                    state <= 1'b0;
                end
            endcase
        end
    end
endmodule