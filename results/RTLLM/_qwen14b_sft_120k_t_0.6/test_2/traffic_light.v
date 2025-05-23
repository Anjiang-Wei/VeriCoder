module traffic_light
    (
      input rst_n, 
      input clk, 
      input pass_request,
      output wire[7:0] clock,
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
            cnt <= 0;
            p_red <= 0;
            p_yellow <= 0;
            p_green <= 0;
        end else begin
            case (state)
                idle: begin
                    p_red <= 0;
                    p_yellow <= 0;
                    p_green <= 0;
                    cnt <= 10;
                    state <= s1_red;
                end
                s1_red: begin
                    p_red <= 1;
                    p_yellow <= 0;
                    p_green <= 0;
                    if (cnt == 3) begin
                        cnt <= 60;
                        state <= s3_green;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                s2_yellow: begin
                    p_red <= 0;
                    p_yellow <= 1;
                    p_green <= 0;
                    if (cnt == 3) begin
                        cnt <= 5;
                        state <= s1_red;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                s3_green: begin
                    p_red <= 0;
                    p_yellow <= 0;
                    p_green <= 1;
                    if (cnt == 3) begin
                        cnt <= 10;
                        state <= s2_yellow;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                default: begin
                    p_red <= 0;
                    p_yellow <= 0;
                    p_green <= 0;
                    state <= idle;
                end
            endcase
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 10;
        end else begin
            if (pass_request && p_green) begin
                cnt <= 10;
            end else if (!p_green && p_yellow) begin
                cnt <= 5;
            end else if (!p_green && p_red) begin
                cnt <= 10;
            end else if (!p_green && p_green) begin
                cnt <= 60;
            end else if (cnt > 1) begin
                cnt <= cnt - 1;
            end
        end
    end

    assign clock = cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red <= 0;
            yellow <= 0;
            green <= 0;
        end else begin
            red <= p_red;
            yellow <= p_yellow;
            green <= p_green;
        end
    end

endmodule