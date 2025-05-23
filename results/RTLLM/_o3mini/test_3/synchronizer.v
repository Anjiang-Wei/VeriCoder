module synchronizer(
    input               clk_a,      // Clock signal A for input domain 
    input               clk_b,      // Clock signal B for output domain      
    input               arstn,      // Active-low reset for clk_a domain   
    input               brstn,      // Active-low reset for clk_b domain   
    input       [3:0]   data_in,    // 4-bit input data signal        
    input               data_en,    // Data enable signal             
                                            
    output reg  [3:0]   dataout     // 4-bit output data signal       
);

//
// Declaration of internal registers
//
reg [3:0] data_reg;      // Data register capturing data_in in clk_a domain
reg       en_data_reg;   // Enable register capturing data_en in clk_a domain

reg       en_clap_one;   // First stage synchronizer register in clk_b domain
reg       en_clap_two;   // Second stage synchronizer register in clk_b domain

//
// Data and Enable Capture in clk_a Domain
//
always @(posedge clk_a or negedge arstn) begin
    if (!arstn) begin
        data_reg     <= 4'b0;
        en_data_reg  <= 1'b0;
    end
    else begin
        data_reg     <= data_in;   // Capture data_in when data_en is constant
        en_data_reg  <= data_en;   // Capture data_en signal
    end
end

//
// Synchronization of Enable Signal into clk_b Domain
//
always @(posedge clk_b or negedge brstn) begin
    if (!brstn) begin
        en_clap_one <= 1'b0;
        en_clap_two <= 1'b0;
    end
    else begin
        en_clap_one <= en_data_reg;     // First stage synchronization from clk_a to clk_b
        en_clap_two <= en_clap_one;       // Second stage to further de-glitch
    end
end

//
// Data Output Update in clk_b Domain
// Only update dataout if synchronized enable (en_clap_two) is active
//
always @(posedge clk_b or negedge brstn) begin
    if (!brstn)
        dataout <= 4'b0;
    else begin
        if (en_clap_two)
            dataout <= data_reg;  // Update output data with synchronized data_reg
        else
            dataout <= dataout;   // Retain previous value if enable is not active
    end
end

endmodule