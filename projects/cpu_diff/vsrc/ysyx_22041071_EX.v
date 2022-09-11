`include "define.v"
module ysyx_22041071_EX(
						input wire							 clk		  ,
						input wire							 reset		  ,
						input wire  [`ysyx_22041071_ADDR_BUS]PC4	      ,
						input wire  [`ysyx_22041071_INS_BUS ]Ins3	      ,
						input wire  						 Brch2	      ,
						input wire							 MEM_W_en2    ,
						input wire							 WB_sel2      ,
						input wire	[ 4:0 ]					 ALU_ctrl2    ,
						input wire	[`ysyx_22041071_DATA_BUS]rt_data1     ,
						input wire							 reg_w_en2    ,
						input wire  [ 4:0 ]					 rdest1	      ,
						input wire  [`ysyx_22041071_DATA_BUS]src_a	      ,
						input wire	[`ysyx_22041071_DATA_BUS]src_b	      ,
						input wire  [12:1 ]					 BImm2	      ,
						input wire							 valid4		  ,
						input wire							 ready5		  ,
						output reg							 ready4		  ,
						output reg							 valid5		  ,
						output reg							 bubble23	  ,
						output reg  [`ysyx_22041071_ADDR_BUS]PC5	      ,
                        output reg  [`ysyx_22041071_INS_BUS ]Ins4	      ,
						output reg  						 MEM_W_en3    ,
						output reg 							 WB_sel3      ,//0-result;1-MEM_data
						output reg  						 reg_w_en3    ,
						output reg  [`ysyx_22041071_DATA_BUS]rt_data2     ,
						output reg  [ 4:0 ]					 rdest2	      ,
						output reg  [`ysyx_22041071_DATA_BUS]ALU_result1  ,
						output reg							 reg_w_en3_	  ,
						output reg  [ 4:0 ]					 rdest2_	  ,
						output reg  [`ysyx_22041071_DATA_BUS]ALU_result   ,
						output reg							 Brch_sel1	  ,
						output reg  [`ysyx_22041071_ADDR_BUS]BPC1		  );
	
	wire [`ysyx_22041071_ADDR_BUS]	PC	       	;
	wire [`ysyx_22041071_INS_BUS ]	Ins	   		;
	wire 						 	MEM_W_en 	;
	wire 						 	WB_sel   	;
	wire [`ysyx_22041071_DATA_BUS]	rt_data   	;
	reg								valid		;
	reg								handshake	;
	reg  [31:0]						result		;
	
	assign PC 		 = PC4							;
	assign Ins 		 = Ins3						  	;
	assign MEM_W_en  = MEM_W_en2				  	;
	assign WB_sel	 = WB_sel2						;
	assign reg_w_en3_= reg_w_en2				  	;
	assign rt_data	 = rt_data1				  		;
	assign rdest2_	 = rdest1					  	;
	assign Brch_sel1 = ALU_result && Brch2			; 

/*======0:64位+  1:32位+  2:64位左移    3:32位左移   4:64位算术右移    5:32位算术右移
		6:64位逻辑右移    7:32位逻辑右移   8:64位&     9:64位|       10:64位^   
		11:64位有符号<   12:64位无符号<   13:64位==  14:64位！=   15:64位有符号>=    16:64位无符号>=  
		17:64位无符号-   18:有符号32位-     19:64位*取低64位     20:有符号64位*取高64位   21:无符号64位*取高64位     22:32位有符号乘法取低32位符号扩展    23:64有符号除法    24:64无符号除法  25:有符号32位除法符号扩展   26:32位无符号除法有符号扩展   27:64有符号取余  28:64无符号取余      29:32位无符号取余有符号扩展    30:32位有符号取余有符号扩展*/	
	always@(*)begin
		ready4		= ready5 						;
		handshake 	= valid4 & ready5				;
		BPC1		= PC4 + {{51{BImm2[12]}},BImm2,1'b0};
		
		if(Ins3[6:0]==7'b110_0011)begin//B
			bubble23 = 1'b1;
		end else begin
			bubble23 = 1'b0;
		end
		
		case(ALU_ctrl2)
			5'd0 	:begin
					result 	   = 0											;
					ALU_result = src_a + src_b								;
			end	
			5'd1 	:begin  		
					result 	 = src_a[31:0] + src_b[31:0]					;
					ALU_result = {{32{result[31]}},result}					;
			end              		
			5'd2 	:begin
					result 	   = 0											;
					ALU_result = src_a << src_b[5:0]		 				;
			end
			5'd3 	:begin  		
					result 	 = src_a[31:0] << src_b[4:0]					;
					ALU_result = {{32{result[31]}},result}					;
			end              		
			5'd4 	:begin
					result 	   = 0											;
					ALU_result = (src_a >>> src_b[5:0])	 					;
			end
			5'd5 	:begin		
					result	 = src_a[31:0] >>> src_b[4:0]					;
					ALU_result = {{32{result[31]}},result} 					;
			end		
			5'd6 	:begin
					result 	   = 0											;
					ALU_result = src_a >> src_b[5:0]		  				;
			end
			5'd7 	:begin		
					result 	 = src_a[31:0] >> src_b[4:0]					;
					ALU_result = {{32{result[31]}},result}					;
			end		
			5'd8 	:begin
					result 	   = 0											;
					ALU_result = src_a & src_b								;
			end 
			5'd9 	:begin
					result 	   = 0											;
					ALU_result = src_a | src_b								;
			end 
			5'd10	:begin
					result 	   = 0											;
					ALU_result = src_a ^ src_b								;
			end 
			5'd11	:begin
					result 	   = 0											;
					ALU_result = $signed(src_a) < $signed(src_b)			;
			end	 
			5'd12	:begin
					result 	   = 0											;
					ALU_result = src_a < src_b								;
			end 
			5'd13	:begin
					result 	   = 0											;
					ALU_result = src_a == src_b								;
			end 
			5'd14	:begin
					result 	   = 0											;
					ALU_result = src_a != src_b								;
			end 
			5'd15	:begin
					result 	   = 0											;
					ALU_result = $signed(src_a) >= $signed(src_b)			;
			end 
			5'd16	:begin
					result 	   = 0											;
					ALU_result = src_a >= src_b								;
			end 
			5'd17	:begin
					result 	   = 0											;
					ALU_result = src_a - src_b								;
			end
			5'd18	: begin
					result = $signed(src_a[31:0]) - $signed(src_b[31:0])	;
					ALU_result = {{32{result[31]}},result}					;
			end
			//5'd19	: ALU_result <= src_a  src_b;
			//5'd20	: ALU_result <= src_a  src_b;
			//5'd21	: ALU_result <= src_a  src_b;
			//5'd22	: ALU_result <= src_a  src_b;
			//5'd23	: ALU_result <= src_a  src_b;
			//5'd24	: ALU_result <= src_a  src_b;
			//5'd25	: ALU_result <= src_a  src_b;
			//5'd26	: ALU_result <= src_a  src_b;
			//5'd27	: ALU_result <= src_a  src_b;
			//5'd28	: ALU_result <= src_a  src_b;
			//5'd29	: ALU_result <= src_a  src_b;
			//5'd30	: ALU_result <= src_a  src_b;
			default	: begin
					result 	   = 32'h0	;
					ALU_result = 64'd0	;
			end
		endcase
	end
	
	always@(posedge clk)begin
		if(reset)begin
			valid5		<= 1'b0			;			
			PC5	     	<= PC			;
			Ins4	    <= 32'b0		;
			MEM_W_en3   <= 1'd0			;
			WB_sel3     <= 1'd0			;
			reg_w_en3   <= 1'd0			;
			rt_data2    <= 64'd0		;
			rdest2	    <= 5'd0			;
			ALU_result1 <= 64'd0		;
		end else begin
			if(handshake)begin
				valid5		 <= valid4		;
				PC5	      	 <= PC			;
				Ins4	     <= Ins			;
				MEM_W_en3    <= MEM_W_en	;
				WB_sel3      <= WB_sel		;
				reg_w_en3    <= reg_w_en2	;
				rt_data2     <= rt_data		;
				rdest2	     <= rdest1		;
				ALU_result1  <= ALU_result	;
			end
		end
	
	end
	
	
	
	
	
	
	

endmodule