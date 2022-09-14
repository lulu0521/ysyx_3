`include "define.v"
module ysyx_22041071_ID(
						input									clk		 ,
						input									reset    ,
						input  wire [`ysyx_22041071_ADDR_BUS]	PC2		 ,
						input  wire [`ysyx_22041071_INS_BUS ]	Ins1	 ,
						input  wire								valid2	 ,
						input  wire								ready3	 ,
						output reg								ready2	 ,
						output reg								valid3	 ,
						output reg								bubble21 , //冲刷寄存器2
						output reg 	[`ysyx_22041071_ADDR_BUS]	PC3	 	 ,
						output reg 	[`ysyx_22041071_INS_BUS ]	Ins2	 ,
						output reg 	[`ysyx_22041071_ADDR_BUS]	JPC1	 ,
						output reg 	[6 :0 ]						opcode1	 ,
						output reg 	[4 :0 ]						rs1		 ,
						output reg 	[4 :0 ]						rt1		 ,
						output reg 	[4 :0 ]						rd1		 ,
						output reg 	[11:0 ]						Imm1	 ,
						output reg 	[11:0 ]						SImm1	 ,
						output reg 	[12:1 ]						BImm1	 ,
						output reg 	[31:12]						UImm1	 ,
						output reg 	[ 2:0 ]						src1_sel1, //选择src_1,0-data1;1-result;2-WB_data;3-WB_data2;4-0;5-PC
						output reg 	[ 2:0 ]						src2_sel1, //选择src_2,0-data2;1-Imm;2-result;3-WB_data;4-WB_data1;5-4
						output reg 	[ 1:0 ]						Imm_sel1 , //0-Imm;1-SImm;2-UImm
						output reg 								JPC_sel  , //0-不跳
						output reg 								JRPC_sel1, //0-不跳
						output reg 								Brch1	 , //0-不跳
						output reg 								MEM_W_en1, //1-数据存储器写使能
						output reg 								WB_sel1	 , //0-result;1-MEM_data
						output reg 								reg_w_en1, //1-写使能
						output reg 								dset_sel1, //0-rd;1-rt
						output reg 	[ 4:0 ]						ALU_ctrl1);//ALU控制信号
			
/*===============================signal================================*/
	wire [6 :0 ]	opcode				;
	wire [2 :0 ]	funct3				;
	wire [6 :0 ]	funct7				;
	wire [4 :0 ]	rs					;
	wire [4 :0 ]	rt					;
	wire [4 :0 ]	rd					;
	wire [11:0 ]	Imm					;
	wire [11:0 ]	SImm				;
	wire [20:1 ]	JImm				;
	wire [12:1 ]	BImm				;
	wire [19:0 ]	UImm				;
	reg  [ 2:0 ]	src1_sel			;
	reg  [ 2:0 ]	src2_sel			;
	reg  [ 1:0 ]	Imm_sel 			;
	reg 			JRPC_sel			;
	reg 			Brch				;
	reg 			MEM_W_en			;
	reg 			WB_sel				;
	reg 			reg_w_en			;
	reg 			dset_sel			;
	reg  [ 4:0 ]	ALU_ctrl			;
	reg				valid				;
	reg				handshake			;
