`include "define.v"

`define AXI_TOP_INTERFACE(name) io_memAXI_0_``name

module SimTop(
    input                               clock                            ,
    input                               reset                            ,
    input  [63:0]                       io_logCtrl_log_begin             ,
    input  [63:0]                       io_logCtrl_log_end               ,
    input  [63:0]                       io_logCtrl_log_level             ,
    input                               io_perfInfo_clean                ,
    input                               io_perfInfo_dump                 ,
    output                              io_uart_out_valid                ,
    output [7:0]                        io_uart_out_ch                   ,
    output                              io_uart_in_valid                 ,
    input  [7:0]                        io_uart_in_ch                    ,
    input                               `AXI_TOP_INTERFACE(aw_ready     ),
    output                              `AXI_TOP_INTERFACE(aw_valid     ),
    output [`AXI_ADDR_WIDTH-1:0]        `AXI_TOP_INTERFACE(aw_bits_addr ),
    output [2:0]                        `AXI_TOP_INTERFACE(aw_bits_prot ),
    output [`AXI_ID_WIDTH-1:0]          `AXI_TOP_INTERFACE(aw_bits_id   ),
    output [`AXI_USER_WIDTH-1:0]        `AXI_TOP_INTERFACE(aw_bits_user ),
    output [7:0]                        `AXI_TOP_INTERFACE(aw_bits_len  ),
    output [2:0]                        `AXI_TOP_INTERFACE(aw_bits_size ),
    output [1:0]                        `AXI_TOP_INTERFACE(aw_bits_burst),
    output                              `AXI_TOP_INTERFACE(aw_bits_lock ),
    output [3:0]                        `AXI_TOP_INTERFACE(aw_bits_cache),
    output [3:0]                        `AXI_TOP_INTERFACE(aw_bits_qos  ),  
    input                               `AXI_TOP_INTERFACE(w_ready      ),
    output                              `AXI_TOP_INTERFACE(w_valid      ),
    output [`AXI_DATA_WIDTH-1:0]        `AXI_TOP_INTERFACE(w_bits_data  )[3:0],
    output [`AXI_DATA_WIDTH/8-1:0]      `AXI_TOP_INTERFACE(w_bits_strb  ),
    output                              `AXI_TOP_INTERFACE(w_bits_last  ),
    output                              `AXI_TOP_INTERFACE(b_ready      ),
    input                               `AXI_TOP_INTERFACE(b_valid      ),
    input  [1:0]                        `AXI_TOP_INTERFACE(b_bits_resp  ),
    input  [`AXI_ID_WIDTH-1:0]          `AXI_TOP_INTERFACE(b_bits_id    ),
    input  [`AXI_USER_WIDTH-1:0]        `AXI_TOP_INTERFACE(b_bits_user  ),
    input                               `AXI_TOP_INTERFACE(ar_ready     ),
    output                              `AXI_TOP_INTERFACE(ar_valid     ),
    output [`AXI_ADDR_WIDTH-1:0]        `AXI_TOP_INTERFACE(ar_bits_addr ),
    output [2:0]                        `AXI_TOP_INTERFACE(ar_bits_prot ),
    output [`AXI_ID_WIDTH-1:0]          `AXI_TOP_INTERFACE(ar_bits_id   ),
    output [`AXI_USER_WIDTH-1:0]        `AXI_TOP_INTERFACE(ar_bits_user ),
    output [7:0]                        `AXI_TOP_INTERFACE(ar_bits_len  ),
    output [2:0]                        `AXI_TOP_INTERFACE(ar_bits_size ),
    output [1:0]                        `AXI_TOP_INTERFACE(ar_bits_burst),
    output                              `AXI_TOP_INTERFACE(ar_bits_lock ),
    output [3:0]                        `AXI_TOP_INTERFACE(ar_bits_cache),
    output [3:0]                        `AXI_TOP_INTERFACE(ar_bits_qos  ), 
    output                              `AXI_TOP_INTERFACE(r_ready      ),
    input                               `AXI_TOP_INTERFACE(r_valid      ),
    input  [1:0]                        `AXI_TOP_INTERFACE(r_bits_resp  ),
    input  [`AXI_DATA_WIDTH-1:0]        `AXI_TOP_INTERFACE(r_bits_data  )[3:0],
    input                               `AXI_TOP_INTERFACE(r_bits_last  ),
    input  [`AXI_ID_WIDTH-1:0]          `AXI_TOP_INTERFACE(r_bits_id    ),
    input  [`AXI_USER_WIDTH-1:0]        `AXI_TOP_INTERFACE(r_bits_user  ));

    wire                                              cpu_ar_valid	;//cpu output
    wire [`ysyx_22041071_ADDR_BUS   			    ] cpu_addr	 	;
    wire [`ysyx_22041071_AXI_LEN_WIDTH-1:0	        ] cpu_len		;
    wire [1:0	  							        ] cpu_size	 	;
    wire 									          cpu_aw_valid	;
    wire [`ysyx_22041071_DATA_BUS			        ] cpu_data		;
    wire     						  			      cpu_ar_ready  ;//input cpu	
    wire 										      cpu_r_valid   ;		
    wire [`ysyx_22041071_AXI_DATA_WIDTH-1:0		    ] cpu_r_data    ;
    wire [`ysyx_22041071_ADDR_BUS					] cpu_r_addr	;		
    wire [`ysyx_22041071_AXI_RESP_TYPE_WIDTH-1:0    ] cpu_resp	    ;		
	wire					  				  	      cpu_aw_ready  ;	
    wire 										  	  ar_ready      ;//AR	
    wire 											  ar_valid      ;	
    wire [`ysyx_22041071_AXI_ID_WIDTH-1:0			] ar_id         ;	
    wire [`ysyx_22041071_AXI_ADDR_WIDTH-1:0			] ar_addr       ;	
    wire [`ysyx_22041071_AXI_LEN_WIDTH-1:0			] ar_len        ;	
    wire [`ysyx_22041071_AXI_SIXE_WIDTH-1:0			] ar_size       ;	
    wire [`ysyx_22041071_AXI_BURST_TYPE_WIDTH-1:0	] ar_burst      ;	
    wire [`ysyx_22041071_AXI_PROT_WIDTH-1:0			] ar_prot       ;	
    wire [`ysyx_22041071_AXI_USER_WIDTH-1:0			] ar_user       ;	
    wire 											  ar_lock       ;	
    wire [`ysyx_22041071_AXI_AXCACHE_WIDTH-1:0		] ar_cache      ;	
    wire [`ysyx_22041071_AXI_QOS_WIDTH-1:0			] ar_qos        ;	
    wire [`ysyx_22041071_AXI_REGION_WIDTH-1:0		] ar_region     ;
    wire                               				  r_ready	    ;//R
    wire                       				  		  r_valid	    ;
    wire [`ysyx_22041071_AXI_RESP_TYPE_WIDTH-1:0  	] r_resp	    ;
    wire [`ysyx_22041071_AXI_DATA_WIDTH-1:0			] r_data	    ;
    wire                            				  r_last	    ;
    wire [`ysyx_22041071_AXI_ID_WIDTH-1:0			] r_id	        ;
    wire [`ysyx_22041071_AXI_USER_WIDTH-1:0			] r_user        ;
    wire										  	  aw_ready	    ;//AW
	wire 											  aw_valid	    ;
	wire [`ysyx_22041071_AXI_ID_WIDTH-1:0			] aw_id 	    ;
	wire [`ysyx_22041071_AXI_ADDR_WIDTH-1:0			] aw_addr	    ;
	wire [`ysyx_22041071_AXI_LEN_WIDTH-1:0			] aw_len	    ;
	wire [`ysyx_22041071_AXI_SIXE_WIDTH-1:0			] aw_size	    ;
	wire [`ysyx_22041071_AXI_BURST_TYPE_WIDTH-1:0	] aw_burst	    ;
	wire [`ysyx_22041071_AXI_PROT_WIDTH-1:0			] aw_prot	    ;
	wire [`ysyx_22041071_AXI_USER_WIDTH-1:0			] aw_user	    ;
	wire 											  aw_lock	    ;
	wire [`ysyx_22041071_AXI_AXCACHE_WIDTH-1:0		] aw_cache	    ;
	wire [`ysyx_22041071_AXI_QOS_WIDTH-1:0			] aw_qos	    ;
	wire [`ysyx_22041071_AXI_REGION_WIDTH-1:0		] aw_region	    ;
	wire [`ysyx_22041071_AXI_ID_WIDTH-1:0			] w_id  	    ;//W
	wire [`ysyx_22041071_AXI_DATA_WIDTH-1:0			] w_data	    ;
	wire [`ysyx_22041071_AXI_WSTRB_WIDTH-1:0		] w_wstrb	    ;
	wire											  w_last	    ;
	wire [`ysyx_22041071_AXI_USER_WIDTH-1:0			] w_user	    ;
	wire                            				  w_valid	    ;
	wire                        				  	  w_ready	    ;
	wire [`ysyx_22041071_AXI_ID_WIDTH-1:0			] bw_id	        ;//BW
	wire [`ysyx_22041071_AXI_RESP_TYPE_WIDTH-1:0  	] bw_resp	    ;
	wire [`ysyx_22041071_AXI_USER_WIDTH-1:0			] bw_user	    ;	
	wire                            				  bw_valid	    ;
	wire 											  bw_ready      ;	

    assign ar_ready                           = `AXI_TOP_INTERFACE(ar_ready       );
    assign `AXI_TOP_INTERFACE(ar_valid      ) = ar_valid                           ;
    assign `AXI_TOP_INTERFACE(ar_bits_addr  ) = ar_addr                            ;
    assign `AXI_TOP_INTERFACE(ar_bits_prot  ) = ar_prot                            ;
    assign `AXI_TOP_INTERFACE(ar_bits_id    ) = ar_id                              ;
    assign `AXI_TOP_INTERFACE(ar_bits_user  ) = ar_user                            ;
    assign `AXI_TOP_INTERFACE(ar_bits_len   ) = ar_len                             ;
    assign `AXI_TOP_INTERFACE(ar_bits_size  ) = ar_size                            ;
    assign `AXI_TOP_INTERFACE(ar_bits_burst ) = ar_burst                           ;
    assign `AXI_TOP_INTERFACE(ar_bits_lock  ) = ar_lock                            ;
    assign `AXI_TOP_INTERFACE(ar_bits_cache ) = ar_cache                           ;
    assign `AXI_TOP_INTERFACE(ar_bits_qos   ) = ar_qos                             ; 
    assign `AXI_TOP_INTERFACE(r_ready       ) = r_ready                            ;
    assign r_valid                            = `AXI_TOP_INTERFACE(r_valid        );
    assign r_resp                             = `AXI_TOP_INTERFACE(r_bits_resp    );
    assign r_data                             = `AXI_TOP_INTERFACE(r_bits_data)[0] ;
    assign r_last                             = `AXI_TOP_INTERFACE(r_bits_last    );
    assign r_id                               = `AXI_TOP_INTERFACE(r_bits_id      );
    assign r_user                             = `AXI_TOP_INTERFACE(r_bits_user    );
    //assign aw_ready	                          = `AXI_TOP_INTERFACE(aw_ready       );
    //assign `AXI_TOP_INTERFACE(aw_valid     )  = aw_valid	                       ;
    //assign `AXI_TOP_INTERFACE(aw_bits_id   )  = aw_id                              ;  
    //assign `AXI_TOP_INTERFACE(aw_bits_addr )  = aw_addr	                           ;
    //assign `AXI_TOP_INTERFACE(aw_bits_len  )  = aw_len	                           ;    
    //assign `AXI_TOP_INTERFACE(aw_bits_size )  = aw_size	                           ;
    //assign `AXI_TOP_INTERFACE(aw_bits_burst)  = aw_burst                           ;
    //assign `AXI_TOP_INTERFACE(aw_bits_prot )  = aw_prot	                           ;
    //assign `AXI_TOP_INTERFACE(aw_bits_user )  = aw_user	                           ;
    //assign `AXI_TOP_INTERFACE(aw_bits_lock )  = aw_lock	                           ;
    //assign `AXI_TOP_INTERFACE(aw_bits_cache)  = aw_cache                           ;
    //assign `AXI_TOP_INTERFACE(aw_bits_qos  )  = aw_qos	                           ;    
	////assign w_id  	;
    ////assign w_user	;
    //assign w_ready	                          = `AXI_TOP_INTERFACE(w_ready      )   ;
    //assign `AXI_TOP_INTERFACE(w_bits_data  )  = w_data	                            ;
    //assign `AXI_TOP_INTERFACE(w_bits_strb  )  = w_wstrb	                            ;
    //assign `AXI_TOP_INTERFACE(w_bits_last  )  = w_last	                            ;
    //assign `AXI_TOP_INTERFACE(w_valid      )  = w_valid	                            ;
    //assign bw_id	                          = `AXI_TOP_INTERFACE(b_bits_id    )   ;
    //assign bw_resp	                          = `AXI_TOP_INTERFACE(b_bits_resp  )   ;
    //assign bw_user	                          = `AXI_TOP_INTERFACE(b_bits_user  )   ;
    //assign bw_valid	                          = `AXI_TOP_INTERFACE(b_valid      )   ;
    //assign `AXI_TOP_INTERFACE(b_ready      )  = bw_ready                            ;

	ysyx_22041071_AXI_RW AXI_RW(
			.clk				(clock          ),
			.reset_n			(~reset         ),
			.cpu_ar_valid		(cpu_ar_valid	),
			.cpu_addr	 		(cpu_addr	 	),
			.cpu_len			(cpu_len		),
			.cpu_size	 		(cpu_size	 	),//00:1BYTE;01:2BYTE;10:4BYTE;11:8BYTE
			.cpu_aw_valid		(cpu_aw_valid	),
			.cpu_data			(cpu_data		),
			.cpu_ar_ready		(cpu_ar_ready   ),
			.cpu_r_valid		(cpu_r_valid    ),
			.cpu_r_data 		(cpu_r_data     ),
            .cpu_r_addr         (cpu_r_addr     ),
			.cpu_resp	 		(cpu_resp	    ),
			.cpu_aw_ready		(cpu_aw_ready   ),
			.axi_ar_ready_i		(ar_ready       ),//AR
			.axi_ar_valid_o		(ar_valid       ),
			.axi_ar_id_o		(ar_id          ),
			.axi_ar_addr_o		(ar_addr        ),
			.axi_ar_len_o		(ar_len         ),
			.axi_ar_size_o		(ar_size        ),
			.axi_ar_burst_o		(ar_burst       ),
			.axi_ar_prot_o		(ar_prot        ),
			.axi_ar_user_o		(ar_user        ),
			.axi_ar_lock_o		(ar_lock        ),
			.axi_ar_cache_o		(ar_cache       ),
			.axi_ar_qos_o		(ar_qos         ),
			.axi_ar_region_o	(ar_region      ),
			.axi_r_ready_o		(r_ready        ),//R
			.axi_r_valid_i		(r_valid        ),
			.axi_r_resp_i		(r_resp         ),
			.axi_r_data_i		(r_data         ),
			.axi_r_last_i		(r_last         ),
			.axi_r_id_i			(r_id           ),
			.axi_r_user_i		(r_user         ),
			.axi_aw_ready_i		(aw_ready	    ),//AW
			.axi_aw_valid_o		(aw_valid	    ),
			.axi_aw_id_o		(aw_id          ),
			.axi_aw_addr_o		(aw_addr	    ),
			.axi_aw_len_o		(aw_len	        ),
			.axi_aw_size_o		(aw_size	    ),
			.axi_aw_burst_o		(aw_burst	    ),
			.axi_aw_prot_o		(aw_prot	    ),
			.axi_aw_user_o		(aw_user	    ),
			.axi_aw_lock_o		(aw_lock	    ),
			.axi_aw_cache_o		(aw_cache	    ),
			.axi_aw_qos_o		(aw_qos	        ),
			.axi_aw_region_o	(aw_region	    ),
			.axi_w_id_o			(w_id  	        ),//W
			.axi_w_data_o		(w_data	        ),
			.axi_w_wstrb_o		(w_wstrb	    ),
			.axi_w_last_o		(w_last	        ),
			.axi_w_user_o		(w_user	        ),
			.axi_w_valid_o		(w_valid	    ),
			.axi_w_ready_i		(w_ready	    ),
			.axi_bw_id_i		(bw_id	        ),//BW
			.axi_bw_resp_i		(bw_resp	    ),
			.axi_bw_user_i		(bw_user	    ),	
			.axi_bw_valid_i		(bw_valid	    ),
			.axi_bw_ready_o		(bw_ready       ));

    ysyx_22041071_CPU CPU(
			.clock     	    (clock          ),
    		.reset     	    (reset          ),
			.cpu_ar_ready	(cpu_ar_ready   ),
			.cpu_r_valid	(cpu_r_valid    ),
			.cpu_r_data 	(cpu_r_data     ),
            .cpu_r_addr     (cpu_r_addr     ),
			.cpu_resp	 	(cpu_resp	    ),
			.cpu_aw_ready	(cpu_aw_ready   ),		
			.cpu_ar_valid	(cpu_ar_valid	),
			.cpu_addr	 	(cpu_addr	 	),
			.cpu_len		(cpu_len		),
			.cpu_size	 	(cpu_size	 	),//00:1BYTE;01:2BYTE;10:4BYTE;11:8BYTE
			.cpu_aw_valid	(cpu_aw_valid	),
			.cpu_data		(cpu_data		));
endmodule