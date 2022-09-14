`include "define.v"

module SimTop(input         clock               ,
    		  input         reset               ,
		  
    		  input  [63:0] io_logCtrl_log_begin,
    		  input  [63:0] io_logCtrl_log_end  ,
    		  input  [63:0] io_logCtrl_log_level,
    		  input         io_perfInfo_clean   ,
    		  input         io_perfInfo_dump    ,
		  
    		  output        io_uart_out_valid   ,
    		  output [7:0]  io_uart_out_ch      ,
    		  output        io_uart_in_valid    ,
    		  input  [7:0]  io_uart_in_ch       );

//PC  
wire						     valid1	  ;
wire   [`ysyx_22041071_ADDR_BUS] PC	   	  ;

//IF
wire						   ready1	  ;
wire						   valid2	  ;
wire [`ysyx_22041071_ADDR_BUS] PC2		  ;
wire [`ysyx_22041071_INS_BUS ] Ins		  ;
wire [`ysyx_22041071_ADDR_BUS] SNPC		  ;

//ID
wire							  ready2	;
wire							  valid3	;
wire							  bubble21  ; //冲刷寄存器2
wire 	[`ysyx_22041071_ADDR_BUS] PC3		;
wire 	[`ysyx_22041071_INS_BUS ] Ins2	    ;
wire 	[`ysyx_22041071_ADDR_BUS] JPC1	    ;
wire 	[6 :0 ]					  opcode1	;
wire 	[4 :0 ]					  rs1		;
wire 	[4 :0 ]					  rt1		;
wire 	[4 :0 ]					  rd1		;
wire 	[11:0 ]					  Imm1	    ;
wire 	[11:0 ]					  SImm1	    ;
wire 	[12:1 ]					  BImm1	    ;
wire 	[31:12]					  UImm1	    ;
wire 	[ 2:0 ]					  src1_sel1 ; //0-data1;1-result;2-WB_data;3-WB_data1;4-0;5-PC
wire 	[ 2:0 ]					  src2_sel1 ; //0-data2;1-Imm;2-result;3-WB_data;4-WB_data1;5-4
wire 	[ 1:0 ]					  Imm_sel1  ; //0-Imm;1-SImm;2-UImm
wire 							  JPC_sel  ; //0-不跳
wire 							  JRPC_sel1 ; //0-不跳
wire 							  Brch1	    ; //0-不跳
wire 							  MEM_W_en1 ; //1-数据存储器写使能
wire 							  WB_sel1	; //0-result;1-R_data
wire 							  reg_w_en1 ; //1-写使能
wire 							  dset_sel1 ; //0-rd;1-rt
wire 	[ 4:0 ]					  ALU_ctrl1 ; //ALU控制信号

