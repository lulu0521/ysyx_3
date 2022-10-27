`include "define.v"
module ysyx_22041071_AXI_ARBI(
				input 												  cpu_ar_ready		,
				input 												  cpu_aw_ready		,
				input												  MEM_W_en3			,
				input												  WB_sel2			,
				input 												  WB_sel3			,
				input												  cpu_r_valid		,
				input		[`ysyx_22041071_AXI_DATA_WIDTH-1:0		] cpu_r_data 		,
				input		[`ysyx_22041071_ADDR_BUS				] cpu_r_addr		,
				input		[`ysyx_22041071_AXI_RESP_TYPE_WIDTH-1:0	] cpu_r_resp	 	,
				input 												  cpu_if_ar_valid 	,
				input 		[`ysyx_22041071_ADDR_BUS		 		] cpu_if_ar_addr  	, 
				input 		[`ysyx_22041071_AXI_LEN_WIDTH-1:0 		] cpu_if_ar_len   	,
				input 		[1:0	  						 		] cpu_if_ar_size  	, 	
				input												  cpu_mem_ar_valid	,	
				input 		[`ysyx_22041071_ADDR_BUS		  		] cpu_mem_ar_addr	,
				input 		[`ysyx_22041071_AXI_LEN_WIDTH-1:0		] cpu_mem_ar_len	,
				input 		[1:0	  						  		] cpu_mem_ar_size	,
				output reg											  cpu_ar_valid		,
				output reg  [`ysyx_22041071_ADDR_BUS				] cpu_ar_addr	 	,
				output reg	[`ysyx_22041071_AXI_LEN_WIDTH-1:0		] cpu_ar_len		,
				output reg  [1:0	  								] cpu_ar_size	 	,
				output reg											  cpu_if_ar_ready	,
				output reg											  cpu_if_r_valid	,
				output reg	[`ysyx_22041071_DATA_BUS			   	] cpu_if_r_data 	,
				output reg	[`ysyx_22041071_ADDR_BUS			   	] cpu_if_r_addr 	,
				output reg	[`ysyx_22041071_AXI_RESP_TYPE_WIDTH-1:0	] cpu_if_r_resp		,
				output reg											  cpu_mem_ar_ready	,
				output reg											  cpu_mem_r_valid	,
				output reg	[`ysyx_22041071_DATA_BUS				] cpu_mem_r_data 	,
				output reg	[`ysyx_22041071_ADDR_BUS				] cpu_mem_r_addr 	,
				output reg	[`ysyx_22041071_AXI_RESP_TYPE_WIDTH-1:0 ] cpu_mem_r_resp	);		
	//reg where;//0-if,1-mem
	always@(*)begin
		if(WB_sel2 || WB_sel3)begin
			if(cpu_mem_r_valid)begin
				cpu_mem_ar_ready= 1'b1			;
				cpu_if_ar_ready = cpu_ar_ready	;
			end else begin
				cpu_mem_ar_ready= cpu_ar_ready	;
				cpu_if_ar_ready = 1'b0			;
			end
			end else begin
				cpu_mem_ar_ready = 1'b0			;
				cpu_if_ar_ready = cpu_ar_ready	;
			end
	end

	always@(*)begin
		if(WB_sel2)begin
			cpu_ar_valid 	= cpu_mem_ar_valid	;
		end else begin
			cpu_ar_valid 	= cpu_if_ar_valid	;
		end
	end

	/*always@(*)begin
		if(WB_sel3)begin
			cpu_mem_ar_ready = cpu_ar_ready	;
		end else begin
			cpu_mem_ar_ready = 1'b0			;
		end
	end*/

	always@(*)begin//output AXI
		if(WB_sel3)begin
			cpu_ar_addr	 = cpu_mem_ar_addr	;
			cpu_ar_len	 = cpu_mem_ar_len	;
			cpu_ar_size	 = cpu_mem_ar_size	;
		end else begin
			cpu_ar_addr	 = cpu_if_ar_addr ;
			cpu_ar_len	 = cpu_if_ar_len  ;
			cpu_ar_size	 = cpu_if_ar_size ;
		end
	end

	always@(*)begin //output WB
		if(WB_sel3)begin
			cpu_if_r_valid  = 1'b0			;
    	    cpu_if_r_data   = 64'h0			;
    	    cpu_if_r_addr   = 64'h0 		;
			cpu_if_r_resp   = 2'b00		 	;
			cpu_mem_r_valid = cpu_r_valid	;
    	    cpu_mem_r_data  = cpu_r_data	;
    	    cpu_mem_r_addr  = cpu_r_addr 	;
			cpu_mem_r_resp	= cpu_r_resp 	;
		end else begin
			cpu_if_r_valid  = cpu_r_valid	;
    	    cpu_if_r_data   = cpu_r_data 	;
    	    cpu_if_r_addr   = cpu_r_addr 	;
			cpu_if_r_resp   = cpu_r_resp 	;
			cpu_mem_r_valid = 1'b0			;
			cpu_mem_r_data  = 64'h0			;
			cpu_mem_r_addr  = 64'h0 		;
			cpu_mem_r_resp	= 2'b00		 	;
		end
	end
endmodule
