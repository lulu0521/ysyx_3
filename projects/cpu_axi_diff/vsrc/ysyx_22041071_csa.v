`include "define.v"
module ysyx_22041071_csa(input [2:0]in,
		   output 	  s ,
		   output 	  c );

		assign s = in[0]^in[1]^in[2];
		assign c = in[0]&in[1] | in[0]&in[2] | in[1]&in[2];

endmodule
