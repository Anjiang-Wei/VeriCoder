module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);
    // Define states for the state machine
    typedef enum logic [2:0] {
        IDLE,
        DETECT_1,
        DETECT_2,
        DETECT_3
    } state_t;
    
    // Register to hold the current state
    reg [2:0] current_state;
    reg [2:0] next_state;

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            data_out <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic and output generation
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (data_in == 1'b1) begin
                    next_state = DETECT_1;
                end else begin
                    next_state = IDLE;
                end
            end
            DETECT_1: begin
                if (data_in == 1'b0) begin
                    next_state = DETECT_2;
                end else begin
                    next_state = DETECT_1;
                end
            end
            DETECT_2: begin
                if (data_in == 1'b1) begin
                    next_state = DETECT_3;
                end else begin
                    next_state = IDLE;
                end
            end
            DETECT_3: begin
                if (data_in == 1'b0) begin
                    next_state = IDLE;
                    data_out = 1;
                end else begin
                    next_state = DETECT_3;
                end
            end
            default: begin
                next_state = IDLE;
                data_out = 0;
            end
        endcase
    end

endmodule