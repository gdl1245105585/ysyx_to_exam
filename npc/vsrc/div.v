`define DIV_FREE 0
`define DIV_ON 1
`define DIV_END 2

module div(
    input clk,
    input rst,

    input sign,
    input [63:0] div_data,
    input [63:0] dived_data,
    input div_ready,
    input shorten,

    output reg div_valid,
    output [63:0] result_hi,
    output [63:0] result_lo

);
// reg [127:0] remain_data;
// reg [63:0] result;
wire [64:0] remain_data;
wire [63:0] result;
reg [63:0] src2; 
reg [2:0] div_state;

reg [6:0] result_index;
wire [64:0] sub_data;

wire [63:0] div_data_abs;
wire [63:0] dived_data_abs;

wire div_sign_flag;
wire dived_sign_flag;

assign div_sign_flag =  shorten?sign & div_data[31]: sign & div_data[63];
assign dived_sign_flag = shorten?sign & dived_data[31]:sign &  dived_data[63];

wire [63:0] div_32_data;
assign div_32_data = div_sign_flag ? {32'd0,~div_data[31:0]+1} : {32'd0,div_data[31:0]};
assign div_data_abs = shorten? div_32_data: 
                        div_sign_flag ? ~div_data+1 : div_data;
wire [63:0] dived_32_data;
assign dived_32_data = dived_sign_flag ? {32'd0,~dived_data[31:0]+1} : {32'd0,dived_data[31:0]};
assign dived_data_abs = shorten? dived_32_data: 
                        dived_sign_flag ? ~dived_data+1 : dived_data;

// wire takeup;
// assign sub_data = remain_data[result_index+7'd64-:65] - {1'b0,src2};
// always @(posedge clk) begin
//     if(rst) begin
//         src2 <= 64'd0;
//         remain_data <= 128'd0;
//         div_state <= 3'd0;
//         result_index <= 7'd0;
//         result <= 64'd0;
//         div_valid <= 1'd0;
//     end
//     else if(div_state == `DIV_FREE) begin
//         if(div_ready) begin
//             src2 <= dived_data_abs;
//             div_state <= 3'd1;
//             result_index <= 7'd63;
//             remain_data <= {64'd0,div_data_abs};
//             div_valid <= 1'd0;
//         end
//         else 
//             div_valid <= 1'd0;
//     end
//     else if(div_state == `DIV_ON) begin
//         remain_data[result_index+7'd64-:65] <= sub_data[64] ? remain_data[result_index+7'd64-:65] : sub_data;
//         result[result_index[5:0]] <= ~sub_data[64];
//         result_index <= result_index - 7'd1;
//         if(result_index == 7'd0) begin
//             div_state  <= `DIV_END;
//             div_valid <= 1'd1;
//         end
//     end
//     else if(div_state == `DIV_END) begin
//         div_state  <= `DIV_FREE;
        
