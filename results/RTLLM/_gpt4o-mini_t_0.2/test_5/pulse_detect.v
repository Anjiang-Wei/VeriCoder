module pulse_detect(    
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// State encoding
localparam [1:0] IDLE       = 2'b00,
                 RISING     = 2'b01,
                 HIGH       = 2'b10,
                 FALLING    = 2'b11;

reg [1:0] state, next_state;

// Sequential logic to update the state
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 0;
    end else begin
        state <= next_state;
    end
end

// Combinational logic for state transitions and output generation
always @(*) begin
    // Default values
    next_state = state;
    data_out = 0;

    case (state)
        IDLE: begin
            if (data_in) begin
                // If we detect rising edge
                next_state = RISING;
            end
        end
        RISING: begin
            if (data_in) begin
                // Stay in the HIGH state while data_in is high
                next_state = HIGH;
            end else begin
                // If we detect falling edge, go to FALLING
                next_state = FALLING;
            end
        end
        HIGH: begin
            if (data_in) begin
                // Stay in HIGH if data_in is still high
                next_state = HIGH;
            end else begin
                // If we detect falling edge, go to FALLING
                next_state = FALLING;
            end
        end
        FALLING: begin
            if (data_in) begin
                // If we detect rising edge, return to RISING state
                next_state = RISING;
            end else begin
                // Transition back to IDLE
                next_state = IDLE;
                // Set data_out high when transitioning from HIGH to FALLING
                data_out = 1;
            end
        end
    endcase
end

endmodule