module multi_pipe_4bit#(parameter size = 4)(
    input 						clk 		,
    input 						rst_n		,
    input	[size-1:0]			mul_a		,
    input	[size-1:0]			mul_b		,
    output	reg	[size*2-1:0]	mul_out		
);

parameter N = 2 * size;

// Extension of input signals to match the data width of the multiplier
input	[size-1:0]			ext_mul_a	= { mul_a, {size{1'b0}} };
input	[size-1:0]			ext_mul_b	= { mul_b, {size{1'b0}} };

// Generation of partial products
generate
    for (int i = 0; i < size; i++) begin : gen_part_prod
        reg	[size-1:0]	part_prod;
        if (|mul_b[i]) begin
            part_prod <= ext_mul_a[i];
        end else begin
            part_prod <= 0;
        end
    end
endgenerate

// Add of partial products
always @(posedge clk or posedge rst_n) begin
    if (rst_n) begin
        mul_out <= {N{1'b0}}; // Initialize output to 0
    end else begin
        for (int i = 0; i < N; i++) begin
            mul_out[i] <= part_prod[i];
        end
    end
end