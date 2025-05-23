module radix2_div(
    input wire clk,
    input wire rst,
    input wire [7:0] dividend,    
    input wire [7:0] divisor,    
    input wire sign,       

    input wire opn_valid,   
    output reg res_valid,   
    input wire res_ready,   
    output wire [15:0] result
);

// Initialize variables and shift register
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        result <= 0;
        res_valid <= 0;
        dividend <= 0;
        divisor <= 0;
        sign <= 0;
    end else begin
        if (opn_valid && !res_ready) begin
            result <= dividend;
            res_valid <= 1;
        end
    end
end

// Division process
always @* begin
    counter cnt <= 0;
    start_cnt <= 0;
    shift register SR <= dividend;
    NEG_DIVISOR <= -divisor;
    
    // Division loop
    always @(posedge clk) begin
        if (start_cnt && cnt == 8) begin
            cnt <= 0;
            start_cnt <= 0;
            SR <= SR - NEG_DIVISOR;
            result <= SR;
            res_valid <= 1;
        end else if (cnt == 8) begin
            cnt <= 0;
            start_cnt <= 0;
            SR <= SR - NEG_DIvisor;
            result <= SR;
            res_valid <= 1;
        end else begin
            cnt <= cnt + 1;
            SR <= SR - NEG_DIvisor;
        end
    end
end

// Result validity
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        res_valid <= 0;
    end else begin
        if (opn_valid && !res_ready) begin
            res_valid <= 1;
        end
    end
end