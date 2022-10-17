`include "define.v"
module ysyx_22041071_booth2_part(input  [131:0] x	  ,
				   input  [2  :0] y	  ,
				   output [131:0] part);
				  
	wire		 sel_neg		;		
    wire		 sel_pos		;		
	wire  		 sel_dou_neg	;	
    wire		 sel_dou_pos	;			  
				    
	ysyx_22041071_booth2_sel my_sel(
					  .y		  (y			),
					  .sel_neg	  (sel_neg		),
					  .sel_pos	  (sel_pos		),
					  .sel_dou_neg(sel_dou_neg	),
					  .sel_dou_pos(sel_dou_pos	));
	
	ysyx_22041071_booth2_result my_result(
							.x			(x			),
							.sel_neg	(sel_neg	),		
							.sel_pos	(sel_pos	),		
							.sel_dou_neg(sel_dou_neg),	
							.sel_dou_pos(sel_dou_pos),
							.result		(part		));
	
endmodule
