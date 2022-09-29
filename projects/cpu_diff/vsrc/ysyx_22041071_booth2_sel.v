`include "define.v"
module ysyx_22041071_booth2_sel(
				input  wire [2:0] y				,
				output 			  sel_neg		,
				output 			  sel_pos		,
				output 			  sel_dou_neg	,
				output 			  sel_dou_pos	);
	
	assign sel_neg 	   =  y[2] & ( y[1] & ~y[0] | ~y[1] & y[0]	);
	assign sel_pos 	   = ~y[2] & ( y[1] & ~y[0] | ~y[1] & y[0]	);
	assign sel_dou_neg =  y[2] & (~y[1] & ~y[0]					);
	assign sel_dou_pos = ~y[2] & ( y[1] &  y[0]					);
endmodule