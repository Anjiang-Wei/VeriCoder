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

    localparam 	idle = 2'd0,
                s1_red = 2'd1,
                s2_yellow = 2'd2,
                s3_green = 2'd3;

    reg [7:0] cnt;
    reg [1:0] state;
    reg p_red, p_yellow, p_green;

    always @(*) begin
        case (state)
            idle: begin
                p_red = 0; p_yellow = 0; p_green = 0;
            end
            s1_red: begin
                p_red = 1; p_yellow = 0; p_green = 0;
            end
            s2_yellow: begin
                p_red = 0; p_yellow = 1; p_green = 0;
            end
            s3_green: begin
                p_red = 0; p_yellow = 0; p_green = 1;
            end
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 10;
        end else begin
            if (pass_request && green) begin
                cnt <= 10;
            end else if (!green && p_green) begin
                cnt <= 60;
            end else if (!yellow && p_yellow) begin
                cnt <= 5;
            end else if (!red && p_red) begin
                cnt <= 10;
            end else begin
                cnt <= cnt - 1;
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red <= 0; yellow <= 0; green <= 0;
        end else begin
            red <= p_red;
            yellow <= p_yellow;
            green <= p_green;
        end
    end

    assign clock = cnt;

endmodule