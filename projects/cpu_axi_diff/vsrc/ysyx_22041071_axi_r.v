
`include "define.v"
module ysyx_22041071_axi_r(
			input											  		  clk	 			,
			input											  		  reset_n			,
			input											  		  cpu_ar_valid		,
			input  		[`ysyx_22041071_AXI_ID_WIDTH-1:0			] cpu_id	 		,
			input  		[`ysyx_22041071_ADDR_BUS					] cpu_addr	 		,
			input		[`ysyx_22041071_AXI_LEN_WIDTH-1:0			] cpu_len			,
			input  		[1:0	  									] cpu_size	 		,//00:1BYTE;01:2BYTE;10:4BYTE;11:8BYTE
			output reg 							  				  	  cpu_ar_ready		,
			output reg 												  cpu_r_valid		,
			output reg 	[`ysyx_22041071_AXI_DATA_WIDTH-1:0			] cpu_r_data 		,
			output reg 	[`ysyx_22041071_AXI_RESP_TYPE_WIDTH-1:0		] cpu_r_resp	 	,
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
			input  		[`ysyx_22041071_AXI_USER_WIDTH-1:0			] axi_r_user_i		);

	parameter [1:0] READ_IDLE 	 = 2'b00;
	parameter [1:0] READ_ADDR 	 = 2'b01;
	parameter [1:0] READ_DATA 	 = 2'b10;
	parameter 		OFFSET_WIDTH = $clog2(`ysyx_22041071_AXI_DATA_WIDTH); 	
	wire 						    				ar_ready_	 	;
	wire [`ysyx_22041071_AXI_RESP_TYPE_WIDTH-1:0  ]	resp_			;
	wire                            				axi_ar_valid_o_	;
	wire [`ysyx_22041071_AXI_ID_WIDTH-1:0		  ] axi_ar_id_o_	;
    wire [`ysyx_22041071_AXI_ADDR_WIDTH-1:0		  ] axi_ar_addr_o_	;		
    wire [`ysyx_22041071_AXI_LEN_WIDTH-1:0		  ] axi_ar_len_o_	;
    reg  [`ysyx_22041071_AXI_SIXE_WIDTH-1:0	  	  ] axi_ar_size_o_	;	
    wire [`ysyx_22041071_AXI_BURST_TYPE_WIDTH-1:0 ] axi_ar_burst_o_	;
	wire [`ysyx_22041071_AXI_PROT_WIDTH-1:0	  	  ] axi_ar_prot_o_	;	
    wire [`ysyx_22041071_AXI_USER_WIDTH-1:0	  	  ] axi_ar_user_o_	;
	wire                      						axi_ar_lock_o_	;
	wire [`ysyx_22041071_AXI_AXCACHE_WIDTH-1:0	  ] axi_ar_cache_o_	;
	wire [`ysyx_22041071_AXI_QOS_WIDTH-1:0		  ] axi_ar_qos_o_	;	
    wire [`ysyx_22041071_AXI_REGION_WIDTH-1:0	  ] axi_ar_region_o_;
	wire						   					axi_r_ready_o_	;
	reg [`ysyx_22041071_AXI_ADDR_WIDTH-1:0		  ] addr_			;
	
	wire	  ar_handshake	;//handshake
	wire	  r_handshake	;
	wire	  r_done		;
	reg [1:0] c_state		;
	reg [1:0] n_state		;
	
	assign ar_ready_		= c_state == READ_IDLE				;
	assign resp_			= axi_r_resp_i						;
	assign axi_ar_prot_o_	= 3'd0								;		
	assign axi_ar_user_o_	= 1'b0								;	
	assign axi_ar_lock_o_	= 1'b0								;
	assign axi_ar_cache_o_	= 4'd0								;
	assign axi_ar_qos_o_	= 4'd0								;
	assign axi_ar_region_o_ = 4'd0								;
	assign axi_ar_id_o_		= cpu_id							;
	assign axi_ar_addr_o_	= {cpu_addr[63:3],{3{1'b0}}}		;
	assign axi_ar_burst_o_	= `ysyx_22041071_AXI_BURST_TYPE_INCR;
	assign axi_ar_len_o_	= cpu_len							;

	
	assign axi_ar_valid_o_	= c_state == READ_ADDR				;
	assign axi_r_ready_o_	= c_state == READ_DATA				;
	assign ar_handshake		= axi_ar_valid_o_ & axi_ar_ready_i	;
	assign r_handshake		= axi_r_valid_i   & axi_r_ready_o_	;
	assign r_done			= r_handshake	  & axi_r_last_i	;

	always@(*)begin
		case(cpu_size)
			2'b00:axi_ar_size_o_ = 3'b000;//1 BYTE
			2'b01:axi_ar_size_o_ = 3'b001;//2 BYTE
			2'b10:axi_ar_size_o_ = 3'b010;//4 BYTE
			2'b11:axi_ar_size_o_ = 3'b011;//8 BYTE
		endcase
	end
	
	always@(posedge clk)begin
		if(~reset_n)begin
			c_state <= READ_IDLE;
		end else begin	
			c_state <= n_state	;
		end
	end
	always@(*)begin
		case(c_state)
			READ_IDLE:
				if(cpu_ar_valid)
					n_state = READ_ADDR;
			READ_ADDR:
				if(ar_handshake)
					n_state = READ_DATA;
			READ_DATA:
				if(r_done)
					n_state = READ_IDLE;
			default:
				n_state = READ_IDLE;
		endcase
	end
	
//=============================非对齐的数据输出===============================//
	wire [OFFSET_WIDTH-1:0	 					]	offset_l	;
	reg [`ysyx_22041071_AXI_DATA_WIDTH-1:0	 	]	mask_l		;
	wire [`ysyx_22041071_AXI_DATA_WIDTH-1:0	 	]	data_l		;
//==============读数据选择的掩码===========//
	assign offset_l = {{3'b000},cpu_addr[2:0]} << 3 			;
	assign data_l	= axi_r_data_i & mask_l					 ;
	always@(*)begin
		case(cpu_size)
			2'b00:mask_l = {{`ysyx_22041071_AXI_DATA_WIDTH-8 {1'b0}},{8'hff				   	 }} << offset_l;
			2'b01:mask_l = {{`ysyx_22041071_AXI_DATA_WIDTH-16{1'b0}},{16'hffff			   	 }} << offset_l;
			2'b10:mask_l = {{`ysyx_22041071_AXI_DATA_WIDTH-32{1'b0}},{32'hffff_ffff		   	 }} << offset_l;
			2'b11:mask_l = {{`ysyx_22041071_AXI_DATA_WIDTH-64{1'b0}},{64'hffff_ffff_ffff_ffff}} << offset_l;
		endcase
	end
//================数据输出=================//
	always@(posedge clk)begin
		if(~reset_n)begin
			cpu_r_data <= {`ysyx_22041071_AXI_DATA_WIDTH{1'b0}}	;
			cpu_r_valid<= 1'b0									;
		end else begin
			if(r_handshake)begin
					cpu_r_data  <= data_l;
					cpu_r_valid <= 1'b1	;
			end
		end
	end
//=========================其他信号时序输出=============================//
	always@(posedge clk)begin
		if(~reset_n)begin
			cpu_ar_ready	<= 1'b0											;
		    cpu_r_resp	    <= {`ysyx_22041071_AXI_RESP_TYPE_WIDTH 	 {1'b0}};
			axi_ar_valid_o	<= 1'b0											;
            axi_ar_id_o		<= {`ysyx_22041071_AXI_ID_WIDTH		 	 {1'b0}};
            axi_ar_addr_o	<= {`ysyx_22041071_AXI_ADDR_WIDTH		 {1'b0}};	
            axi_ar_len_o	<= {`ysyx_22041071_AXI_LEN_WIDTH		 {1'b0}};	
            axi_ar_size_o	<= {`ysyx_22041071_AXI_SIXE_WIDTH		 {1'b0}};	
            axi_ar_burst_o	<= {`ysyx_22041071_AXI_BURST_TYPE_WIDTH	 {1'b0}};
            axi_ar_prot_o	<= {`ysyx_22041071_AXI_PROT_WIDTH		 {1'b0}};	
            axi_ar_user_o	<= {`ysyx_22041071_AXI_USER_WIDTH		 {1'b0}};	
            axi_ar_lock_o	<= {`ysyx_22041071_AXI_LOCK_WIDTH		 {1'b0}};	
            axi_ar_cache_o	<= {`ysyx_22041071_AXI_AXCACHE_WIDTH	 {1'b0}};
            axi_ar_qos_o	<= {`ysyx_22041071_AXI_QOS_WIDTH		 {1'b0}};	
			axi_ar_region_o	<= {`ysyx_22041071_AXI_REGION_WIDTH		 {1'b0}};
			axi_r_ready_o	<= 1'b0											;
		end else begin
			cpu_ar_ready	<= ar_ready_			;
			axi_r_ready_o	<= axi_r_ready_o_		;
			axi_ar_valid_o	<= axi_ar_valid_o_		;
			if(ar_handshake)begin
            	axi_ar_id_o		<= axi_ar_id_o_		;
            	axi_ar_addr_o	<= axi_ar_addr_o_	;	
            	axi_ar_len_o	<= axi_ar_len_o_	;	
            	axi_ar_size_o	<= axi_ar_size_o_	;	
            	axi_ar_burst_o	<= axi_ar_burst_o_	;
            	axi_ar_prot_o	<= axi_ar_prot_o_	;	
            	axi_ar_user_o	<= axi_ar_user_o_	;	
            	axi_ar_lock_o	<= axi_ar_lock_o_	;	
            	axi_ar_cache_o	<= axi_ar_cache_o_	;
            	axi_ar_qos_o	<= axi_ar_qos_o_	;	
				axi_ar_region_o	<= axi_ar_region_o_	;
			end
			if(r_handshake)begin
				cpu_r_resp	    <= resp_			;
			end
		end
	end
	always@(*)begin
		$display("======================22222222222===========%x",axi_ar_addr_o_	);
		$display("======================22222222222===========%d",axi_ar_len_o_		);
		$display("======================22222222222===========%d",axi_ar_size_o_	);
	end
endmodule
