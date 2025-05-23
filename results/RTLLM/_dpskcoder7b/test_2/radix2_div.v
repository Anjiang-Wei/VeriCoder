// Import libraries
`include "define.vh"

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

// Internal wires and registers
reg [15:0] remainder;
reg [15:0] quotient;
reg [7:0] dividend_abs;
reg [7:0] divisor_abs;
reg [15:0] sr;
reg [7:0] cnt;
reg start_cnt;

// Calculate absolute values
assign dividend_abs = sign ? -dividend : dividend;
assign divisor_abs = sign ? -divisor : divisor;

// Division process
always @(posedge clk or posedge rst) begin
    if (rst) begin
        sr <= {1'b1, dividend_abs, 1'b0};
        remainder <= 16'b0;
        quotient <= 16'b0;
        cnt <= 8'b0;
        start_cnt <= 1'b0;
        res_valid <= 1'b0;
    end else if (opn_valid && !res_valid) begin
        sr <= {1'b1, dividend_abs, 1'b0};
        start_cnt <= 1'b1;
    end else if (start_cnt) begin
        if (cnt == 8'd0) begin
            sr <= {1'b1, remainder, quotient[7]};
            start_cnt <= 1'b0;
        end else begin
            sr <= {sr[14:0], 1'b0};
            if ($signed(sr) >= $signed({1'b0, divisor_abs, 7'b0})) begin
                sr <= sr - {1'b0, divisor_abs, 7'b0};
                quotient <= {quotient[14:0], 1'b1};
            end else begin
                quotient <= {quotient[14:0], 1'b0};
            end
        end
        cnt <= cnt + 1'b1;
    end
    
    // Update remainder and quotient
    if (res_ready && res_valid) begin
        res_valid <= 1'b0;
        remainder <= sr[15:8];
        quotient <= {1'b0, quotient[15:1]};
    end
end

// Assign result
assign result = {quotient, remainder};

endmodule