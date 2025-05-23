module pulse_detect(    
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

    // State definition
    localparam IDLE = 0;
    localparam RISE = 1;
    localparam FALL = 2;

    // State register
    reg [1:0] state;

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= IDLE;
            data_out <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (data_in == 1) begin
                        state <= RISE;
                    end else begin
                        state <= IDLE;
                    end
                end
                RISE: begin
                    if (data_in == 0) begin
                        state <= FALL;
                    end else begin
                        state <= RISE;
                    end
                end
                FALL: begin
                    if (data_in == 1) begin
                        state <= RISE;
                    end else begin
                        state <= IDLE;
                        data_out <= 1;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end

    // Output logic
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            data_out <= 0;
        end else begin
            if (state == FALL) begin
                data_out <= 1;
            end else begin
                data_out <= 0;
            end
        end
    end

endmodule