`include "define.v"
module ysyx_22041071_DIV(
				input 								 clk		,
				input								 reset		,
				input								 flush		,//取消除法
				input								 div_valid 	,//为高表示输入数据有效
				input								 div_signed	,//为高表示有符号除法
				input								 divw		,//32位除法
				input 	   [`ysyx_22041071_DATA_BUS] dividend	,//被除数
				input 	   [`ysyx_22041071_DATA_BUS] divisor	,//除数
				output								 div_ready	,//为高除法器处于空闲状态
				output								 out_valid	,//为高输出有效
				output reg [`ysyx_22041071_DATA_BUS] rema		,//余数
				output reg [`ysyx_22041071_DATA_BUS] quot 	  	);//商
	
	reg							  in_valid	;//为高输入数据有效
	reg [`ysyx_22041071_DATA_BUS] x_abs 	;
	reg [31:0				    ] x_abs_	;
	reg [127:0				    ] x_abs_ex	;
	reg [`ysyx_22041071_DATA_BUS] y_abs 	;
	reg [31:0				    ] y_abs_	;
	reg [127:0				    ] y_abs_ex	;
	reg							 rema_s		;
	reg							 quot_s		;
	
/*===================================指示输入数据有效============================================*/	
	always@(*)begin
		if(flush)begin
			in_valid = 1'b0;
		end else begin
			in_valid = div_valid;
		end

	end
/*=====================确定除数和被除数 === 商和余数的符号位========================*/
	always@(*)begin
		if(in_valid)begin
			$display("********************************");
					$display("dividend=%x",dividend);
					$display("divisor=%x",divisor);
			if(div_signed)begin
				if(divw)begin
					if(dividend[31])begin
						x_abs_ = ~dividend[31:0] + 1;
						x_abs  = {32'b0,x_abs_}	;
					end else begin
						x_abs_ = 32'b0					;
						x_abs  = {32'b0,dividend[31:0]} ;
					end
					if(divisor[31])begin
						y_abs_ = ~divisor[31:0] + 1;
						y_abs  = {32'b0,y_abs_} ;
					end else begin
						y_abs_ = 32'b0					;
						y_abs  = {32'b0,divisor[31:0]};
					end
					quot_s = dividend[31] ^ divisor[31] ;
					rema_s = dividend[31];
				end else begin
					if(dividend[63])begin
						x_abs_ = 32'b0		 ;
						x_abs = ~dividend + 1;
					end else begin
						x_abs_ = 32'b0		 ;
						x_abs = dividend	 ;
					end
					if(divisor[63])begin
						y_abs_ = 32'b0		;
						y_abs = ~divisor + 1;
					end else begin
						y_abs_ = 32'b0 ;
						y_abs = divisor;
					end
					quot_s = dividend[63] ^ divisor[63] ;
					rema_s = dividend[63];
				end
			end else begin
				if(divw)begin
					x_abs_ = 32'b0		 ;
					y_abs_ = 32'b0		 ;
					x_abs = {32'b0,dividend[31:0]};
					y_abs = {32'b0,divisor [31:0]};
					quot_s = 1'b0	 ;
					rema_s = 1'b0	 ;
				end else begin
					x_abs_ = 32'b0	 ;
					y_abs_ = 32'b0	 ;
					x_abs  = dividend;
					y_abs  = divisor ;
					quot_s = 1'b0	 ;
					rema_s = 1'b0	 ;

				end
			end
		end else begin
			x_abs_ = 32'b0;
			y_abs_ = 32'b0;
			x_abs  = 64'b0;
			y_abs  = 64'b0;
			quot_s = 1'b0 ;
			rema_s = 1'b0 ;
		end
	end
	
/*================================除法器========================================*/
	reg [1:0					] c_stats;
	reg [1:0					] n_stats;
	reg [`ysyx_22041071_DATA_BUS] q		 ;
	reg	[5:0					] counter;
	parameter IDLE = 2'b00;
	parameter QR   = 2'b01;
	parameter LLS  = 2'b10;
	parameter DONE = 2'b11;
	
	
	always@(posedge clk)begin
		if(reset)begin
			c_stats <= IDLE	  ;
		end else begin
			c_stats <= n_stats;
		end
	end
	
	always@(*)begin
		case(c_stats)
			IDLE:
				if(in_valid)begin
					n_stats = QR	;
				end else begin
					n_stats = IDLE ;
				end
			QR:
				n_stats = LLS		;
			LLS:
				if(counter<63)begin
					n_stats = QR	;
				end else begin
					n_stats = DONE	;
				end
			DONE:
				n_stats = IDLE		;
		endcase
	end
	
	always@(posedge clk)begin
		if(reset)begin
			x_abs_ex <= 128'b0;
			y_abs_ex <= 128'b0;
			q		 <= 64'b0 ;
			counter  <= 6'b0  ;
		end else begin
			case(c_stats)
				IDLE:begin
					x_abs_ex <= {64'b0,x_abs	  };
					y_abs_ex <= {1 'b0,y_abs,63'b0};
				end
				QR:
					if(x_abs_ex>=y_abs_ex && x_abs_ex!=0)begin
						q <= {q[62:0],1'b1};
						x_abs_ex <= x_abs_ex - y_abs_ex; 
					end else begin
						q <= {q[62:0],1'b0};
					    x_abs_ex <= x_abs_ex; 
					end
				LLS:
					if(counter<63)begin
						x_abs_ex <= x_abs_ex <<1'b1;
						counter <= counter + 1;
					end
				DONE:
					counter <= 6'b0		;
			endcase
		end
		
	end
	
	assign div_ready = c_stats == IDLE;
	assign out_valid = c_stats == DONE;
	always@(*)begin
		if(out_valid)begin
			if(quot_s)begin
				quot = ~q + 1;
			end else begin
				quot = q;
			end
			
			if(rema_s)begin
				rema = ~x_abs_ex[126:63] + 1;
			end else begin
				rema = x_abs_ex[126:63];
			end
		end else begin
			quot = 64'h0;
			rema = 64'h0;
		end
		
	end

endmodule
