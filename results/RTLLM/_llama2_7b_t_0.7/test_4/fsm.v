module fsm(IN,MATCH,CLK,RST);
input IN,CLK,RST;
output reg MATCH;

// Define the states of the FSM
wire [2:0] state = (IN & CLK) % 3;

// Define the output signal based on the current state
assign MATCH = (state == 1) || (state == 2 && IN == 1);

// Implement the transition logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        // Reset the output signal to 0
        MATCH <= 0;
    end else begin
        // Update the state based on the input and clock signal
        case (state)
            1: if (IN == 1 && IN != state[1]) state <= 2;
            2: if (IN == 0 && IN != state[0]) state <= 1;
            default: ; // No action
        endcase
        MATCH <= (state == 1) || (state == 2 && IN == 1);
    end
end