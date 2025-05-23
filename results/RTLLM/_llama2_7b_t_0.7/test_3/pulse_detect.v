module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
) {
    // Declare a register to keep track of the current state of the pulse detection process
    reg [1:0] state = 2'b00;

    // Inside an always block, sensitive to the positive edge of clk and negative edge of rst_n
    always @(posedge clk or negedge rst_n) begin
        // In reset condition (~rst_n), set state register to initial state and data_out to 0
        if (!rst_n) begin
            state <= 2'b00;
            data_out <= 0;
        end else begin
            // Check the value of data_in and transition to next state accordingly
            case (state) is
                // If current state is 0, and data_in has changed from 0 to 1, set data_out to 1 to indicate end of pulse
               2'b00: begin
                    if (data_in && !prev_data_in) begin
                        state <= 2'b01;
                        data_out <= 1;
                    end
                end

                // If current state is 1, and data_in has changed from 1 to 0, set data_out to 0 to indicate no pulse
               2'b01: begin
                    if (data_in && !prev_data_in) begin
                        state <= 2'b00;
                        data_out <= 0;
                    end
                end

                // Otherwise, set data_out to 0 to indicate no pulse
                default: begin
                    data_out <= 0;
                end
            end
        end
    end
}