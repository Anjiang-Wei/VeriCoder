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

    always @* begin
        case (state)
            idle: begin
                red <= 0;
                yellow <= 0;
                green <= 0;
            end
            s1_red: begin
                red <= pass_request && clock < 3;
                yellow <= 0;
                green <= 0;
            end
            s2_yellow: begin
                red <= 0;
                yellow <= pass_request && clock < 3;
                green <= 0;
            end
            s3_green: begin
                red <= 0;
                yellow <= 0;
                green <= pass_request && clock < 3;
            end
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 10;
            state <= idle;
        end else begin
            cnt <= clock - 1;
            case (state)
                idle: begin
                    if (cnt < 10) begin
                        state <= s1_red;
                    end else begin
                        state <= idle;
                    end
                end
                s1_red: begin
                    if (clock < 3) begin
                        state <= s2_yellow;
                    end else begin
                        state <= s1_red;
                    end
                end
                s2_yellow: begin
                    if (pass_request && clock < 3) begin
                        state <= s3_green;
                    end else begin
                        state <= s2_yellow;
                    end
                end
                s3_green: begin
                    if (clock < 3) begin
                        state <= idle;
                    end else begin
                        state <= s3_green;
                    end
                end
            endcase
        end
    end

    assign red = p_red;
    assign yellow = p_yellow;
    assign green = p_green;

endmodule