module fsm(IN, MATCH, CLK, RST);
input IN, CLK, RST;
output reg MATCH;

// State encoding: 0000, 0001, 0010, 0011, 0100, 0101
reg [4:0] state, next_state;

// State transition logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= 5'b00000; // Reset state to initial state
        MATCH <= 1'b0;     // Reset MATCH signal
    end else begin
        state <= next_state; // Update state on clock edge
        MATCH <= (state == 5'b0101); // Set MATCH when in final state
    end
end

// Next state logic
always @(*) begin
    case (state)
        5'b00000: next_state = IN ? 5'b00001 : 5'b00000; // Initial state
        5'b00001: next_state = IN ? 5'b00010 : 5'b00000;
        5'b00010: next_state = IN ? 5'b00011 : 5'b00000;
        5'b00011: next_state = IN ? 5'b00100 : 5'b00000;
        5'b00100: next_state = IN ? 5'b00101 : 5'b00000;
        5'b00101: next_state = IN ? 5'b00101 : 5'b00000; // Final state
        default: next_state = 5'b00000; // Default state
    endcase
end

endmodule