module fsm(IN,MATCH,CLK,RST);
input IN,CLK,RST;
output reg MATCH;

// State definition
reg [3:0] state;

// State encoding
localparam S0 = 4'b0000;
localparam S1 = 4'b0001;
localparam S2 = 4'b0010;
localparam S3 = 4'b0011;
localparam S4 = 4'b0100;
localparam S5 = 4'b0101;

// Initial state assignment
initial begin
    state <= S0;
    MATCH <= 0;
end

// State transition and output logic
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        state <= S0;
        MATCH <= 0;
    end else begin
        case (state)
            S0: begin
                if (IN == 1) begin
                    state <= S1;
                    MATCH <= 0;
                end else begin
                    state <= S0;
                    MATCH <= 0;
                end
            end
            S1: begin
                if (IN == 0) begin
                    state <= S2;
                    MATCH <= 0;
                end else begin
                    state <= S1;
                    MATCH <= 0;
                end
            end
            S2: begin
                if (IN == 0) begin
                    state <= S3;
                    MATCH <= 0;
                end else begin
                    state <= S1;
                    MATCH <= 0;
                end
            end
            S3: begin
                if (IN == 1) begin
                    state <= S4;
                    MATCH <= 0;
                end else begin
                    state <= S0;
                    MATCH <= 0;
                end
            end
            S4: begin
                if (IN == 1) begin
                    state <= S5;
                    MATCH <= 1;
                end else begin
                    state <= S0;
                    MATCH <= 0;
                end
            end
            S5: begin
                if (IN == 1) begin
                    state <= S5;
                    MATCH <= 1;
                end else begin
                    state <= S0;
                    MATCH <= 0;
                end
            end
            default: begin
                state <= S0;
                MATCH <= 0;
            end
        endcase
    end
end

endmodule