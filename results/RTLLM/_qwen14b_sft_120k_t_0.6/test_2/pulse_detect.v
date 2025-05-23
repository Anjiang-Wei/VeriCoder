module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam RISING_EDGE = 2'b01;
    localparam FALLING_EDGE = 2'b10;
    localparam PULSE = 2'b11;

    reg [1:0] state, next_state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            case (state)
                IDLE:      data_out <= 1'b0;
                RISING_EDGE:  data_out <= 1'b0;
                FALLING_EDGE: data_out <= 1'b0;
                PULSE:     data_out <= 1'b1;
                default:   data_out <= 1'b0;
            endcase
        end
    end

    always @(*) begin
        case (state)
            IDLE:      next_state = data_in ? RISING_EDGE : IDLE;
            RISING_EDGE:  next_state = data_in ? RISING_EDGE : FALLING_EDGE;
            FALLING_EDGE: next_state = data_in ? RISING_EDGE : IDLE;
            PULSE:     next_state = IDLE;
            default:   next_state = IDLE;
        endcase
    end

endmodule