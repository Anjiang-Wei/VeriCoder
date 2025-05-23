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

// Define the shift register SR
localparam SR_WIDTH = 8;
reg [SR_WIDTH-1:0] SR;

// Define the counter cnt
localparam CNT_WIDTH = 8;
reg [CNT_WIDTH-1:0] cnt;
reg start_cnt;

// Define the negated divisor NEG_DIVISOR
reg [7:0] NEG_DIVISOR = -divisor;

// Initialize the inputs and shift register SR
assign dividend = $const(dividend);
assign divisor = $const(divisor);
assign sign = 0; // Unsigned division by default

always@(posedge clk or negedge rst) begin
    if (rst) begin
        SR <= 0;
        cnt <= 0;
        start_cnt <= 0;
    end else begin
        // Save the inputs and initialize the shift register SR
        if (opn_valid & res_ready) begin
            SR <= dividend;
            cnt <= 1;
            start_cnt <= 1;
        end
        
        // Perform the division process
        if (start_cnt == 0) begin
            // Division is complete, update result and clear counters
            if (cnt == 8) begin
                SR <= result;
                cnt <= 0;
                start_cnt <= 0;
            end else begin
                // Subtract NEG_DIVISOR, shift left and insert carry-out
                SR = SR << (cnt - 1) & ~NEG_DIVISOR;
                cnt <= cnt + 1;
            end
        end
        
        // Check for result validity
        res_valid <= (opn_valid & res_ready);
    end
end

// Output the result
assign result = SR[15:0];