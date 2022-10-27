`include "define.v"
module ysyx_22041071_axi_w(
			input											  		  clk	 			,
			input											  		  reset_n			,
			input											  		  cpu_aw_valid		,
			input  		[`ysyx_22041071_AXI_ID_WIDTH-1:0			] cpu_id	 		,
			input  		[`ysyx_22041071_ADDR_BUS					] cpu_addr	 		,
			input		[`ysyx_22041071_AXI_LEN_WIDTH-1:0			] cpu_aw_len		,
			input  		[1:0	  									] cpu_size	 		,//00:1BYTE;01:2BYTE;10:4BYTE;11:8BYTE
			input		[`ysyx_22041071_DATA_BUS					] cpu_w_data		,
			output  							  				  	  cpu_aw_ready		,
			output reg 	[`ysyx_22041071_AXI_RESP_TYPE_WIDTH-1:0		] cpu_w_resp	 	,
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
			output 													  axi_bw_ready_o	);
			
	parameter [1:0]								W_IDLE = 2'b00	;
	parameter [1:0]								W_ADDR = 2'b01	;
	parameter [1:0]								W_DATA = 2'b10	;
	parameter [1:0]								W_DONE = 2'b11	;
	reg 	  [1:0] 							c_state			;
	reg 	  [1:0] 							n_state			;
	wire										aw_handshake	;
	wire										w_handshake		;
	wire										w_done			;
	wire										bw_handshake	;
	reg      [`ysyx_22041071_AXI_LEN_WIDTH-1:0] len_	 		;
	wire										len_reset		;
	wire										len_en	 		;
	reg 	[`ysyx_22041071_AXI_ADDR_WIDTH-1:0] addr_			;

	wire 							  				  	  aw_ready_			;						
	wire 	[`ysyx_22041071_AXI_RESP_TYPE_WIDTH-1:0		] resp_				;
	wire 												  axi_aw_valid_o_	;//AW
    wire 	[`ysyx_22041071_AXI_ID_WIDTH-1:0			] axi_aw_id_o_		;
    wire 	[`ysyx_22041071_AXI_ADDR_WIDTH-1:0			] axi_aw_addr_o_	;
    wire 	[`ysyx_22041071_AXI_LEN_WIDTH-1:0			] axi_aw_len_o_		;
    reg 	[`ysyx_22041071_AXI_SIXE_WIDTH-1:0			] axi_aw_size_o_	;
    wire 	[`ysyx_22041071_AXI_BURST_TYPE_WIDTH-1:0	] axi_aw_burst_o_	;
    wire 	[`ysyx_22041071_AXI_PROT_WIDTH-1:0			] axi_aw_prot_o_	;
    wire 	[`ysyx_22041071_AXI_USER_WIDTH-1:0			] axi_aw_user_o_	;
    wire 												  axi_aw_lock_o_	;
    wire 	[`ysyx_22041071_AXI_AXCACHE_WIDTH-1:0		] axi_aw_cache_o_	;
    wire 	[`ysyx_22041071_AXI_QOS_WIDTH-1:0			] axi_aw_qos_o_		;
    wire 	[`ysyx_22041071_AXI_REGION_WIDTH-1:0		] axi_aw_region_o_	;
    wire  	[`ysyx_22041071_AXI_ID_WIDTH-1:0			] axi_w_id_o_		;//W
    wire  	[`ysyx_22041071_AXI_DATA_WIDTH-1:0			] axi_w_data_o_		;
    reg  	[`ysyx_22041071_AXI_WSTRB_WIDTH-1:0			] axi_w_wstrb_o_	;
    wire												  axi_w_last_o_		;
    wire 	[`ysyx_22041071_AXI_USER_WIDTH-1:0			] axi_w_user_o_		;
    wire                           				  	  	  axi_w_valid_o_	;
	wire											  	  axi_bw_ready_o_	;//BW	
	
	assign resp_		   = axi_bw_resp_i										;
	assign axi_aw_id_o_    = cpu_id												;
	assign axi_aw_len_o_   = cpu_aw_len											;
	assign axi_aw_burst_o_ = `ysyx_22041071_AXI_BURST_TYPE_INCR					;
	assign axi_aw_prot_o_  = 3'd0												;
	assign axi_aw_user_o_  = 1'b0												;	
	assign axi_aw_lock_o_  = 1'b0												;
	assign axi_aw_cache_o_ = 4'd0												;
	assign axi_aw_qos_o_   = 4'd0												;	
	assign axi_aw_region_o_= 4'd0												;
	assign axi_w_id_o_	   = cpu_id												;
	assign axi_w_data_o_   = cpu_w_data										;
	assign axi_w_user_o_   = 1'b0												;
	assign axi_aw_addr_o_  = {addr_[`ysyx_22041071_AXI_ADDR_WIDTH-1:3],{3{1'b0}}};
	assign axi_w_last_o_   = len_ == cpu_aw_len									;
	
	assign aw_ready_	   = c_state == W_IDLE									;
	assign axi_aw_valid_o_ = c_state == W_ADDR									;
	assign aw_handshake	   = axi_aw_valid_o_ && axi_aw_ready_i					;
	assign axi_w_valid_o_  = c_state == W_ADDR									;	//////////
	assign w_handshake	   = c_state == W_DATA &&  axi_w_ready_i				;
	assign w_done		   = w_handshake && axi_w_last_o_						;
	assign axi_bw_ready_o_ = c_state == W_DONE									;
	assign bw_handshake    = axi_bw_ready_o_ && axi_bw_valid_i					;
	assign cpu_aw_ready	   = aw_ready_											;
	assign axi_bw_ready_o  = axi_bw_ready_o_									;   
	always@(*)begin
		case(cpu_size)
			2'b00:axi_aw_size_o_ = 3'b000;//1 BYTE
			2'b01:axi_aw_size_o_ = 3'b001;//2 BYTE
			2'b10:axi_aw_size_o_ = 3'b010;//4 BYTE
			2'b11:axi_aw_size_o_ = 3'b011;//8 BYTE
		endcase
	end
//========================AXI总线状态转化===========================//
	always@(posedge clk)begin
		if(~reset_n)begin
			c_state <= W_IDLE ;
		end else begin
			c_state <= n_state;
		end
	end
	
	always@(*)begin
		case(c_state)
			W_IDLE:
				if(cpu_aw_valid)
					n_state = W_ADDR;
				else 
					n_state = W_IDLE;
		    W_ADDR:
				if(aw_handshake)
					n_state = W_DATA;
				else
					n_state = W_ADDR;
		    W_DATA:
				if(w_done)
					n_state = W_DONE;
				else 
					n_state = W_DATA;
		    W_DONE:
				if(bw_handshake)
					n_state = W_IDLE;
				else
					n_state = W_DONE;
		endcase
	end
	
//==============计数输出的长度===============//	
	assign len_reset = ~reset_n || c_state== W_IDLE;
	assign len_en	 = (len_ != cpu_aw_len) && c_state==W_DATA;
	always@(posedge clk)begin
		if(len_reset)begin
			len_ <= {`ysyx_22041071_AXI_LEN_WIDTH{1'b0}};
		end else begin
			if(len_en)begin
				len_ <= len_ + 1;
			end
		end
	end
//==================更新每次输出的地址=================//	
	always@(*)begin
		if(w_handshake)begin
			case(cpu_size)
				2'b00:addr_ = cpu_addr + len_	;
				2'b01:addr_ = cpu_addr + len_<<1;
				2'b10:addr_ = cpu_addr + len_<<2;
				2'b11:addr_ = cpu_addr + len_<<3;
			endcase
		end else begin
			addr_ = cpu_addr;
		end
	end
//===================写掩码=================//	
	always@(*)begin
			case(cpu_size)
				2'b00: axi_w_wstrb_o_ = 8'b0000_0001 << addr_[2:0];
				2'b01: axi_w_wstrb_o_ = 8'b0000_0011 << addr_[2:0];
				2'b10: axi_w_wstrb_o_ = 8'b0000_1111 << addr_[2:0];
				2'b11: axi_w_wstrb_o_ = 8'b1111_1111 << addr_[2:0];
			endcase
	end
	
//==============输出===============//
	always@(posedge clk)begin
		if(~reset_n)begin	
			cpu_w_resp      <= {`ysyx_22041071_AXI_RESP_TYPE_WIDTH 	 {1'b0}};
			axi_aw_valid_o	<= 1'b0											;
            axi_aw_id_o		<= {`ysyx_22041071_AXI_ID_WIDTH		 	 {1'b0}};
            axi_aw_addr_o	<= {`ysyx_22041071_AXI_ADDR_WIDTH		 {1'b0}};	
            axi_aw_len_o	<= {`ysyx_22041071_AXI_LEN_WIDTH		 {1'b0}};	
            axi_aw_size_o	<= {`ysyx_22041071_AXI_SIXE_WIDTH		 {1'b0}};	
            axi_aw_burst_o	<= {`ysyx_22041071_AXI_BURST_TYPE_WIDTH	 {1'b0}};
            axi_aw_prot_o	<= {`ysyx_22041071_AXI_PROT_WIDTH		 {1'b0}};	
            axi_aw_user_o	<= {`ysyx_22041071_AXI_USER_WIDTH		 {1'b0}};	
            axi_aw_lock_o	<= {`ysyx_22041071_AXI_LOCK_WIDTH		 {1'b0}};	
            axi_aw_cache_o	<= {`ysyx_22041071_AXI_AXCACHE_WIDTH	 {1'b0}};
            axi_aw_qos_o	<= {`ysyx_22041071_AXI_QOS_WIDTH		 {1'b0}};	
            axi_aw_region_o	<= {`ysyx_22041071_AXI_REGION_WIDTH		 {1'b0}};
            axi_w_id_o		<= {`ysyx_22041071_AXI_ID_WIDTH		 	 {1'b0}};
            axi_w_data_o	<= {`ysyx_22041071_AXI_DATA_WIDTH		 {1'b0}};	
            axi_w_wstrb_o	<= {`ysyx_22041071_AXI_WSTRB_WIDTH		 {1'b0}};	
            axi_w_last_o	<= 1'b0											;	
            axi_w_user_o	<= {`ysyx_22041071_AXI_USER_WIDTH		 {1'b0}};	
			axi_w_valid_o	<= 1'b0											;
		end else begin
				axi_aw_valid_o	<= axi_aw_valid_o_	;
				axi_aw_id_o		<= axi_aw_id_o_		;
				axi_aw_addr_o	<= axi_aw_addr_o_	;
				axi_aw_len_o	<= axi_aw_len_o_	;
				axi_aw_size_o	<= axi_aw_size_o_	;
				axi_aw_burst_o	<= axi_aw_burst_o_	;
				axi_aw_prot_o	<= axi_aw_prot_o_	;
				axi_aw_user_o	<= axi_aw_user_o_	;
				axi_aw_lock_o	<= axi_aw_lock_o_	;
				axi_aw_cache_o	<= axi_aw_cache_o_	;
				axi_aw_qos_o	<= axi_aw_qos_o_	;
				axi_aw_region_o	<= axi_aw_region_o_	;
			//if(w_handshake)begin
				axi_w_valid_o	<= axi_w_valid_o_	;
				axi_w_id_o		<= axi_w_id_o_		;
				axi_w_data_o	<= axi_w_data_o_	;
				axi_w_wstrb_o	<= axi_w_wstrb_o_	;
				axi_w_last_o	<= axi_w_last_o_	;
				axi_w_user_o	<= axi_w_user_o_	;
			//end
			if(bw_handshake)begin
				cpu_w_resp      <= resp_			;
			end  
		end                    	
	end                        	                          
endmodule                      	
                               	
                               
                               