`include "define.v"
module ysyx_22041071_MUL_64(
				input     							 clk		,
				input 	   						 	 reset		,
				input 	   						 	 flush		,//取消乘法
				input 	   						 	 mul_valid 	,//为高表示输入数据有效
				input      [1  :0]					 mul_signed	,//2’b11(s x s);2’b10(s x uns);2’b00(uns x uns)；
				input 	   						 	 mulw		,//32位乘法
				input      [`ysyx_22041071_DATA_BUS] mul1		,//被乘法
				input      [`ysyx_22041071_DATA_BUS] mul2		,//乘法
				output reg							 mul_ready	,//为高乘法器处于空闲状态
				output reg							 out_valid_m,//为高输出有效
				output reg [`ysyx_22041071_DATA_BUS] result_h	,
				output reg [`ysyx_22041071_DATA_BUS] result_l	);//乘法结果
	reg							  in_valid	  ;
	reg [127:0					] multiplicand;
	reg [`ysyx_22041071_DATA_BUS] multiply	  ;
	reg [127:0					] multiplicand_;
	reg [`ysyx_22041071_DATA_BUS] multiply_	   ;
	reg [`ysyx_22041071_DATA_BUS] mul1_		  ;
	reg [`ysyx_22041071_DATA_BUS] mul2_		  ;
	reg [127:0					] result	  ;
	reg							  result_s	  ;
	
	always@(*)begin
		if(flush)begin
			in_valid = 1'b0;
		end else begin
			in_valid = mul_valid;
		end
	end
/*================================被乘数和乘数=========================================*/	
	always@(*)begin
		if(in_valid)begin
			case(mul_signed)
				2'b11:
					if(mulw)begin
						if(mul1[31])begin
							mul1_ = ~mul1 + 1'b1				 	;
							multiplicand = {{96{1'b0}},mul1_[31:0]}	; 
						end else begin
							mul1_ = mul1				    	 	;
							multiplicand = {{96{1'b0}},mul1_[31:0]}	; 
						end
						if(mul2[31])begin
							mul2_ = ~mul2 + 1'b1				 	;
							multiply = {{32{1'b0}},mul2_[31:0]}	 	; 
						end else begin
							mul2_ = mul2			    		 	;
							multiply = {{32{1'b0}},mul2_[31:0]}	 	;
						end
						result_s = mul1[31] ^ mul2[31]				;
					end else begin
						if(mul1[63])begin
							mul1_ = ~mul1 + 1'b1					;
							multiplicand = {{64{1'b0}},mul1_}		; 
						end else begin	
							mul1_ = mul1				    		;
							multiplicand = {{64{1'b0}},mul1_ } 		; 
						end	
						if(mul2[63])begin	
							mul2_	 = ~mul2 + 1'b1					;
							multiply = mul2_						; 
						end else begin	
							mul2_    = mul2			    			;
							multiply = mul2_						;
						end	
						result_s = mul1[63] ^ mul2[63]				;
					end
				2'b00:
					if(mulw)begin
						mul1_ = mul1				    			;
						mul2_ = mul2			    				;
						multiplicand = {{96{1'b0}},mul1_[31:0]}		;
						multiply 	 = {{32{1'b0}},mul2_[31:0]}		;
						result_s	 = 1'b0							;
					end else begin	
						mul1_ = mul1				    			;
						mul2_ = mul2			    				;
						multiplicand = {{64{1'b0}},mul1_} 			;
						multiply = mul2_							;
						result_s	 = 1'b0							;
					end
				2'b10:
					if(mulw)begin
						if(mul1[31])begin
							mul1_ = ~mul1 + 1'b1				 	;
							multiplicand = {{96{1'b0}},mul1_[31:0]}	; 
						end else begin	
							mul1_ = mul1			    		 	;
							multiplicand = {{96{1'b0}},mul1_[31:0]}	 ;
						end
						mul2_ = mul2			    		 		;
						multiply = {{32{1'b0}},mul2_[31:0]}			; 
						result_s = 1'b0 ^ mul1[31]					;
					end else begin	 
						if(mul1[63])begin		
							mul1_	 = ~mul1 + 1'b1					;
							multiplicand = {{64{1'b0}},mul1_} 		; 
						end else begin	
							mul1_    = mul1			    			;
							multiplicand = {{64{1'b0}},mul1_} 		;
						end	
						mul2_ = mul2				    			;
						multiply = mul2_				 			;
						result_s = 1'b0 ^ mul1[63]					;
					end
				default:begin
					multiplicand = 128'h0							;
					multiply 	 = 64'h0							;
					result_s	 = 1'b0								;
				end
			endcase
		end else begin
			multiplicand = 128'h0							;
			multiply 	 = 64'h0							;
			result_s	 = result_s							;
		end
	end
	
	reg [1:0] c_state;
	reg [1:0] n_state;
	reg [5:0] counter;
	parameter IDLE = 2'b00;
	parameter SUM  = 2'b01;
	parameter LLS  = 2'b10;
	parameter DONE = 2'b11;
	
	always@(posedge clk)begin
		if(reset)begin
			c_state <= IDLE;
		end else begin
			c_state <= n_state;
		end
	end
	
	always@(*)begin
		case(c_state)
			IDLE :
				if(mul_valid)begin
					n_state = SUM;
				end else begin
					n_state = IDLE;
				end
			SUM  :
				n_state = LLS;
			LLS  :
				if(counter<63)begin
					n_state = SUM;
				end else begin
					n_state = DONE;
				end
			DONE :
				n_state = IDLE;
		endcase
	end
	
	always@(posedge clk)begin
		if(reset)begin
			multiplicand_ <= 128'h0	;
			multiply_	  <= 64'h0	;
			result		  <= 128'h0	;
			counter		  <= 6'h0	;
		end else begin
			case(c_state)
				IDLE :begin
					result		  <= 128'h0		  ;
					multiplicand_ <= multiplicand ;
					multiply_	  <= multiply	  ;  
				end
				SUM  :begin
					if(multiply_[0]==1'b1)begin
						result <= result + multiplicand_;
					end else begin 
						result <= result + 0			;
					end
				end
				LLS  :
					if(counter<63)begin
						multiplicand_ <= multiplicand_ << 1'b1;
						multiply_	  <= multiply_	  >> 1'b1;
						counter <= counter + 1;
					end
				DONE :begin
					counter <= 6'h0;
				end
			endcase
		end
	end
	
	always@(*)begin
		mul_ready	= c_state == IDLE;
		out_valid_m = c_state == DONE;
		if(result_s)begin
			result_h	= ~result[127:64] + 1;
			result_l	= ~result[63 :0 ] + 1;
		end else begin
			result_h	= result[127:64];
		    result_l	= result[63 :0 ];
		end
	end
	
endmodule
