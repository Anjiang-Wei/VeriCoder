module pulse_detect(    
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

    // State register to keep track of the pulse detection process
    reg [1:0] state;

    // Define the states
    localparam IDLE = 2'b00;
    localparam RISE = 2'b01;
    localparam FALL = 2'b10;

    // Assign initial values
    initial begin
        state = IDLE;
        data_out = 0;
    end

    // Implement the pulse detection logic
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= IDLE;
            data_out <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (data_in == 1'b1) begin
                        state <= RISE;
                    end else begin
                        state <= IDLE;
                    end
                    data_out <= 0;
                end
                RISE: begin
                    if (data_in == 1'b0) begin
                        state <= FALL;
                    end else begin
                        state <= RISE;
                    end
                    data_out <= 0;
                end
                FALL: begin
                    if (data_in == 1'b1) begin
                        state <= RISE;
                    end else begin
                        state <= IDLE;
                    end
                    data_out <= 1;
                end
                default: begin
                    state <= IDLE;
                    data_out <= 0;
                end
            endcase
        end
    end

endmodule