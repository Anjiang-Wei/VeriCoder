reg [7:0] dividend_abs;
reg [7:0] divisor_abs;
reg [7:0] dividend_neg;
reg [7:0] divisor_neg;
reg [7:0] sr;
reg [7:0] sr_neg;
reg [7:0] sr_abs;
reg [7:0] sr_shift;
reg [7:0] sr_shift_neg;
reg [2:0] cnt;
reg start_cnt;
reg [7:0] shift_reg;
reg [7:0] shift_reg_neg;
reg [7:0] shift_reg_abs;
reg [7:0] shift_reg_shift;
reg [7:0] shift_reg_shift_neg;

reg [7:0] sub_result;
reg [7:0] sub_result_abs;
reg [7:0] sub_result_neg;
reg [7:0] sub_result_shift;
reg [7:0] sub_result_shift_neg;

reg [7:0] sub_result_carry;
reg [7:0] sub_result_carry_shift;
reg [7:0] sub_result_carry_shift_neg;

reg [7:0] sub_result_carry_reg;
reg [7:0] sub_result_carry_reg_shift;
reg [7:0] sub_result_carry_reg_shift_neg;

reg [7:0] shift_carry;
reg [7:0] shift_carry_shift;
reg [7:0] shift_carry_shift_neg;
reg [7:0] shift_carry_reg;
reg [7:0] shift_carry_reg_shift;
reg [7:0] shift_carry_reg_shift_neg;

reg [7:0] quotient;
reg [7:0] remainder;

reg [7:0] temp;
reg [7:0] temp_shift;
reg [7:0] temp_shift_neg;
reg [7:0] temp_shift_abs;
reg [7:0] temp_shift_reg;
reg [7:0] temp_shift_reg_neg;
reg [7:0] temp_shift_reg_abs;
reg [7:0] temp_shift_reg_shift;
reg [7:0] temp_shift_reg_shift_neg;

reg [7:0] temp_carry;
reg [7:0] temp_carry_shift;
reg [7:0] temp_carry_shift_neg;
reg [7:0] temp_carry_reg;
reg [7:0] temp_carry_reg_shift;
reg [7:0] temp_carry_reg_shift_neg;

reg [7:0] temp_quotient;
reg [7:0] temp_remainder;

reg [7:0] final_quotient;
reg [7:0] final_remainder;

reg [7:0] final_quotient_abs;
reg [7:0] final_remainder_abs;
reg [7:0] final_quotient_neg;
reg [7:0] final_remainder_neg;

reg [7:0] final_quotient_shift;
reg [7:0] final_remainder_shift;
reg [7:0] final_quotient_shift_neg;
reg [7:0] final_remainder_shift_neg;

reg [7:0] final_quotient_shift_reg;
reg [7:0] final_remainder_shift_reg;
reg [7:0] final_quotient_shift_reg_neg;
reg [7:0] final_remainder_shift_reg_neg;

reg [7:0] final_quotient_shift_reg_shift;
reg [7:0] final_remainder_shift_reg_shift;
reg [7:0] final_quotient_shift_reg_shift_neg;
reg [7:0] final_remainder_shift_reg_shift_neg;

reg [7:0] final_quotient_shift_reg_shift_abs;
reg [7:0] final_remainder_shift_reg_shift_abs;
reg [7:0] final_quotient_shift_reg_shift_neg_abs;
reg [7:0] final_remainder_shift_reg_shift_neg_abs;

reg [7:0] final_quotient_shift_reg_shift_reg;
reg [7:0] final_remainder_shift_reg_shift_reg;
reg [7:0] final_quotient_shift_reg_shift_reg_neg;
reg [7:0] final_remainder_shift_reg_shift_reg_neg;

reg [7:0] final_quotient_shift_reg_shift_reg_shift;
reg [7:0] final_remainder_shift_reg_shift_reg_shift;
reg [7:0] final_quotient_shift_reg_shift_reg_shift_neg;
reg [7:0] final_remainder_shift_reg_shift_reg_shift_neg;

reg [7:0] final_quotient_shift_reg_shift_reg_shift_abs;
reg [7:0] final_remainder_shift_reg_shift_reg_shift_abs;
reg [7:0] final_quotient_shift_reg_shift_reg_shift_neg_abs;
reg [7:0] final_remainder_shift_reg_shift_reg_shift_neg_abs;

reg [7:0] final_quotient_shift_reg_shift