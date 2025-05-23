module traffic_light
    (
        input        rst_n, 
        input        clk, 
        input        pass_request,
        output wire [7:0] clock,
        output reg       red,
        output reg       yellow,
        output reg       green
    );

    // state encoding
    parameter   idle      = 2'd0,
                s1_red    = 2'd1,
                s2_yellow = 2'd2,
                s3_green  = 2'd3;

    // internal registers
    reg [7:0]  cnt;
    reg [1:0]  state;
    reg        p_red, p_yellow, p_green;

    //========================================================================
    // 1) State register and next‐output logic
    //========================================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= idle;
            p_red    <= 1'b0;
            p_yellow <= 1'b0;
            p_green  <= 1'b0;
        end else begin
            case (state)
                idle: begin
                    state    <= s1_red;
                    p_red    <= 1'b1;
                    p_yellow <= 1'b0;
                    p_green  <= 1'b0;
                end

                s1_red: begin
                    // red for cnt cycles, then go to green
                    p_red    <= 1'b1;
                    p_yellow <= 1'b0;
                    p_green  <= 1'b0;
                    if (cnt == 8'd0)
                        state <= s3_green;
                    else
                        state <= s1_red;
                end

                s3_green: begin
                    // green for cnt cycles, then go to yellow
                    p_red    <= 1'b0;
                    p_yellow <= 1'b0;
                    p_green  <= 1'b1;
                    if (cnt == 8'd0)
                        state <= s2_yellow;
                    else
                        state <= s3_green;
                end

                s2_yellow: begin
                    // yellow for cnt cycles, then go to red
                    p_red    <= 1'b0;
                    p_yellow <= 1'b1;
                    p_green  <= 1'b0;
                    if (cnt == 8'd0)
                        state <= s1_red;
                    else
                        state <= s2_yellow;
                end

                default: begin
                    state    <= idle;
                    p_red    <= 1'b0;
                    p_yellow <= 1'b0;
                    p_green  <= 1'b0;
                end
            endcase
        end
    end

    //========================================================================
    // 2) Counter reload / decrement logic
    //========================================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // on reset, start with red for 10 cycles
            cnt <= 8'd10;
        end else if (pass_request && green && (cnt > 8'd10)) begin
            // pedestrian request shortens green to 10 if more remains
            cnt <= 8'd10;
        end else if (!green && p_green) begin
            // just entered green
            cnt <= 8'd60;
        end else if (!yellow && p_yellow) begin
            // just entered yellow
            cnt <= 8'd5;
        end else if (!red && p_red) begin
            // just entered red
            cnt <= 8'd10;
        end else begin
            // normal countdown
            cnt <= cnt - 8'd1;
        end
    end

    //========================================================================
    // 3) Output registers assignment
    //========================================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red    <= 1'b0;
            yellow <= 1'b0;
            green  <= 1'b0;
        end else begin
            red    <= p_red;
            yellow <= p_yellow;
            green  <= p_green;
        end
    end

    // expose the counter value
    assign clock = cnt;

endmodule