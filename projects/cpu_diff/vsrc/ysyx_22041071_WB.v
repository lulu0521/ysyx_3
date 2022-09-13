`include "define.v"
module ysyx_22041071_WB(
						input wire 							  clk		,
						input wire  [`ysyx_22041071_ADDR_BUS] PC6		,
						input wire  [`ysyx_22041071_INS_BUS ] Ins5	    ,
						input wire 							  reset		,
						input wire  						  reg_w_en4	,
						input wire  [ 4:0 ]					  rdest3	,
						input wire  [`ysyx_22041071_DATA_BUS] WB_data1	,
						input wire							  valid6	,
						output reg							  ready6	,
						output reg							  valid7	,
						output reg  [`ysyx_22041071_ADDR_BUS] PC7		,
						output reg  [`ysyx_22041071_INS_BUS ] Ins6	    ,
						output reg  						  reg_w_en5	,
						output reg  [ 4:0 ]					  rdest4,
                        output reg  [`ysyx_22041071_DATA_BUS] WB_data2	);
	
	//reg handshake	;
	
	always@(*)begin
		PC7		  = PC6 		;
		Ins6	  = Ins5		;	
		ready6	  = 1'b1		;
		valid7	  = valid6		;
		reg_w_en5 = reg_w_en4	;	
		rdest4	  = rdest3	  	;	 		
		WB_data2  = WB_data1 	;
		$display("*******************************PC6 = %x ",PC6);
		$display("*******************************reg_w_en5 = %x ",reg_w_en5);
		$display("*******************************WB_data2 = %x ",WB_data1);	
		$display("******************************* rdest4 = %x",rdest4 );		
	end
	
endmodule