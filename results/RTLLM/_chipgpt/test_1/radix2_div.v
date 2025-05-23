module radix2_div( 
    .clk( clk ),
    .rst( rst ),
    .dividend( dividend ),
    .divisor( divisor ),
    .opn_valid( opn_valid ),
    .res_valid( res_valid ),
    .result( result )
);

// Fixed point 16-bit (lower 8 bits as quotient, upper 8 bits as remainder)
reg [3:0] res; // 4-bit for the top 2 bits of the dividend, 4-bit for the 8 bit dividend
reg cnt;
reg start_cnt; // 16-bit counting register to count up to 8 (max number of bits in the dividend)
wire neg_divisor;

always @(posedge clk or negedge rst) begin
    if(!rst) begin
        res <= 'b0;
        cnt <= 0;
        start_cnt <= 16'd0;   // 2^8=256, so this should be the max counter value for the dividend to be 8 bits long.
    end
    else begin
        if(opn_valid && res_ready) res <= result;
        else res <= 'b0;
        continue();   //start the next operation when done with this one
    end
end
//Registers declarations
always @(*) begin
    case(sign)
        1'b0: neg_divisor = 16'b0;
        1'b1: neg_divisor = 16'bfffeffff_ffff;   //negated absolute value of the divisor
    endcase
end
//Division process
always @(*) begin
    case(start_cnt)
        'd15: begin
            res <= {~{8{res[3:0]}}, 16'hFF_FF_FF, {8{res[7:0]}}};   //divide by 2^8
            start_cnt <= 0;
        end
        'd14: begin
            res <= {~{8{res[3:0]}}, res[7:0]};                           //divide by 2^7
            start_cnt <= 'd15;
        end
        'd13: begin
            res <= {~{8{res[3:0]}}, {7{res[6:0]}}};                     //divide by 2^6
            start_cnt <= 'd14;
        end
        'd12: begin
            res <= {~{8{res[3:0]}}, {5{res[5:0]}}};                    //divide by 2^5
            start_cnt <= 'd13;
        end
        'd11: begin
            res <= {~{8{res[3:0]}}, {3{res[4:0]}}};                   //divide by 2^4
            start_cnt <= 'd12;
        end
        'd10: begin
            res <= {~{8{res[3:0]}}, {1{res[3:0]}}};                    //divide by 2^3
            start_cnt <= 'd11;
        end
        'd9: begin
            res <= {~{8{neg_divisor[7:0]}}, neg_divisor[6:0]};       //subtract the divisor and place in a new register
            cnt <= 0;
            start_cnt <= 1'b0;
        end
    endcase
end
//Registers update based on carry-out
always @(*) begin
    case(start_cnt)
        'd9: begin
            res[7:0] <= cnt - neg_divisor[6:0];   //subtract the divisor and place in a new register 
        end
        'd15: begin
            res[7:0] <= {8{res[3:0]}};         
        end
        'd14: begin
            res[7:0] <= {7{res[6:0]}};        
        end
        'd13: begin
            res[7:0] <= {5{res[5:0]}};     
        end
        'd12: begin
            res[7:0] <= {3{res[4:0]}};    
        end
        'd11: begin
            res[7:0] <= {1{res[3:0]}};   
        end
        default: res[7:0] = 0;
    endcase
end
assign res_valid = start_cnt /= 16'd1;
assign opn_valid && res_ready ? res_valid <= 1 : res_valid <= 0;

endmodule