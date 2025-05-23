module traffic_light (
    input           rst_n,        // active‐low reset
    input           clk,          // system clock
    input           pass_request, // pedestrian request button
    output wire[7:0] clock,       // current counter value
    output reg      red,
    output reg      yellow,
    output reg      green
);

    // FSM state encoding
    parameter idle     = 2'd0,
              s1_red   = 2'd1,
              s2_yellow= 2'd2,
              s3_green = 2'd3;

    // State & counter
    reg [1:0]  state,    next_state;
    reg [7:0]  cnt,      next_cnt;
    // Next‐cycle outputs
    reg        p_red,    p_yellow,    p_green;

    //============================================================================
    // 1) Combinational block: compute next_state, next_cnt, and next outputs
    //============================================================================
    always @* begin
        // default assignments
        next_state  = state;
        next_cnt    = cnt - 8'd1;  // normally count down
        p_red       = 1'b0;
        p_yellow    = 1'b0;
        p_green     = 1'b0;

        case(state)
        //----------------------------------------------------------------------
        // idle: upon coming out of reset, go immediately to RED (10 ticks)
        idle: begin
            next_state = s1_red;
            next_cnt   = 8'd10;
        end

        //----------------------------------------------------------------------
        // s1_red: RED on for 10 ticks, then go GREEN(60)
        s1_red: begin
            p_red = 1'b1;
            if (cnt == 8'd1) begin
                next_state = s3_green;
                next_cnt   = 8'd60;
            end
        end

        //----------------------------------------------------------------------
        // s3_green: GREEN on for 60 ticks, but if pass_request arrives
        // and remaining >10, shorten to 10.  When it expires, go YELLOW(5).
        s3_green: begin
            p_green = 1'b1;
            if (cnt == 8'd1) begin
                // normal expiry of green
                next_state = s2_yellow;
                next_cnt   = 8'd5;
            end
            else if (pass_request && (cnt > 8'd10)) begin
                // pedestrian pushes button, cut to 10 if more remaining
                next_cnt = 8'd10;
            end
        end

        //----------------------------------------------------------------------
        // s2_yellow: YELLOW on for 5 ticks, then go RED(10)
        s2_yellow: begin
            p_yellow = 1'b1;
            if (cnt == 8'd1) begin
                next_state = s1_red;
                next_cnt   = 8'd10;
            end
        end

        //----------------------------------------------------------------------
        default: begin
            next_state = idle;
            next_cnt   = 8'd0;
        end

        endcase
    end


    //============================================================================
    // 2) Sequential block: update state, counter, and outputs on clock edge
    //============================================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // asynchronous reset
            state   <= idle;
            cnt     <= 8'd0;
            red     <= 1'b0;
            yellow  <= 1'b0;
            green   <= 1'b0;
        end
        else begin
            state   <= next_state;
            cnt     <= next_cnt;
            red     <= p_red;
            yellow  <= p_yellow;
            green   <= p_green;
        end
    end

    //============================================================================
    // 3) Drive the 8‐bit counter output
    //============================================================================
    assign clock = cnt;

endmodule