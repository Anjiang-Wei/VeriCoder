module fsm(
    input IN,
    output reg MATCH,
    input CLK,
    input RST
);

// State machine states and transitions
localparam IDLE = 2'b00;
localparam WAIT_1 = 2'b01;
localparam WAIT_0_1 = 2'b10;
localparam WAIT_0_0_1 = 2'b11;

reg [1:0] STATE;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        MATCH <= 1'b0;
        STATE <= IDLE;
    end else begin
        case (STATE)
            IDLE:
                if (IN == 1'b1) begin
                    MATCH <= 1'b0;
                    STATE <= WAIT_1;
                end else begin
                    MATCH <= 1'b0;
                    STATE <= IDLE;
                end

            WAIT_1:
                if (IN == 1'b0) begin
                    MATCH <= 1'b0;
                    STATE <= WAIT_0_1;
                end else begin
                    MATCH <= 1'b0;
                    STATE <= IDLE;
                end

            WAIT_0_1:
                if (IN == 1'b0) begin
                    MATCH <= 1'b0;
                    STATE <= WAIT_0_0_1;
                end else begin
                    MATCH <= 1'b0;
                    STATE <= WAIT_1;
                end

            WAIT_0_0_1:
                if (IN == 1'b0) begin
                    MATCH <= 1'b0;
                    STATE <= IDLE;
                end else begin
                    MATCH <= IN ? 1'b1 : 1'b0;
                    STATE <= WAIT_0_1;
                end
        endcase
    end
end

endmodule // fsm