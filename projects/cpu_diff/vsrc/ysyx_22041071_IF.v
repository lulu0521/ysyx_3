`include "define.v"
module ysyx_22041071_IF(input  wire 						  clk	  	,
						input  wire							  reset	  	,
						input  wire [`ysyx_22041071_ADDR_BUS] PC1	  	,
						input  wire							  bubble21	,
						input  wire							  bubble22	,
						input  wire							  bubble23	,
						input  wire							  valid1	,
						input  wire							  ready2	,
						output reg							  ready1	,
						output reg							  valid2	,
						output reg  [`ysyx_22041071_ADDR_BUS] PC2		,
						output reg  [`ysyx_22041071_INS_BUS ] Ins		,
						output reg  [`ysyx_22041071_ADDR_BUS] SNPC		);
	

RAMHelper IRAMHelper(.clk   (clk					),
  					 .en    (1						),
  					 .rIdx  ((PC1 - `START_ADDR-4) >> 3),
  					 .rdata (INS_					),
  					 .wIdx  (0						),
  					 .wdata (0						),
  					 .wmask (0						),
  					 .wen   (0						));

	reg [`ysyx_22041071_INS_BUS ] INS_;			 
	reg handshake;
	
	always@(*)begin
		ready1	  = ready2			;
		handshake = valid1 & ready2	;
		SNPC   	  = PC1 + 64'h4		;
	end
	
	always@(posedge clk)begin
		if(reset)begin
			valid2 <= 1'b0		 	;
		end else begin
			if(bubble21==1'b1 || bubble22==1'b1 || bubble23==1'b1)begin
				valid2 <= 1'b1		 ;
				PC2	   <= PC1		 ;
				Ins	   <= 32'b0		 ;
			end else begin
				if(handshake)begin
					valid2 <= valid1	;
					PC2	   <= PC1		;
					Ins	   <= INS_		;
				end
			end
		end
	end

endmodule