//ID2
wire							  ready3	;
wire							  valid4	;
wire							  bubble22  ;
wire  [`ysyx_22041071_ADDR_BUS]   PC4	    ;
wire  [`ysyx_22041071_INS_BUS ]   Ins3	  	;
wire  						      JRPC_sel2 ;
wire  [`ysyx_22041071_ADDR_BUS]   JRPC1	  	;
wire  						      Brch2	  	;
wire							  MEM_W_en2 ;
wire							  WB_sel2   ;
wire	[ 4:0 ]					  ALU_ctrl2 ;
wire							  reg_w_en2 ;
wire  [`ysyx_22041071_DATA_BUS]   rt_data1  ;
wire  [ 4:0 ]					  rdest1	;
wire  [`ysyx_22041071_DATA_BUS]   src_a	  	;
wire  [`ysyx_22041071_DATA_BUS]   src_b	  	;
wire  [12:1 ]					  BImm2	  	;
wire							  bubble4	;
wire  [`ysyx_22041071_DATA_BUS] reg_file0 	;
wire  [`ysyx_22041071_DATA_BUS] reg_file1 	;
wire  [`ysyx_22041071_DATA_BUS] reg_file2 	;
wire  [`ysyx_22041071_DATA_BUS] reg_file3 	;
wire  [`ysyx_22041071_DATA_BUS] reg_file4 	;
wire  [`ysyx_22041071_DATA_BUS] reg_file5 	;
wire  [`ysyx_22041071_DATA_BUS] reg_file6 	;
wire  [`ysyx_22041071_DATA_BUS] reg_file7 	;
wire  [`ysyx_22041071_DATA_BUS] reg_file8 	;
wire  [`ysyx_22041071_DATA_BUS] reg_file9 	;
wire  [`ysyx_22041071_DATA_BUS] reg_file10	;
wire  [`ysyx_22041071_DATA_BUS] reg_file11	;
wire  [`ysyx_22041071_DATA_BUS] reg_file12	;
wire  [`ysyx_22041071_DATA_BUS] reg_file13	;
wire  [`ysyx_22041071_DATA_BUS] reg_file14	;
wire  [`ysyx_22041071_DATA_BUS] reg_file15	;
wire  [`ysyx_22041071_DATA_BUS] reg_file16	;
wire  [`ysyx_22041071_DATA_BUS] reg_file17	;
wire  [`ysyx_22041071_DATA_BUS] reg_file18	;
wire  [`ysyx_22041071_DATA_BUS] reg_file19	;
wire  [`ysyx_22041071_DATA_BUS] reg_file20	;
wire  [`ysyx_22041071_DATA_BUS] reg_file21	;
wire  [`ysyx_22041071_DATA_BUS] reg_file22	;
wire  [`ysyx_22041071_DATA_BUS] reg_file23	;
wire  [`ysyx_22041071_DATA_BUS] reg_file24	;
wire  [`ysyx_22041071_DATA_BUS] reg_file25	;
wire  [`ysyx_22041071_DATA_BUS] reg_file26	;
wire  [`ysyx_22041071_DATA_BUS] reg_file27	;
wire  [`ysyx_22041071_DATA_BUS] reg_file28	;
wire  [`ysyx_22041071_DATA_BUS] reg_file29	;
wire  [`ysyx_22041071_DATA_BUS] reg_file30	;
wire  [`ysyx_22041071_DATA_BUS] reg_file31	;

//EX
wire							  ready4	 ; 
wire							  valid5	 ; 
wire							  bubble23   ; 
wire  [`ysyx_22041071_ADDR_BUS]   PC5	     ;
wire  [`ysyx_22041071_INS_BUS ]   Ins4	   	 ; 
wire  						      MEM_W_en3  ;  
wire 							  WB_sel3    ;  
wire  						      reg_w_en3  ;  
wire  [`ysyx_22041071_DATA_BUS]   rt_data2   ;  
wire  [ 4:0 ]					  rdest2	 ;   
wire  [`ysyx_22041071_DATA_BUS]   ALU_result1; 
wire						 	  reg_w_en3_ ;
wire  [ 4:0 ]					  rdest2_	 ;
wire  [`ysyx_22041071_DATA_BUS]	  ALU_result ; 
wire							  Brch_sel1  ; 
wire  [`ysyx_22041071_ADDR_BUS]   BPC1	   	 ; 

//MEM
wire							  ready5	 ;  
wire							  valid6	 ; 
wire  [`ysyx_22041071_ADDR_BUS]   PC6		 ;
wire  [`ysyx_22041071_INS_BUS ]   Ins5		 ; 
wire  						      reg_w_en4  ;   
wire  [ 4:0 ]					  rdest3	 ;    
wire  [`ysyx_22041071_DATA_BUS]   WB_data1   ; 
wire  						 	  reg_w_en4_ ;
wire  [ 4:0 ]					  rdest3_	 ;
wire  [`ysyx_22041071_DATA_BUS]	  WB_data1_  ; 

