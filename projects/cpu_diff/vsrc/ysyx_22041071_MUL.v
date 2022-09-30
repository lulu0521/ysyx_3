`include "define.v"
module ysyx_22041071_MUL(
			input 		  		flush		 ,//取消乘法
			input 		  		mul_valid	 ,//高表示输入数据有效
			input 		  		mulw		 ,//为1表示32位乘法
			input  		[1 :0]	mul_signed 	 ,//2’b11(s x s);2’b10(s x uns);2’b00(uns x uns)；
			input  		[63:0]	mul_1		 ,//被乘数
			input  		[63:0]	mul_2		 ,//乘数
			output reg 		  	mul_ready	 ,//高表示乘法器准备好了
			output reg 	  		out_valid	 ,//高表示输出结果有效
			output reg 	[63:0] 	result_h	 ,
			output reg 	[63:0] 	result_l	 );
	
	reg  		 data_valid		 ;//数据是否有效
	reg  [131:0] multiplicand	 ;//被乘数
	reg  [66 :0] multiplier		 ;//乘数
	wire [131:0] part_pro [0: 32];//33个部分积
	wire [32 :0] switch_  [0:131];//将部分积转置的结果
	reg  [131:0] result			 ;

/*======================输入数据是否有效=======================*/		
	always@(*)begin
		if(flush)begin
			data_valid = 1'b0	  ;
		end else begin
			data_valid = mul_valid;
		end
	end

/*======================确定乘数和被乘数=======================*/			
	always@(*)begin
		if(mulw)begin
			case(mul_signed)
				2'b00:begin
					multiplicand = {{100{1'b0}},{mul_1[31:0]}};
				    multiplier	 = {{34 {1'b0}},{mul_2[31:0]},{1'b0}};  
				end
				2'b10:begin
					multiplicand = {{100{mul_1[31]}},{mul_1[31:0]}};
					multiplier	 = {{34 {1'b0}},{mul_2[31:0]},{1'b0}}; 
				end
				2'b11:begin
					multiplicand = {{100{mul_1[31]}},{mul_1[31:0]}};
					multiplier	 = {{34 {mul_2[31]}},{mul_2[31:0]},{1'b0}};
				end
				default:begin
					multiplicand = 132'h0;
					multiplier	 = 67 'h0;
				end
			endcase
		end else begin
			case(mul_signed)
				2'b00:begin
					multiplicand = {{68{1'b0}},{mul_1[63:0]}};
				    multiplier	 = {{2 {1'b0}},{mul_2[63:0]},{1'b0}};  
				end
				2'b10:begin
					multiplicand = {{68{mul_1[63]}},{mul_1[63:0]}};
					multiplier	 = {{2 {1'b0}},{mul_2[63:0]},{1'b0}};  
				end
				2'b11:begin
					multiplicand = {{68{mul_1[63]}},{mul_1[63:0]}};
				    multiplier	 = {{2 {mul_2[63]}},{mul_2[63:0]},{1'b0}};  
				end
				default:begin
					multiplicand = 132'h0;
					multiplier	 = 67 'h0;
				end
			endcase
		end
		
	end
/*======================确定输出是否有效/乘法器是否准备好=======================*/			
	always@(*)begin
		if(data_valid)begin
			out_valid = 1'b1;
			mul_ready = 1'b0;
		end else begin
			out_valid = 1'b0;
			mul_ready = 1'b1;
		end
	end
/*======================计算结果=======================*/
//两位booth	
	ysyx_22041071_booth2_part my_part0 (.x(multiplicand     ), .y(multiplier[2 :0 ]), .part(part_pro[0 ]));
	ysyx_22041071_booth2_part my_part1 (.x(multiplicand <<2 ), .y(multiplier[4 :2 ]), .part(part_pro[1 ]));
	ysyx_22041071_booth2_part my_part2 (.x(multiplicand <<4 ), .y(multiplier[6 :4 ]), .part(part_pro[2 ]));
	ysyx_22041071_booth2_part my_part3 (.x(multiplicand <<6 ), .y(multiplier[8 :6 ]), .part(part_pro[3 ]));
	ysyx_22041071_booth2_part my_part4 (.x(multiplicand <<8 ), .y(multiplier[10:8 ]), .part(part_pro[4 ]));
	ysyx_22041071_booth2_part my_part5 (.x(multiplicand <<10), .y(multiplier[12:10]), .part(part_pro[5 ]));
	ysyx_22041071_booth2_part my_part6 (.x(multiplicand <<12), .y(multiplier[14:12]), .part(part_pro[6 ]));
	ysyx_22041071_booth2_part my_part7 (.x(multiplicand <<14), .y(multiplier[16:14]), .part(part_pro[7 ]));
	ysyx_22041071_booth2_part my_part8 (.x(multiplicand <<16), .y(multiplier[18:16]), .part(part_pro[8 ]));
	ysyx_22041071_booth2_part my_part9 (.x(multiplicand <<18), .y(multiplier[20:18]), .part(part_pro[9 ]));
	ysyx_22041071_booth2_part my_part10(.x(multiplicand <<20), .y(multiplier[22:20]), .part(part_pro[10]));
	ysyx_22041071_booth2_part my_part11(.x(multiplicand <<22), .y(multiplier[24:22]), .part(part_pro[11]));
	ysyx_22041071_booth2_part my_part12(.x(multiplicand <<24), .y(multiplier[26:24]), .part(part_pro[12]));
	ysyx_22041071_booth2_part my_part13(.x(multiplicand <<26), .y(multiplier[28:26]), .part(part_pro[13]));
	ysyx_22041071_booth2_part my_part14(.x(multiplicand <<28), .y(multiplier[30:28]), .part(part_pro[14]));
	ysyx_22041071_booth2_part my_part15(.x(multiplicand <<30), .y(multiplier[32:30]), .part(part_pro[15]));
	ysyx_22041071_booth2_part my_part16(.x(multiplicand <<32), .y(multiplier[34:32]), .part(part_pro[16]));
	ysyx_22041071_booth2_part my_part17(.x(multiplicand <<34), .y(multiplier[36:34]), .part(part_pro[17]));
	ysyx_22041071_booth2_part my_part18(.x(multiplicand <<36), .y(multiplier[38:36]), .part(part_pro[18]));
	ysyx_22041071_booth2_part my_part19(.x(multiplicand <<38), .y(multiplier[40:38]), .part(part_pro[19]));
	ysyx_22041071_booth2_part my_part20(.x(multiplicand <<40), .y(multiplier[42:40]), .part(part_pro[20]));
	ysyx_22041071_booth2_part my_part21(.x(multiplicand <<42), .y(multiplier[44:42]), .part(part_pro[21]));
	ysyx_22041071_booth2_part my_part22(.x(multiplicand <<44), .y(multiplier[46:44]), .part(part_pro[22]));
	ysyx_22041071_booth2_part my_part23(.x(multiplicand <<46), .y(multiplier[48:46]), .part(part_pro[23]));
	ysyx_22041071_booth2_part my_part24(.x(multiplicand <<48), .y(multiplier[50:48]), .part(part_pro[24]));
	ysyx_22041071_booth2_part my_part25(.x(multiplicand <<50), .y(multiplier[52:50]), .part(part_pro[25]));
	ysyx_22041071_booth2_part my_part26(.x(multiplicand <<52), .y(multiplier[54:52]), .part(part_pro[26]));
	ysyx_22041071_booth2_part my_part27(.x(multiplicand <<54), .y(multiplier[56:54]), .part(part_pro[27]));
	ysyx_22041071_booth2_part my_part28(.x(multiplicand <<56), .y(multiplier[58:56]), .part(part_pro[28]));
	ysyx_22041071_booth2_part my_part29(.x(multiplicand <<58), .y(multiplier[60:58]), .part(part_pro[29]));
	ysyx_22041071_booth2_part my_part30(.x(multiplicand <<60), .y(multiplier[62:60]), .part(part_pro[30]));
	ysyx_22041071_booth2_part my_part31(.x(multiplicand <<62), .y(multiplier[64:62]), .part(part_pro[31]));
	ysyx_22041071_booth2_part my_part32(.x(multiplicand <<64), .y(multiplier[66:64]), .part(part_pro[32]));
	
//转置	
	ysyx_22041071_switch my_switch(
					 .part0 	(part_pro[0 ]),
					 .part1 	(part_pro[1 ]),
					 .part2 	(part_pro[2 ]),
					 .part3 	(part_pro[3 ]),
					 .part4 	(part_pro[4 ]),
					 .part5 	(part_pro[5 ]),
					 .part6 	(part_pro[6 ]),
					 .part7 	(part_pro[7 ]),
					 .part8 	(part_pro[8 ]),
					 .part9 	(part_pro[9 ]),
					 .part10	(part_pro[10]),
					 .part11	(part_pro[11]),
					 .part12	(part_pro[12]),
					 .part13	(part_pro[13]),
					 .part14	(part_pro[14]),
					 .part15	(part_pro[15]),
					 .part16	(part_pro[16]),
					 .part17	(part_pro[17]),
					 .part18	(part_pro[18]),
					 .part19	(part_pro[19]),
					 .part20	(part_pro[20]),
					 .part21	(part_pro[21]),
					 .part22	(part_pro[22]),
					 .part23	(part_pro[23]),
					 .part24	(part_pro[24]),
					 .part25	(part_pro[25]),
					 .part26	(part_pro[26]),
					 .part27	(part_pro[27]),
					 .part28	(part_pro[28]),
					 .part29	(part_pro[29]),
					 .part30	(part_pro[30]),
					 .part31	(part_pro[31]),
					 .part32	(part_pro[32]),			  
					 .switch0   (switch_[0  ]),
					 .switch1   (switch_[1  ]),
					 .switch2   (switch_[2  ]),
					 .switch3   (switch_[3  ]),
					 .switch4   (switch_[4  ]),
					 .switch5   (switch_[5  ]),
					 .switch6   (switch_[6  ]),
					 .switch7   (switch_[7  ]),
					 .switch8   (switch_[8  ]),
					 .switch9   (switch_[9  ]),
					 .switch10  (switch_[10 ]),
					 .switch11  (switch_[11 ]),
					 .switch12  (switch_[12 ]),
					 .switch13  (switch_[13 ]),
					 .switch14  (switch_[14 ]),
					 .switch15  (switch_[15 ]),
					 .switch16  (switch_[16 ]),
					 .switch17  (switch_[17 ]),
					 .switch18  (switch_[18 ]),
					 .switch19  (switch_[19 ]),
					 .switch20  (switch_[20 ]),
					 .switch21  (switch_[21 ]),
					 .switch22  (switch_[22 ]),
					 .switch23  (switch_[23 ]),
					 .switch24  (switch_[24 ]),
					 .switch25  (switch_[25 ]),
					 .switch26  (switch_[26 ]),
					 .switch27  (switch_[27 ]),
					 .switch28  (switch_[28 ]),
					 .switch29  (switch_[29 ]),
					 .switch30  (switch_[30 ]),
					 .switch31  (switch_[31 ]),
					 .switch32  (switch_[32 ]),
					 .switch33  (switch_[33 ]),
					 .switch34  (switch_[34 ]),
					 .switch35  (switch_[35 ]),
					 .switch36  (switch_[36 ]),
					 .switch37  (switch_[37 ]),
					 .switch38  (switch_[38 ]),
					 .switch39  (switch_[39 ]),
					 .switch40  (switch_[40 ]),
					 .switch41  (switch_[41 ]),
					 .switch42  (switch_[42 ]),
					 .switch43  (switch_[43 ]),
					 .switch44  (switch_[44 ]),
					 .switch45  (switch_[45 ]),
					 .switch46  (switch_[46 ]),
					 .switch47  (switch_[47 ]),
					 .switch48  (switch_[48 ]),
					 .switch49  (switch_[49 ]),
					 .switch50  (switch_[50 ]),
					 .switch51  (switch_[51 ]),
					 .switch52  (switch_[52 ]),
					 .switch53  (switch_[53 ]),
					 .switch54  (switch_[54 ]),
					 .switch55  (switch_[55 ]),
					 .switch56  (switch_[56 ]),
					 .switch57  (switch_[57 ]),
					 .switch58  (switch_[58 ]),
					 .switch59  (switch_[59 ]),
					 .switch60  (switch_[60 ]),
					 .switch61  (switch_[61 ]),
					 .switch62  (switch_[62 ]),
					 .switch63  (switch_[63 ]),
					 .switch64  (switch_[64 ]),
					 .switch65  (switch_[65 ]),
					 .switch66  (switch_[66 ]),
					 .switch67  (switch_[67 ]),
					 .switch68  (switch_[68 ]),
					 .switch69  (switch_[69 ]),
					 .switch70  (switch_[70 ]),
					 .switch71  (switch_[71 ]),
					 .switch72  (switch_[72 ]),
					 .switch73  (switch_[73 ]),
					 .switch74  (switch_[74 ]),
					 .switch75  (switch_[75 ]),
					 .switch76  (switch_[76 ]),
					 .switch77  (switch_[77 ]),
					 .switch78  (switch_[78 ]),
					 .switch79  (switch_[79 ]),
					 .switch80  (switch_[80 ]),
					 .switch81  (switch_[81 ]),
					 .switch82  (switch_[82 ]),
					 .switch83  (switch_[83 ]),
					 .switch84  (switch_[84 ]),
					 .switch85  (switch_[85 ]),
					 .switch86  (switch_[86 ]),
					 .switch87  (switch_[87 ]),
					 .switch88  (switch_[88 ]),
					 .switch89  (switch_[89 ]),
					 .switch90  (switch_[90 ]),
					 .switch91  (switch_[91 ]),
					 .switch92  (switch_[92 ]),
					 .switch93  (switch_[93 ]),
					 .switch94  (switch_[94 ]),
					 .switch95  (switch_[95 ]),
					 .switch96  (switch_[96 ]),
					 .switch97  (switch_[97 ]),
					 .switch98  (switch_[98 ]),
					 .switch99  (switch_[99 ]),
					 .switch100 (switch_[100]),
					 .switch101 (switch_[101]),
					 .switch102 (switch_[102]),
					 .switch103 (switch_[103]),
					 .switch104 (switch_[104]),
					 .switch105 (switch_[105]),
					 .switch106 (switch_[106]),
					 .switch107 (switch_[107]),
					 .switch108 (switch_[108]),
					 .switch109 (switch_[109]),
					 .switch110 (switch_[110]),
					 .switch111 (switch_[111]),
					 .switch112 (switch_[112]),
					 .switch113 (switch_[113]),
					 .switch114 (switch_[114]),
					 .switch115 (switch_[115]),
					 .switch116 (switch_[116]),
					 .switch117 (switch_[117]),
					 .switch118 (switch_[118]),
					 .switch119 (switch_[119]),
					 .switch120 (switch_[120]),
					 .switch121 (switch_[121]),
					 .switch122 (switch_[122]),
					 .switch123 (switch_[123]),
					 .switch124 (switch_[124]),
					 .switch125 (switch_[125]),
					 .switch126 (switch_[126]),
					 .switch127 (switch_[127]),
					 .switch128 (switch_[128]),
					 .switch129 (switch_[129]),
					 .switch130 (switch_[130]),
					 .switch131 (switch_[131]));
	
	
//华莱士树加法器
	wire  [29 :0] cin_ [0:131];
	wire  [131:0] sum_ 		 ;
	wire  [131:0] c_	  	 ;	
	
	ysyx_22041071_walloc_33b my_walloc(.src_in(switch_[0]),.cin(30'b0),.c_group (cin_[0]),.sum(sum_[0]),.c(c_[0]));
	genvar j;
	generate 
		for(j=1;j<132;j=j+1)begin:u1
			ysyx_22041071_walloc_33b my_walloc0(.src_in(switch_[j]),.cin(cin_[j-1]),.c_group (cin_[j]),.sum(sum_[j]),.c(c_[j]));
		end
	endgenerate
	
	always@(*)begin
		if(out_valid)begin
			result   = sum_ + (c_<<1'b1);
			result_h = result[127:64];
			result_l = result[63 : 0];
		end else begin
			result   = 132'h0;
			result_h = 64'h0 ;
			result_l = 64'h0 ;
		end
	end
	                 
endmodule            
                     
                     
                    
                     
                     
                    
                   