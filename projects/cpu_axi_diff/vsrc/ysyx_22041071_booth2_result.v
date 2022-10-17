`include "define.v"
module ysyx_22041071_booth2_result(
					input  wire [131:0] x			,
					input  wire	  		sel_neg		,		
                    input  wire	  		sel_pos		,		
					input  wire	  		sel_dou_neg	,	
                    input  wire	  		sel_dou_pos	,
					output      [131:0] result		);
					
	wire [131:0] x2;
	assign x2 = x <<1'b1;
					
	assign result = ~(~({132{sel_neg	}} & (~x  + 1)) & 
					  ~({132{sel_pos	}} &  x 	  ) &
					  ~({132{sel_dou_neg}} & (~x2 + 1)) &
					  ~({132{sel_dou_pos}} &  x2	 ));
			 
endmodule