//WB
wire							ready6		 ;
wire							valid7		 ;
wire  [`ysyx_22041071_ADDR_BUS] PC7 		 ;
wire  [`ysyx_22041071_INS_BUS ] Ins6		 ;
wire  						    reg_w_en5	 ;
wire  [ 4:0 ]					rdest4	     ;	
wire  [`ysyx_22041071_DATA_BUS] WB_data2	 ;


ysyx_22041071_PC MY_PC(	.clk	  (clock      ),
						.reset    (reset      ),
						.Brch_sel (Brch_sel1  ),	//B指令跳转控制
						.JPC_sel  (JPC_sel    ),   //JAL指令跳转控制
						.JRPC_sel2(JRPC_sel2  ),   //JALR指令跳转控制
						.BPC	  (BPC1       ),   //B指令跳转目的地址
						.JPC	  (JPC1       ),   //JAL指令跳转目的地址
						.JRPC	  (JRPC1      ),   //JALR指令跳转目的地址
						.SNPC	  (SNPC       ),   //PC+4
						.ready1   (ready1     ),
						.valid1	  (valid1     ),
						.PC		  (PC		  ));  //输出PC

ysyx_22041071_IF IF(.clk	  (clock      ),
				    .reset	  (reset      ),
				    .PC1	  (PC         ),
					.Brch_sel1(Brch_sel1  ), 
					.PC4	  (PC4		  ),	
				    .bubble21 (bubble21   ),
				    .bubble22 (bubble22   ),
				    .bubble23 (bubble23   ),
					.PC3	  (PC3		  ),
					.bubble4  (bubble4	  ),
				    .valid1	  (valid1     ),
				    .ready2	  (ready2     ),
				    .ready1	  (ready1	  ),
				    .valid2	  (valid2	  ),
				    .PC2	  (PC2		  ),
				    .Ins	  (Ins		  ),
				    .SNPC	  (SNPC		  ));

ysyx_22041071_ID ID(.clk	   (clock     ),
					.reset     (reset     ),
					.PC2	   (PC2       ),
					.Ins1	   (Ins       ),
					.valid2	   (valid2    ),
					.ready3	   (ready3    ),
					.ready2	   (ready2	  ),
					.valid3	   (valid3	  ),
					.bubble21  (bubble21  ),//冲刷寄存器2
					.PC3	   (PC3	      ),
					.Ins2	   (Ins2	  ),
					.JPC1	   (JPC1	  ),
					.opcode1   (opcode1	  ),
					.rs1	   (rs1		  ),
					.rt1	   (rt1		  ),
					.rd1	   (rd1		  ),
					.Imm1	   (Imm1	  ),
					.SImm1	   (SImm1	  ),
					.BImm1	   (BImm1	  ),
					.UImm1	   (UImm1	  ),
					.src1_sel1 (src1_sel1 ), //0-data1;1-result;2-WB_data;3-WB_data1;4-0;5-PC
					.src2_sel1 (src2_sel1 ), //0-data2;1-Imm;2-result;3-WB_data;4-WB_data1;5-4
					.Imm_sel1  (Imm_sel1  ), //0-Imm;1-SImm;2-UImm
					.JPC_sel   (JPC_sel   ), //0-不跳
					.JRPC_sel1 (JRPC_sel1 ), //0-不跳
					.Brch1	   (Brch1	  ), //0-不跳
					.MEM_W_en1 (MEM_W_en1 ), //1-数据存储器写使能
					.WB_sel1   (WB_sel1	  ), //0-result;1-R_data
					.reg_w_en1 (reg_w_en1 ), //1-写使能
					.dset_sel1 (dset_sel1 ), //0-rd;1-rt
					.ALU_ctrl1 (ALU_ctrl1 ));//ALU控制信号

ysyx_22041071_ID2 ID2(
					.clk	  	(clock		 ),
					.reset    	(reset		 ),
					.PC3	  	(PC3	     ),
					.Ins2	  	(Ins2	     ),
					.Ins31	  	(Ins3	     ),
					.opcode1  	(opcode1     ),
					.rs1	  	(rs1		 ),
					.rt1	  	(rt1		 ),
					.rd1	  	(rd1		 ),
					.Imm1	  	(Imm1	     ),
					.SImm1	  	(SImm1		 ),
					.BImm1	  	(BImm1		 ),
					.UImm1	  	(UImm1		 ),
					.src1_sel1	(src1_sel1 	 ), //0-data1;1-result;2-WB_data;3-WB_data1;4-0;5-PC
					.src2_sel1	(src2_sel1 	 ), //0-data2;1-Imm;2-result;3-WB_data;4-WB_data1;5-4
					.Imm_sel1 	(Imm_sel1  	 ), //0-Imm;1-SImm;2-UImm
					.JRPC_sel1	(JRPC_sel1 	 ), //0-不跳
					.Brch1	  	(Brch1     	 ), //0-不跳
					.MEM_W_en1	(MEM_W_en1 	 ), //1-数据存储器写使能
					.WB_sel1  	(WB_sel1   	 ), //0-result;1-R_data
					.reg_w_en1	(reg_w_en1 	 ), //1-写使能
					.dset_sel1	(dset_sel1 	 ), //0-rd;1-rt
					.ALU_ctrl1	(ALU_ctrl1 	 ), //ALU控制信号
					.reg_w_en5	(reg_w_en5 	 ), //使能写寄存器
					.rdest4	  	(rdest4	 	 ), //写寄存器
					.WB_data2 	(WB_data2	 ), //WB得到的结果
					.reg_w_en3_	(reg_w_en3_	 ),
					.rdest1_  	(rdest2_   	 ), //EX阶段寄存器
					.result   	(ALU_result  ), //EX得到的结果		
					.reg_w_en4_ (reg_w_en4_	 ),
					.rdest2	  	(rdest3_	 ),//MEM阶段寄存器
					.WB_data  	(WB_data1_	 ),//MEM得到的结果
					.valid3	  	(valid3	 	 ),
					.ready4	  	(ready4	 	 ),
					.ready3	  	(ready3	 	 ),
					.valid4	  	(valid4	 	 ),
					.bubble22 	(bubble22  	 ),
					.PC4	  	(PC4	     ),
					.Ins3	  	(Ins3	     ),
					.JRPC_sel2	(JRPC_sel2 	 ),
					.JRPC1	  	(JRPC1	 	 ),
					.Brch2	  	(Brch2	 	 ),
					.MEM_W_en2	(MEM_W_en2   ),
					.WB_sel2  	(WB_sel2     ),
					.ALU_ctrl2	(ALU_ctrl2   ),
					.reg_w_en2	(reg_w_en2   ),
					.rt_data1 	(rt_data1    ),
					.rdest1	  	(rdest1	 	 ),
					.src_a	  	(src_a	 	 ),
					.src_b	  	(src_b	 	 ),
					.BImm2	  	(BImm2	 	 ),
					.bubble4	(bubble4	 ),
					.reg_file0  (reg_file0 	 ),
					.reg_file1  (reg_file1 	 ),
					.reg_file2  (reg_file2 	 ),
					.reg_file3  (reg_file3 	 ),
					.reg_file4  (reg_file4 	 ),
					.reg_file5  (reg_file5 	 ),
					.reg_file6  (reg_file6 	 ),
					.reg_file7  (reg_file7 	 ),
					.reg_file8  (reg_file8 	 ),
					.reg_file9  (reg_file9 	 ),
					.reg_file10 (reg_file10	 ),
					.reg_file11 (reg_file11	 ),
					.reg_file12 (reg_file12	 ),
					.reg_file13 (reg_file13	 ),
					.reg_file14 (reg_file14	 ),
					.reg_file15 (reg_file15	 ),
					.reg_file16 (reg_file16	 ),
					.reg_file17 (reg_file17	 ),
					.reg_file18 (reg_file18	 ),
					.reg_file19 (reg_file19	 ),
					.reg_file20 (reg_file20	 ),
					.reg_file21 (reg_file21	 ),
					.reg_file22 (reg_file22	 ),
					.reg_file23 (reg_file23	 ),
					.reg_file24 (reg_file24	 ),
					.reg_file25 (reg_file25	 ),
					.reg_file26 (reg_file26	 ),
					.reg_file27 (reg_file27	 ),
					.reg_file28 (reg_file28	 ),
					.reg_file29 (reg_file29	 ),
					.reg_file30 (reg_file30	 ),
					.reg_file31 (reg_file31	 ));

ysyx_22041071_EX EX(.clk	   	(clock		 ),
					.reset	   	(reset		 ),
					.PC4	   	(PC4	     ),
					.Ins3	   	(Ins3	     ),
					.Brch2	   	(Brch2	 	 ),
					.MEM_W_en2 	(MEM_W_en2 	 ),
					.WB_sel2   	(WB_sel2   	 ),
					.ALU_ctrl2 	(ALU_ctrl2   ),
					.rt_data1  	(rt_data1    ),
					.reg_w_en2 	(reg_w_en2   ),
					.rdest1	   	(rdest1	 	 ),
					.src_a	   	(src_a	 	 ),
					.src_b	   	(src_b	 	 ),
					.BImm2	   	(BImm2	 	 ),
					.valid4		(valid4		 ),
					.ready5		(ready5		 ),
					.ready4		(ready4		 ),
					.valid5		(valid5		 ),
					.bubble23	(bubble23	 ),
					.PC5	    (PC5	     ),
                    .Ins4	    (Ins4	     ),
					.MEM_W_en3  (MEM_W_en3   ),
					.WB_sel3    (WB_sel3     ),
					.reg_w_en3  (reg_w_en3   ),
					.rt_data2   (rt_data2    ),
					.rdest2	    (rdest2	     ),
					.ALU_result1(ALU_result1 ),
					.reg_w_en3_ (reg_w_en3_  ),
					.rdest2_	(rdest2_	 ),
					.ALU_result	(ALU_result	 ),
					.Brch_sel1	(Brch_sel1	 ),
					.BPC1		(BPC1		 ));

ysyx_22041071_MEM MEM(.clk		  (clock		),
					  .reset	  (reset		),
					  .PC5	      (PC5	 	    ),
                      .Ins4	      (Ins4	 	    ),
					  .Ins5_	  (Ins5			), 
					  .MEM_W_en3  (MEM_W_en3   	),
					  .WB_sel3    (WB_sel3     	),
					  .reg_w_en3  (reg_w_en3   	),
					  .rt_data2   (rt_data2    	),
					  .rdest2	  (rdest2	    ),
					  .ALU_result1(ALU_result1  ),
					  .valid5	  (valid5		),
					  .ready6	  (ready6		),
					  .ready5	  (ready5		),
					  .valid6	  (valid6		),
					  .PC6		  (PC6			),
					  .Ins5		  (Ins5			),
					  .reg_w_en4  (reg_w_en4	),
					  .rdest3	  (rdest3	  	),
					  .WB_data1	  (WB_data1		),
					  .reg_w_en4_ (reg_w_en4_   ),
					  .rdest3_	  (rdest3_		),
					  .WB_data1_  (WB_data1_	));

ysyx_22041071_WB WB(.clk		(clock		),
					.reset		(reset		),
					.PC6 		(PC6		),	
					.Ins5		(Ins5		),	
					.reg_w_en4	(reg_w_en4	),
					.rdest3	  	(rdest3	  	),
					.WB_data1	(WB_data1	),
					.valid6		(valid6		),
					.ready6		(ready6		),
					.valid7		(valid7		),
					.PC7 		(PC7 		),
					.Ins6		(Ins6		),
					.reg_w_en5	(reg_w_en5	),
					.rdest4	  	(rdest4	  	),
                    .WB_data2	(WB_data2	));



//Difftest
reg [`ysyx_22041071_ADDR_BUS] PC7_				;	
reg [`ysyx_22041071_INS_BUS ] Ins6_				;				
reg 						  reg_w_en5_		;			
reg [ 4:0 					] rdest4_			;				
reg [`ysyx_22041071_DATA_BUS] WB_data2_			;	
reg 						  CMT_valid 		;
reg [`ysyx_22041071_ADDR_BUS] CMT_pc			;
reg [`ysyx_22041071_INS_BUS ] CMT_inst			;
reg 						  CMT_reg_w_en		;	
reg [ 4:0 					] CMT_rdest			;
reg [`ysyx_22041071_DATA_BUS] CMT_WB_data		;
reg							  TRAP				;
reg [7:0					] TRAP_code			;
reg [63:0					] cycleCnt			;
reg [63:0					] instrCnt			;
wire						  INST_valid		;
reg [`ysyx_22041071_DATA_BUS] REGS_diff [0:31]	;

