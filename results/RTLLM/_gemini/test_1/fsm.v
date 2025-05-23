module fsm(IN,MATCH,CLK,RST);
input IN,CLK,RST;
output reg MATCH;

reg [2:0] state;

// State definitions
localparam S0 = 3'b000;
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam S4 = 3'b100;
localparam S5 = 3'b101;

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
                end else begin
                    state <= S0;
                end
            end
            S1: begin
                if (IN == 0) begin
                    state <= S2;
                end else begin
                    state <= S1;
                end
            end
            S2: begin
                if (IN == 0) begin
                    state <= S3;
                end else begin
                    state <= S1;
                end
            end
            S3: begin
                if (IN == 1) begin
                    state <= S4;
                end else begin
                    state <= S1;
                end
            end
            S4: begin
                if (IN == 1) begin
                    state <= S5;
                    MATCH <= 1;
                end else begin
                    state <= S1;
                end
            end
            S5: begin
                if (IN == 0) begin
                    state <= S0;
                end else begin
                    state <= S5;
                    MATCH <= 1;
                end
            end
            default: state <= S0;
        endcase
    end
end

endmodule