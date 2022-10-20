`include "define.v"
module ysyx_22041071_IF(input  wire 						  clk	  	,
						input  wire							  reset	  	,
						input  wire [`ysyx_22041071_ADDR_BUS] PC1	  	,
						input  wire							  Brch_sel1 ,
						input  wire [`ysyx_22041071_ADDR_BUS] PC4		,
						input  wire							  bubble21	,
						input  wire							  bubble22	,
						input  wire							  bubble23	,
						input  wire [`ysyx_22041071_ADDR_BUS] PC3		,
						input  wire							  bubble4	,
						input  wire							  valid1	,
						input  wire							  ready2	,
						output reg							  ready1	,
						output reg							  valid2	,
						output reg  [`ysyx_22041071_ADDR_BUS] PC2		,
						output reg  [`ysyx_22041071_INS_BUS ] Ins		,
						output reg  [`ysyx_22041071_ADDR_BUS] SNPC		);
	

RAMHelper IRAMHelper(.clk   (clk						),
  					 .en    (1							),
  					 .rIdx  ((PC1 - `START_ADDR-4) >> 3	),
  					 .rdata (Ins_						),
  					 .wIdx  (0							),
  					 .wdata (0							),
  					 .wmask (0							),
  					 .wen   (0							));

	reg [64:0					] Ins_	;
	reg [`ysyx_22041071_INS_BUS ] Ins_32;			 
	reg handshake;
	
	always@(*)begin
		ready1	  = ready2			;
		handshake = valid1 & ready2	;
		
		if(bubble23==1'b1 && Brch_sel1==0)begin
			SNPC = PC4 + 64'h4;
		end else if(bubble4==1'b1) begin
			SNPC = PC3 + 64'd12;
		end else begin
			SNPC = PC1 + 64'h4;
		end

		if(PC1[2])begin
			Ins_32 = Ins_[63:32];
		end else begin
			Ins_32 = Ins_[31:0 ];
		end
	end
	
	always@(posedge clk)begin
		if(reset)begin
			valid2 <= 1'b0	;
			Ins	   <= 32'b0 ;
		end else begin
			if(handshake)begin
				if(bubble21==1'b1 || bubble22==1'b1 || bubble23==1'b1)begin
					valid2 <= 1'b1		 ;
					PC2	   <= PC1		 ;
					Ins	   <= 32'b0		 ;
				end else begin
					valid2 <= valid1	;
					PC2	   <= PC1		;
					Ins	   <= Ins_32	;
				end
			end
		end
	end

endmodule