always@(posedge clock)begin
	PC7_		<= PC7 		 ;
	Ins6_		<= Ins6		 ;
	reg_w_en5_	<= reg_w_en5 ;
	rdest4_		<= rdest4	 ; 
	WB_data2_	<= WB_data2	 ;

end

assign INST_valid = Ins6_ != 0;
always@(negedge clock)begin
	if(reset)begin
		CMT_valid 	   <= 1'b0	;
		CMT_pc		   <= 64'h0 ;
		CMT_inst	   <= 32'h0 ;	
		CMT_reg_w_en   <= 1'b0	;	
		CMT_rdest	   <= 5'h0	;	
		CMT_WB_data	   <= 64'h0 ;
		TRAP		   <= 1'b0	;	
		TRAP_code	   <= 8'h0	;	
		cycleCnt	   <= 64'h0 ;	
		instrCnt	   <= 64'h0 ;
		REGS_diff[0]   <= 64'h0 ;
		REGS_diff[1]   <= 64'h0 ;
		REGS_diff[2]   <= 64'h0 ;
		REGS_diff[3]   <= 64'h0 ;
		REGS_diff[4]   <= 64'h0 ;
		REGS_diff[5]   <= 64'h0 ;
		REGS_diff[6]   <= 64'h0 ;
		REGS_diff[7]   <= 64'h0 ;
		REGS_diff[8]   <= 64'h0 ;
		REGS_diff[9]   <= 64'h0 ;
		REGS_diff[10]  <= 64'h0 ;
		REGS_diff[11]  <= 64'h0 ;
		REGS_diff[12]  <= 64'h0 ;
		REGS_diff[13]  <= 64'h0 ;
		REGS_diff[14]  <= 64'h0 ;
		REGS_diff[15]  <= 64'h0 ;
		REGS_diff[16]  <= 64'h0 ;
		REGS_diff[17]  <= 64'h0 ;
		REGS_diff[18]  <= 64'h0 ;
		REGS_diff[19]  <= 64'h0 ;
		REGS_diff[20]  <= 64'h0 ;
		REGS_diff[21]  <= 64'h0 ;
		REGS_diff[22]  <= 64'h0 ;
		REGS_diff[23]  <= 64'h0 ;
		REGS_diff[24]  <= 64'h0 ;
		REGS_diff[25]  <= 64'h0 ;
		REGS_diff[26]  <= 64'h0 ;
		REGS_diff[27]  <= 64'h0 ;
		REGS_diff[28]  <= 64'h0 ;
		REGS_diff[29]  <= 64'h0 ;
		REGS_diff[30]  <= 64'h0 ;
		REGS_diff[31]  <= 64'h0 ;	
	end else if(~TRAP) begin
		CMT_valid 	<= INST_valid			;
		CMT_pc		<= PC7_					;
		CMT_inst	<= Ins6_				;
		CMT_reg_w_en<= reg_w_en5_			;
		CMT_rdest	<= rdest4_				;
		CMT_WB_data	<= WB_data2_			;
		TRAP		<= Ins6_[6:0] == 7'h6b	;
		TRAP_code	<= REGS_diff[10][7:0]	;
		cycleCnt	<= cycleCnt + 1			;
		instrCnt	<= instrCnt + INST_valid;
		REGS_diff[0]   <= reg_file0 		;
		REGS_diff[1]   <= reg_file1 		;
		REGS_diff[2]   <= reg_file2 		;
		REGS_diff[3]   <= reg_file3 		;
		REGS_diff[4]   <= reg_file4 		;
		REGS_diff[5]   <= reg_file5 		;
		REGS_diff[6]   <= reg_file6 		;
		REGS_diff[7]   <= reg_file7 		;
		REGS_diff[8]   <= reg_file8 		;
		REGS_diff[9]   <= reg_file9 		;
		REGS_diff[10]  <= reg_file10		;
		REGS_diff[11]  <= reg_file11		;
		REGS_diff[12]  <= reg_file12		;
		REGS_diff[13]  <= reg_file13		;
		REGS_diff[14]  <= reg_file14		;
		REGS_diff[15]  <= reg_file15		;
		REGS_diff[16]  <= reg_file16		;
		REGS_diff[17]  <= reg_file17		;
		REGS_diff[18]  <= reg_file18		;
		REGS_diff[19]  <= reg_file19		;
		REGS_diff[20]  <= reg_file20		;
		REGS_diff[21]  <= reg_file21		;
		REGS_diff[22]  <= reg_file22		;
		REGS_diff[23]  <= reg_file23		;
		REGS_diff[24]  <= reg_file24		;
		REGS_diff[25]  <= reg_file25		;
		REGS_diff[26]  <= reg_file26		;
		REGS_diff[27]  <= reg_file27		;
		REGS_diff[28]  <= reg_file28		;
		REGS_diff[29]  <= reg_file29		;
		REGS_diff[30]  <= reg_file30		; 
		REGS_diff[31]  <= reg_file31		;
	end
