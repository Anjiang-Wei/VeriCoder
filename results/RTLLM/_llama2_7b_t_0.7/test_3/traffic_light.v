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

input rst_n (active low);
input clk (clock signal);
input pass_request (request signal for allowing vehicles to pass);

output wire [7:0] clock;
output reg red, yellow, green;

// Internal counter and state machine
wire [1:0] state = idle;
reg cnt = 10;
reg p_red, p_yellow, p_green;

always @(posedge clk or negedge rst_n) begin
    // State transition logic
    case (state)
        idle: begin
            if (!rst_n && pass_request)
                state <= s1_red;
            else if (state == s1_red && cnt > 0)
                state <= s3_green;
            else if (state == s2_yellow && cnt > 0)
                state <= s1_red;
            else
                state <= idle;
        end
        s1_red: begin
            if (cnt > 0)
                state <= s2_yellow;
            else
                state <= idle;
        end
        s2_yellow: begin
            if (cnt > 0)
                state <= s3_green;
            else
                state <= idle;
        end
        s3_green: begin
            if (cnt > 0)
                state <= s1_red;
            else
                state <= idle;
        end
    end
    
    // Counter logic
    cnt <= min(cnt - 1, 10);
end

always @* begin
    // Output signal logic
    case (state)
        idle: begin
            red <= 0;
            yellow <= 0;
            green <= 0;
        end
        s1_red: begin
            red <= 1;
            yellow <= 0;
            green <= 0;
        end
        s2_yellow: begin
            red <= 0;
            yellow <= 1;
            green <= 0;
        end
        s3_green: begin
            red <= 0;
            yellow <= 0;
            green <= 1;
        end
    end
end

// Connect the signals to the output ports
assign clock = cnt;
assign red = p_red;
assign yellow = p_yellow;
assign green = p_green;