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
    
    parameter 	idle = 2'd0,
                s1_red = 2'd1,
                s2_yellow = 2'd2,
                s3_green = 2'd3;
                
    reg [2:0] state, next_state;
    reg [7:0] cnt, next_cnt;
    
    // Internal counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 8'hA;
        end else begin
            cnt <= next_cnt;
        end
    end
    
    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
        end else begin
            state <= next_state;
        end
    end
    
    // Next state and counter logic
    always @(*) begin
        case(state)
            idle: begin
                if (pass_request) begin
                    next_state = s1_red;
                    next_cnt = 8'hA;
                end else begin
                    next_state = idle;
                    next_cnt = 8'hA;
                end
            end
            s1_red: begin
                if (cnt == 8'h0) begin
                    next_state = s3_green;
                    next_cnt = 8'h3C;
                end else begin
                    next_state = s1_red;
                    next_cnt = cnt - 8'h1;
                end
            end
            s2_yellow: begin
                if (cnt == 8'h0) begin
                    next_state = s1_red;
                    next_cnt = 8'h3;
                end else begin
                    next_state = s2_yellow;
                    next_cnt = cnt - 8'h1;
                end
            end
            s3_green: begin
                if (cnt == 8'h0) begin
                    next_state = s2_yellow;
                    next_cnt = 8'h3C;
                end else begin
                    next_state = s3_green;
                    cnt = cnt - 8'h1;
                end
            end
        endcase
    end
    
    // Output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red <= 1'b0;
            yellow <= 1'b0;
            green <= 1'b0;
        end else begin
            red <= (state == s1_red);
            yellow <= (state == s2_yellow);
            green <= (state == s3_green);
        end
    end
    
    // Assign clock output
    assign clock = cnt;
    
endmodule