module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

    // State encoding for pulse detection
    localparam IDLE = 2'd0;
    localparam RISE1 = 2'd1;
    localparam RISE2 = 2'd2;
    localparam FALL = 2'd3;

    reg [1:0] state, next_state;

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            data_out <= (state == FALL) ? 1'b1 : 1'b0;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = data_in ? RISE1 : IDLE;
            RISE1: next_state = data_in ? RISE2 : IDLE;
            RISE2: next_state = data_in ? RISE2 : FALL;
            FALL: next_state = data_in ? RISE1 : IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule