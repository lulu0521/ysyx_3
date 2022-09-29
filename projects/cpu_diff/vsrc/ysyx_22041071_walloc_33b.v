`include "define.v"
module ysyx_22041071_walloc_33b(
				 input 	[32:0] src_in ,
				 input 	[29:0] cin    ,
				 output [29:0] c_group,
				 output	 	   sum	  ,
				 output  	   c      );
	reg [29:0] group;			 
/*================ 0 ==================*/
	wire [10:0] first_s;
	ysyx_22041071_csa csa0_0 (.in(src_in[2 :0 ]), .s(first_s[0 ]), .c(c_group[0 ]));
	ysyx_22041071_csa csa0_1 (.in(src_in[5 :3 ]), .s(first_s[1 ]), .c(c_group[1 ]));
	ysyx_22041071_csa csa0_2 (.in(src_in[8 :6 ]), .s(first_s[2 ]), .c(c_group[2 ]));
	ysyx_22041071_csa csa0_3 (.in(src_in[11:9 ]), .s(first_s[3 ]), .c(c_group[3 ]));
	ysyx_22041071_csa csa0_4 (.in(src_in[14:12]), .s(first_s[4 ]), .c(c_group[4 ]));
    ysyx_22041071_csa csa0_5 (.in(src_in[17:15]), .s(first_s[5 ]), .c(c_group[5 ]));
	ysyx_22041071_csa csa0_6 (.in(src_in[20:18]), .s(first_s[6 ]), .c(c_group[6 ]));
	ysyx_22041071_csa csa0_7 (.in(src_in[23:21]), .s(first_s[7 ]), .c(c_group[7 ]));
	ysyx_22041071_csa csa0_8 (.in(src_in[26:24]), .s(first_s[8 ]), .c(c_group[8 ]));
	ysyx_22041071_csa csa0_9 (.in(src_in[29:27]), .s(first_s[9 ]), .c(c_group[9 ]));
	ysyx_22041071_csa csa0_10(.in(src_in[32:30]), .s(first_s[10]), .c(c_group[10]));
/*================= 1 =====================*/
	wire [6:0] second_s;
	ysyx_22041071_csa csa1_0 (.in( first_s[2 :0 ]			), .s(second_s[0 ]), .c(c_group[11 ]));
	ysyx_22041071_csa csa1_1 (.in( first_s[5 :3 ]			), .s(second_s[1 ]), .c(c_group[12 ]));
	ysyx_22041071_csa csa1_2 (.in( first_s[8 :6 ]			), .s(second_s[2 ]), .c(c_group[13 ]));
	ysyx_22041071_csa csa1_3 (.in({first_s[10:9 ],cin[0]}	), .s(second_s[3 ]), .c(c_group[14 ]));
	ysyx_22041071_csa csa1_4 (.in( cin	[3 :1 ]		   		), .s(second_s[4 ]), .c(c_group[15 ]));
    ysyx_22041071_csa csa1_5 (.in( cin	[6 :4 ]		   		), .s(second_s[5 ]), .c(c_group[16 ]));
	ysyx_22041071_csa csa1_6 (.in( cin	[9 :7 ]		   		), .s(second_s[6 ]), .c(c_group[17 ]));
/*================= 2 =====================*/
	wire [4:0] third_s;
	ysyx_22041071_csa csa2_0 (.in( second_s[2 :0 ]		    	), .s(third_s[0 ]), .c(c_group[18 ]));
	ysyx_22041071_csa csa2_1 (.in( second_s[5 :3 ]		    	), .s(third_s[1 ]), .c(c_group[19 ]));
	ysyx_22041071_csa csa2_2 (.in({second_s[   6 ],cin[11:10]}	), .s(third_s[2 ]), .c(c_group[20 ]));
	ysyx_22041071_csa csa2_3 (.in( cin	   [14:12]		    	), .s(third_s[3 ]), .c(c_group[21 ]));
	ysyx_22041071_csa csa2_4 (.in( cin	   [17:15]		    	), .s(third_s[4 ]), .c(c_group[22 ]));
/*================= 3 =====================*/
	wire [2:0] forth_s;
	ysyx_22041071_csa csa3_0 (.in( third_s[2 :0 ]			  	), .s(forth_s[0 ]), .c(c_group[23 ]));
	ysyx_22041071_csa csa3_1 (.in({third_s[4 :3 ],cin[18]}   	), .s(forth_s[1 ]), .c(c_group[24 ]));
	ysyx_22041071_csa csa3_2 (.in( cin	[21:19]			   		), .s(forth_s[2 ]), .c(c_group[25 ]));
/*================= 4 =====================*/
	wire [1:0] fifth_s;
	ysyx_22041071_csa csa4_0 (.in( forth_s[2 :0 ]), .s(fifth_s[0 ]), .c(c_group[26 ]));
	ysyx_22041071_csa csa4_1 (.in( cin	[24:22]	 ), .s(fifth_s[1 ]), .c(c_group[27 ]));
/*================= 5 =====================*/
	wire 	   sixth_s;
	ysyx_22041071_csa csa5_0 (.in({fifth_s[1 :0 ],cin[25]}), .s(sixth_s	), .c(c_group[28 ]));
/*================= 6 =====================*/
	wire 	   seventh_s;
	ysyx_22041071_csa csa6_0 (.in({sixth_s,cin[27:26]}), .s(seventh_s), .c(c_group[29 ]));
/*================= 7 =====================*/	
	wire 	   eighth_s;
	ysyx_22041071_csa csa7_0 (.in({seventh_s,cin[29:28]}), .s(sum), .c(c));

endmodule
