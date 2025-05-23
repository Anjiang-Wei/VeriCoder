module fsm(
    input  IN,
    output reg MATCH,
    input  CLK,
    input  RST
);

// Initialize MATCH to 0 on reset
always @(posedge RST)
    MATCH <= 1'b0;

// Define states of the FSM
typedef enum {
    s00,  // Initial state
    s01,  // State for IN=1
    s02,  // State for IN=0
    s03   // Final state for match
} fsm_state;

// State register to store current state
reg [2:0] current_state;
reg [3:0] input_count;      // Count of matching sequence

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= s00;
        input_count  <= 'b0000;
        MATCH        <= 1'b0;
    end else begin
        // Next state logic based on current state and IN
        case (current_state)
            s00: begin
                if (IN == 1'b1) begin
                    current_state <= s01;
                    input_count  <= 'b0001;
                end else if (RST) MATCH <= 1'b0;
            end
            s01: begin
                if (IN == 1'b1) begin
                    current_state <= s02;
                    input_count  <= 'b0011;
                end else if (RST) MATCH <= 1'b0;
            end
            s02: begin
                if (IN == 1'b0) begin
                    current_state <= s03;
                    input_count  <= 'b0111;
                end else if (RST) MATCH <= 1'b0;
            end
            s03: begin
                if (IN == 1'b1) begin
                    if (input_count[3:2] == 2'd11)
                        MATCH <= 1'b1;     // Match condition met
                    current_state <= s01;
                    input_count  <= 'b1000;
                end else if (RST) MATCH <= 1'b0;
            end
        endcase
    end
end

endmodule