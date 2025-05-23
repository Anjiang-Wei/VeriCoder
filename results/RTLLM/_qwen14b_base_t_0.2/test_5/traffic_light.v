module traffic_light
(
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

reg [7:0] cnt;
reg [1:0] state;
reg p_red, p_yellow, p_green;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        cnt <= 10;
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        case (state)
            idle: begin
                red <= 0;
                yellow <= 0;
                green <= 0;
                state <= s1_red;
                cnt <= 10;
            end
            s1_red: begin
                red <= 1;
                yellow <= 0;
                green <= 0;
                if (cnt == 10) begin
                    state <= s2_yellow;
                    cnt <= 5;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            s2_yellow: begin
                red <= 0;
                yellow <= 1;
                green <= 0;
                if (cnt == 5) begin
                    state <= s3_green;
                    cnt <= 60;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            s3_green: begin
                red <= 0;
                yellow <= 0;
                green <= 1;
                if (pass_request && cnt > 10) begin
                    cnt <= 10;
                end else if (cnt == 10) begin
                    state <= s2_yellow;
                    cnt <= 5;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            default: begin
                state <= idle;
            end
        endcase
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        p_red <= red;
        p_yellow <= yellow;
        p_green <= green;
    end
end

assign clock = cnt;

endmodule