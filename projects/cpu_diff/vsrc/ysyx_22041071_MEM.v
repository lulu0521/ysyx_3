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
			if(Ins4[6:0]==7'b000_0011)begin
				case(Ins4[14:12])
					3'b000://lb
						case(ALU_result1[2:0])
							3'b000:WB_data1_ = {{56{MEM_data[7 ]}} ,MEM_data[7 :0 ]};
							3'b001:WB_data1_ = {{56{MEM_data[15]}} ,MEM_data[15:8 ]};
							3'b010:WB_data1_ = {{56{MEM_data[23]}} ,MEM_data[23:16]};
							3'b011:WB_data1_ = {{56{MEM_data[31]}} ,MEM_data[31:24]};
							3'b100:WB_data1_ = {{56{MEM_data[39]}} ,MEM_data[39:32]};
							3'b101:WB_data1_ = {{56{MEM_data[47]}} ,MEM_data[47:40]};
							3'b110:WB_data1_ = {{56{MEM_data[55]}} ,MEM_data[55:48]};
							3'b111:WB_data1_ = {{56{MEM_data[63]}} ,MEM_data[63:56]};
						endcase
					3'b001://lh
						case(ALU_result1[2:0])
							3'b000:WB_data1_ = {{48{MEM_data[15]}} ,MEM_data[15:0 ]};
							//3'b001:WB_data1_ = {{48{MEM_data[23]}} ,MEM_data[23:8 ]};
							3'b010:WB_data1_ = {{48{MEM_data[31]}} ,MEM_data[31:16]};
							//3'b011:WB_data1_ = {{48{MEM_data[39]}} ,MEM_data[39:24]};
							3'b100:WB_data1_ = {{48{MEM_data[47]}} ,MEM_data[47:32]};
							//3'b101:WB_data1_ = {{48{MEM_data[55]}} ,MEM_data[55:40]};
							3'b110:WB_data1_ = {{48{MEM_data[63]}} ,MEM_data[63:48]};
							//3'b111:WB_data1_ = 64'h0								;
							default:WB_data1_ = 64'h0;
						endcase
					3'b010:WB_data1_ = {{32{MEM_data[31]}},MEM_data[31:0]};//lw
					3'b011:WB_data1_ = MEM_data							  ;//ld
					3'b100:
						case(ALU_result1[2:0])
							3'b000:WB_data1_ = {56'h0,MEM_data[7 :0 ]};
							3'b001:WB_data1_ = {56'h0,MEM_data[15:8 ]};
							3'b010:WB_data1_ = {56'h0,MEM_data[23:16]};
							3'b011:WB_data1_ = {56'h0,MEM_data[31:24]};
							3'b100:WB_data1_ = {56'h0,MEM_data[39:32]};
							3'b101:WB_data1_ = {56'h0,MEM_data[47:40]};
							3'b110:WB_data1_ = {56'h0,MEM_data[55:48]};
							3'b111:WB_data1_ = {56'h0,MEM_data[63:56]};
						endcase
					3'b101:WB_data1_ = {48'h0			  ,MEM_data[15:0]};//lhu
					3'b110:WB_data1_ = {32'h0			  ,MEM_data[31:0]};//lwu
					default:WB_data1_ = 64'h0							  ;
				endcase
			end else begin
				WB_data1_ = 64'h0							  ;
			end	
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
