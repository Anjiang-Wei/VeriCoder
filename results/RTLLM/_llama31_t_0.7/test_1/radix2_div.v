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

// Internal signals and registers
reg signed [7:0] dividend_abs;
reg signed [7:0] divisor_abs;
reg signed [15:0] shift_reg;
reg signed [1:0] cnt;
reg start_cnt;
reg signed [8:0] neg_divisor;

reg [7:0] remainder;
reg [7:0] quotient;
reg [2:0] sub_result;

always @(posedge clk)
begin
    if (rst == 1'b1) begin
        shift_reg <= 16'd0;
        cnt <= 8'd0;
        start_cnt <= 1'b0;
        res_valid <= 1'b0;
    end else if (opn_valid == 1'b1 && res_valid == 1'b0) begin
        // Save inputs and initialize variables
        dividend_abs <= |dividend;
        divisor_abs <= |divisor;
        neg_divisor <= -|divisor;

        start_cnt <= 1'b1;
        cnt <= 8'd1;
        shift_reg <= {8'd0, dividend_abs};
    end else if (start_cnt == 1'b1) begin
        // Division process
        case (cnt)
            8'd1: begin
                sub_result[2] = shift_reg[15];
                sub_result[1] = shift_reg[14];
                sub_result[0] = shift_reg[13];

                if (sub_result == neg_divisor) begin
                    // Quotient is too large, remainder will be 0 and quotient will be -1
                    remainder <= 8'd0;
                    quotient <= 8'd-1;
                end else begin
                    // Update shift register with new result
                    shift_reg[15:12] <= sub_result;

                    // Check if division is complete
                    if (cnt == 8'd8) begin
                        cnt <= 8'd0;
                        start_cnt <= 1'b0;
                        res_valid <= 1'b1; // Result valid, wait for res_ready

                        remainder <= shift_reg[15:8];
                        quotient <= shift_reg[7:0];
                    end else begin
                        cnt <= cnt + 1;
                    end
                end
            end
            default: begin
                sub_result[2] = shift_reg[15];
                sub_result[1] = shift_reg[14];
                sub_result[0] = shift_reg[13];

                if (sub_result == neg_divisor) begin
                    // Quotient is too large, remainder will be 0 and quotient will be -1
                    remainder <= 8'd0;
                    quotient <= 8'd-1;
                end else begin
                    // Update shift register with new result
                    shift_reg[15:12] <= sub_result;

                    // Check if division is complete
                    if (cnt == 8'd8) begin
                        cnt <= 8'd0;
                        start_cnt <= 1'b0;
                        res_valid <= 1'b1; // Result valid, wait for res_ready

                        remainder <= shift_reg[15:8];
                        quotient <= shift_reg[7:0];
                    end else begin
                        cnt <= cnt + 1;

                        if (sub_result[2] == neg_divisor[8]) begin
                            // Left shift result
                            shift_reg[15:12] <= {shift_reg[11:8], shift_reg[15]};
                        end else begin
                            // Insert carry-out
                            shift_reg[15:12] <= {1'b0, sub_result};
                        end
                    end
                end
            end
        endcase
    end

    // Manage result validity
    if (res_valid == 1'b1 && res_ready == 1'b1) begin
        res_valid <= 1'b0;
    end
end

// Assign output port values
assign result[15:8] = remainder;
assign result[7:0] = quotient;

endmodule