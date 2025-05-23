The Verilog code for the FSM is as follows:
```verilog
reg [2:0] state;
always @(posedge CLK, posedge RST) begin
    if (RST) begin
        state <= 3'b000;
        MATCH <= 1'b0;
    end
    else begin
        case (state)
            3'b000: begin
                if (IN) begin
                    state <= 3'b001;
                end
            end
            3'b001: begin
                if (!IN) begin
                    state <= 3'b010;
                end
            end
            3'b010: begin
                if (IN) begin
                    state <= 3'b011;
                end
            end
            3'b011: begin
                if (IN) begin
                    state <= 3'b100;
                end
            end
            3'b100: begin
                if (!IN) begin
                    state <= 3'b101;
                end
            end
            3'b101: begin
                if (IN) begin
                    state <= 3'b110;
                end
            end
            3'b110: begin
                if (!IN) begin
                    state <= 3'b111;
                end
            end
            3'b111: begin
                if (IN) begin
                    state <= 3'b000;
                    MATCH <= 1'b1;
                end
                else begin
                    state <= 3'b000;
                end
            end
        endcase
    end
end
endmodulemodule top_module(
    input wire clk,
    input wire rst_n,
    input wire [31:0] data_in,
    input wire [1:0] mode,
    output reg [31:0] data_out
);

reg [31:0] reg1;
reg [31:0] reg2;
reg [31:0] reg3;
reg [31:0] reg4;
reg [31:0] reg5;
reg [31:0] reg6;
reg [31:0] reg7;
reg [31:0] reg8;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg1 <= 0;
        reg2 <= 0;
        reg3 <= 0;
        reg4 <= 0;
        reg5 <= 0;
        reg6 <= 0;
        reg7 <= 0;
        reg8 <= 0;
    end else begin
        case (mode)
            2'b00: begin
                reg1 <= data_in;
                reg2 <= reg1;
                reg3 <= reg2;
                reg4 <= reg3;
                reg5 <= reg4;
                reg6 <= reg5;
                reg7 <= reg6;
                reg8 <= reg7;
            end
            2'b01: begin
                reg1 <= data_in;
                reg2 <= reg1;
                reg3 <= reg2;
                reg4 <= reg3;
                reg5 <= reg4;
                reg6 <= reg5;
                reg7 <= reg6;
                reg8 <= reg7;
            end
            2'b10: begin
                reg1 <= data_in;
                reg2 <= reg1;
                reg3 <= reg2;
                reg4 <= reg3;
                reg5 <= reg4;
                reg6 <= reg5;
                reg7 <= reg6;
                reg8 <= reg7;
            end
            2'b11: begin
                reg1 <= data_in;
                reg2 <= reg1;
                reg3 <= reg2;
                reg4 <= reg3;
                reg5 <= reg4;
                reg6 <= reg5;
                reg7 <= reg6;
                reg8 <= reg7;
            end
        endcase
    end
end

always @(*) begin
    case (mode)
        2'b00: data_out = reg8;
        2'b01: data_out = reg8;
        2'b10: data_out = reg8;
        2