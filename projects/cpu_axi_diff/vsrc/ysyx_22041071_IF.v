`include "define.v"
module ysyx_22041071_IF(input  wire 											  clk	  		,
						input  wire												  reset	  		,
						input  wire [`ysyx_22041071_ADDR_BUS					] PC1	  		,
						input  wire [`ysyx_22041071_ADDR_BUS					] JPC 			,
						input  wire [`ysyx_22041071_ADDR_BUS					] JRPC			,
						input  wire [`ysyx_22041071_ADDR_BUS					] BPC			,
						input  wire												  bubble21		,
						input  wire												  bubble31		,
						input  wire												  bubble41		,
						input  wire [`ysyx_22041071_ADDR_BUS					] PC3			,
						input  wire												  bubble4		,
						input  wire												  valid1		,
						input  wire												  ready2		,
						//input 													  cpu_ar_ready	,//AXI_S
						input													  cpu_r_valid	,
						input 		[`ysyx_22041071_AXI_DATA_WIDTH-1:0			] cpu_r_data 	,
						input		[`ysyx_22041071_ADDR_BUS					] cpu_r_addr	,
						input 		[`ysyx_22041071_AXI_RESP_TYPE_WIDTH-1:0		] cpu_resp	 	,//axi_E
						//output reg												  ready1		,
						output reg												  valid2		,
						output reg  [`ysyx_22041071_ADDR_BUS					] PC2			,
						output reg  [`ysyx_22041071_INS_BUS 					] Ins			,
						output reg  [`ysyx_22041071_ADDR_BUS					] SNPC			,
						output reg												  JPC_sel_s  	,	
						output reg												  JRPC_sel_s 	,	
						output reg												  Brch_sel_s 	,	
						output reg  [`ysyx_22041071_ADDR_BUS					] JPC_s			,
						output reg  [`ysyx_22041071_ADDR_BUS					] JRPC_s		,	
						output reg  [`ysyx_22041071_ADDR_BUS					] BPC_s			);
	

/*RAMHelper IRAMHelper(.clk   (clk						),
  					 .en    (1							),
  					 .rIdx  ((PC1 - `START_ADDR-4) >> 3	),
  					 .rdata (Ins_						),
  					 .wIdx  (0							),
  					 .wdata (0							),
  					 .wmask (0							),
  					 .wen   (0							));*/
	
	
	reg [63:0					] Ins_	;
	reg [`ysyx_22041071_INS_BUS ] Ins_32;
	reg handshake1;		
	reg invalid;
	//reg bubble1;	 
	//reg handshake2;
	
	always@(*)begin
		//ready1	   = cpu_ar_ready & ready2		;
		handshake1 = valid1 & ready2;
		//handshake2 = cpu_r_valid  & ready2  	;
	end
	always@(*)begin	
		//if(bubble23==1'b1 && Brch_sel1==0)begin
			//SNPC = PC4 + 64'h4;
		if(bubble4==1'b1) begin
			SNPC = PC3 + 64'd12;
		end else begin
			SNPC = PC1 + 64'h4;
		end
	end
	always@(*)begin	
			Ins_ = cpu_r_data;
		if(cpu_r_addr[2])begin
			Ins_32 = Ins_[63:32];
		end else begin
			Ins_32 = Ins_[31:0 ];
		end
	end
//save all jump parameter	
	always@(posedge clk)begin
		if(cpu_r_valid)begin
			invalid    	<= 1'b0	;
			JPC_sel_s  	<= 1'b0	;
			JRPC_sel_s 	<= 1'b0	;
			Brch_sel_s 	<= 1'b0	; 
			JPC_s		<= 64'h0;
			JRPC_s		<= 64'h0;
			BPC_s		<= 64'h0;
		end else begin
			if(bubble21 || bubble31 || bubble41)begin
				case({bubble41,bubble31,bubble21})
					3'b001:begin
						invalid		<= 1'b1	;
						JPC_sel_s  	<= 1'b1	;
						JRPC_sel_s 	<= 1'b0	;
						Brch_sel_s 	<= 1'b0	; 
						JPC_s		<= JPC	;
						JRPC_s		<= 64'h0;
						BPC_s		<= 64'h0;
					end
					3'b010:begin
						invalid <= 1'b1;
						JPC_sel_s  	<= 1'b0	;
						JRPC_sel_s 	<= 1'b1	;
						Brch_sel_s 	<= 1'b0	; 
						JPC_s		<= 64'h0;
						JRPC_s		<= JRPC;
						BPC_s		<= 64'h0;
					end
					3'b100:begin
						invalid 	<= 1'b1;
						JPC_sel_s  	<= 1'b0	;
						JRPC_sel_s 	<= 1'b0	;
						Brch_sel_s 	<= 1'b1	; 
						JPC_s		<= 64'h0;
						JRPC_s		<= 64'h0;
						BPC_s		<= BPC	;
					end
					default:begin
						invalid <= 1'b0;
						JPC_sel_s  	<= 1'b0	;
						JRPC_sel_s 	<= 1'b0	;
						Brch_sel_s 	<= 1'b0	; 
						JPC_s		<= 64'h0;
						JRPC_s		<= 64'h0;
						BPC_s		<= 64'h0;
					end
				endcase		
			end
		end
	end

	always@(posedge clk)begin
		if(reset)begin
			valid2 <= 1'b0	;
			Ins	   <= 32'b0 ;
		end else begin
			if(handshake1)begin
				if(invalid==0)begin
					if(bubble21==1'b1 || bubble31==1'b1 ||bubble41)begin
						valid2 <= 1'b1		 	;
						PC2	   <= cpu_r_addr	;
						Ins	   <= 32'b0		 	;
					end else begin
						if(cpu_r_valid)begin
							valid2 <= cpu_r_valid	;
							PC2	   <= cpu_r_addr	;
							Ins	   <= Ins_32		;
						end else begin
							valid2 <= valid1		;
							PC2	   <= cpu_r_addr	;
							Ins	   <= 32'h0			;
						end
					end
				end else begin
					valid2 <= valid1		;
					PC2	   <= cpu_r_addr	;
					Ins	   <= 32'h0			;
				end
				
			end
		end
	end
endmodule
