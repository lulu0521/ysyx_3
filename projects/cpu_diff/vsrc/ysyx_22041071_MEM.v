`include "define.v"
module ysyx_22041071_MEM(
						input  wire							  clk		  ,
						input  wire							  reset		  ,
						input  wire [`ysyx_22041071_ADDR_BUS] PC5	      ,
                        input  wire [`ysyx_22041071_INS_BUS ] Ins4	      ,
						input  wire 						  MEM_W_en3   ,
						input  wire							  WB_sel3     ,//0-result;1-MEM_data
						input  wire 						  reg_w_en3   ,
						input  wire [`ysyx_22041071_DATA_BUS] rt_data2    ,
						input  wire [ 4:0 ]					  rdest2	  ,
						input  wire [`ysyx_22041071_DATA_BUS] ALU_result1 ,
						input  wire						 	  valid5	  ,
						input  wire						 	  ready6	  ,
						output reg							  ready5	  ,
						output reg							  valid6	  ,
						output reg  [`ysyx_22041071_ADDR_BUS] PC6		  ,
						output reg  [`ysyx_22041071_INS_BUS ] Ins5	      ,
						output reg  						  reg_w_en4   ,
						output reg  [ 4:0 ]					  rdest3	  ,
						output reg  [`ysyx_22041071_DATA_BUS] WB_data1	  ,
						output reg  						  reg_w_en4_  ,
						output reg  [ 4:0 ]					  rdest3_	  ,
						output reg  [`ysyx_22041071_DATA_BUS] WB_data1_	  );
	
RAMHelper IRAMHelper(.clk   (clk									),
  					 .en    (WB_sel3								),
  					 .rIdx  ({3'b000,{ALU_result1-64'h8000_0000}>>3}),
  					 .rdata (MEM_data								),
  					 .wIdx  ({3'b000,{ALU_result1-64'h8000_0000}>>3}), //write addr
  					 .wdata (rt_data2								), //write data
  					 .wmask (0										), //mask
  					 .wen   (MEM_W_en3								));//write enable

	reg [`ysyx_22041071_DATA_BUS] MEM_data	;
	reg							  valid		;
	reg							  handshake	;
	
	assign reg_w_en4_ = reg_w_en3;
	assign rdest3_	  = rdest2	 ;
	
	always@(*)begin
		ready5	  = ready6			;
		handshake = valid5 & ready6	;

		if(WB_sel3)begin
			WB_data1_ = MEM_data;
		end else begin 
			WB_data1_ = ALU_result1;
		end
	end
	
	always@(posedge clk)begin
		if(reset)begin
			PC6			 <= PC5	 ;
			Ins5		 <= 32'h0;	
			valid6		 <= 1'b0 ;
			reg_w_en4    <= 1'd0 ;
			rdest3	     <= 5'd0 ; 
			WB_data1	 <= 64'd0;
		end else begin
			if(handshake)begin
				PC6			 <= PC5			;
				Ins5		 <= Ins4		;
				valid6		 <= valid5		;
				reg_w_en4    <= reg_w_en3	;
				rdest3	     <= rdest2		;
				WB_data1	 <= WB_data1_	;
			end
		end
	end
endmodule
