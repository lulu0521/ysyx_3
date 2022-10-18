`timescale 1s/1s
`define ysyx_22041071_ADDR_BUS 63:0
`define ysyx_22041071_INS_BUS  31:0
`define ysyx_22041071_DATA_BUS 63:0
`define START_ADDR  64'h0000_0000_7fff_fffc

//`define BOOTH_WALLOC 0
`define RISCV_PRIV_MODE_U   0
`define RISCV_PRIV_MODE_S   1
`define RISCV_PRIV_MODE_M   3

//axi
`define ysyx_22041071_AXI_ID_WIDTH         3'd4
`define ysyx_22041071_AXI_ADDR_WIDTH       7'd64
`define ysyx_22041071_AXI_DATA_WIDTH       7'd64
`define ysyx_22041071_AXI_WSTRB_WIDTH	   4'd8
`define ysyx_22041071_AXI_DATA_MASK_WIDTH  8'd128
`define ysyx_22041071_AXI_LEN_WIDTH 	   4'd8
`define ysyx_22041071_AXI_SIXE_WIDTH 	   2'd3
`define ysyx_22041071_AXI_BURST_TYPE_WIDTH 2'd2
`define ysyx_22041071_AXI_RESP_TYPE_WIDTH  2'd2 
`define ysyx_22041071_AXI_LOCK_WIDTH       1'd1 
`define ysyx_22041071_AXI_AXCACHE_WIDTH    3'd4 
`define ysyx_22041071_AXI_PROT_WIDTH   	   2'd3 
`define ysyx_22041071_AXI_QOS_WIDTH   	   3'd4 
`define ysyx_22041071_AXI_REGION_WIDTH     3'd4 
`define ysyx_22041071_AXI_USER_WIDTH       1'd1 
// Access permissions
`define ysyx_22041071_AXI_PROT_UNPRIVILEGED_ACCESS 3'b000
`define ysyx_22041071_AXI_PROT_PRIVILEGED_ACCESS   3'b001
`define ysyx_22041071_AXI_PROT_SECURE_ACCESS       3'b000
`define ysyx_22041071_AXI_PROT_NON_SECURE_ACCESS   3'b010
`define ysyx_22041071_AXI_PROT_DATA_ACCESS         3'b000
`define ysyx_22041071_AXI_PROT_INSTRUCTION_ACCESS  3'b100
//Burst types
`define ysyx_22041071_AXI_BURST_TYPE_FIXED  2'b00
`define ysyx_22041071_AXI_BURST_TYPE_INCR   2'b01
`define ysyx_22041071_AXI_BURST_TYPE_WRAP   2'b10
//RB_RESP
`define ysyx_22041071_AXI_RESP_OKAY	        2'b00
`define ysyx_22041071_AXI_RESP_EXOKAY       2'b01
`define ysyx_22041071_AXI_RESP_SLVERR       2'b10
`define ysyx_22041071_AXI_RESP_DECERR       2'b11
// Memory types (AR)
`define ysyx_22041071_AXI_ARCACHE_DEVICE_NON_BUFFERABLE                   4'b0000
`define ysyx_22041071_AXI_ARCACHE_DEVICE_BUFFERABLE                       4'b0001
`define ysyx_22041071_AXI_ARCACHE_NORMAL_NON_CACHEABLE_NON_BUFFERABLE     4'b0010
`define ysyx_22041071_AXI_ARCACHE_NORMAL_NON_CACHEABLE_BUFFERABLE         4'b0011
`define ysyx_22041071_AXI_ARCACHE_WRITE_THROUGH_NO_ALLOCATE               4'b1010
`define ysyx_22041071_AXI_ARCACHE_WRITE_THROUGH_READ_ALLOCATE             4'b1110
`define ysyx_22041071_AXI_ARCACHE_WRITE_THROUGH_WRITE_ALLOCATE            4'b1010
`define ysyx_22041071_AXI_ARCACHE_WRITE_THROUGH_READ_AND_WRITE_ALLOCATE   4'b1110
`define ysyx_22041071_AXI_ARCACHE_WRITE_BACK_NO_ALLOCATE                  4'b1011
`define ysyx_22041071_AXI_ARCACHE_WRITE_BACK_READ_ALLOCATE                4'b1111
`define ysyx_22041071_AXI_ARCACHE_WRITE_BACK_WRITE_ALLOCATE               4'b1011
`define ysyx_22041071_AXI_ARCACHE_WRITE_BACK_READ_AND_WRITE_ALLOCATE      4'b1111
// Memory types (AW)
`define ysyx_22041071_AXI_AWCACHE_DEVICE_NON_BUFFERABLE                   4'b0000
`define ysyx_22041071_AXI_AWCACHE_DEVICE_BUFFERABLE                       4'b0001
`define ysyx_22041071_AXI_AWCACHE_NORMAL_NON_CACHEABLE_NON_BUFFERABLE     4'b0010
`define ysyx_22041071_AXI_AWCACHE_NORMAL_NON_CACHEABLE_BUFFERABLE         4'b0011
`define ysyx_22041071_AXI_AWCACHE_WRITE_THROUGH_NO_ALLOCATE               4'b0110
`define ysyx_22041071_AXI_AWCACHE_WRITE_THROUGH_READ_ALLOCATE             4'b0110
`define ysyx_22041071_AXI_AWCACHE_WRITE_THROUGH_WRITE_ALLOCATE            4'b1110
`define ysyx_22041071_AXI_AWCACHE_WRITE_THROUGH_READ_AND_WRITE_ALLOCATE   4'b1110
`define ysyx_22041071_AXI_AWCACHE_WRITE_BACK_NO_ALLOCATE                  4'b0111
`define ysyx_22041071_AXI_AWCACHE_WRITE_BACK_READ_ALLOCATE                4'b0111
`define ysyx_22041071_AXI_AWCACHE_WRITE_BACK_WRITE_ALLOCATE               4'b1111
`define ysyx_22041071_AXI_AWCACHE_WRITE_BACK_READ_AND_WRITE_ALLOCATE      4'b1111
//AXI_SIZE_BYTES
`define ysyx_22041071_AXI_SIZE_BYTES_1                                    3'b000
`define ysyx_22041071_AXI_SIZE_BYTES_2                                    3'b001
`define ysyx_22041071_AXI_SIZE_BYTES_4                                    3'b010
`define ysyx_22041071_AXI_SIZE_BYTES_8                                    3'b011
`define ysyx_22041071_AXI_SIZE_BYTES_16                                   3'b100
`define ysyx_22041071_AXI_SIZE_BYTES_32                                   3'b101
`define ysyx_22041071_AXI_SIZE_BYTES_64                                   3'b110
`define ysyx_22041071_AXI_SIZE_BYTES_128                                  3'b111

`define ysyx_22041071_SIZE_B  2'b00
`define ysyx_22041071_SIZE_H  2'b01
`define ysyx_22041071_SIZE_W  2'b10
`define ysyx_22041071_SIZE_D  2'b11


//slaver
`define AXI_ADDR_WIDTH    64
`define AXI_DATA_WIDTH    64
`define AXI_ID_WIDTH      4
`define AXI_USER_WIDTH    1