module synchronizer(
    input               clk_a   , 
    input               clk_b   ,   
    input               arstn   ,  // asynchronous active-low reset for clk_a domain
    input               brstn   ,  // asynchronous active-low reset for clk_b domain
    input       [3:0]   data_in ,
    input               data_en ,

    output reg  [3:0]   dataout
);

// Internal register to capture the data from data_in in clk_a domain.
reg [3:0] data_reg;
// Internal register to capture the enable signal in clk_a domain.
reg       en_data_reg;

// Enable control registers for synchronizing data_en into clk_b domain.
reg       en_clap_one;
reg       en_clap_two;

//
// Data Register and Enable Data Register
// Captured in the clk_a domain. 
//
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg    <= 4'd0;
        en_data_reg <= 1'b0;
    end else begin
        data_reg    <= data_in;
        en_data_reg <= data_en;
    end
end

//
// Enable Control Registers Delay Chain (in clk_b domain)
// This block synchronizes the en_data_reg signal into the clk_b domain 
// with two sequential registers. 
//
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one <= 1'b0;
        en_clap_two <= 1'b0;
    end else begin
        en_clap_one <= en_data_reg;
        en_clap_two <= en_clap_one;
    end
end

//
// Output Data Assignment (in clk_b domain)
// On the rising edge of clk_b, if en_clap_two is active, update dataout
// with the value of data_reg. Otherwise, dataout retains its previous value.
//
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        dataout <= 4'd0;
    end else if (en_clap_two) begin
        dataout <= data_reg;
    end 
    // else: implicit retention of previous value (flip-flop behavior)
end

endmodule