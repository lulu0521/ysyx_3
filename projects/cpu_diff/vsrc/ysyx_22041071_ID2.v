`include "define.v"
module ysyx_22041071_ID2(
						input								  clk	    	,
						input								  reset     	,
						input  wire [`ysyx_22041071_ADDR_BUS] PC3	    	,
						input  wire [`ysyx_22041071_INS_BUS ] Ins2	    	,
						input  wire [`ysyx_22041071_INS_BUS ] Ins31	    	,
						input  wire [6 :0					] opcode1   	,
						input  wire [4 :0 					] rs1	    	,
						input  wire [4 :0 					] rt1	    	,
						input  wire [4 :0 					] rd1	    	,
						input  wire [11:0 					] Imm1	    	,
						input  wire [11:0 					] SImm1	    	,
						input  wire [12:1 					] BImm1	    	,
						input  wire [31:12					] UImm1	    	,
						input  wire [ 2:0 					] src1_sel1 	, //0-data1;1-result;2-WB_data;3-WB_data1;4-0;5-PC
						input  wire [ 2:0 					] src2_sel1 	, //0-data2;1-Imm;2-result;3-WB_data;4-WB_data1;5-4
						input  wire [1:0					] Imm_sel1  	, //0-Imm;1-SImm;2-UImm
						input  wire 						  JRPC_sel1 	, //0-不跳
						input  wire 						  Brch1	    	, //0-不跳
						input  wire 						  MEM_W_en1 	, //1-数据存储器写使能
						input  wire 						  WB_sel1   	, //0-result;1-R_data
						input  wire 						  reg_w_en1 	, //1-写使能
						input  wire 						  dset_sel1 	, //0-rd;1-rt
						input  wire [ 4:0 					] ALU_ctrl1 	, //ALU控制信号
						input  wire							  reg_w_en5 	, //使能写寄存器
						input  wire	[ 4:0					] rdest4		, //写寄存器
						input  wire	[`ysyx_22041071_DATA_BUS] WB_data2  	, //write data
						input  wire 						  reg_w_en3_	,
						input  wire [ 4:0					] rdest1_   	,//EX阶段寄存器
						input  wire [`ysyx_22041071_DATA_BUS] result    	,//EX得到的结果
						input  wire							  reg_w_en4_	,
						input  wire [ 4:0					] rdest2		,//MEM阶段寄存器
						input  wire [`ysyx_22041071_DATA_BUS] WB_data   	,//MEM得到的结果
						input  wire							  valid3		,
						input  wire							  ready4		,
						output reg							  ready3		,
						output reg							  valid4		,
						output reg							  bubble22  	,
						output reg  [`ysyx_22041071_ADDR_BUS] PC4	    	,
						output reg  [`ysyx_22041071_INS_BUS ] Ins3	    	,
						output reg  						  JRPC_sel2 	,
						output reg	[`ysyx_22041071_ADDR_BUS] JRPC1	    	,
						output reg  						  Brch2	    	,
						output reg							  MEM_W_en2 	,
						output reg							  WB_sel2   	,//0-result;1-MEM_data
						output reg	[ 4:0 ]					  ALU_ctrl2 	,
						output reg							  reg_w_en2 	,
						output reg	[`ysyx_22041071_DATA_BUS] rt_data1  	,
						output reg  [ 4:0 ]					  rdest1		,
						output reg  [`ysyx_22041071_DATA_BUS] src_a	    	,
						output reg	[`ysyx_22041071_DATA_BUS] src_b	    	,
						output reg  [12:1 ]					  BImm2	    	,
						output reg  [`ysyx_22041071_DATA_BUS] reg_file0 	,
						output reg  [`ysyx_22041071_DATA_BUS] reg_file1 	,
						output reg  [`ysyx_22041071_DATA_BUS] reg_file2 	,
						output reg  [`ysyx_22041071_DATA_BUS] reg_file3 	,
						output reg  [`ysyx_22041071_DATA_BUS] reg_file4 	,
						output reg  [`ysyx_22041071_DATA_BUS] reg_file5 	,
						output reg  [`ysyx_22041071_DATA_BUS] reg_file6 	,
						output reg  [`ysyx_22041071_DATA_BUS] reg_file7 	,
						output reg  [`ysyx_22041071_DATA_BUS] reg_file8 	,
						output reg  [`ysyx_22041071_DATA_BUS] reg_file9 	,
						output reg  [`ysyx_22041071_DATA_BUS] reg_file10	,
						output reg  [`ysyx_22041071_DATA_BUS] reg_file11	,
						output reg  [`ysyx_22041071_DATA_BUS] reg_file12	,
						output reg  [`ysyx_22041071_DATA_BUS] reg_file13	,
						output reg  [`ysyx_22041071_DATA_BUS] reg_file14	,
						output reg  [`ysyx_22041071_DATA_BUS] reg_file15	,
						output reg  [`ysyx_22041071_DATA_BUS] reg_file16	,
						output reg  [`ysyx_22041071_DATA_BUS] reg_file17	,
						output reg  [`ysyx_22041071_DATA_BUS] reg_file18	,
						output reg  [`ysyx_22041071_DATA_BUS] reg_file19	,
						output reg  [`ysyx_22041071_DATA_BUS] reg_file20	,
						output reg  [`ysyx_22041071_DATA_BUS] reg_file21	,
						output reg  [`ysyx_22041071_DATA_BUS] reg_file22	,
						output reg  [`ysyx_22041071_DATA_BUS] reg_file23	,
						output reg  [`ysyx_22041071_DATA_BUS] reg_file24	,
						output reg  [`ysyx_22041071_DATA_BUS] reg_file25	,
						output reg  [`ysyx_22041071_DATA_BUS] reg_file26	,
						output reg  [`ysyx_22041071_DATA_BUS] reg_file27	,
						output reg  [`ysyx_22041071_DATA_BUS] reg_file28	,
						output reg  [`ysyx_22041071_DATA_BUS] reg_file29	,
						output reg  [`ysyx_22041071_DATA_BUS] reg_file30	,
						output reg  [`ysyx_22041071_DATA_BUS] reg_file31	);
	 
	reg [63:0] reg_file [0:31];
	
	wire [`ysyx_22041071_ADDR_BUS]	 PC	  	 	;
	wire [`ysyx_22041071_INS_BUS ]	 Ins	 	;
	wire  							 Brch	 	;
	wire							 MEM_W_en	;
	wire							 WB_sel  	;
	wire [ 4:0 					 ]	 ALU_ctrl	;
	wire							 reg_w_en	;
	wire [ 4:0					 ]	 rt		 	;
	wire [12:1					 ]	 BImm	 	;
	wire [`ysyx_22041071_DATA_BUS]	 rt_data 	;
	reg  [2:0					 ]	 src1_sel	;
	reg  [2:0					 ]	 src2_sel	;
	reg  [ 4:0 ]					 rdest	 	;
	reg  [`ysyx_22041071_DATA_BUS]	 src_1	 	;
	reg	 [`ysyx_22041071_DATA_BUS]	 src_2	 	;
	reg  [63:0 ]					 Imm	 	;
	reg								 valid	 	;
	reg								 handshake	;
	reg								 bubble4	;

	assign PC	  	= PC3	  		;
	assign Ins	  	= Ins2			;
	assign JRPC_sel2= JRPC_sel1		;
	assign Brch	  	= Brch1			;
	assign MEM_W_en = MEM_W_en1		;
	assign WB_sel  	= WB_sel1		;
	assign ALU_ctrl = ALU_ctrl1		;
	assign reg_w_en = reg_w_en1		;
	assign rt 		= rt1			;
	assign BImm 	= BImm1			;
	assign rt_data  = reg_file[rt1] ;
	assign reg_file0  = reg_file[0 ];
	assign reg_file1  = reg_file[1 ];
	assign reg_file2  = reg_file[2 ];
	assign reg_file3  = reg_file[3 ];
	assign reg_file4  = reg_file[4 ];
	assign reg_file5  = reg_file[5 ];
	assign reg_file6  = reg_file[6 ];
	assign reg_file7  = reg_file[7 ];
	assign reg_file8  = reg_file[8 ];
	assign reg_file9  = reg_file[9 ];
	assign reg_file10 = reg_file[10];
	assign reg_file11 = reg_file[11];
	assign reg_file12 = reg_file[12];
	assign reg_file13 = reg_file[13];
	assign reg_file14 = reg_file[14];
	assign reg_file15 = reg_file[15];
	assign reg_file16 = reg_file[16];
	assign reg_file17 = reg_file[17];
	assign reg_file18 = reg_file[18];
	assign reg_file19 = reg_file[19];
	assign reg_file20 = reg_file[20];
	assign reg_file22 = reg_file[21];
	assign reg_file23 = reg_file[22];
	assign reg_file24 = reg_file[23];
	assign reg_file25 = reg_file[24];
	assign reg_file26 = reg_file[25];
	assign reg_file27 = reg_file[26];
	assign reg_file28 = reg_file[27];
	assign reg_file29 = reg_file[28];
	assign reg_file30 = reg_file[29];
	assign reg_file31 = reg_file[30];
	assign reg_file31 = reg_file[31];

	always@(*)begin
		handshake = valid3 & ready4				    	 ;
		JRPC1	  = reg_file[rs1] + {{52{Imm1[11]}},Imm1};
		
		if(opcode1==7'b110_0111 || opcode1==7'b110_0011)begin//jalr and B
			bubble22 = 1'b1;
		end else begin
			bubble22 = 1'b0;
		end
		
		if(Ins31[6:0]==7'b000_0011 && ((opcode1==7'b011_0011 || opcode1==7'b011_1011)&&(rs1==rdest1_ || rt1==rdest1_)
		|| (opcode1==7'b110_0111 || opcode1==7'b000_0011 || opcode1==7'b001_1011 || opcode1==7'b001_1011)&&rs1==rdest1_
		|| opcode1==7'b010_0011 && (rs1==rdest1_ || rt1==rdest1_)
		|| opcode1==7'b110_0011 && (rs1==rdest1_ || rt1==rdest1_)))begin
			ready3 	= 1'b0	;
			bubble4 = 1'b1	; 
		end else begin
			ready3 	= ready4;
			bubble4 = 1'b0	; 
		end
		
		if(dset_sel1)begin//选择目的寄存器
			rdest = rt1;
		end else begin
			rdest = rd1;
		end
		
		case(Imm_sel1)
			2'd0:Imm = {{52{Imm1[11]}} ,Imm1 			};
			2'd1:Imm = {{52{SImm1[11]}},SImm1			};
			2'd2:Imm = {{32{UImm1[31]}},UImm1,{12{1'b0}}};
			default:Imm = 64'h0;
		endcase
		
		//确定src1_sel
		if(opcode1!=7'b011_0111 && opcode1!=7'b001_0111 && opcode1!=7'b110_1111)begin//U and J
			if(rs1 == rdest1_ && reg_w_en3_ == 1'b1)
				src1_sel = 3'd1;
			else if(rs1 == rdest2 && reg_w_en4_ == 1'b1)
				src1_sel = 3'd2;
			else if(rs1 == rdest4 && reg_w_en5 == 1'b1)
				src1_sel = 3'd3;
			else
				src1_sel = src1_sel1;
		end

		case(src1_sel)//选择src_1,0-data1;1-result;2-WB_data;3-WB_data2;4-0;5-PC
			3'd0:src_1 = reg_file[rs1]	;
			3'd1:src_1 = result			;
			3'd2:src_1 = WB_data		;
			3'd3:src_1 = WB_data2		;
			3'd4:src_1 = 0				;
			3'd5:src_1 = PC3			;
			default:src_1 = 64'h0		;
		endcase
		
		//确定src2_sel
		if(opcode1==7'b011_0011 || opcode1==7'b011_1011 || opcode1==7'b010_0011 || opcode1==7'b110_0011)begin//R S B
			if(rt1 == rdest1_ && reg_w_en3_ == 1'b1)
				src2_sel = 3'd2;
			else if(rt1 == rdest2 && reg_w_en4_ == 1'b1)
				src2_sel = 3'd3;
			else if(rt1 == rdest4 && reg_w_en5 == 1'b1)
				src2_sel = 3'd4;
			else 
				src2_sel = src2_sel1;
		end else begin
			src2_sel = src2_sel1;
		end
		
		case(src2_sel)//选择src_2,0-data2;1-Imm;2-result;3-WB_data;4-WB_data1;5-4
			3'd0:src_2 = reg_file[rt1];
			3'd1:src_2 = Imm		  ;
			3'd2:src_2 = result	  ;
			3'd3:src_2 = WB_data	  ;
			3'd4:src_2 = WB_data2	  ;
			3'd5:src_2 = 4			  ;
			default:src_2 = 64'h0	  ;
		endcase	
	end
	
	always@(posedge clk)begin
		if(reset)begin
			valid4	   <= 1'b0 ;
			PC4	  	   <= PC3  ;
			Ins3	   <= 32'b0;
			Brch2	   <= 1'd0 ;
			MEM_W_en2  <= 1'd0 ;
			WB_sel2    <= 1'd0 ;
			ALU_ctrl2  <= 5'd0 ;
			reg_w_en2  <= 1'd0 ;
			rt_data1   <= 64'd0;
			rdest1	   <= 5'd0 ;
			src_a	   <= 64'd0;
			src_b	   <= 64'd0;
			BImm2	   <= 12'd0;
		end else begin
			if(bubble4)begin
				valid4	   <= 1'b1 ;
				PC4	  	   <= PC3  ;
				Ins3	   <= 32'b0;
				Brch2	   <= 1'd0 ;
				MEM_W_en2  <= 1'd0 ;
				WB_sel2    <= 1'd0 ;
				ALU_ctrl2  <= 5'd0 ;
				reg_w_en2  <= 1'd0 ;
				rt_data1   <= 64'd0;
				rdest1	   <= 5'd0 ;
				src_a	   <= 64'd0;
				src_b	   <= 64'd0;
				BImm2	   <= 12'd0;
			end else begin
				if(handshake)begin
					valid4	   <= valid3	  ;		
					PC4	  	   <= PC	  	  ;
					Ins3	   <= Ins	 	  ;
					Brch2	   <= Brch		  ;
					MEM_W_en2  <= MEM_W_en	  ;
					WB_sel2    <= WB_sel  	  ;
					ALU_ctrl2  <= ALU_ctrl	  ;
					rt_data1   <= rt_data	  ;
					reg_w_en2  <= reg_w_en	  ;
					rdest1	   <= rdest		  ;
					src_a	   <= src_1		  ;
					src_b	   <= src_2		  ;
					BImm2	   <= BImm		  ;	
				end	  	
			end  
		end 
		if(reg_w_en5)begin 
			reg_file[rdest4] <= WB_data2; 
		end
	end

endmodule
