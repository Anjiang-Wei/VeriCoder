module top_module (
    input clk,
    input reset,
    input [7:0] data_in,
    input [2:0] op_code,
    output [7:0] data_out
);

reg [7:0] reg1, reg2, reg3, reg4;

always @(posedge clk) begin
    if (reset) begin
        reg1 <= 8'b0;
        reg2 <= 8'b0;
        reg3 <= 8'b0;
        reg4 <= 8'b0;
    end else begin
        case (op_code)
            3'b000: reg1 <= data_in; // Load data into register 1
            3'b001: reg2 <= data_in; // Load data into register 2
            3'b010: reg3 <= data_in; // Load data into register 3
            3'b011: reg4 <= data_in; // Load data into register 4
            3'b100: data_out <= reg1; // Output data from register 1
            3'b101: data_out <= reg2; // Output data from register 2
            3'b110: data_out <= reg3; // Output data from register 3
            3'b111: data_out <= reg4; // Output data from register 4
        endcase
    end
end

endmodule