always@(posedge clk or negedge rst_n)
    if (~rst_n) rise <= 1'b0;
    else rise <= ~a ? 1 : a; //rising edge detected when the input signal changes from high to low.

always@(posedge clk or negedge rst_n)
    if (~rst_n) down <= 1'b0;
    else down <= ~a? 1 : {down, a}; //falling edge detected when the input signal changes from low to high.