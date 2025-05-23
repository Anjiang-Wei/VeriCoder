module div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
    );
    
    reg [15:0] dividend;
    reg [7:0] divisor;
    reg [15:0] quotient;
    reg [15:0] remainder;
    reg [15:0] temp;
    reg [15:0] shift_reg;
    reg [1:0] state;
    reg [3:0] count;
    
    // State machine states
    parameter IDLE = 2'b00;
    parameter DIVIDE = 2'b01;
    parameter DONE = 2'b10;
    
    always @(posedge A or posedge B) begin
        if (A !== dividend || B !== divisor) begin
            dividend <= A;
            divisor <= B;
            quotient <= 16'b0;
            remainder <= 16'b0;
            shift_reg <= 16'b0;
            state <= IDLE;
            count <= 4'b0;
        end
    end
    
    always @(posedge A or posedge B) begin
        case (state)
            IDLE: begin
                if (divisor !== 8'b0) begin
                    shift_reg <= {dividend[15:8], 8'b0};
                    state <= DIVIDE;
                    count <= 4'b0;
                end
            end
            DIVIDE: begin
                if (count < 4'b1111) begin
                    if (shift_reg >= divisor) begin
                        shift_reg <= shift_reg - divisor;
                        quotient <= quotient + 1;
                    end
                    shift_reg <= {shift_reg[15:1], 1'b0};
                    count <= count + 1;
                end else begin
                    state <= DONE;
                end
            end
            DONE: begin
                result <= quotient;
                odd <= shift_reg;
                state <= IDLE;
            end
        endcase
    end
endmodule