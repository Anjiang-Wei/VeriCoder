module traffic_light (
    input rst_n,
    input clk,
    input pass_request,
    output wire [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

parameter idle = 2'd0,
s1_red = 2'd1,
s2_yellow = 2'd2,
s3_green = 2'd3;

always @(posedge clk or negedge rst_n) begin
    // State transition logic
    case (state)
        idle: begin
            red <= 0;
            yellow <= 0;
            green <= 0;
            state <= idle;
        end
        s1_red: begin
            red <= 1;
            yellow <= 0;
            green <= 0;
            state <= s1_red;
        end
        s2_yellow: begin
            red <= 0;
            yellow <= 1;
            green <= 0;
            state <= s2_yellow;
        end
        s3_green: begin
            red <= 0;
            yellow <= 0;
            green <= 1;
            state <= s3_green;
        end
    endcase
end

always @*begin
    // Counting logic
    if (!rst_n) begin
        cnt <= 10;
    end else if (pass_request && green) begin
        cnt <= 10;
    end else if (green && !p_green) begin
        cnt <= 60;
    end else if (yellow && !p_yellow) begin
        cnt <= 5;
    end else begin
        cnt <= cnt - 1;
    end
end

assign clock = cnt;

always @(posedge clk or negedge rst_n) begin
    // Output signal assignment
    red <= p_red;
    yellow <= p_yellow;
    green <= p_green;
end