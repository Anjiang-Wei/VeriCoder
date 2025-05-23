module traffic_light
    (
        input rst_n, 
        input clk, 
        input pass_request,
            output wire[7:0]clock,
            output reg red,
            output reg yellow,
            output reg green
    );
    
    parameter idle = 2'd0,
        s1_red = 2'd1,
        s2_yellow = 2'd2,
        s3_green = 2'd3;
    
    always @(posedge clk or negedge rst_n) begin
        case (state)
            idle: begin
                red <= 0;
                yellow <= 0;
                green <= 0;
            end
            s1_red: begin
                red <= pass_request & green;
                yellow <= 0;
                green <= 0;
            end
            s2_yellow: begin
                red <= 0;
                yellow <= pass_request & green;
                green <= 0;
            end
            s3_green: begin
                red <= 0;
                yellow <= 0;
                green <= pass_request & green;
            end
        endcase
    end
    
    always @* begin
        cnt <= clock - 1;
        
        case (state)
            idle: begin
                if (!rst_n) begin
                    cnt <= 10;
                end else begin
                    cnt <= 0;
                end
            end
            s1_red: begin
                if (pass_request & green) begin
                    cnt <= 60;
                end else begin
                    cnt <= 0;
                end
            end
            s2_yellow: begin
                if (!green) begin
                    cnt <= 5;
                end else begin
                    cnt <= 0;
                end
            end
            s3_green: begin
                if (green) begin
                    cnt <= 10;
                end else begin
                    cnt <= 0;
                end
            end
        endcase
    end
    
    assign red = p_red;
    assign yellow = p_yellow;
    assign green = p_green;
endmodule