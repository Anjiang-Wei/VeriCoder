Please complete the rest of the code.

Please complete the code with the following implementation:

```verilog
reg [7:0]cnt;
reg [1:0]state;
reg p_red, p_yellow, p_green;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= idle;
        cnt <= 8'h0;
        p_red <= 1'b0;
        p_yellow <= 1'b0;
        p_green <= 1'b0;
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
    end else begin
        case (state)
            idle: begin
                if (cnt == 8'h00) begin
                    cnt <= 8'h03;
                    p_red <= 1'b1;
                    p_yellow <= 1'b0;
                    p_green <= 1'b0;
                    red <= p_red;
                    yellow <= p_yellow;
                    green <= p_green;
                    state <= s1_red;
                end else begin
                    cnt <= cnt - 1;
                    p_red <= 1'b0;
                    p_yellow <= 1'b0;
                    p_green <= 1'b0;
                    red <= p_red;
                    yellow <= p_yellow;
                    green <= p_green;
                end
            end
            s1_red: begin
                if (cnt == 8'h00) begin
                    cnt <= 8'h10;
                    p_red <= 1'b0;
                    p_yellow <= 1'b0;
                    p_green <= 1'b0;
                    red <= p_red;
                    yellow <= p_yellow;
                    green <= p_green;
                    state <= s3_green;
                end else begin
                    cnt <= cnt - 1;
                    p_red <= 1'b0;
                    p_yellow <= 1'b0;
                    p_green <= 1'b0;
                    red <= p_red;
                    yellow <= p_yellow;
                    green <= p_green;
                end
            end
            s2_yellow: begin
                if (cnt == 8'h00) begin
                    cnt <= 8'h05;
                    p_red <= 1'b0;
                    p_yellow <= 1'b1;
                    p_green <= 1'b0;
                    red <= p_red;
                    yellow <= p_yellow;
                    green <= p_green;
                    state <= s1_red;
                end else begin
                    cnt <= cnt - 1;
                    p_red <= 1'b0;
                    p_yellow <= 1'b0;
                    p_green <= 1'b0;
                    red <= p_red;
                    yellow <= p_yellow;
                    green <= p_green;
                end
            end
            s3_green: begin
                if (cnt == 8'h00) begin
                    cnt <= 8'h60;
                    p_red <= 1'b0;
                    p_yellow <= 1'b0;
                    p_green <= 1'b1;
                    red <= p_red;
                    yellow <= p_yellow;
                    green <= p_green;
                    state <= s2_yellow;
                end else begin
                    cnt <= cnt - 1;
                    p_red <= 1'b0;
                    p_yellow <= 1'b0;
                    p_green <= 1'b0;
                    red <= p_red;
                    yellow <= p_yellow;
                    green <= p_green;
                end
            end
            default: begin
                state <= idle;
                cnt <= 8'h00;
                p_red <= 1'b0;
                p_yellow <= 1'b0;
                p_green <= 1'b0;
                red <= 1'b0;
                yellow <= 1'b0;
                green <= 1'b0;
            end
        endcase
    end
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 8'h0;
    end else begin
        if (pass_request && green) begin
            cnt <= 8'h0A;
        end else if (!green && p_green) begin
            cnt <= 8'h60;
        end else if (!yellow && p_yellow) begin
            cnt <= 8'h05;
        end else if (!red && p_red) begin
            cnt <= 8'h0A;
        end else begin
            cnt <= cnt - 1;
        end
    end
end

assign clock = cnt;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        p_red <= 1'b0;
        p_yellow <= 1'b0;
        p_green <= 1'b0;
    end else begin
        p_red <= red;
        p_yellow <= yellow;
        p_green <= green;
    end
end

always @ (posedge clk or negedge rst_n