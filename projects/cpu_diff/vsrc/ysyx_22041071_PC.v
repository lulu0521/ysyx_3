`include "define.v"
module ysyx_22041071_PC(input  wire 						   clk      ,
						input  wire							   reset    ,
						input  wire			 				   Brch_sel ,	//B指令跳转控制
						input  wire			 				   JPC_sel  ,   //JAL指令跳转控制
						input  wire			 				   JRPC_sel2,   //JALR指令跳转控制
						input  wire	 [`ysyx_22041071_ADDR_BUS] BPC	  	,   //B指令跳转目的地址
						input  wire	 [`ysyx_22041071_ADDR_BUS] JPC	  	,   //JAL指令跳转目的地址
						input  wire	 [`ysyx_22041071_ADDR_BUS] JRPC		,   //JALR指令跳转目的地址
						input  wire	 [`ysyx_22041071_ADDR_BUS] SNPC		,   //PC+4
						input  wire							   ready1	,
						output reg							   valid1	,
						output reg	 [`ysyx_22041071_ADDR_BUS] PC		);  //输出PC
						
	reg  [`ysyx_22041071_ADDR_BUS]	DNPC 		;
	reg								valid		;
	reg								handshake	;
	wire [2:0					 ]	sel	 		;
	assign sel = {Brch_sel,JPC_sel,JRPC_sel2}	;
	
	always@(*)begin
		valid = 1'b1;
		handshake = valid & ready1;
		case(sel)
			3'b000: DNPC = SNPC 	;
			3'b001: DNPC = JRPC 	;
			3'b010: DNPC = JPC  	;
			3'b100: DNPC = BPC  	;
			default:DNPC = 64'h0	;
		endcase
	end
	
/*====================时序控制===========================*/
	always@(posedge clk)begin
		if(reset)begin
			valid1 	<= 1'b0			;
			PC 		<= `START_ADDR	;
		end else begin
			if(handshake)begin
				valid1 <= valid;
				PC	   <= DNPC ;
			end
		end
	end
endmodule
