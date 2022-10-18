`include "define.v"
module ysyx_22041071_AXI_RW(
			input													  clk				,
			input													  reset_n			,
			input											  		  cpu_ar_valid		,
			input  		[`ysyx_22041071_ADDR_BUS					] cpu_addr	 		,
			input		[`ysyx_22041071_AXI_LEN_WIDTH-1:0			] cpu_len			,
			input  		[1:0	  									] cpu_size	 		,//00:1BYTE;01:2BYTE;10:4BYTE;11:8BYTE
			input											  		  cpu_aw_valid		,
			input		[`ysyx_22041071_DATA_BUS					] cpu_data			,
			output reg 							  				  	  cpu_ar_ready		,
			output reg 												  cpu_r_valid		,
			output reg 	[`ysyx_22041071_AXI_DATA_WIDTH-1:0			] cpu_r_data 		,
			output reg 	[`ysyx_22041071_AXI_RESP_TYPE_WIDTH-1:0		] cpu_resp	 		,
			output reg 							  				  	  cpu_aw_ready		,
			input  												  	  axi_ar_ready_i	,//AR
			output reg 												  axi_ar_valid_o	,
			output reg 	[`ysyx_22041071_AXI_ID_WIDTH-1:0			] axi_ar_id_o		,
			output reg 	[`ysyx_22041071_AXI_ADDR_WIDTH-1:0			] axi_ar_addr_o		,
			output reg 	[`ysyx_22041071_AXI_LEN_WIDTH-1:0			] axi_ar_len_o		,
			output reg 	[`ysyx_22041071_AXI_SIXE_WIDTH-1:0			] axi_ar_size_o		,
			output reg 	[`ysyx_22041071_AXI_BURST_TYPE_WIDTH-1:0	] axi_ar_burst_o	,
			output reg 	[`ysyx_22041071_AXI_PROT_WIDTH-1:0			] axi_ar_prot_o		,
			output reg 	[`ysyx_22041071_AXI_USER_WIDTH-1:0			] axi_ar_user_o		,
			output reg 												  axi_ar_lock_o		,
			output reg 	[`ysyx_22041071_AXI_AXCACHE_WIDTH-1:0		] axi_ar_cache_o	,
			output reg 	[`ysyx_22041071_AXI_QOS_WIDTH-1:0			] axi_ar_qos_o		,
			output reg 	[`ysyx_22041071_AXI_REGION_WIDTH-1:0		] axi_ar_region_o	,
			output reg                            				  	  axi_r_ready_o		,//R
			input                             				  		  axi_r_valid_i		,
			input  		[`ysyx_22041071_AXI_RESP_TYPE_WIDTH-1:0  	] axi_r_resp_i		,
			input  		[`ysyx_22041071_AXI_DATA_WIDTH-1:0			] axi_r_data_i		,
			input  		                           				  	  axi_r_last_i		,
			input  		[`ysyx_22041071_AXI_ID_WIDTH-1:0			] axi_r_id_i		,
			input  		[`ysyx_22041071_AXI_USER_WIDTH-1:0			] axi_r_user_i		,
			input  												  	  axi_aw_ready_i	,//AW
			output reg 												  axi_aw_valid_o	,
			output reg 	[`ysyx_22041071_AXI_ID_WIDTH-1:0			] axi_aw_id_o		,
			output reg 	[`ysyx_22041071_AXI_ADDR_WIDTH-1:0			] axi_aw_addr_o		,
			output reg 	[`ysyx_22041071_AXI_LEN_WIDTH-1:0			] axi_aw_len_o		,
			output reg 	[`ysyx_22041071_AXI_SIXE_WIDTH-1:0			] axi_aw_size_o		,
			output reg 	[`ysyx_22041071_AXI_BURST_TYPE_WIDTH-1:0	] axi_aw_burst_o	,
			output reg 	[`ysyx_22041071_AXI_PROT_WIDTH-1:0			] axi_aw_prot_o		,
			output reg 	[`ysyx_22041071_AXI_USER_WIDTH-1:0			] axi_aw_user_o		,
			output reg 												  axi_aw_lock_o		,
			output reg 	[`ysyx_22041071_AXI_AXCACHE_WIDTH-1:0		] axi_aw_cache_o	,
			output reg 	[`ysyx_22041071_AXI_QOS_WIDTH-1:0			] axi_aw_qos_o		,
			output reg 	[`ysyx_22041071_AXI_REGION_WIDTH-1:0		] axi_aw_region_o	,
			output reg  [`ysyx_22041071_AXI_ID_WIDTH-1:0			] axi_w_id_o		,//W
			output reg  [`ysyx_22041071_AXI_DATA_WIDTH-1:0			] axi_w_data_o		,
			output reg  [`ysyx_22041071_AXI_WSTRB_WIDTH-1:0			] axi_w_wstrb_o		,
			output reg												  axi_w_last_o		,
			output reg 	[`ysyx_22041071_AXI_USER_WIDTH-1:0			] axi_w_user_o		,
			output reg                            				  	  axi_w_valid_o		,
			input                             				  		  axi_w_ready_i		,
			input 		[`ysyx_22041071_AXI_ID_WIDTH-1:0			] axi_bw_id_i		,//BW
			input  		[`ysyx_22041071_AXI_RESP_TYPE_WIDTH-1:0  	] axi_bw_resp_i		,
			input  		[`ysyx_22041071_AXI_USER_WIDTH-1:0			] axi_bw_user_i		,	
			input		                           				  	  axi_bw_valid_i	,
			output reg												  axi_bw_ready_o	);

	

	

	ysyx_22041071_axi_r my_axi_r(
			.clk	 			(clk								),
			.reset_n			(reset_n							),
			.cpu_ar_valid		(cpu_ar_valid						),
			.cpu_id	 			({`ysyx_22041071_AXI_ID_WIDTH{1'b0}}),
			.cpu_addr	 		(cpu_addr	 						),
			.cpu_len			(cpu_len							),
			.cpu_size	 		(cpu_size	 						),//00:1BYTE;01:2BYTE;10:4BYTE;11:8BYTE
			.cpu_ar_ready		(cpu_ar_ready						),
			.cpu_r_valid		(cpu_r_valid						),
			.cpu_r_data 		(cpu_r_data 						),
			.cpu_r_resp	 		(cpu_resp							),
			.axi_ar_ready_i		(axi_ar_ready_i						),//AR
			.axi_ar_valid_o		(axi_ar_valid_o						),
			.axi_ar_id_o		(axi_ar_id_o						),
			.axi_ar_addr_o		(axi_ar_addr_o						),
			.axi_ar_len_o		(axi_ar_len_o						),
			.axi_ar_size_o		(axi_ar_size_o						),
			.axi_ar_burst_o		(axi_ar_burst_o						),
			.axi_ar_prot_o		(axi_ar_prot_o						),
			.axi_ar_user_o		(axi_ar_user_o						),
			.axi_ar_lock_o		(axi_ar_lock_o						),
			.axi_ar_cache_o		(axi_ar_cache_o						),
			.axi_ar_qos_o		(axi_ar_qos_o						),
			.axi_ar_region_o	(axi_ar_region_o					),
			.axi_r_ready_o		(axi_r_ready_o						),//R
			.axi_r_valid_i		(axi_r_valid_i						),
			.axi_r_resp_i		(axi_r_resp_i						),
			.axi_r_data_i		(axi_r_data_i						),
			.axi_r_last_i		(axi_r_last_i						),
			.axi_r_id_i			(axi_r_id_i							),
			.axi_r_user_i		(axi_r_user_i						));
			
	ysyx_22041071_axi_w my_axi_w(
			.clk	 			(clk								),
			.reset_n			(reset_n							),
			.cpu_aw_valid		(cpu_aw_valid						),
			.cpu_id	 			({`ysyx_22041071_AXI_ID_WIDTH{1'b0}}),
			.cpu_addr	 		(cpu_addr							),
			.cpu_data			(cpu_data							),
			.cpu_len			(cpu_len							),
			.cpu_size	 		(cpu_size	 						),//00:1BYTE;01:2BYTE;10:4BYTE;11:8BYTE
			.cpu_aw_ready		(cpu_aw_ready						),
			.cpu_w_resp	 		(cpu_resp							),
			.axi_aw_ready_i		(axi_aw_ready_i						),//AW
			.axi_aw_valid_o		(axi_aw_valid_o						),
			.axi_aw_id_o		(axi_aw_id_o						),
			.axi_aw_addr_o		(axi_aw_addr_o						),
			.axi_aw_len_o		(axi_aw_len_o						),
			.axi_aw_size_o		(axi_aw_size_o						),
			.axi_aw_burst_o		(axi_aw_burst_o						),
			.axi_aw_prot_o		(axi_aw_prot_o						),
			.axi_aw_user_o		(axi_aw_user_o						),
			.axi_aw_lock_o		(axi_aw_lock_o						),
			.axi_aw_cache_o		(axi_aw_cache_o						),
			.axi_aw_qos_o		(axi_aw_qos_o						),
			.axi_aw_region_o	(axi_aw_region_o					),
			.axi_w_id_o			(axi_w_id_o							),//W
			.axi_w_data_o		(axi_w_data_o						),
			.axi_w_wstrb_o		(axi_w_wstrb_o						),
			.axi_w_last_o		(axi_w_last_o						),
			.axi_w_user_o		(axi_w_user_o						),
			.axi_w_valid_o		(axi_w_valid_o						),
			.axi_w_ready_i		(axi_w_ready_i						),
			.axi_bw_id_i		(axi_bw_id_i						),//BW
			.axi_bw_resp_i		(axi_bw_resp_i						),
			.axi_bw_user_i		(axi_bw_user_i						),	
			.axi_bw_valid_i		(axi_bw_valid_i						),
			.axi_bw_ready_o		(axi_bw_ready_o						));
endmodule
