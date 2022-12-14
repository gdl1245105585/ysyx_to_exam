module alu(
    input wire [13:0] alu_control,
    input wire [63:0] alu_src1,
    input wire [63:0] alu_src2,
    output wire [63:0] alu_result
);

    wire op_add;
    wire op_sub;
    wire op_slt;
    wire op_sltu;
    wire op_and;
    wire op_or;
    wire op_xor;
    wire op_sll;
    wire op_srl;
    wire op_sra;
    wire op_lui;
    wire op_sllw;
    wire op_srlw;
    wire op_sraw;
    assign {op_add, op_sub, op_slt, op_sltu,
            op_and, op_or, op_xor,
            op_sll, op_srl, op_sra, op_lui,op_sraw,op_sllw,op_srlw} = alu_control;
    
    wire [63:0] add_sub_result;
    wire [63:0] slt_result;
    wire [63:0] sltu_result;
    wire [63:0] and_result;
    wire [63:0] or_result;
    wire [63:0] xor_result;
    wire [63:0] sll_result;
    wire [63:0] srl_result;
    wire [63:0] sra_result;
    wire [63:0] lui_result;
    wire [63:0] sraw_result;
    wire [63:0] srlw_result;
    wire [63:0] sllw_result;
    assign and_result = alu_src1 & alu_src2;
    assign or_result = alu_src1 | alu_src2;
    assign xor_result = alu_src1 ^ alu_src2;
    assign lui_result = alu_src2;

    wire [63:0] adder_a;
    wire [63:0] adder_b;
    wire [63:0] adder_cin;
    wire [63:0] adder_result;
    wire        adder_cout;

    assign adder_a = alu_src1;
    assign adder_b = (op_sub | op_slt | op_sltu) ? ~alu_src2 : alu_src2;
    assign adder_cin = (op_sub | op_slt | op_sltu) ? 64'b1 : 64'b0;
    assign {adder_cout, adder_result} = adder_a + adder_b + adder_cin;

    assign add_sub_result = adder_result;

    assign slt_result[63:1] = 63'b0;
    assign slt_result[0] = (alu_src1[63] & ~alu_src2[63]) 
                         | (~(alu_src1[63]^alu_src2[63]) & adder_result[63]);
    
    assign sltu_result[63:1] = 63'b0;
    assign sltu_result[0] = ~adder_cout;

    assign sll_result = alu_src1 << alu_src2[5:0];
    assign sllw_result[31:0] = alu_src1[31:0] << alu_src2[4:0];
    
    assign srl_result = alu_src1 >> alu_src2[5:0];
    assign srlw_result[31:0] = alu_src1[31:0] >> alu_src2[4:0];
    
    assign sra_result = alu_src1 >>> alu_src2[5:0];
    assign sraw_result[31:0] = ($signed(alu_src1[31:0])) >>> alu_src2[4:0];
    assign alu_result = ({64{op_add|op_sub  }} & add_sub_result)
                      | ({64{op_slt         }} & slt_result)
                      | ({64{op_sltu        }} & sltu_result)
                      | ({64{op_and         }} & and_result)
                      | ({64{op_or          }} & or_result)
                      | ({64{op_xor         }} & xor_result)
                      | ({64{op_sll         }} & sll_result)
                      | ({64{op_srl         }} & srl_result)
                      | ({64{op_srlw        }} & srlw_result)
                      | ({64{op_sllw        }} & sllw_result)
                      | ({64{op_sraw        }} & sraw_result)
                      | ({64{op_sra         }} & sra_result)
                      | ({64{op_lui         }} & lui_result);
                      
endmodule