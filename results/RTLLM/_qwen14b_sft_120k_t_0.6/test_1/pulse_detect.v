module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

    // Define states for pulse detection
    localparam IDLE = 2'b00;    
    localparam PULSE_1 = 2'b01;
    localparam PULSE_2 = 2'b10;

    reg [1:0] state;

    // Always block for state transitions and output generation
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= IDLE;
            data_out <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (data_in) begin
                        state <= PULSE_1;
                    end
                end
                PULSE_1: begin
                    if (data_in) begin
                        state <= PULSE_2;
                    end else begin
                        state <= IDLE;
                    end
                end
                PULSE_2: begin
                    if (data_in) begin
                        state <= PULSE_2;
                    end else begin
                        state <= IDLE;
                        data_out <= 1'b1;
                    end
                end
                default: begin
                    state <= IDLE;
                    data_out <= 1'b0;
                end
            endcase
        end
    end

endmodule