//     end
// end
wire [63:0] result;
wire [64:0] remain_data_1_1,remain_data_1_2;
assign remain_data_1_1 = {64'd0,div_data_abs[63]};
assign remain_data_1_2 =  remain_data_1_1- {1'b0,dived_data_abs};
assign result[63] = ~remain_data_1_2[64];

wire [64:0] remain_data_2_1,remain_data_2_2;
assign remain_data_2_1 = remain_data_1_2[64] ? {remain_data_1_1[63:0],div_data_abs[62]} :{remain_data_1_2[63:0],div_data_abs[62]};
assign remain_data_2_2 = remain_data_2_1 - {1'b0,dived_data_abs};
assign result[62] = ~remain_data_2_2[64];

wire [64:0] remain_data_3_1,remain_data_3_2;
assign remain_data_3_1 = remain_data_2_2[64] ? {remain_data_2_1[63:0],div_data_abs[61]} :{remain_data_2_2[63:0],div_data_abs[61]};
assign remain_data_3_2 = remain_data_3_1 - {1'b0,dived_data_abs};
assign result[61] = ~remain_data_3_2[64];

wire [64:0] remain_data_4_1,remain_data_4_2;
assign remain_data_4_1 = remain_data_3_2[64] ? {remain_data_3_1[63:0],div_data_abs[60]} :{remain_data_3_2[63:0],div_data_abs[60]};
assign remain_data_4_2 = remain_data_4_1 - {1'b0,dived_data_abs};
assign result[60] = ~remain_data_4_2[64];

wire [64:0] remain_data_5_1,remain_data_5_2;
assign remain_data_5_1 = remain_data_4_2[64] ? {remain_data_4_1[63:0],div_data_abs[59]} :{remain_data_4_2[63:0],div_data_abs[59]};
assign remain_data_5_2 = remain_data_5_1 - {1'b0,dived_data_abs};
assign result[59] = ~remain_data_5_2[64];

wire [64:0] remain_data_6_1,remain_data_6_2;
assign remain_data_6_1 = remain_data_5_2[64] ? {remain_data_5_1[63:0],div_data_abs[58]} :{remain_data_5_2[63:0],div_data_abs[58]};
assign remain_data_6_2 = remain_data_6_1 - {1'b0,dived_data_abs};
assign result[58] = ~remain_data_6_2[64];

wire [64:0] remain_data_7_1,remain_data_7_2;
assign remain_data_7_1 = remain_data_6_2[64] ? {remain_data_6_1[63:0],div_data_abs[57]} :{remain_data_6_2[63:0],div_data_abs[57]};
assign remain_data_7_2 = remain_data_7_1 - {1'b0,dived_data_abs};
assign result[57] = ~remain_data_7_2[64];

wire [64:0] remain_data_8_1,remain_data_8_2;
assign remain_data_8_1 = remain_data_7_2[64] ? {remain_data_7_1[63:0],div_data_abs[56]} :{remain_data_7_2[63:0],div_data_abs[56]};
assign remain_data_8_2 = remain_data_8_1 - {1'b0,dived_data_abs};
assign result[56] = ~remain_data_8_2[64];

wire [64:0] remain_data_9_1,remain_data_9_2;
assign remain_data_9_1 = remain_data_8_2[64] ? {remain_data_8_1[63:0],div_data_abs[55]} :{remain_data_8_2[63:0],div_data_abs[55]};
assign remain_data_9_2 = remain_data_9_1 - {1'b0,dived_data_abs};
assign result[55] = ~remain_data_9_2[64];

wire [64:0] remain_data_10_1,remain_data_10_2;
assign remain_data_10_1 = remain_data_9_2[64] ? {remain_data_9_1[63:0],div_data_abs[54]} :{remain_data_9_2[63:0],div_data_abs[54]};
assign remain_data_10_2 = remain_data_10_1 - {1'b0,dived_data_abs};
assign result[54] = ~remain_data_10_2[64];

wire [64:0] remain_data_11_1,remain_data_11_2;
assign remain_data_11_1 = remain_data_10_2[64] ? {remain_data_10_1[63:0],div_data_abs[53]} :{remain_data_10_2[63:0],div_data_abs[53]};
assign remain_data_11_2 = remain_data_11_1 - {1'b0,dived_data_abs};
assign result[53] = ~remain_data_11_2[64];

wire [64:0] remain_data_12_1,remain_data_12_2;
assign remain_data_12_1 = remain_data_11_2[64] ? {remain_data_11_1[63:0],div_data_abs[52]} :{remain_data_11_2[63:0],div_data_abs[52]};
assign remain_data_12_2 = remain_data_12_1 - {1'b0,dived_data_abs};
assign result[52] = ~remain_data_12_2[64];

wire [64:0] remain_data_13_1,remain_data_13_2;
assign remain_data_13_1 = remain_data_12_2[64] ? {remain_data_12_1[63:0],div_data_abs[51]} :{remain_data_12_2[63:0],div_data_abs[51]};
assign remain_data_13_2 = remain_data_13_1 - {1'b0,dived_data_abs};
assign result[51] = ~remain_data_13_2[64];

wire [64:0] remain_data_14_1,remain_data_14_2;
assign remain_data_14_1 = remain_data_13_2[64] ? {remain_data_13_1[63:0],div_data_abs[50]} :{remain_data_13_2[63:0],div_data_abs[50]};
assign remain_data_14_2 = remain_data_14_1 - {1'b0,dived_data_abs};
assign result[50] = ~remain_data_14_2[64];

wire [64:0] remain_data_15_1,remain_data_15_2;
assign remain_data_15_1 = remain_data_14_2[64] ? {remain_data_14_1[63:0],div_data_abs[49]} :{remain_data_14_2[63:0],div_data_abs[49]};
assign remain_data_15_2 = remain_data_15_1 - {1'b0,dived_data_abs};
assign result[49] = ~remain_data_15_2[64];

wire [64:0] remain_data_16_1,remain_data_16_2;
assign remain_data_16_1 = remain_data_15_2[64] ? {remain_data_15_1[63:0],div_data_abs[48]} :{remain_data_15_2[63:0],div_data_abs[48]};
assign remain_data_16_2 = remain_data_16_1 - {1'b0,dived_data_abs};
assign result[48] = ~remain_data_16_2[64];

wire [64:0] remain_data_17_1,remain_data_17_2;
assign remain_data_17_1 = remain_data_16_2[64] ? {remain_data_16_1[63:0],div_data_abs[47]} :{remain_data_16_2[63:0],div_data_abs[47]};
assign remain_data_17_2 = remain_data_17_1 - {1'b0,dived_data_abs};
assign result[47] = ~remain_data_17_2[64];

wire [64:0] remain_data_18_1,remain_data_18_2;
assign remain_data_18_1 = remain_data_17_2[64] ? {remain_data_17_1[63:0],div_data_abs[46]} :{remain_data_17_2[63:0],div_data_abs[46]};
assign remain_data_18_2 = remain_data_18_1 - {1'b0,dived_data_abs};
assign result[46] = ~remain_data_18_2[64];

wire [64:0] remain_data_19_1,remain_data_19_2;
assign remain_data_19_1 = remain_data_18_2[64] ? {remain_data_18_1[63:0],div_data_abs[45]} :{remain_data_18_2[63:0],div_data_abs[45]};
assign remain_data_19_2 = remain_data_19_1 - {1'b0,dived_data_abs};
assign result[45] = ~remain_data_19_2[64];

wire [64:0] remain_data_20_1,remain_data_20_2;
assign remain_data_20_1 = remain_data_19_2[64] ? {remain_data_19_1[63:0],div_data_abs[44]} :{remain_data_19_2[63:0],div_data_abs[44]};
assign remain_data_20_2 = remain_data_20_1 - {1'b0,dived_data_abs};
assign result[44] = ~remain_data_20_2[64];

wire [64:0] remain_data_21_1,remain_data_21_2;
assign remain_data_21_1 = remain_data_20_2[64] ? {remain_data_20_1[63:0],div_data_abs[43]} :{remain_data_20_2[63:0],div_data_abs[43]};
assign remain_data_21_2 = remain_data_21_1 - {1'b0,dived_data_abs};
assign result[43] = ~remain_data_21_2[64];

wire [64:0] remain_data_22_1,remain_data_22_2;
assign remain_data_22_1 = remain_data_21_2[64] ? {remain_data_21_1[63:0],div_data_abs[42]} :{remain_data_21_2[63:0],div_data_abs[42]};
assign remain_data_22_2 = remain_data_22_1 - {1'b0,dived_data_abs};
assign result[42] = ~remain_data_22_2[64];

wire [64:0] remain_data_23_1,remain_data_23_2;
assign remain_data_23_1 = remain_data_22_2[64] ? {remain_data_22_1[63:0],div_data_abs[41]} :{remain_data_22_2[63:0],div_data_abs[41]};
assign remain_data_23_2 = remain_data_23_1 - {1'b0,dived_data_abs};
assign result[41] = ~remain_data_23_2[64];

wire [64:0] remain_data_24_1,remain_data_24_2;
assign remain_data_24_1 = remain_data_23_2[64] ? {remain_data_23_1[63:0],div_data_abs[40]} :{remain_data_23_2[63:0],div_data_abs[40]};
assign remain_data_24_2 = remain_data_24_1 - {1'b0,dived_data_abs};
assign result[40] = ~remain_data_24_2[64];

wire [64:0] remain_data_25_1,remain_data_25_2;
assign remain_data_25_1 = remain_data_24_2[64] ? {remain_data_24_1[63:0],div_data_abs[39]} :{remain_data_24_2[63:0],div_data_abs[39]};
assign remain_data_25_2 = remain_data_25_1 - {1'b0,dived_data_abs};
assign result[39] = ~remain_data_25_2[64];

wire [64:0] remain_data_26_1,remain_data_26_2;
assign remain_data_26_1 = remain_data_25_2[64] ? {remain_data_25_1[63:0],div_data_abs[38]} :{remain_data_25_2[63:0],div_data_abs[38]};
assign remain_data_26_2 = remain_data_26_1 - {1'b0,dived_data_abs};
assign result[38] = ~remain_data_26_2[64];

wire [64:0] remain_data_27_1,remain_data_27_2;
assign remain_data_27_1 = remain_data_26_2[64] ? {remain_data_26_1[63:0],div_data_abs[37]} :{remain_data_26_2[63:0],div_data_abs[37]};
assign remain_data_27_2 = remain_data_27_1 - {1'b0,dived_data_abs};
assign result[37] = ~remain_data_27_2[64];

wire [64:0] remain_data_28_1,remain_data_28_2;
assign remain_data_28_1 = remain_data_27_2[64] ? {remain_data_27_1[63:0],div_data_abs[36]} :{remain_data_27_2[63:0],div_data_abs[36]};
assign remain_data_28_2 = remain_data_28_1 - {1'b0,dived_data_abs};
assign result[36] = ~remain_data_28_2[64];

wire [64:0] remain_data_29_1,remain_data_29_2;
assign remain_data_29_1 = remain_data_28_2[64] ? {remain_data_28_1[63:0],div_data_abs[35]} :{remain_data_28_2[63:0],div_data_abs[35]};
assign remain_data_29_2 = remain_data_29_1 - {1'b0,dived_data_abs};
assign result[35] = ~remain_data_29_2[64];

wire [64:0] remain_data_30_1,remain_data_30_2;
assign remain_data_30_1 = remain_data_29_2[64] ? {remain_data_29_1[63:0],div_data_abs[34]} :{remain_data_29_2[63:0],div_data_abs[34]};
assign remain_data_30_2 = remain_data_30_1 - {1'b0,dived_data_abs};
assign result[34] = ~remain_data_30_2[64];

wire [64:0] remain_data_31_1,remain_data_31_2;
assign remain_data_31_1 = remain_data_30_2[64] ? {remain_data_30_1[63:0],div_data_abs[33]} :{remain_data_30_2[63:0],div_data_abs[33]};
assign remain_data_31_2 = remain_data_31_1 - {1'b0,dived_data_abs};
assign result[33] = ~remain_data_31_2[64];

wire [64:0] remain_data_32_1,remain_data_32_2;
assign remain_data_32_1 = remain_data_31_2[64] ? {remain_data_31_1[63:0],div_data_abs[32]} :{remain_data_31_2[63:0],div_data_abs[32]};
assign remain_data_32_2 = remain_data_32_1 - {1'b0,dived_data_abs};
assign result[32] = ~remain_data_32_2[64];

wire [64:0] remain_data_33_1,remain_data_33_2;
assign remain_data_33_1 = remain_data_32_2[64] ? {remain_data_32_1[63:0],div_data_abs[31]} :{remain_data_32_2[63:0],div_data_abs[31]};
assign remain_data_33_2 = remain_data_33_1 - {1'b0,dived_data_abs};
assign result[31] = ~remain_data_33_2[64];

wire [64:0] remain_data_34_1,remain_data_34_2;
assign remain_data_34_1 = remain_data_33_2[64] ? {remain_data_33_1[63:0],div_data_abs[30]} :{remain_data_33_2[63:0],div_data_abs[30]};
assign remain_data_34_2 = remain_data_34_1 - {1'b0,dived_data_abs};
assign result[30] = ~remain_data_34_2[64];

wire [64:0] remain_data_35_1,remain_data_35_2;
assign remain_data_35_1 = remain_data_34_2[64] ? {remain_data_34_1[63:0],div_data_abs[29]} :{remain_data_34_2[63:0],div_data_abs[29]};
assign remain_data_35_2 = remain_data_35_1 - {1'b0,dived_data_abs};
assign result[29] = ~remain_data_35_2[64];

wire [64:0] remain_data_36_1,remain_data_36_2;
assign remain_data_36_1 = remain_data_35_2[64] ? {remain_data_35_1[63:0],div_data_abs[28]} :{remain_data_35_2[63:0],div_data_abs[28]};
assign remain_data_36_2 = remain_data_36_1 - {1'b0,dived_data_abs};
assign result[28] = ~remain_data_36_2[64];

wire [64:0] remain_data_37_1,remain_data_37_2;
assign remain_data_37_1 = remain_data_36_2[64] ? {remain_data_36_1[63:0],div_data_abs[27]} :{remain_data_36_2[63:0],div_data_abs[27]};
assign remain_data_37_2 = remain_data_37_1 - {1'b0,dived_data_abs};
assign result[27] = ~remain_data_37_2[64];

wire [64:0] remain_data_38_1,remain_data_38_2;
assign remain_data_38_1 = remain_data_37_2[64] ? {remain_data_37_1[63:0],div_data_abs[26]} :{remain_data_37_2[63:0],div_data_abs[26]};
assign remain_data_38_2 = remain_data_38_1 - {1'b0,dived_data_abs};
assign result[26] = ~remain_data_38_2[64];

wire [64:0] remain_data_39_1,remain_data_39_2;
assign remain_data_39_1 = remain_data_38_2[64] ? {remain_data_38_1[63:0],div_data_abs[25]} :{remain_data_38_2[63:0],div_data_abs[25]};
assign remain_data_39_2 = remain_data_39_1 - {1'b0,dived_data_abs};
assign result[25] = ~remain_data_39_2[64];

wire [64:0] remain_data_40_1,remain_data_40_2;
assign remain_data_40_1 = remain_data_39_2[64] ? {remain_data_39_1[63:0],div_data_abs[24]} :{remain_data_39_2[63:0],div_data_abs[24]};
assign remain_data_40_2 = remain_data_40_1 - {1'b0,dived_data_abs};
assign result[24] = ~remain_data_40_2[64];

wire [64:0] remain_data_41_1,remain_data_41_2;
assign remain_data_41_1 = remain_data_40_2[64] ? {remain_data_40_1[63:0],div_data_abs[23]} :{remain_data_40_2[63:0],div_data_abs[23]};
assign remain_data_41_2 = remain_data_41_1 - {1'b0,dived_data_abs};
assign result[23] = ~remain_data_41_2[64];

wire [64:0] remain_data_42_1,remain_data_42_2;
assign remain_data_42_1 = remain_data_41_2[64] ? {remain_data_41_1[63:0],div_data_abs[22]} :{remain_data_41_2[63:0],div_data_abs[22]};
assign remain_data_42_2 = remain_data_42_1 - {1'b0,dived_data_abs};
assign result[22] = ~remain_data_42_2[64];

wire [64:0] remain_data_43_1,remain_data_43_2;
assign remain_data_43_1 = remain_data_42_2[64] ? {remain_data_42_1[63:0],div_data_abs[21]} :{remain_data_42_2[63:0],div_data_abs[21]};
assign remain_data_43_2 = remain_data_43_1 - {1'b0,dived_data_abs};
assign result[21] = ~remain_data_43_2[64];

wire [64:0] remain_data_44_1,remain_data_44_2;
assign remain_data_44_1 = remain_data_43_2[64] ? {remain_data_43_1[63:0],div_data_abs[20]} :{remain_data_43_2[63:0],div_data_abs[20]};
assign remain_data_44_2 = remain_data_44_1 - {1'b0,dived_data_abs};
assign result[20] = ~remain_data_44_2[64];

wire [64:0] remain_data_45_1,remain_data_45_2;
assign remain_data_45_1 = remain_data_44_2[64] ? {remain_data_44_1[63:0],div_data_abs[19]} :{remain_data_44_2[63:0],div_data_abs[19]};
assign remain_data_45_2 = remain_data_45_1 - {1'b0,dived_data_abs};
assign result[19] = ~remain_data_45_2[64];

wire [64:0] remain_data_46_1,remain_data_46_2;
assign remain_data_46_1 = remain_data_45_2[64] ? {remain_data_45_1[63:0],div_data_abs[18]} :{remain_data_45_2[63:0],div_data_abs[18]};
assign remain_data_46_2 = remain_data_46_1 - {1'b0,dived_data_abs};
assign result[18] = ~remain_data_46_2[64];

wire [64:0] remain_data_47_1,remain_data_47_2;
assign remain_data_47_1 = remain_data_46_2[64] ? {remain_data_46_1[63:0],div_data_abs[17]} :{remain_data_46_2[63:0],div_data_abs[17]};
assign remain_data_47_2 = remain_data_47_1 - {1'b0,dived_data_abs};
assign result[17] = ~remain_data_47_2[64];

wire [64:0] remain_data_48_1,remain_data_48_2;
assign remain_data_48_1 = remain_data_47_2[64] ? {remain_data_47_1[63:0],div_data_abs[16]} :{remain_data_47_2[63:0],div_data_abs[16]};
assign remain_data_48_2 = remain_data_48_1 - {1'b0,dived_data_abs};
assign result[16] = ~remain_data_48_2[64];

wire [64:0] remain_data_49_1,remain_data_49_2;
assign remain_data_49_1 = remain_data_48_2[64] ? {remain_data_48_1[63:0],div_data_abs[15]} :{remain_data_48_2[63:0],div_data_abs[15]};
assign remain_data_49_2 = remain_data_49_1 - {1'b0,dived_data_abs};
assign result[15] = ~remain_data_49_2[64];

wire [64:0] remain_data_50_1,remain_data_50_2;
assign remain_data_50_1 = remain_data_49_2[64] ? {remain_data_49_1[63:0],div_data_abs[14]} :{remain_data_49_2[63:0],div_data_abs[14]};
assign remain_data_50_2 = remain_data_50_1 - {1'b0,dived_data_abs};
assign result[14] = ~remain_data_50_2[64];

wire [64:0] remain_data_51_1,remain_data_51_2;
assign remain_data_51_1 = remain_data_50_2[64] ? {remain_data_50_1[63:0],div_data_abs[13]} :{remain_data_50_2[63:0],div_data_abs[13]};
assign remain_data_51_2 = remain_data_51_1 - {1'b0,dived_data_abs};
assign result[13] = ~remain_data_51_2[64];

wire [64:0] remain_data_52_1,remain_data_52_2;
assign remain_data_52_1 = remain_data_51_2[64] ? {remain_data_51_1[63:0],div_data_abs[12]} :{remain_data_51_2[63:0],div_data_abs[12]};
assign remain_data_52_2 = remain_data_52_1 - {1'b0,dived_data_abs};
assign result[12] = ~remain_data_52_2[64];

wire [64:0] remain_data_53_1,remain_data_53_2;
assign remain_data_53_1 = remain_data_52_2[64] ? {remain_data_52_1[63:0],div_data_abs[11]} :{remain_data_52_2[63:0],div_data_abs[11]};
assign remain_data_53_2 = remain_data_53_1 - {1'b0,dived_data_abs};
assign result[11] = ~remain_data_53_2[64];

wire [64:0] remain_data_54_1,remain_data_54_2;
assign remain_data_54_1 = remain_data_53_2[64] ? {remain_data_53_1[63:0],div_data_abs[10]} :{remain_data_53_2[63:0],div_data_abs[10]};
assign remain_data_54_2 = remain_data_54_1 - {1'b0,dived_data_abs};
assign result[10] = ~remain_data_54_2[64];

wire [64:0] remain_data_55_1,remain_data_55_2;
assign remain_data_55_1 = remain_data_54_2[64] ? {remain_data_54_1[63:0],div_data_abs[9]} :{remain_data_54_2[63:0],div_data_abs[9]};
assign remain_data_55_2 = remain_data_55_1 - {1'b0,dived_data_abs};
assign result[9] = ~remain_data_55_2[64];

wire [64:0] remain_data_56_1,remain_data_56_2;
assign remain_data_56_1 = remain_data_55_2[64] ? {remain_data_55_1[63:0],div_data_abs[8]} :{remain_data_55_2[63:0],div_data_abs[8]};
assign remain_data_56_2 = remain_data_56_1 - {1'b0,dived_data_abs};
assign result[8] = ~remain_data_56_2[64];

wire [64:0] remain_data_57_1,remain_data_57_2;
assign remain_data_57_1 = remain_data_56_2[64] ? {remain_data_56_1[63:0],div_data_abs[7]} :{remain_data_56_2[63:0],div_data_abs[7]};
assign remain_data_57_2 = remain_data_57_1 - {1'b0,dived_data_abs};
assign result[7] = ~remain_data_57_2[64];

wire [64:0] remain_data_58_1,remain_data_58_2;
assign remain_data_58_1 = remain_data_57_2[64] ? {remain_data_57_1[63:0],div_data_abs[6]} :{remain_data_57_2[63:0],div_data_abs[6]};
assign remain_data_58_2 = remain_data_58_1 - {1'b0,dived_data_abs};
assign result[6] = ~remain_data_58_2[64];

wire [64:0] remain_data_59_1,remain_data_59_2;
assign remain_data_59_1 = remain_data_58_2[64] ? {remain_data_58_1[63:0],div_data_abs[5]} :{remain_data_58_2[63:0],div_data_abs[5]};
assign remain_data_59_2 = remain_data_59_1 - {1'b0,dived_data_abs};
assign result[5] = ~remain_data_59_2[64];

wire [64:0] remain_data_60_1,remain_data_60_2;
assign remain_data_60_1 = remain_data_59_2[64] ? {remain_data_59_1[63:0],div_data_abs[4]} :{remain_data_59_2[63:0],div_data_abs[4]};
assign remain_data_60_2 = remain_data_60_1 - {1'b0,dived_data_abs};
assign result[4] = ~remain_data_60_2[64];

wire [64:0] remain_data_61_1,remain_data_61_2;
assign remain_data_61_1 = remain_data_60_2[64] ? {remain_data_60_1[63:0],div_data_abs[3]} :{remain_data_60_2[63:0],div_data_abs[3]};
assign remain_data_61_2 = remain_data_61_1 - {1'b0,dived_data_abs};
assign result[3] = ~remain_data_61_2[64];

wire [64:0] remain_data_62_1,remain_data_62_2;
assign remain_data_62_1 = remain_data_61_2[64] ? {remain_data_61_1[63:0],div_data_abs[2]} :{remain_data_61_2[63:0],div_data_abs[2]};
assign remain_data_62_2 = remain_data_62_1 - {1'b0,dived_data_abs};
assign result[2] = ~remain_data_62_2[64];

wire [64:0] remain_data_63_1,remain_data_63_2;
assign remain_data_63_1 = remain_data_62_2[64] ? {remain_data_62_1[63:0],div_data_abs[1]} :{remain_data_62_2[63:0],div_data_abs[1]};
assign remain_data_63_2 = remain_data_63_1 - {1'b0,dived_data_abs};
assign result[1] = ~remain_data_63_2[64];

wire [64:0] remain_data_64_1,remain_data_64_2;
assign remain_data_64_1 = remain_data_63_2[64] ? {remain_data_63_1[63:0],div_data_abs[0]} :{remain_data_63_2[63:0],div_data_abs[0]};
assign remain_data_64_2 = remain_data_64_1 - {1'b0,dived_data_abs};
assign result[0] = ~remain_data_64_2[64];





assign remain_data = remain_data_64_2[64] ? remain_data_64_1 : remain_data_64_2;

wire [31:0] rem32;
assign rem32 = ~remain_data[31:0] + 1;
wire [63:0] short_rem32;
assign short_rem32 = div_sign_flag ? {{32{rem32[31]}},rem32}: {{32{remain_data[31]}},remain_data[31:0]};
wire [31:0] result32;
assign result32 = ~result[31:0] +1;
wire [63:0] short_div32;
assign short_div32 = dived_sign_flag ^ div_sign_flag? {{32{result32[31]}},result32}: {{32{result[31]}},result[31:0]};
assign result_hi = shorten? short_rem32 :
                     div_sign_flag ? ~remain_data[63:0] + 1: remain_data[63:0];
assign result_lo =  shorten? short_div32 :
                    dived_sign_flag ^ div_sign_flag ?~result +1 :  result ;
endmodule