/*======================================解析信号=========================================*/	
	assign opcode[6 : 0] =  Ins1[6 : 0]										;
	assign funct3[2 : 0] =  Ins1[14:12]										;
	assign funct7[6 : 0] =  Ins1[31:25]										;
	assign rs    [4 : 0] =  Ins1[19:15]										;
	assign rt	 [4 : 0] =  Ins1[24:20]										;
	assign rd 	 [4 : 0] =  Ins1[11: 7]										;
	assign Imm   [11: 0] =  Ins1[31:20]										;
	assign SImm  [11: 0] = {Ins1[31:25],Ins1[11:7]}							;
	assign JImm  [20: 1] = {Ins1[31   ],Ins1[19:12],Ins1[20   ],Ins1[30:21]};
	assign BImm	 [12:1 ] = {Ins1[31   ],Ins1[7    ],Ins1[30:25],Ins1[11: 8]};
	assign UImm  [19:0 ] =  Ins1[31:12]										; 
	

	always@(*)begin
		ready2	  = ready3								;
		handshake = valid2 & ready3						;
		JPC1 	  = PC2 + {{43{JImm[20]}},{JImm[20:1]},1'b0};
		
		if(opcode==7'b110_1111 || opcode==7'b110_0111 || opcode==7'b110_0011)begin//Jal and jalr B
			bubble21 = 1'b1;
		end else begin
			bubble21 = 1'b0	;
		end
/*====================================R TYPE============================================*/
		if(opcode==7'b011_0011 || opcode==7'b011_1011)begin
			src1_sel = 3'd0;
			src2_sel = 3'd0;
			Imm_sel  = 2'd0;
			JPC_sel	 = 1'b0;
			JRPC_sel = 1'b0;
			Brch	 = 1'b0;
			MEM_W_en = 1'b0;
			WB_sel	 = 1'b0;
			reg_w_en = 1'b1;
			dset_sel = 1'b0;
		end 
/*=======================================I TYPE==============================================*/	
/*=========================1-jalr   2-ld    3-32位运算    4-64位运算=========================*/
		else if(opcode==7'b110_0111 || opcode==7'b000_0011 || opcode==7'b001_1011 || opcode==7'b001_0011)begin
			Imm_sel  = 2'd0;
			JPC_sel	 = 1'b0;
			Brch	 = 1'b0;
			MEM_W_en = 1'b0;
			reg_w_en = 1'b1;
			dset_sel = 1'b0;
/*================ld 类===================*/
			if(opcode==7'b000_0011)begin
				WB_sel = 1'b1;
			end else begin
				WB_sel = 1'b0;
			end
/*================jalr 类===================*/	
			if(opcode==7'b110_0111)begin
				JRPC_sel = 1'b1;
				src1_sel = 3'd5;
				src2_sel = 3'd5;
			end else begin
				JRPC_sel = 1'b0;
				src1_sel = 3'd0;
				src2_sel = 3'd1;
			end
		end
/*=======================================S TYPE==============================================*/	
		else if(opcode==7'b010_0011)begin
			src1_sel = 3'd0;
			src2_sel = 3'd1;
			Imm_sel  = 2'd1;
			JPC_sel	 = 1'b0;
			JRPC_sel = 1'b0;
			Brch	 = 1'b0;
			MEM_W_en = 1'b1;
			WB_sel	 = 1'b0;
			reg_w_en = 1'b0;
			dset_sel = 1'b0;
		end
/*=======================================B TYPE==============================================*/	
		else if(opcode==7'b110_0011)begin
			src1_sel = 3'd0;
			src2_sel = 3'd0;
			Imm_sel  = 2'd0;
			JPC_sel	 = 1'b0;
			JRPC_sel = 1'b0;
			Brch	 = 1'b1;
			MEM_W_en = 1'b0;
			WB_sel	 = 1'b0;
			reg_w_en = 1'b0;
			dset_sel = 1'b0;
		end
		
/*=======================================J TYPE==============================================*/	
		else if(opcode==7'b110_1111)begin
			src1_sel = 3'd5;
			src2_sel = 3'd5;
			Imm_sel  = 2'd0;
			JPC_sel	 = 1'b1;
			JRPC_sel = 1'b0;
			Brch	 = 1'b0;
			MEM_W_en = 1'b0;
			WB_sel	 = 1'b0;
			reg_w_en = 1'b1;
			dset_sel = 1'b0;
		end
/*=======================================U TYPE==============================================*/
/*==================lui==================*/
		else if(opcode==7'b011_0111)begin
			src1_sel = 3'd4;
			src2_sel = 3'd1;
			Imm_sel  = 2'd2;
			JPC_sel	 = 1'b0;
			JRPC_sel = 1'b0;
			Brch	 = 1'b0;
			MEM_W_en = 1'b0;
			WB_sel	 = 1'b0;
			reg_w_en = 1'b1;
			dset_sel = 1'b0;
		end
/*==================auipc=================*/
		else if(opcode==7'b001_0111)begin
			src1_sel = 3'd5;
			src2_sel = 3'd1;
			Imm_sel  = 2'd2;
			JPC_sel	 = 1'b0;
			JRPC_sel = 1'b0;
			Brch	 = 1'b0;
			MEM_W_en = 1'b0;
			WB_sel	 = 1'b0;
			reg_w_en = 1'b1;
			dset_sel = 1'b0;
		end
		else begin
			src1_sel = 3'd0;
			src2_sel = 3'd0;
			Imm_sel  = 2'd0;
			JPC_sel	 = 1'b0;
			JRPC_sel = 1'b0;
			Brch	 = 1'b0;
			MEM_W_en = 1'b0;
			WB_sel	 = 1'b0;
			reg_w_en = 1'b0;
			dset_sel = 1'b0;
		end
	end
/*========================================ALU_ctrl=========================================*/
/*======0:64位+  1:32位+  2:64位左移    3:32位左移   4:64位算术右移    5:32位算术右移
		6:64位逻辑右移    7:32位逻辑右移   8:64位&     9:64位|       10:64位^   
		11:64位有符号<   12:64位无符号<   13:64位==  14:64位！=   15:64位有符号>=    16:64位无符号>=  
		17:64位无符号-   18:有符号32位-     19:64位*取低64位     20:有符号64位*取高64位   21:无符号64位*取高64位     22:32位有符号乘法取低32位符号扩展    23:64有符号除法    24:64无符号除法  25:有符号32位除法符号扩展   26:32位无符号除法有符号扩展   27:64有符号取余  28:64无符号取余      29:32位无符号取余有符号扩展    30:32位有符号取余有符号扩展*/

	always@(*)begin
		case(opcode) 
			7'b011_0011:begin//R TYPE
				case(funct3)
					3'b000: begin
							if(~Ins1[30]) ALU_ctrl = 5'd0 ; else ALU_ctrl = 5'd17;//add,sub
							if( Ins1[25]) ALU_ctrl = 5'd19;
					end
					3'b111: if(~Ins1[25]) ALU_ctrl = 5'd8 ; else ALU_ctrl = 5'd28;//and,remu
					3'b011: if(~Ins1[25]) ALU_ctrl = 5'd12; else ALU_ctrl = 5'd21;//sltu,mulhu
					3'b010: ALU_ctrl = 5'd11;//slt
					3'b001: if(~Ins1[25]) ALU_ctrl = 5'd2 ; else ALU_ctrl = 5'd20;//sll,mulh
					3'b101: begin
							if(~Ins1[30]) ALU_ctrl = 5'd6 ; else ALU_ctrl = 5'd4 ;//srl,sra
							if( Ins1[25]) ALU_ctrl = 5'd24;//divu
					end
					3'b100: if(~Ins1[30]) ALU_ctrl = 5'd10; else ALU_ctrl = 5'd23;//xor,div
					3'b110: if(~Ins1[25]) ALU_ctrl = 5'd9 ; else ALU_ctrl = 5'd27;//or,rem
				endcase
			end
			7'b011_1011:begin
				case(funct3)
					3'b101: begin
							if( Ins1[25]) ALU_ctrl = 5'd26;//divuw
							if( Ins1[30]) ALU_ctrl = 5'd5 ; else ALU_ctrl = 5'd7 ;//sraw,srlw
					end
					3'b111: ALU_ctrl = 5'd29;//remuw
					3'b000: begin
							if( Ins1[30]) ALU_ctrl = 5'd18; else ALU_ctrl = 5'd1 ;//subw,addw
							if( Ins1[25]) ALU_ctrl = 5'd22;//mulw
					end
					3'b001: ALU_ctrl = 5'd3 ;//sllw
					3'b100: ALU_ctrl = 5'd25;//divw
					3'b110: ALU_ctrl = 5'd30;//remw
					default:ALU_ctrl = 5'h1f;
				endcase
			end
			7'b110_0111:begin//I TYPE
				ALU_ctrl = 5'd0 ;//jalr
			end
			7'b000_0011:begin
				ALU_ctrl = 5'd0 ;//ld类
			end	
			7'b001_1011:begin
				case(funct3)
					3'b000: ALU_ctrl = 5'd1 ;//addiw
					3'b001: ALU_ctrl = 5'd3 ;//slliw
					3'b101: if( Ins1[30]) ALU_ctrl = 5'd5; else ALU_ctrl = 5'd7;//sraiw,srliw
					default: ALU_ctrl = 5'h1f;
				endcase
			end
			7'b001_0011:begin
				case(funct3)
					3'b000: ALU_ctrl = 5'd0 ;//addi
					3'b111: ALU_ctrl = 5'd8 ;//andi
					3'b110: ALU_ctrl = 5'd9 ;//ori
					3'b100: ALU_ctrl = 5'd10;//xori
					3'b101: if( Ins1[30]) ALU_ctrl = 5'd4; else ALU_ctrl = 5'd6;//srai,srli
					3'b001: ALU_ctrl = 5'd2 ;//slli
					3'b010: ALU_ctrl = 5'd11;//slti
					3'b011: ALU_ctrl = 5'd12;//sltiu	
				endcase
			end
			7'b010_0011:begin//S 类
				ALU_ctrl = 5'd0;
			end
			7'b110_0011:begin//B 类
				case(funct3)
					3'b000: ALU_ctrl = 5'd13;//beq
					3'b001: ALU_ctrl = 5'd14;//bne
					3'b101: ALU_ctrl = 5'd15;//bge
					3'b111: ALU_ctrl = 5'd16;//bgeu
					3'b100: ALU_ctrl = 5'd11;//blt
					3'b110: ALU_ctrl = 5'd12;//bltu
					default:ALU_ctrl = 5'h1f;
				endcase
			end	
			7'b110_1111:begin//J TYPE
				ALU_ctrl = 5'd0;
			end
			7'b011_0111:begin//lui
				ALU_ctrl = 5'd0;
			end
			7'b001_0111:begin
				ALU_ctrl = 5'd0;//auipc
			end
			default: ALU_ctrl = 5'h1f;
		endcase
	end

/*======================================时序输出=======================================*/	
	always@(posedge clk)begin
		$display("*********************************%x",PC3);
		$display("*********************************%x",Ins2);
		$display("*********************************%x",handshake);
		if(reset)begin
			valid3	  <= 1'b0 	;
			Ins2	  <= 32'b0	;	 
			PC3		  <= PC2	;
			opcode1	  <= 7'd0	;
			rs1		  <= 5'd0	;
			rt1		  <= 5'd0	;
			rd1		  <= 5'd0	;
			Imm1	  <= 12'd0	;
			SImm1	  <= 12'd0	;
			BImm1	  <= 12'd0	;
			UImm1	  <= 20'd0	;
			src1_sel1 <= 3'd0	;
			src2_sel1 <= 3'd0	;
			Imm_sel1  <= 2'd0	;
			JRPC_sel1 <= 1'd0	;
			Brch1	  <= 1'd0	;
			MEM_W_en1 <= 1'd0	;
			WB_sel1	  <= 1'd0	;
			reg_w_en1 <= 1'd0	;
			dset_sel1 <= 1'd0	;
			ALU_ctrl1 <= 5'd0	;
		end else begin
			if(handshake)begin
				valid3	  <= valid2	 ;
				Ins2	  <= Ins1	 ;	
				PC3		  <= PC2	 ;
				opcode1	  <= opcode	 ;
				rs1		  <= rs		 ;
				rt1		  <= rt		 ;
				rd1		  <= rd		 ;
				Imm1	  <= Imm	 ;
				SImm1	  <= SImm	 ;
				BImm1	  <= BImm	 ;
				UImm1	  <= UImm	 ;
				src1_sel1 <= src1_sel;
				src2_sel1 <= src2_sel;
				Imm_sel1  <= Imm_sel ;
				JRPC_sel1 <= JRPC_sel;
				Brch1	  <= Brch	 ;
				MEM_W_en1 <= MEM_W_en;
				WB_sel1	  <= WB_sel	 ;
				reg_w_en1 <= reg_w_en;
				dset_sel1 <= dset_sel;
				ALU_ctrl1 <= ALU_ctrl;
			end
		end	
	end
endmodule