end

DifftestInstrCommit DifftestInstrCommit(
  									.clock              (clock		 ),
  									.coreid             (0			 ),
  									.index              (0			 ),
  									.valid              (CMT_valid	 ),// 是否提交指令
  									.pc                 (CMT_pc		 ),// 当前PC
  									.instr              (CMT_inst 	 ),// 当前指令
  									.skip               (0			 ),// 跳过当前指令的对比
  									.isRVC              (0			 ),// 压缩指令
  									.scFailed           (0			 ),// SC指令执行失败
  									.wen                (CMT_reg_w_en),// 写回
  									.wdest              (CMT_rdest	 ),// 写回寄存器堆索引
  									.wdata              (CMT_WB_data ),// 写回值
  									.special            (0			 ));

DifftestArchIntRegState DifftestArchIntRegState (
  												.clock              (clock		 	),
  												.coreid             (0			 	),
  												.gpr_0              (REGS_diff[0] 	),
  												.gpr_1              (REGS_diff[1] 	),
  												.gpr_2              (REGS_diff[2] 	),
  												.gpr_3              (REGS_diff[3] 	),
  												.gpr_4              (REGS_diff[4] 	),
  												.gpr_5              (REGS_diff[5] 	),
  												.gpr_6              (REGS_diff[6] 	),
  												.gpr_7              (REGS_diff[7] 	),
  												.gpr_8              (REGS_diff[8] 	),
  												.gpr_9              (REGS_diff[9] 	),
  												.gpr_10             (REGS_diff[10]	),
  												.gpr_11             (REGS_diff[11]	),
  												.gpr_12             (REGS_diff[12]	),
  												.gpr_13             (REGS_diff[13]	),
  												.gpr_14             (REGS_diff[14]	),
  												.gpr_15             (REGS_diff[15]	),
  												.gpr_16             (REGS_diff[16]	),
  												.gpr_17             (REGS_diff[17]	),
  												.gpr_18             (REGS_diff[18]	),
  												.gpr_19             (REGS_diff[19]	),
  												.gpr_20             (REGS_diff[20]	),
  												.gpr_21             (REGS_diff[21]	),
  												.gpr_22             (REGS_diff[22]	),
  												.gpr_23             (REGS_diff[23]	),
  												.gpr_24             (REGS_diff[24]	),
  												.gpr_25             (REGS_diff[25]	),
  												.gpr_26             (REGS_diff[26]	),
  												.gpr_27             (REGS_diff[27]	),
  												.gpr_28             (REGS_diff[28]	),
  												.gpr_29             (REGS_diff[29]	),
  												.gpr_30             (REGS_diff[30]	),
  												.gpr_31             (REGS_diff[31]	));

