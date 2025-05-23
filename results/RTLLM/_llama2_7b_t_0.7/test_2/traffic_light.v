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
    
    always @(posedge clk or negedge rst_n) begin
        case (state)
            idle: begin
                red <= 0;
                yellow <= 0;
                green <= 0;
            end
            s1_red: begin
                if (pass_request && !green) begin
                    clock <= 10;
                    state <= s3_green;
                end else begin
                    clock <= 3;
                    state <= idle;
                end
            end
            s2_yellow: begin
                if (pass_request && green) begin
                    clock <= 10;
                    state <= s1_red;
                end else begin
                    clock <= 3;
                    state <= s2_yellow;
                end
            end
            s3_green: begin
                if (pass_request && !yellow) begin
                    clock <= 10;
                    state <= s2_yellow;
                end else begin
                    clock <= 3;
                    state <= s3_green;
                end
            end
        endcase
    end
    
    always @* begin
        case (state)
            idle: begin
                cnt <= 10;
            end
            s1_red: begin
                cnt <= 3;
            end
            s2_yellow: begin
                cnt <= 5;
            end
            s3_green: begin
                cnt <= 60 - green;
            end
        endcase
    end
    
    assign red = p_red;
    assign yellow = p_yellow;
    assign green = p_green;
endmodule