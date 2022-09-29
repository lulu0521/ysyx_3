`include "define.v"
module ysyx_22041071_switch(
			  input  [131:0] part0 ,
			  input  [131:0] part1 ,
			  input  [131:0] part2 ,
			  input  [131:0] part3 ,
			  input  [131:0] part4 ,
			  input  [131:0] part5 ,
			  input  [131:0] part6 ,
			  input  [131:0] part7 ,
			  input  [131:0] part8 ,
			  input  [131:0] part9 ,
			  input  [131:0] part10,
			  input  [131:0] part11,
			  input  [131:0] part12,
			  input  [131:0] part13,
			  input  [131:0] part14,
			  input  [131:0] part15,
			  input  [131:0] part16,
			  input  [131:0] part17,
			  input  [131:0] part18,
			  input  [131:0] part19,
			  input  [131:0] part20,
			  input  [131:0] part21,
			  input  [131:0] part22,
			  input  [131:0] part23,
			  input  [131:0] part24,
			  input  [131:0] part25,
			  input  [131:0] part26,
			  input  [131:0] part27,
			  input  [131:0] part28,
			  input  [131:0] part29,
			  input  [131:0] part30,
			  input  [131:0] part31,
			  input  [131:0] part32,			  
			  output [32 :0] switch0,
			  output [32 :0] switch1,
			  output [32 :0] switch2,
			  output [32 :0] switch3,
			  output [32 :0] switch4,
			  output [32 :0] switch5,
			  output [32 :0] switch6,
			  output [32 :0] switch7,
			  output [32 :0] switch8,
			  output [32 :0] switch9,
			  output [32 :0] switch10,
			  output [32 :0] switch11,
			  output [32 :0] switch12,
			  output [32 :0] switch13,
			  output [32 :0] switch14,
			  output [32 :0] switch15,
			  output [32 :0] switch16,
			  output [32 :0] switch17,
			  output [32 :0] switch18,
			  output [32 :0] switch19,
			  output [32 :0] switch20,
			  output [32 :0] switch21,
			  output [32 :0] switch22,
			  output [32 :0] switch23,
			  output [32 :0] switch24,
			  output [32 :0] switch25,
			  output [32 :0] switch26,
			  output [32 :0] switch27,
			  output [32 :0] switch28,
			  output [32 :0] switch29,
			  output [32 :0] switch30,
			  output [32 :0] switch31,
			  output [32 :0] switch32,
			  output [32 :0] switch33,
			  output [32 :0] switch34,
			  output [32 :0] switch35,
			  output [32 :0] switch36,
			  output [32 :0] switch37,
			  output [32 :0] switch38,
			  output [32 :0] switch39,
			  output [32 :0] switch40,
			  output [32 :0] switch41,
			  output [32 :0] switch42,
			  output [32 :0] switch43,
			  output [32 :0] switch44,
			  output [32 :0] switch45,
			  output [32 :0] switch46,
			  output [32 :0] switch47,
			  output [32 :0] switch48,
			  output [32 :0] switch49,
			  output [32 :0] switch50,
			  output [32 :0] switch51,
			  output [32 :0] switch52,
			  output [32 :0] switch53,
			  output [32 :0] switch54,
			  output [32 :0] switch55,
			  output [32 :0] switch56,
			  output [32 :0] switch57,
			  output [32 :0] switch58,
			  output [32 :0] switch59,
			  output [32 :0] switch60,
			  output [32 :0] switch61,
			  output [32 :0] switch62,
			  output [32 :0] switch63,
			  output [32 :0] switch64,
			  output [32 :0] switch65,
			  output [32 :0] switch66,
			  output [32 :0] switch67,
			  output [32 :0] switch68,
			  output [32 :0] switch69,
			  output [32 :0] switch70,
			  output [32 :0] switch71,
			  output [32 :0] switch72,
			  output [32 :0] switch73,
			  output [32 :0] switch74,
			  output [32 :0] switch75,
			  output [32 :0] switch76,
			  output [32 :0] switch77,
			  output [32 :0] switch78,
			  output [32 :0] switch79,
			  output [32 :0] switch80,
			  output [32 :0] switch81,
			  output [32 :0] switch82,
			  output [32 :0] switch83,
			  output [32 :0] switch84,
			  output [32 :0] switch85,
			  output [32 :0] switch86,
			  output [32 :0] switch87,
			  output [32 :0] switch88,
			  output [32 :0] switch89,
			  output [32 :0] switch90,
			  output [32 :0] switch91,
			  output [32 :0] switch92,
			  output [32 :0] switch93,
			  output [32 :0] switch94,
			  output [32 :0] switch95,
			  output [32 :0] switch96,
			  output [32 :0] switch97,
			  output [32 :0] switch98,
			  output [32 :0] switch99,
			  output [32 :0] switch100,
			  output [32 :0] switch101,
			  output [32 :0] switch102,
			  output [32 :0] switch103,
			  output [32 :0] switch104,
			  output [32 :0] switch105,
			  output [32 :0] switch106,
			  output [32 :0] switch107,
			  output [32 :0] switch108,
			  output [32 :0] switch109,
			  output [32 :0] switch110,
			  output [32 :0] switch111,
			  output [32 :0] switch112,
			  output [32 :0] switch113,
			  output [32 :0] switch114,
			  output [32 :0] switch115,
			  output [32 :0] switch116,
			  output [32 :0] switch117,
			  output [32 :0] switch118,
			  output [32 :0] switch119,
			  output [32 :0] switch120,
			  output [32 :0] switch121,
			  output [32 :0] switch122,
			  output [32 :0] switch123,
			  output [32 :0] switch124,
			  output [32 :0] switch125,
			  output [32 :0] switch126,
			  output [32 :0] switch127,
			  output [32 :0] switch128,
			  output [32 :0] switch129,
			  output [32 :0] switch130,
			  output [32 :0] switch131);
			  
	reg [32:0]switch [0:131];
	genvar i;
	
		generate 
			for(i=0;i<132;i=i+1)begin:u1
				always@(*)begin
					switch[i] = {part0 [i],
								part1  [i],
								part2  [i],
								part3  [i],
								part4  [i],
								part5  [i],
								part6  [i],
								part7  [i],
								part8  [i],
								part9  [i],
								part10 [i],
								part11 [i],
								part12 [i],
								part13 [i],
								part14 [i],
								part15 [i],
								part16 [i],
								part17 [i],
								part18 [i],
								part19 [i],
								part20 [i],
								part21 [i],
								part22 [i],
								part23 [i],
								part24 [i],
								part25 [i],
								part26 [i],
								part27 [i],
								part28 [i],
								part29 [i],
								part30 [i],
								part31 [i],
								part32 [i]};
				end
			end
		endgenerate

	assign switch0   = switch[0  ];
	assign switch1   = switch[1  ];
	assign switch2   = switch[2  ];
	assign switch3   = switch[3  ];
	assign switch4   = switch[4  ];
	assign switch5   = switch[5  ];
	assign switch6   = switch[6  ];
	assign switch7   = switch[7  ];
	assign switch8   = switch[8  ];
	assign switch9   = switch[9  ];
	assign switch10  = switch[10 ];
	assign switch11  = switch[11 ];
	assign switch12  = switch[12 ];
	assign switch13  = switch[13 ];
	assign switch14  = switch[14 ];
	assign switch15  = switch[15 ];
	assign switch16  = switch[16 ];
	assign switch17  = switch[17 ];
	assign switch18  = switch[18 ];
	assign switch19  = switch[19 ];
	assign switch20  = switch[20 ];
	assign switch21  = switch[21 ];
	assign switch22  = switch[22 ];
	assign switch23  = switch[23 ];
	assign switch24  = switch[24 ];
	assign switch25  = switch[25 ];
	assign switch26  = switch[26 ];
	assign switch27  = switch[27 ];
	assign switch28  = switch[28 ];
	assign switch29  = switch[29 ];
	assign switch30  = switch[30 ];
	assign switch31  = switch[31 ];
	assign switch32  = switch[32 ];
	assign switch33  = switch[33 ];
	assign switch34  = switch[34 ];
	assign switch35  = switch[35 ];
	assign switch36  = switch[36 ];
	assign switch37  = switch[37 ];
	assign switch38  = switch[38 ];
	assign switch39  = switch[39 ];
	assign switch40  = switch[40 ];
	assign switch41  = switch[41 ];
	assign switch42  = switch[42 ];
	assign switch43  = switch[43 ];
	assign switch44  = switch[44 ];
	assign switch45  = switch[45 ];
	assign switch46  = switch[46 ];
	assign switch47  = switch[47 ];
	assign switch48  = switch[48 ];
	assign switch49  = switch[49 ];
	assign switch50  = switch[50 ];
	assign switch51  = switch[51 ];
	assign switch52  = switch[52 ];
	assign switch53  = switch[53 ];
	assign switch54  = switch[54 ];
	assign switch55  = switch[55 ];
	assign switch56  = switch[56 ];
	assign switch57  = switch[57 ];
	assign switch58  = switch[58 ];
	assign switch59  = switch[59 ];
	assign switch60  = switch[60 ];
	assign switch61  = switch[61 ];
	assign switch62  = switch[62 ];
	assign switch63  = switch[63 ];
	assign switch64  = switch[64 ];
	assign switch65  = switch[65 ];
	assign switch66  = switch[66 ];
	assign switch67  = switch[67 ];
	assign switch68  = switch[68 ];
	assign switch69  = switch[69 ];
	assign switch70  = switch[70 ];
	assign switch71  = switch[71 ];
	assign switch72  = switch[72 ];
	assign switch73  = switch[73 ];
	assign switch74  = switch[74 ];
	assign switch75  = switch[75 ];
	assign switch76  = switch[76 ];
	assign switch77  = switch[77 ];
	assign switch78  = switch[78 ];
	assign switch79  = switch[79 ];
	assign switch80  = switch[80 ];
	assign switch81  = switch[81 ];
	assign switch82  = switch[82 ];
	assign switch83  = switch[83 ];
    assign switch84  = switch[84 ];                               
	assign switch85  = switch[85 ];                          
    assign switch86  = switch[86 ];
    assign switch87  = switch[87 ];
    assign switch88  = switch[88 ];
    assign switch89  = switch[89 ];
    assign switch90  = switch[90 ];
    assign switch91  = switch[91 ];
    assign switch92  = switch[92 ];
    assign switch93  = switch[93 ];
    assign switch94  = switch[94 ];
    assign switch95  = switch[95 ];
    assign switch96  = switch[96 ];
    assign switch97  = switch[97 ];
    assign switch98  = switch[98 ];
    assign switch99  = switch[99 ];
    assign switch100 = switch[100];
    assign switch101 = switch[101];
    assign switch102 = switch[102];
    assign switch103 = switch[103];
    assign switch104 = switch[104];
    assign switch105 = switch[105];
    assign switch106 = switch[106];
    assign switch107 = switch[107];
    assign switch108 = switch[108];
    assign switch109 = switch[109];
    assign switch110 = switch[110];
    assign switch111 = switch[111];
    assign switch112 = switch[112];
    assign switch113 = switch[113];
    assign switch114 = switch[114];
    assign switch115 = switch[115];
    assign switch116 = switch[116];
    assign switch117 = switch[117];
    assign switch118 = switch[118];
    assign switch119 = switch[119];
    assign switch120 = switch[120];
    assign switch121 = switch[121];
    assign switch122 = switch[122];
    assign switch123 = switch[123];
    assign switch124 = switch[124];
    assign switch125 = switch[125];
    assign switch126 = switch[126];
    assign switch127 = switch[127];
	assign switch128 = switch[128];
	assign switch129 = switch[129];
	assign switch130 = switch[130];
	assign switch131 = switch[131];
	
endmodule