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
//div
	reg							  div_valid ;//??????????????????????????????
	reg						 	  div_signed;//???????????????????????????
	reg						 	  divw		;//32?????????
	reg							  div_ready	;//?????????????????????????????????
	reg							  out_valid	;//??????????????????
	reg [`ysyx_22041071_DATA_BUS] rema		;//??????
	reg [`ysyx_22041071_DATA_BUS] quot 	  	;//???

	ysyx_22041071_DIV my_DIV(
							.clk		(clk		),
							.reset		(reset		),
							.flush		(1'b0		),//????????????
							.div_valid 	(div_valid 	),//??????????????????????????????
							.div_signed	(div_signed	),//???????????????????????????
							.divw		(divw	 	),//32?????????
							.dividend	(src_a		),//?????????
							.divisor	(src_b		),//??????
							.div_ready	(div_ready  ),//?????????????????????????????????
							.out_valid	(out_valid  ),//??????????????????
							.rema		(rema		),//??????
							.quot 	  	(quot 	    ));//???



	reg							  mul_valid1 ;//???????????????????????????
	reg							  mul_valid2 ;
	reg		  					  mulw		 ;//???1??????32?????????
	reg [1 :0					] mul_signed ;//2???b11(s x s);2???b10(s x uns);2???b00(uns x uns)???
	reg 						  mul_ready	 ;//??????????????????????????????
	reg 						  out_valid_m1;//???????????????????????????
	reg 						  out_valid_m2;//???????????????????????????
	reg [`ysyx_22041071_DATA_BUS] result_h	 ;
	reg [`ysyx_22041071_DATA_BUS] result_l	 ;
//mul_booth+walloc
	`ifdef BOOTH_WALLOC
	ysyx_22041071_MUL my_MUL0(
							.flush		(1'b0		),//????????????
							.mul_valid	(mul_valid1	),//???????????????????????????
							.mulw		(mulw		),//???1??????32?????????
							.mul_signed (mul_signed ),//2???b11(s x s);2???b10(s x uns);2???b00(uns x uns)???
							.mul_1		(src_a		),//?????????
							.mul_2		(src_b		),//??????
							.mul_ready	(mul_ready	),//??????????????????????????????
							.out_valid	(out_valid_m1),//???????????????????????????
							.result_h	(result_h	),
							.result_l	(result_l	));
	
//mul
	`else
	ysyx_22041071_MUL_64 my_MUL1(
							.clk		(clk		),
							.reset		(reset		),
							.flush		(1'b0		),//????????????
							.mul_valid 	(mul_valid2	),//??????????????????????????????
							.mul_signed	(mul_signed	),//2???b11(s x s);2???b10(s x uns);2???b00(uns x uns)???
							.mulw		(mulw		),//32?????????
							.mul1		(src_a		),//?????????
							.mul2		(src_b		),//??????
							.mul_ready	(mul_ready	),//?????????????????????????????????
							.out_valid_m(out_valid_m2),//??????????????????
							.result_h	(result_h	),
							.result_l	(result_l	));//????????????
	
	`endif

/*======0:64???+  1:32???+  2:64?????????    3:32?????????   4:64???????????????    5:32???????????????
		6:64???????????????    7:32???????????????   8:64???&     9:64???|       10:64???^   
		11:64????????????<   12:64????????????<   13:64???==  14:64??????=   15:64????????????>=    16:64????????????>=  
		17:64????????????-   18:?????????32???-     19:64???*??????64???     20:?????????64???*??????64???   21:?????????64???*??????64???    
		22:32????????????????????????32???????????????    23:64???????????????    24:64???????????????  25:?????????32?????????????????????   26:32?????????????????????????????????  
		27:64???????????????  28:64???????????????      29:32?????????????????????????????????    30:32?????????????????????????????????*/
	`ifdef BOOTH_WALLOC
		always@(*)begin
			if(ALU_ctrl2>=23 && ALU_ctrl2<=30 && ~out_valid)begin//div and mul make stop 
				ready4 = 1'b0;
			end else begin
				ready4 = ready5;
			end
		end	
	`else 
		always@(*)begin
			if((ALU_ctrl2>=23 && ALU_ctrl2<=30 && ~out_valid) || (ALU_ctrl2>=19 && ALU_ctrl2<=22 && ~out_valid_m2))begin//div and mul make stop 
				ready4 = 1'b0;
			end else begin
				ready4 = ready5;
			end
		end	
	`endif	

	always@(*)begin
		handshake 	= valid4 & ready5				;
		BPC1		= PC4 + {{51{BImm2[12]}},BImm2,1'b0};
	end
	
		
	always@(*)begin	
		if((Ins3[6:0]==7'b110_0011) && (handshake == 1'b1))begin//B
			bubble23 = 1'b1;
		end else begin
			bubble23 = 1'b0;
		end
	end	

	always@(*)begin
		case(ALU_ctrl2)
			5'd0 	:begin
					mul_valid1	= 1'b0   								;
					mul_valid2	= 1'b0   								;
					mulw		= 1'b0   								;
					mul_signed  = 2'b0   								;
					div_valid   = 1'b0									;
					div_signed  = 1'b0									;
					divw	    = 1'b0									;
					result 	   = 0										;
					ALU_result = src_a + src_b							;
			end	
			5'd1 	:begin 
					mul_valid1	= 1'b0   								;
					mul_valid2	= 1'b0   								;
					mulw		= 1'b0   								;
					mul_signed  = 2'b0   								;
					div_valid   = 1'b0									;
					div_signed  = 1'b0									;
					divw	    = 1'b0									; 		
					result 	 = src_a[31:0] + src_b[31:0]				;
					ALU_result = {{32{result[31]}},result}				;
			end              		
			5'd2 	:begin
					mul_valid1	= 1'b0   								;
					mul_valid2	= 1'b0   								;
					mulw		= 1'b0   								;
					mul_signed  = 2'b0   								;
					div_valid   = 1'b0									;
					div_signed  = 1'b0									;
					divw	    = 1'b0									;
					result 	   = 0										;
					ALU_result = src_a << src_b[5:0]		 			;
			end
			5'd3 	:begin  
					mul_valid1	= 1'b0   								;
					mul_valid2	= 1'b0   								;
					mulw		= 1'b0   								;
					mul_signed  = 2'b0   								;
					div_valid   = 1'b0									;
					div_signed  = 1'b0									;
					divw	    = 1'b0									;		
					result 	 = src_a[31:0] << src_b[4:0]				;
					ALU_result = {{32{result[31]}},result}				;
			end              		
			5'd4 	:begin
					mul_valid1	= 1'b0   								;
					mul_valid2	= 1'b0   								;
					mulw		= 1'b0   								;
					mul_signed  = 2'b0   								;
					div_valid   = 1'b0									;
					div_signed  = 1'b0									;
					divw	    = 1'b0									;
					result 	   = 0										;
					ALU_result = $signed(src_a) >>> src_b[5:0]		 	;
			end
			5'd5 	:begin	
					mul_valid1	= 1'b0   								;
					mul_valid2	= 1'b0   								;
					mulw		= 1'b0   								;
					mul_signed  = 2'b0   								;
					div_valid   = 1'b0									;
					div_signed  = 1'b0									;
					divw	    = 1'b0									;	
					result	 = $signed(src_a[31:0]) >>> src_b[4:0]		;
					ALU_result = {{32{result[31]}},result} 				;
			end		
			5'd6 	:begin
					mul_valid1	= 1'b0   								;
					mul_valid2	= 1'b0   								;
					mulw		= 1'b0   								;
					mul_signed  = 2'b0   								;
					div_valid   = 1'b0									;
					div_signed  = 1'b0									;
					divw	    = 1'b0									;
					result 	   = 0										;
					ALU_result = src_a >> src_b[5:0]		  			;
			end
			5'd7 	:begin	
					mul_valid1	= 1'b0   								;
					mul_valid2	= 1'b0   								;
					mulw		= 1'b0   								;
					mul_signed  = 2'b0   								;
					div_valid   = 1'b0									;
					div_signed  = 1'b0									;
					divw	    = 1'b0									;	
					result 	 = src_a[31:0] >> src_b[4:0]				;
					ALU_result = {{32{result[31]}},result}				;
			end		
			5'd8 	:begin
					mul_valid1	= 1'b0   								;
					mul_valid2	= 1'b0   								;
					mulw		= 1'b0   								;
					mul_signed  = 2'b0   								;
					div_valid   = 1'b0									;
					div_signed  = 1'b0									;
					divw	    = 1'b0									;
					result 	   = 0										;
					ALU_result = src_a & src_b							;
			end 
			5'd9 	:begin
					mul_valid1	= 1'b0   								;
					mul_valid2	= 1'b0   								;
					mulw		= 1'b0   								;
					mul_signed  = 2'b0   								;
					div_valid   = 1'b0									;
					div_signed  = 1'b0									;
					divw	    = 1'b0									;
					result 	   = 0										;
					ALU_result = src_a | src_b							;
			end 
			5'd10	:begin
					mul_valid1	= 1'b0   								;
					mul_valid2	= 1'b0   								;
					mulw		= 1'b0   								;
					mul_signed  = 2'b0   								;
					div_valid   = 1'b0									;
					div_signed  = 1'b0									;
					divw	    = 1'b0									;
					result 	   = 0										;
					ALU_result = src_a ^ src_b							;
			end 
			5'd11	:begin
					mul_valid1	= 1'b0   								;
					mul_valid2	= 1'b0   								;
					mulw		= 1'b0   								;
					mul_signed  = 2'b0   								;
					div_valid   = 1'b0									;
					div_signed  = 1'b0									;
					divw	    = 1'b0									;
					result 	   = 0										;
					ALU_result = $signed(src_a) < $signed(src_b)		;
			end	 
			5'd12	:begin
					mul_valid1	= 1'b0   								;
					mul_valid2	= 1'b0   								;
					mulw		= 1'b0   								;
					mul_signed  = 2'b0   								;
					div_valid   = 1'b0									;
					div_signed  = 1'b0									;
					divw	    = 1'b0									;
					result 	   = 0										;
					ALU_result = src_a < src_b							;
			end 
			5'd13	:begin
					mul_valid1	= 1'b0   								;
					mul_valid2	= 1'b0   								;
					mulw		= 1'b0   								;
					mul_signed  = 2'b0   								;
					div_valid   = 1'b0									;
					div_signed  = 1'b0									;
					divw	    = 1'b0									;
					result 	   = 0										;
					ALU_result = src_a == src_b							;
			end 
			5'd14	:begin
					mul_valid1	= 1'b0   								;
					mul_valid2	= 1'b0   								;
					mulw		= 1'b0   								;
					mul_signed  = 2'b0   								;
					div_valid   = 1'b0									;
					div_signed  = 1'b0									;
					divw	    = 1'b0									;
					result 	   = 0										;
					ALU_result = src_a != src_b							;
			end 
			5'd15	:begin
					mul_valid1	= 1'b0   								;
					mul_valid2	= 1'b0   								;
					mulw		= 1'b0   								;
					mul_signed  = 2'b0   								;
					div_valid   = 1'b0									;
					div_signed  = 1'b0									;
					divw	    = 1'b0									;
					result 	   = 0										;
					ALU_result = $signed(src_a) >= $signed(src_b)		;
			end 
			5'd16	:begin
					mul_valid1	= 1'b0   								;
					mul_valid2	= 1'b0   								;
					mulw		= 1'b0   								;
					mul_signed  = 2'b0   								;
					div_valid   = 1'b0									;
					div_signed  = 1'b0									;
					divw	    = 1'b0									;
					result 	   = 0										;
					ALU_result = src_a >= src_b							;
			end 
			5'd17	:begin
					mul_valid1	= 1'b0   								;
					mul_valid2	= 1'b0   								;
					mulw		= 1'b0   								;
					mul_signed  = 2'b0   								;
					div_valid   = 1'b0									;
					div_signed  = 1'b0									;
					divw	    = 1'b0									;
					result 	   = 0										;
					ALU_result = src_a - src_b							;
			end
			5'd18	: begin
					mul_valid1	= 1'b0   								;
					mul_valid2	= 1'b0   								;
					mulw		= 1'b0   								;
					mul_signed  = 2'b0   								;
					div_valid   = 1'b0									;
					div_signed  = 1'b0									;
					divw	    = 1'b0									;
					result = $signed(src_a[31:0]) - $signed(src_b[31:0]);
					ALU_result = {{32{result[31]}},result}				;
			end
			5'd19	: begin//64???*??????64???
					mul_valid1	= 1'b1    								;
					mul_valid2	= mul_ready & ~out_valid_m2  			;	
					mulw		= 1'b0    								;
					mul_signed  = 2'b00   								;
					div_valid   = 1'b0									;
					div_signed  = 1'b0									;
					divw	    = 1'b0									;
					result 	    = 0										;
					ALU_result  = result_l								;
			end
			5'd20	: begin//?????????64???*??????64???
					mul_valid1	= 1'b1    								;
					mul_valid2	= mul_ready & ~out_valid_m2  			;	
					mulw		= 1'b0    								;
					mul_signed  = 2'b11   								;
					div_valid   = 1'b0									;
					div_signed  = 1'b0									;
					divw	    = 1'b0									;
					result 	    = 0										;
					ALU_result  = result_h								;
			end
			5'd21	: begin//?????????64???*??????64???
					mul_valid1	= 1'b1    								;
					mul_valid2	= mul_ready & ~out_valid_m2 			;	
					mulw		= 1'b0    								;
					mul_signed  = 2'b00   								;
					div_valid   = 1'b0									;
					div_signed  = 1'b0									;
					divw	    = 1'b0									;
					result 	    = 0										;
					ALU_result  = result_h;
			end
			5'd22	: begin//32????????????????????????32??????????????? 
					mul_valid1	= 1'b1    								;
					mul_valid2	= mul_ready & ~out_valid_m2  			;	
					mulw		= 1'b1    								;
					mul_signed  = 2'b11   								;
					div_valid   = 1'b0									;
					div_signed  = 1'b0									;
					divw	    = 1'b0									;
					result 	    = 0										;
					ALU_result  = {{32{result_l[31]}},result_l[31:0]};
			end
			5'd23	: begin//64???????????????
					mul_valid1	= 1'b0   								;
					mul_valid2	= 1'b0   								;
					mulw		= 1'b0   								;
					mul_signed  = 2'b0   								;
					div_valid   = div_ready & ~out_valid				;
					div_signed  = 1'b1									;
					divw	    = 1'b0									;
					result 	    = 0										;	
					ALU_result  = quot									;
			end
			5'd24	: begin//64???????????????
					mul_valid1	= 1'b0   								;
					mul_valid2	= 1'b0   								;
					mulw		= 1'b0   								;
					mul_signed  = 2'b0   								;
					div_valid   = div_ready & ~out_valid				;
					div_signed  = 1'b0									;
					divw	    = 1'b0									;	
					result 	    = 0										;
					ALU_result  = quot									;
			end
			5'd25	: begin//?????????32?????????????????????
					mul_valid1	= 1'b0   								;
					mul_valid2	= 1'b0   								;
					mulw		= 1'b0   								;
					mul_signed  = 2'b0   								;
					div_valid   = div_ready & ~out_valid				;
					div_signed  = 1'b1									;
					divw	    = 1'b1									;	
					result 	    = 0										;
					ALU_result  = quot									;
			end
			5'd26	: begin//32?????????????????????????????????
					mul_valid1	= 1'b0   								;
					mul_valid2	= 1'b0   								;
					mulw		= 1'b0   								;
					mul_signed  = 2'b0   								;
					div_valid   = div_ready & ~out_valid				;
					div_signed  = 1'b0									;
					divw	    = 1'b1									;
					result 	    = 0										;	
					ALU_result  = quot									;
			end
			5'd27	: begin//64???????????????
					mul_valid1	= 1'b0   								;
					mul_valid2	= 1'b0   								;
					mulw		= 1'b0   								;
					mul_signed  = 2'b0   								;
					div_valid   = div_ready & ~out_valid				;
					div_signed  = 1'b1									;
					divw	    = 1'b0									;
					result 	    = 0										;	
					ALU_result  = rema									;
			end
			5'd28	: begin//64??????????????? 
					mul_valid1	= 1'b0   								;
					mul_valid2	= 1'b0   								;
					mulw		= 1'b0   								;
					mul_signed  = 2'b0   								;
					div_valid   = div_ready & ~out_valid				;
					div_signed  = 1'b0									;
					divw	    = 1'b0									;
					result 	    = 0										;	
					ALU_result  = rema									;
			end
			5'd29	: begin//32?????????????????????????????????
					mul_valid1	= 1'b0   								;
					mul_valid2	= 1'b0   								;
					mulw		= 1'b0   								;
					mul_signed  = 2'b0   								;
					div_valid   = div_ready & ~out_valid				;
					div_signed  = 1'b0									;
					divw	    = 1'b1									;
					result 	    = 0										;	
					ALU_result  = rema									;
			end
			5'd30	: begin//32?????????????????????????????????
					mul_valid1	= 1'b0   								;
					mul_valid2	= 1'b0   								;
					mulw		= 1'b0   								;
					mul_signed  = 2'b0   								;
					div_valid   = div_ready & ~out_valid				;
					div_signed  = 1'b1									;
					divw	    = 1'b1									;
					result 	    = 0										;	
					ALU_result  = rema									;
			end
			default	: begin
					mul_valid1	= 1'b0   								;
					mul_valid2	= 1'b0   								;
					mulw		= 1'b0   								;
					mul_signed  = 2'b0   								;
					div_valid   = 1'b0									;
					div_signed  = 1'b0									;
					divw	    = 1'b0									;
					result 	    = 32'h0									;
					ALU_result  = 64'd0									;	
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
		`ifdef BOOTH_WALLOC
			if(ALU_ctrl2>=23 && ALU_ctrl2<=30 && ~out_valid)begin//
			valid5		 <= 1'b1	;
			PC5	      	 <= PC		;
			Ins4	     <= 32'b0	;
			MEM_W_en3    <= 1'd0	;
			WB_sel3      <= 1'd0	;
			reg_w_en3    <= 1'd0	;
			rt_data2     <= 64'd0	;
			rdest2	     <= 5'd0	;
			ALU_result1  <= 64'd0	;
		`else 
			if((ALU_ctrl2>=23 && ALU_ctrl2<=30 && ~out_valid) || (ALU_ctrl2>=19 && ALU_ctrl2<=22 && ~out_valid_m2))begin//
			valid5		 <= 1'b1	;
			PC5	      	 <= PC		;
			Ins4	     <= 32'b0	;
			MEM_W_en3    <= 1'd0	;
			WB_sel3      <= 1'd0	;
			reg_w_en3    <= 1'd0	;
			rt_data2     <= 64'd0	;
			rdest2	     <= 5'd0	;
			ALU_result1  <= 64'd0	;
		`endif	
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
	
	end

endmodule