DifftestTrapEvent DifftestTrapEvent(
  									.clock   (clock		),
  									.coreid  (0			),
  									.valid   (TRAP		),
  									.code    (TRAP_code	),
  									.pc      (CMT_pc	),
  									.cycleCnt(cycleCnt	),
  									.instrCnt(instrCnt	));

DifftestCSRState DifftestCSRState(
  								.clock              (clock				),
  								.coreid             (0					),
  								.priviledgeMode     (`RISCV_PRIV_MODE_M	),
  								.mstatus            (0					),
  								.sstatus            (0					),
  								.mepc               (0					),
  								.sepc               (0					),
  								.mtval              (0					),
  								.stval              (0					),
  								.mtvec              (0					),
  								.stvec              (0					),
  								.mcause             (0					),
  								.scause             (0					),
  								.satp               (0					),
  								.mip                (0					),
  								.mie                (0					),
  								.mscratch           (0					),
  								.sscratch           (0					),
  								.mideleg            (0					),
  								.medeleg            (0					));

DifftestArchFpRegState DifftestArchFpRegState(
  											.clock              (clock	),
  											.coreid             (0		),
  											.fpr_0              (0		),
  											.fpr_1              (0		),
  											.fpr_2              (0		),
  											.fpr_3              (0		),
  											.fpr_4              (0		),
  											.fpr_5              (0		),
  											.fpr_6              (0		),
  											.fpr_7              (0		),
  											.fpr_8              (0		),
  											.fpr_9              (0		),
  											.fpr_10             (0		),
  											.fpr_11             (0		),
  											.fpr_12             (0		),
  											.fpr_13             (0		),
  											.fpr_14             (0		),
  											.fpr_15             (0		),
  											.fpr_16             (0		),
  											.fpr_17             (0		),
  											.fpr_18             (0		),
  											.fpr_19             (0		),
  											.fpr_20             (0		),
  											.fpr_21             (0		),
  											.fpr_22             (0		),
  											.fpr_23             (0		),
  											.fpr_24             (0		),
  											.fpr_25             (0		),
  											.fpr_26             (0		),
  											.fpr_27             (0		),
  											.fpr_28             (0		),
  											.fpr_29             (0		),
  											.fpr_30             (0		),
  											.fpr_31             (0		));

endmodule