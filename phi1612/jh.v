/*
 * Copyright (c) 2017 Sprocket
 *
 * This is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License with
 * additional permissions to the one published by the Free Software
 * Foundation, either version 3 of the License, or (at your option)
 * any later version. For more information see LICENSE.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

module JH512 (
	input clk,
	input [511:0] data,
	output [511:0] hash
);

	reg [511:0] data0, data1;
	reg [1023:0] H0, H1, h;
	reg phase = 1'b0;
	
	wire [1023:0] state0, state1;
	
	F8 F8 (clk, H0, data0, state0);

	wire [511:0] hash_le;
	assign hash = hash_le;

	genvar j;
	generate
		for( j=0; j < 64 ; j = j + 1) begin: HASH_REVERSE
			assign hash_le[j*8 +: 8] = h[(127-j)*8 +: 8];
		end
	endgenerate

	always @ ( posedge clk ) begin

		if ( !phase ) begin
			H0 <= 1024'h4bdd8ccc78465a54fb1785e6dffcc2e356b116577c8806a756f8b19decf657cf99c15a2db1716e3b243c84c1d0a747105ae66f2e8e8ab546694ae34105e66901f73bf8ba763a0fa9a6ba7520dbcc8e58806d2bea6b05a92a1e806f53c1a01d8961c3b3f2591234e90bef970c8d5e228a43d5157a052e6a6317aa003e964bd16f;
			data0 <= data;
			h <= state0;
		end
		else begin
			H0 <= state0;
			data0 <= 512'h80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000200;
			h <= h;
		end
		
		phase <= ~phase;

	end
	
endmodule

module F8 (
	input clk,
	input [1023:0] H,
	input [511:0] data,
	output [1023:0] state
);

	reg [1023:0] Hx, h;
	reg [255:0] Rx;
	
	wire [1023:0] A, h0;

	wire [1023:0] a00,a01,a02,a03,a04,a05,a06,a07,a08,a09;
	wire [1023:0] a10,a11,a12,a13,a14,a15,a16,a17,a18,a19;
	wire [1023:0] a20,a21,a22,a23,a24,a25,a26,a27,a28,a29;
	wire [1023:0] a30,a31,a32,a33,a34,a35,a36,a37,a38,a39,a40,a41,a42;
	
	reg [511:0] d00,d01,d02,d03,d04,d05,d06,d07,d08,d09;
	reg [511:0] d10,d11,d12,d13,d14,d15,d16,d17,d18,d19;
	reg [511:0] d20,d21,d22,d23,d24,d25,d26,d27,d28,d29;
	reg [511:0] d30,d31,d32,d33,d34,d35,d36,d37,d38,d39,d40,d41,d42,d43,d44;

	wire [255:0] r00,r01,r02,r03,r04,r05,r06,r07,r08,r09;
	wire [255:0] r10,r11,r12,r13,r14,r15,r16,r17,r18,r19;
	wire [255:0] r20,r21,r22,r23,r24,r25,r26,r27,r28,r29;
	wire [255:0] r30,r31,r32,r33,r34,r35,r36,r37,r38,r39,r40,r41,r42;
	
	E8i E8i  (Hx, A);
	E8 E8_00  (clk, A, Rx, a00, r00);
	E8 E8_01  (clk, a00, r00, a01, r01);
	E8 E8_02  (clk, a01, r01, a02, r02);
	E8 E8_03  (clk, a02, r02, a03, r03);
	E8 E8_04  (clk, a03, r03, a04, r04);
	E8 E8_05  (clk, a04, r04, a05, r05);
	E8 E8_06  (clk, a05, r05, a06, r06);
	E8 E8_07  (clk, a06, r06, a07, r07);
	E8 E8_08  (clk, a07, r07, a08, r08);
	E8 E8_09  (clk, a08, r08, a09, r09);
	E8 E8_10  (clk, a09, r09, a10, r10);
	E8 E8_11  (clk, a10, r10, a11, r11);
	E8 E8_12  (clk, a11, r11, a12, r12);
	E8 E8_13  (clk, a12, r12, a13, r13);
	E8 E8_14  (clk, a13, r13, a14, r14);
	E8 E8_15  (clk, a14, r14, a15, r15);
	E8 E8_16  (clk, a15, r15, a16, r16);
	E8 E8_17  (clk, a16, r16, a17, r17);
	E8 E8_18  (clk, a17, r17, a18, r18);
	E8 E8_19  (clk, a18, r18, a19, r19);
	E8 E8_20  (clk, a19, r19, a20, r20);
	E8 E8_21  (clk, a20, r20, a21, r21);
	E8 E8_22  (clk, a21, r21, a22, r22);
	E8 E8_23  (clk, a22, r22, a23, r23);
	E8 E8_24  (clk, a23, r23, a24, r24);
	E8 E8_25  (clk, a24, r24, a25, r25);
	E8 E8_26  (clk, a25, r25, a26, r26);
	E8 E8_27  (clk, a26, r26, a27, r27);
	E8 E8_28  (clk, a27, r27, a28, r28);
	E8 E8_29  (clk, a28, r28, a29, r29);
	E8 E8_30  (clk, a29, r29, a30, r30);
	E8 E8_31  (clk, a30, r30, a31, r31);
	E8 E8_32  (clk, a31, r31, a32, r32);
	E8 E8_33  (clk, a32, r32, a33, r33);
	E8 E8_34  (clk, a33, r33, a34, r34);
	E8 E8_35  (clk, a34, r34, a35, r35);
	E8 E8_36  (clk, a35, r35, a36, r36);
	E8 E8_37  (clk, a36, r36, a37, r37);
	E8 E8_38  (clk, a37, r37, a38, r38);
	E8 E8_39  (clk, a38, r38, a39, r39);
	E8 E8_40  (clk, a39, r39, a40, r40);
	E8 E8_41  (clk, a40, r40, a41, r41);
	E8f E8f  (a41, h0);

	wire [511:0] data_le;
	
	assign state = h;

	genvar j;
	generate
		for( j=0; j < 64 ; j = j + 1) begin: DATA_REVERSE
			assign data_le[j*8 +: 8] = data[(63-j)*8 +: 8];
		end
	endgenerate
	
	always @ ( posedge clk ) begin
	
		Hx[1023:512] <= H[1023:512];
		Hx[511:0] <= H[511:0] ^ data_le;
 
		Rx <= 256'ha2237660b095f2ad99057721571ceda3e3d759ae6631bf2b809ccb3f766e90a6;
	
		h[1023:512] <= h0[1023:512] ^ d42;
		h[511:0] <= h0[511:0];

//		d44 <= d43;
//		d43 <= d42;
		d42 <= d41;
		d41 <= d40;
		d40 <= d39;
		d39 <= d38;
		d38 <= d37;
		d37 <= d36;
		d36 <= d35;
		d35 <= d34;
		d34 <= d33;
		d33 <= d32;
		d32 <= d31;
		d31 <= d30;
		d30 <= d29;
		d29 <= d28;
		d28 <= d27;
		d27 <= d26;
		d26 <= d25;
		d25 <= d24;
		d24 <= d23;
		d23 <= d22;
		d22 <= d21;
		d21 <= d20;
		d20 <= d19;
		d19 <= d18;
		d18 <= d17;
		d17 <= d16;
		d16 <= d15;
		d15 <= d14;
		d14 <= d13;
		d13 <= d12;
		d12 <= d11;
		d11 <= d10;
		d10 <= d09;
		d09 <= d08;
		d08 <= d07;
		d07 <= d06;
		d06 <= d05;
		d05 <= d04;
		d04 <= d03;
		d03 <= d02;
		d02 <= d01;
		d01 <= d00;
		d00 <= data_le;

	end
	
endmodule

module E8i (
	input [1023:0] H,
	output [1023:0] A
);

	assign A[3:0] = { H[7], H[263], H[519], H[775] };
	assign A[11:8] = { H[6], H[262], H[518], H[774] };
	assign A[19:16] = { H[5], H[261], H[517], H[773] };
	assign A[27:24] = { H[4], H[260], H[516], H[772] };
	assign A[35:32] = { H[3], H[259], H[515], H[771] };
	assign A[43:40] = { H[2], H[258], H[514], H[770] };
	assign A[51:48] = { H[1], H[257], H[513], H[769] };
	assign A[59:56] = { H[0], H[256], H[512], H[768] };
	assign A[67:64] = { H[15], H[271], H[527], H[783] };
	assign A[75:72] = { H[14], H[270], H[526], H[782] };
	assign A[83:80] = { H[13], H[269], H[525], H[781] };
	assign A[91:88] = { H[12], H[268], H[524], H[780] };
	assign A[99:96] = { H[11], H[267], H[523], H[779] };
	assign A[107:104] = { H[10], H[266], H[522], H[778] };
	assign A[115:112] = { H[9], H[265], H[521], H[777] };
	assign A[123:120] = { H[8], H[264], H[520], H[776] };
	assign A[131:128] = { H[23], H[279], H[535], H[791] };
	assign A[139:136] = { H[22], H[278], H[534], H[790] };
	assign A[147:144] = { H[21], H[277], H[533], H[789] };
	assign A[155:152] = { H[20], H[276], H[532], H[788] };
	assign A[163:160] = { H[19], H[275], H[531], H[787] };
	assign A[171:168] = { H[18], H[274], H[530], H[786] };
	assign A[179:176] = { H[17], H[273], H[529], H[785] };
	assign A[187:184] = { H[16], H[272], H[528], H[784] };
	assign A[195:192] = { H[31], H[287], H[543], H[799] };
	assign A[203:200] = { H[30], H[286], H[542], H[798] };
	assign A[211:208] = { H[29], H[285], H[541], H[797] };
	assign A[219:216] = { H[28], H[284], H[540], H[796] };
	assign A[227:224] = { H[27], H[283], H[539], H[795] };
	assign A[235:232] = { H[26], H[282], H[538], H[794] };
	assign A[243:240] = { H[25], H[281], H[537], H[793] };
	assign A[251:248] = { H[24], H[280], H[536], H[792] };
	assign A[259:256] = { H[39], H[295], H[551], H[807] };
	assign A[267:264] = { H[38], H[294], H[550], H[806] };
	assign A[275:272] = { H[37], H[293], H[549], H[805] };
	assign A[283:280] = { H[36], H[292], H[548], H[804] };
	assign A[291:288] = { H[35], H[291], H[547], H[803] };
	assign A[299:296] = { H[34], H[290], H[546], H[802] };
	assign A[307:304] = { H[33], H[289], H[545], H[801] };
	assign A[315:312] = { H[32], H[288], H[544], H[800] };
	assign A[323:320] = { H[47], H[303], H[559], H[815] };
	assign A[331:328] = { H[46], H[302], H[558], H[814] };
	assign A[339:336] = { H[45], H[301], H[557], H[813] };
	assign A[347:344] = { H[44], H[300], H[556], H[812] };
	assign A[355:352] = { H[43], H[299], H[555], H[811] };
	assign A[363:360] = { H[42], H[298], H[554], H[810] };
	assign A[371:368] = { H[41], H[297], H[553], H[809] };
	assign A[379:376] = { H[40], H[296], H[552], H[808] };
	assign A[387:384] = { H[55], H[311], H[567], H[823] };
	assign A[395:392] = { H[54], H[310], H[566], H[822] };
	assign A[403:400] = { H[53], H[309], H[565], H[821] };
	assign A[411:408] = { H[52], H[308], H[564], H[820] };
	assign A[419:416] = { H[51], H[307], H[563], H[819] };
	assign A[427:424] = { H[50], H[306], H[562], H[818] };
	assign A[435:432] = { H[49], H[305], H[561], H[817] };
	assign A[443:440] = { H[48], H[304], H[560], H[816] };
	assign A[451:448] = { H[63], H[319], H[575], H[831] };
	assign A[459:456] = { H[62], H[318], H[574], H[830] };
	assign A[467:464] = { H[61], H[317], H[573], H[829] };
	assign A[475:472] = { H[60], H[316], H[572], H[828] };
	assign A[483:480] = { H[59], H[315], H[571], H[827] };
	assign A[491:488] = { H[58], H[314], H[570], H[826] };
	assign A[499:496] = { H[57], H[313], H[569], H[825] };
	assign A[507:504] = { H[56], H[312], H[568], H[824] };
	assign A[515:512] = { H[71], H[327], H[583], H[839] };
	assign A[523:520] = { H[70], H[326], H[582], H[838] };
	assign A[531:528] = { H[69], H[325], H[581], H[837] };
	assign A[539:536] = { H[68], H[324], H[580], H[836] };
	assign A[547:544] = { H[67], H[323], H[579], H[835] };
	assign A[555:552] = { H[66], H[322], H[578], H[834] };
	assign A[563:560] = { H[65], H[321], H[577], H[833] };
	assign A[571:568] = { H[64], H[320], H[576], H[832] };
	assign A[579:576] = { H[79], H[335], H[591], H[847] };
	assign A[587:584] = { H[78], H[334], H[590], H[846] };
	assign A[595:592] = { H[77], H[333], H[589], H[845] };
	assign A[603:600] = { H[76], H[332], H[588], H[844] };
	assign A[611:608] = { H[75], H[331], H[587], H[843] };
	assign A[619:616] = { H[74], H[330], H[586], H[842] };
	assign A[627:624] = { H[73], H[329], H[585], H[841] };
	assign A[635:632] = { H[72], H[328], H[584], H[840] };
	assign A[643:640] = { H[87], H[343], H[599], H[855] };
	assign A[651:648] = { H[86], H[342], H[598], H[854] };
	assign A[659:656] = { H[85], H[341], H[597], H[853] };
	assign A[667:664] = { H[84], H[340], H[596], H[852] };
	assign A[675:672] = { H[83], H[339], H[595], H[851] };
	assign A[683:680] = { H[82], H[338], H[594], H[850] };
	assign A[691:688] = { H[81], H[337], H[593], H[849] };
	assign A[699:696] = { H[80], H[336], H[592], H[848] };
	assign A[707:704] = { H[95], H[351], H[607], H[863] };
	assign A[715:712] = { H[94], H[350], H[606], H[862] };
	assign A[723:720] = { H[93], H[349], H[605], H[861] };
	assign A[731:728] = { H[92], H[348], H[604], H[860] };
	assign A[739:736] = { H[91], H[347], H[603], H[859] };
	assign A[747:744] = { H[90], H[346], H[602], H[858] };
	assign A[755:752] = { H[89], H[345], H[601], H[857] };
	assign A[763:760] = { H[88], H[344], H[600], H[856] };
	assign A[771:768] = { H[103], H[359], H[615], H[871] };
	assign A[779:776] = { H[102], H[358], H[614], H[870] };
	assign A[787:784] = { H[101], H[357], H[613], H[869] };
	assign A[795:792] = { H[100], H[356], H[612], H[868] };
	assign A[803:800] = { H[99], H[355], H[611], H[867] };
	assign A[811:808] = { H[98], H[354], H[610], H[866] };
	assign A[819:816] = { H[97], H[353], H[609], H[865] };
	assign A[827:824] = { H[96], H[352], H[608], H[864] };
	assign A[835:832] = { H[111], H[367], H[623], H[879] };
	assign A[843:840] = { H[110], H[366], H[622], H[878] };
	assign A[851:848] = { H[109], H[365], H[621], H[877] };
	assign A[859:856] = { H[108], H[364], H[620], H[876] };
	assign A[867:864] = { H[107], H[363], H[619], H[875] };
	assign A[875:872] = { H[106], H[362], H[618], H[874] };
	assign A[883:880] = { H[105], H[361], H[617], H[873] };
	assign A[891:888] = { H[104], H[360], H[616], H[872] };
	assign A[899:896] = { H[119], H[375], H[631], H[887] };
	assign A[907:904] = { H[118], H[374], H[630], H[886] };
	assign A[915:912] = { H[117], H[373], H[629], H[885] };
	assign A[923:920] = { H[116], H[372], H[628], H[884] };
	assign A[931:928] = { H[115], H[371], H[627], H[883] };
	assign A[939:936] = { H[114], H[370], H[626], H[882] };
	assign A[947:944] = { H[113], H[369], H[625], H[881] };
	assign A[955:952] = { H[112], H[368], H[624], H[880] };
	assign A[963:960] = { H[127], H[383], H[639], H[895] };
	assign A[971:968] = { H[126], H[382], H[638], H[894] };
	assign A[979:976] = { H[125], H[381], H[637], H[893] };
	assign A[987:984] = { H[124], H[380], H[636], H[892] };
	assign A[995:992] = { H[123], H[379], H[635], H[891] };
	assign A[1003:1000] = { H[122], H[378], H[634], H[890] };
	assign A[1011:1008] = { H[121], H[377], H[633], H[889] };
	assign A[1019:1016] = { H[120], H[376], H[632], H[888] };
	assign A[7:4] = { H[135], H[391], H[647], H[903] };
	assign A[15:12] = { H[134], H[390], H[646], H[902] };
	assign A[23:20] = { H[133], H[389], H[645], H[901] };
	assign A[31:28] = { H[132], H[388], H[644], H[900] };
	assign A[39:36] = { H[131], H[387], H[643], H[899] };
	assign A[47:44] = { H[130], H[386], H[642], H[898] };
	assign A[55:52] = { H[129], H[385], H[641], H[897] };
	assign A[63:60] = { H[128], H[384], H[640], H[896] };
	assign A[71:68] = { H[143], H[399], H[655], H[911] };
	assign A[79:76] = { H[142], H[398], H[654], H[910] };
	assign A[87:84] = { H[141], H[397], H[653], H[909] };
	assign A[95:92] = { H[140], H[396], H[652], H[908] };
	assign A[103:100] = { H[139], H[395], H[651], H[907] };
	assign A[111:108] = { H[138], H[394], H[650], H[906] };
	assign A[119:116] = { H[137], H[393], H[649], H[905] };
	assign A[127:124] = { H[136], H[392], H[648], H[904] };
	assign A[135:132] = { H[151], H[407], H[663], H[919] };
	assign A[143:140] = { H[150], H[406], H[662], H[918] };
	assign A[151:148] = { H[149], H[405], H[661], H[917] };
	assign A[159:156] = { H[148], H[404], H[660], H[916] };
	assign A[167:164] = { H[147], H[403], H[659], H[915] };
	assign A[175:172] = { H[146], H[402], H[658], H[914] };
	assign A[183:180] = { H[145], H[401], H[657], H[913] };
	assign A[191:188] = { H[144], H[400], H[656], H[912] };
	assign A[199:196] = { H[159], H[415], H[671], H[927] };
	assign A[207:204] = { H[158], H[414], H[670], H[926] };
	assign A[215:212] = { H[157], H[413], H[669], H[925] };
	assign A[223:220] = { H[156], H[412], H[668], H[924] };
	assign A[231:228] = { H[155], H[411], H[667], H[923] };
	assign A[239:236] = { H[154], H[410], H[666], H[922] };
	assign A[247:244] = { H[153], H[409], H[665], H[921] };
	assign A[255:252] = { H[152], H[408], H[664], H[920] };
	assign A[263:260] = { H[167], H[423], H[679], H[935] };
	assign A[271:268] = { H[166], H[422], H[678], H[934] };
	assign A[279:276] = { H[165], H[421], H[677], H[933] };
	assign A[287:284] = { H[164], H[420], H[676], H[932] };
	assign A[295:292] = { H[163], H[419], H[675], H[931] };
	assign A[303:300] = { H[162], H[418], H[674], H[930] };
	assign A[311:308] = { H[161], H[417], H[673], H[929] };
	assign A[319:316] = { H[160], H[416], H[672], H[928] };
	assign A[327:324] = { H[175], H[431], H[687], H[943] };
	assign A[335:332] = { H[174], H[430], H[686], H[942] };
	assign A[343:340] = { H[173], H[429], H[685], H[941] };
	assign A[351:348] = { H[172], H[428], H[684], H[940] };
	assign A[359:356] = { H[171], H[427], H[683], H[939] };
	assign A[367:364] = { H[170], H[426], H[682], H[938] };
	assign A[375:372] = { H[169], H[425], H[681], H[937] };
	assign A[383:380] = { H[168], H[424], H[680], H[936] };
	assign A[391:388] = { H[183], H[439], H[695], H[951] };
	assign A[399:396] = { H[182], H[438], H[694], H[950] };
	assign A[407:404] = { H[181], H[437], H[693], H[949] };
	assign A[415:412] = { H[180], H[436], H[692], H[948] };
	assign A[423:420] = { H[179], H[435], H[691], H[947] };
	assign A[431:428] = { H[178], H[434], H[690], H[946] };
	assign A[439:436] = { H[177], H[433], H[689], H[945] };
	assign A[447:444] = { H[176], H[432], H[688], H[944] };
	assign A[455:452] = { H[191], H[447], H[703], H[959] };
	assign A[463:460] = { H[190], H[446], H[702], H[958] };
	assign A[471:468] = { H[189], H[445], H[701], H[957] };
	assign A[479:476] = { H[188], H[444], H[700], H[956] };
	assign A[487:484] = { H[187], H[443], H[699], H[955] };
	assign A[495:492] = { H[186], H[442], H[698], H[954] };
	assign A[503:500] = { H[185], H[441], H[697], H[953] };
	assign A[511:508] = { H[184], H[440], H[696], H[952] };
	assign A[519:516] = { H[199], H[455], H[711], H[967] };
	assign A[527:524] = { H[198], H[454], H[710], H[966] };
	assign A[535:532] = { H[197], H[453], H[709], H[965] };
	assign A[543:540] = { H[196], H[452], H[708], H[964] };
	assign A[551:548] = { H[195], H[451], H[707], H[963] };
	assign A[559:556] = { H[194], H[450], H[706], H[962] };
	assign A[567:564] = { H[193], H[449], H[705], H[961] };
	assign A[575:572] = { H[192], H[448], H[704], H[960] };
	assign A[583:580] = { H[207], H[463], H[719], H[975] };
	assign A[591:588] = { H[206], H[462], H[718], H[974] };
	assign A[599:596] = { H[205], H[461], H[717], H[973] };
	assign A[607:604] = { H[204], H[460], H[716], H[972] };
	assign A[615:612] = { H[203], H[459], H[715], H[971] };
	assign A[623:620] = { H[202], H[458], H[714], H[970] };
	assign A[631:628] = { H[201], H[457], H[713], H[969] };
	assign A[639:636] = { H[200], H[456], H[712], H[968] };
	assign A[647:644] = { H[215], H[471], H[727], H[983] };
	assign A[655:652] = { H[214], H[470], H[726], H[982] };
	assign A[663:660] = { H[213], H[469], H[725], H[981] };
	assign A[671:668] = { H[212], H[468], H[724], H[980] };
	assign A[679:676] = { H[211], H[467], H[723], H[979] };
	assign A[687:684] = { H[210], H[466], H[722], H[978] };
	assign A[695:692] = { H[209], H[465], H[721], H[977] };
	assign A[703:700] = { H[208], H[464], H[720], H[976] };
	assign A[711:708] = { H[223], H[479], H[735], H[991] };
	assign A[719:716] = { H[222], H[478], H[734], H[990] };
	assign A[727:724] = { H[221], H[477], H[733], H[989] };
	assign A[735:732] = { H[220], H[476], H[732], H[988] };
	assign A[743:740] = { H[219], H[475], H[731], H[987] };
	assign A[751:748] = { H[218], H[474], H[730], H[986] };
	assign A[759:756] = { H[217], H[473], H[729], H[985] };
	assign A[767:764] = { H[216], H[472], H[728], H[984] };
	assign A[775:772] = { H[231], H[487], H[743], H[999] };
	assign A[783:780] = { H[230], H[486], H[742], H[998] };
	assign A[791:788] = { H[229], H[485], H[741], H[997] };
	assign A[799:796] = { H[228], H[484], H[740], H[996] };
	assign A[807:804] = { H[227], H[483], H[739], H[995] };
	assign A[815:812] = { H[226], H[482], H[738], H[994] };
	assign A[823:820] = { H[225], H[481], H[737], H[993] };
	assign A[831:828] = { H[224], H[480], H[736], H[992] };
	assign A[839:836] = { H[239], H[495], H[751], H[1007] };
	assign A[847:844] = { H[238], H[494], H[750], H[1006] };
	assign A[855:852] = { H[237], H[493], H[749], H[1005] };
	assign A[863:860] = { H[236], H[492], H[748], H[1004] };
	assign A[871:868] = { H[235], H[491], H[747], H[1003] };
	assign A[879:876] = { H[234], H[490], H[746], H[1002] };
	assign A[887:884] = { H[233], H[489], H[745], H[1001] };
	assign A[895:892] = { H[232], H[488], H[744], H[1000] };
	assign A[903:900] = { H[247], H[503], H[759], H[1015] };
	assign A[911:908] = { H[246], H[502], H[758], H[1014] };
	assign A[919:916] = { H[245], H[501], H[757], H[1013] };
	assign A[927:924] = { H[244], H[500], H[756], H[1012] };
	assign A[935:932] = { H[243], H[499], H[755], H[1011] };
	assign A[943:940] = { H[242], H[498], H[754], H[1010] };
	assign A[951:948] = { H[241], H[497], H[753], H[1009] };
	assign A[959:956] = { H[240], H[496], H[752], H[1008] };
	assign A[967:964] = { H[255], H[511], H[767], H[1023] };
	assign A[975:972] = { H[254], H[510], H[766], H[1022] };
	assign A[983:980] = { H[253], H[509], H[765], H[1021] };
	assign A[991:988] = { H[252], H[508], H[764], H[1020] };
	assign A[999:996] = { H[251], H[507], H[763], H[1019] };
	assign A[1007:1004] = { H[250], H[506], H[762], H[1018] };
	assign A[1015:1012] = { H[249], H[505], H[761], H[1017] };
	assign A[1023:1020] = { H[248], H[504], H[760], H[1016] };
	
endmodule


module E8 (
	input clk,
	input [1023:0] A,
	input [255:0] R,
	output reg [1023:0] A_out,
	output reg [255:0] R_out
);

	wire [1023:0] Ao;
	wire [255:0] Ro;

	wire [64*4-1:0] round_in_rev;

	R8 R8 (round_in_rev, A, Ao); 

	update_round update_round (
		.round_in(R), 
		.round_out(Ro)
	);

	genvar i;
	generate
		for(i=0; i<256; i=i+4)
		begin: rnd_rev
			assign round_in_rev [i] = R[i+3];
			assign round_in_rev [i+1] = R[i+2];
			assign round_in_rev [i+2] = R[i+1];
			assign round_in_rev [i+3] = R[i];
		end		
	endgenerate	
	
	always @ ( posedge clk ) begin

		A_out <= Ao;
		R_out <= Ro;

	end
	
endmodule

module R8 (
	input [255:0] round_in,
	input [1023:0] state_in,
	output [1023:0] out
);         

	wire [3:0] sbox [0:31] = { 4'h9,4'h0,4'h4,4'hb,4'hd,4'hc,4'h3,4'hf,4'h1,4'ha,4'h2,4'h6,4'h7,4'h5,4'h8,4'he,4'h3,4'hc,4'h6,4'hd,4'h5,4'h7,4'h1,4'h9,4'hf,4'h2,4'h0,4'h4,4'hb,4'ha,4'he,4'h8 };
	wire [1023:0] L1, L2;
	
	assign L1[1023:1020] = sbox[ { round_in[255], state_in[1023:1020] } ];
	assign L1[1019:1016] = sbox[ { round_in[254], state_in[1019:1016] } ];
	assign L1[1015:1012] = sbox[ { round_in[253], state_in[1015:1012] } ];
	assign L1[1011:1008] = sbox[ { round_in[252], state_in[1011:1008] } ];
	assign L1[1007:1004] = sbox[ { round_in[251], state_in[1007:1004] } ];
	assign L1[1003:1000] = sbox[ { round_in[250], state_in[1003:1000] } ];
	assign L1[999:996] = sbox[ { round_in[249], state_in[999:996] } ];
	assign L1[995:992] = sbox[ { round_in[248], state_in[995:992] } ];
	assign L1[991:988] = sbox[ { round_in[247], state_in[991:988] } ];
	assign L1[987:984] = sbox[ { round_in[246], state_in[987:984] } ];
	assign L1[983:980] = sbox[ { round_in[245], state_in[983:980] } ];
	assign L1[979:976] = sbox[ { round_in[244], state_in[979:976] } ];
	assign L1[975:972] = sbox[ { round_in[243], state_in[975:972] } ];
	assign L1[971:968] = sbox[ { round_in[242], state_in[971:968] } ];
	assign L1[967:964] = sbox[ { round_in[241], state_in[967:964] } ];
	assign L1[963:960] = sbox[ { round_in[240], state_in[963:960] } ];
	assign L1[959:956] = sbox[ { round_in[239], state_in[959:956] } ];
	assign L1[955:952] = sbox[ { round_in[238], state_in[955:952] } ];
	assign L1[951:948] = sbox[ { round_in[237], state_in[951:948] } ];
	assign L1[947:944] = sbox[ { round_in[236], state_in[947:944] } ];
	assign L1[943:940] = sbox[ { round_in[235], state_in[943:940] } ];
	assign L1[939:936] = sbox[ { round_in[234], state_in[939:936] } ];
	assign L1[935:932] = sbox[ { round_in[233], state_in[935:932] } ];
	assign L1[931:928] = sbox[ { round_in[232], state_in[931:928] } ];
	assign L1[927:924] = sbox[ { round_in[231], state_in[927:924] } ];
	assign L1[923:920] = sbox[ { round_in[230], state_in[923:920] } ];
	assign L1[919:916] = sbox[ { round_in[229], state_in[919:916] } ];
	assign L1[915:912] = sbox[ { round_in[228], state_in[915:912] } ];
	assign L1[911:908] = sbox[ { round_in[227], state_in[911:908] } ];
	assign L1[907:904] = sbox[ { round_in[226], state_in[907:904] } ];
	assign L1[903:900] = sbox[ { round_in[225], state_in[903:900] } ];
	assign L1[899:896] = sbox[ { round_in[224], state_in[899:896] } ];
	assign L1[895:892] = sbox[ { round_in[223], state_in[895:892] } ];
	assign L1[891:888] = sbox[ { round_in[222], state_in[891:888] } ];
	assign L1[887:884] = sbox[ { round_in[221], state_in[887:884] } ];
	assign L1[883:880] = sbox[ { round_in[220], state_in[883:880] } ];
	assign L1[879:876] = sbox[ { round_in[219], state_in[879:876] } ];
	assign L1[875:872] = sbox[ { round_in[218], state_in[875:872] } ];
	assign L1[871:868] = sbox[ { round_in[217], state_in[871:868] } ];
	assign L1[867:864] = sbox[ { round_in[216], state_in[867:864] } ];
	assign L1[863:860] = sbox[ { round_in[215], state_in[863:860] } ];
	assign L1[859:856] = sbox[ { round_in[214], state_in[859:856] } ];
	assign L1[855:852] = sbox[ { round_in[213], state_in[855:852] } ];
	assign L1[851:848] = sbox[ { round_in[212], state_in[851:848] } ];
	assign L1[847:844] = sbox[ { round_in[211], state_in[847:844] } ];
	assign L1[843:840] = sbox[ { round_in[210], state_in[843:840] } ];
	assign L1[839:836] = sbox[ { round_in[209], state_in[839:836] } ];
	assign L1[835:832] = sbox[ { round_in[208], state_in[835:832] } ];
	assign L1[831:828] = sbox[ { round_in[207], state_in[831:828] } ];
	assign L1[827:824] = sbox[ { round_in[206], state_in[827:824] } ];
	assign L1[823:820] = sbox[ { round_in[205], state_in[823:820] } ];
	assign L1[819:816] = sbox[ { round_in[204], state_in[819:816] } ];
	assign L1[815:812] = sbox[ { round_in[203], state_in[815:812] } ];
	assign L1[811:808] = sbox[ { round_in[202], state_in[811:808] } ];
	assign L1[807:804] = sbox[ { round_in[201], state_in[807:804] } ];
	assign L1[803:800] = sbox[ { round_in[200], state_in[803:800] } ];
	assign L1[799:796] = sbox[ { round_in[199], state_in[799:796] } ];
	assign L1[795:792] = sbox[ { round_in[198], state_in[795:792] } ];
	assign L1[791:788] = sbox[ { round_in[197], state_in[791:788] } ];
	assign L1[787:784] = sbox[ { round_in[196], state_in[787:784] } ];
	assign L1[783:780] = sbox[ { round_in[195], state_in[783:780] } ];
	assign L1[779:776] = sbox[ { round_in[194], state_in[779:776] } ];
	assign L1[775:772] = sbox[ { round_in[193], state_in[775:772] } ];
	assign L1[771:768] = sbox[ { round_in[192], state_in[771:768] } ];
	assign L1[767:764] = sbox[ { round_in[191], state_in[767:764] } ];
	assign L1[763:760] = sbox[ { round_in[190], state_in[763:760] } ];
	assign L1[759:756] = sbox[ { round_in[189], state_in[759:756] } ];
	assign L1[755:752] = sbox[ { round_in[188], state_in[755:752] } ];
	assign L1[751:748] = sbox[ { round_in[187], state_in[751:748] } ];
	assign L1[747:744] = sbox[ { round_in[186], state_in[747:744] } ];
	assign L1[743:740] = sbox[ { round_in[185], state_in[743:740] } ];
	assign L1[739:736] = sbox[ { round_in[184], state_in[739:736] } ];
	assign L1[735:732] = sbox[ { round_in[183], state_in[735:732] } ];
	assign L1[731:728] = sbox[ { round_in[182], state_in[731:728] } ];
	assign L1[727:724] = sbox[ { round_in[181], state_in[727:724] } ];
	assign L1[723:720] = sbox[ { round_in[180], state_in[723:720] } ];
	assign L1[719:716] = sbox[ { round_in[179], state_in[719:716] } ];
	assign L1[715:712] = sbox[ { round_in[178], state_in[715:712] } ];
	assign L1[711:708] = sbox[ { round_in[177], state_in[711:708] } ];
	assign L1[707:704] = sbox[ { round_in[176], state_in[707:704] } ];
	assign L1[703:700] = sbox[ { round_in[175], state_in[703:700] } ];
	assign L1[699:696] = sbox[ { round_in[174], state_in[699:696] } ];
	assign L1[695:692] = sbox[ { round_in[173], state_in[695:692] } ];
	assign L1[691:688] = sbox[ { round_in[172], state_in[691:688] } ];
	assign L1[687:684] = sbox[ { round_in[171], state_in[687:684] } ];
	assign L1[683:680] = sbox[ { round_in[170], state_in[683:680] } ];
	assign L1[679:676] = sbox[ { round_in[169], state_in[679:676] } ];
	assign L1[675:672] = sbox[ { round_in[168], state_in[675:672] } ];
	assign L1[671:668] = sbox[ { round_in[167], state_in[671:668] } ];
	assign L1[667:664] = sbox[ { round_in[166], state_in[667:664] } ];
	assign L1[663:660] = sbox[ { round_in[165], state_in[663:660] } ];
	assign L1[659:656] = sbox[ { round_in[164], state_in[659:656] } ];
	assign L1[655:652] = sbox[ { round_in[163], state_in[655:652] } ];
	assign L1[651:648] = sbox[ { round_in[162], state_in[651:648] } ];
	assign L1[647:644] = sbox[ { round_in[161], state_in[647:644] } ];
	assign L1[643:640] = sbox[ { round_in[160], state_in[643:640] } ];
	assign L1[639:636] = sbox[ { round_in[159], state_in[639:636] } ];
	assign L1[635:632] = sbox[ { round_in[158], state_in[635:632] } ];
	assign L1[631:628] = sbox[ { round_in[157], state_in[631:628] } ];
	assign L1[627:624] = sbox[ { round_in[156], state_in[627:624] } ];
	assign L1[623:620] = sbox[ { round_in[155], state_in[623:620] } ];
	assign L1[619:616] = sbox[ { round_in[154], state_in[619:616] } ];
	assign L1[615:612] = sbox[ { round_in[153], state_in[615:612] } ];
	assign L1[611:608] = sbox[ { round_in[152], state_in[611:608] } ];
	assign L1[607:604] = sbox[ { round_in[151], state_in[607:604] } ];
	assign L1[603:600] = sbox[ { round_in[150], state_in[603:600] } ];
	assign L1[599:596] = sbox[ { round_in[149], state_in[599:596] } ];
	assign L1[595:592] = sbox[ { round_in[148], state_in[595:592] } ];
	assign L1[591:588] = sbox[ { round_in[147], state_in[591:588] } ];
	assign L1[587:584] = sbox[ { round_in[146], state_in[587:584] } ];
	assign L1[583:580] = sbox[ { round_in[145], state_in[583:580] } ];
	assign L1[579:576] = sbox[ { round_in[144], state_in[579:576] } ];
	assign L1[575:572] = sbox[ { round_in[143], state_in[575:572] } ];
	assign L1[571:568] = sbox[ { round_in[142], state_in[571:568] } ];
	assign L1[567:564] = sbox[ { round_in[141], state_in[567:564] } ];
	assign L1[563:560] = sbox[ { round_in[140], state_in[563:560] } ];
	assign L1[559:556] = sbox[ { round_in[139], state_in[559:556] } ];
	assign L1[555:552] = sbox[ { round_in[138], state_in[555:552] } ];
	assign L1[551:548] = sbox[ { round_in[137], state_in[551:548] } ];
	assign L1[547:544] = sbox[ { round_in[136], state_in[547:544] } ];
	assign L1[543:540] = sbox[ { round_in[135], state_in[543:540] } ];
	assign L1[539:536] = sbox[ { round_in[134], state_in[539:536] } ];
	assign L1[535:532] = sbox[ { round_in[133], state_in[535:532] } ];
	assign L1[531:528] = sbox[ { round_in[132], state_in[531:528] } ];
	assign L1[527:524] = sbox[ { round_in[131], state_in[527:524] } ];
	assign L1[523:520] = sbox[ { round_in[130], state_in[523:520] } ];
	assign L1[519:516] = sbox[ { round_in[129], state_in[519:516] } ];
	assign L1[515:512] = sbox[ { round_in[128], state_in[515:512] } ];
	assign L1[511:508] = sbox[ { round_in[127], state_in[511:508] } ];
	assign L1[507:504] = sbox[ { round_in[126], state_in[507:504] } ];
	assign L1[503:500] = sbox[ { round_in[125], state_in[503:500] } ];
	assign L1[499:496] = sbox[ { round_in[124], state_in[499:496] } ];
	assign L1[495:492] = sbox[ { round_in[123], state_in[495:492] } ];
	assign L1[491:488] = sbox[ { round_in[122], state_in[491:488] } ];
	assign L1[487:484] = sbox[ { round_in[121], state_in[487:484] } ];
	assign L1[483:480] = sbox[ { round_in[120], state_in[483:480] } ];
	assign L1[479:476] = sbox[ { round_in[119], state_in[479:476] } ];
	assign L1[475:472] = sbox[ { round_in[118], state_in[475:472] } ];
	assign L1[471:468] = sbox[ { round_in[117], state_in[471:468] } ];
	assign L1[467:464] = sbox[ { round_in[116], state_in[467:464] } ];
	assign L1[463:460] = sbox[ { round_in[115], state_in[463:460] } ];
	assign L1[459:456] = sbox[ { round_in[114], state_in[459:456] } ];
	assign L1[455:452] = sbox[ { round_in[113], state_in[455:452] } ];
	assign L1[451:448] = sbox[ { round_in[112], state_in[451:448] } ];
	assign L1[447:444] = sbox[ { round_in[111], state_in[447:444] } ];
	assign L1[443:440] = sbox[ { round_in[110], state_in[443:440] } ];
	assign L1[439:436] = sbox[ { round_in[109], state_in[439:436] } ];
	assign L1[435:432] = sbox[ { round_in[108], state_in[435:432] } ];
	assign L1[431:428] = sbox[ { round_in[107], state_in[431:428] } ];
	assign L1[427:424] = sbox[ { round_in[106], state_in[427:424] } ];
	assign L1[423:420] = sbox[ { round_in[105], state_in[423:420] } ];
	assign L1[419:416] = sbox[ { round_in[104], state_in[419:416] } ];
	assign L1[415:412] = sbox[ { round_in[103], state_in[415:412] } ];
	assign L1[411:408] = sbox[ { round_in[102], state_in[411:408] } ];
	assign L1[407:404] = sbox[ { round_in[101], state_in[407:404] } ];
	assign L1[403:400] = sbox[ { round_in[100], state_in[403:400] } ];
	assign L1[399:396] = sbox[ { round_in[99], state_in[399:396] } ];
	assign L1[395:392] = sbox[ { round_in[98], state_in[395:392] } ];
	assign L1[391:388] = sbox[ { round_in[97], state_in[391:388] } ];
	assign L1[387:384] = sbox[ { round_in[96], state_in[387:384] } ];
	assign L1[383:380] = sbox[ { round_in[95], state_in[383:380] } ];
	assign L1[379:376] = sbox[ { round_in[94], state_in[379:376] } ];
	assign L1[375:372] = sbox[ { round_in[93], state_in[375:372] } ];
	assign L1[371:368] = sbox[ { round_in[92], state_in[371:368] } ];
	assign L1[367:364] = sbox[ { round_in[91], state_in[367:364] } ];
	assign L1[363:360] = sbox[ { round_in[90], state_in[363:360] } ];
	assign L1[359:356] = sbox[ { round_in[89], state_in[359:356] } ];
	assign L1[355:352] = sbox[ { round_in[88], state_in[355:352] } ];
	assign L1[351:348] = sbox[ { round_in[87], state_in[351:348] } ];
	assign L1[347:344] = sbox[ { round_in[86], state_in[347:344] } ];
	assign L1[343:340] = sbox[ { round_in[85], state_in[343:340] } ];
	assign L1[339:336] = sbox[ { round_in[84], state_in[339:336] } ];
	assign L1[335:332] = sbox[ { round_in[83], state_in[335:332] } ];
	assign L1[331:328] = sbox[ { round_in[82], state_in[331:328] } ];
	assign L1[327:324] = sbox[ { round_in[81], state_in[327:324] } ];
	assign L1[323:320] = sbox[ { round_in[80], state_in[323:320] } ];
	assign L1[319:316] = sbox[ { round_in[79], state_in[319:316] } ];
	assign L1[315:312] = sbox[ { round_in[78], state_in[315:312] } ];
	assign L1[311:308] = sbox[ { round_in[77], state_in[311:308] } ];
	assign L1[307:304] = sbox[ { round_in[76], state_in[307:304] } ];
	assign L1[303:300] = sbox[ { round_in[75], state_in[303:300] } ];
	assign L1[299:296] = sbox[ { round_in[74], state_in[299:296] } ];
	assign L1[295:292] = sbox[ { round_in[73], state_in[295:292] } ];
	assign L1[291:288] = sbox[ { round_in[72], state_in[291:288] } ];
	assign L1[287:284] = sbox[ { round_in[71], state_in[287:284] } ];
	assign L1[283:280] = sbox[ { round_in[70], state_in[283:280] } ];
	assign L1[279:276] = sbox[ { round_in[69], state_in[279:276] } ];
	assign L1[275:272] = sbox[ { round_in[68], state_in[275:272] } ];
	assign L1[271:268] = sbox[ { round_in[67], state_in[271:268] } ];
	assign L1[267:264] = sbox[ { round_in[66], state_in[267:264] } ];
	assign L1[263:260] = sbox[ { round_in[65], state_in[263:260] } ];
	assign L1[259:256] = sbox[ { round_in[64], state_in[259:256] } ];
	assign L1[255:252] = sbox[ { round_in[63], state_in[255:252] } ];
	assign L1[251:248] = sbox[ { round_in[62], state_in[251:248] } ];
	assign L1[247:244] = sbox[ { round_in[61], state_in[247:244] } ];
	assign L1[243:240] = sbox[ { round_in[60], state_in[243:240] } ];
	assign L1[239:236] = sbox[ { round_in[59], state_in[239:236] } ];
	assign L1[235:232] = sbox[ { round_in[58], state_in[235:232] } ];
	assign L1[231:228] = sbox[ { round_in[57], state_in[231:228] } ];
	assign L1[227:224] = sbox[ { round_in[56], state_in[227:224] } ];
	assign L1[223:220] = sbox[ { round_in[55], state_in[223:220] } ];
	assign L1[219:216] = sbox[ { round_in[54], state_in[219:216] } ];
	assign L1[215:212] = sbox[ { round_in[53], state_in[215:212] } ];
	assign L1[211:208] = sbox[ { round_in[52], state_in[211:208] } ];
	assign L1[207:204] = sbox[ { round_in[51], state_in[207:204] } ];
	assign L1[203:200] = sbox[ { round_in[50], state_in[203:200] } ];
	assign L1[199:196] = sbox[ { round_in[49], state_in[199:196] } ];
	assign L1[195:192] = sbox[ { round_in[48], state_in[195:192] } ];
	assign L1[191:188] = sbox[ { round_in[47], state_in[191:188] } ];
	assign L1[187:184] = sbox[ { round_in[46], state_in[187:184] } ];
	assign L1[183:180] = sbox[ { round_in[45], state_in[183:180] } ];
	assign L1[179:176] = sbox[ { round_in[44], state_in[179:176] } ];
	assign L1[175:172] = sbox[ { round_in[43], state_in[175:172] } ];
	assign L1[171:168] = sbox[ { round_in[42], state_in[171:168] } ];
	assign L1[167:164] = sbox[ { round_in[41], state_in[167:164] } ];
	assign L1[163:160] = sbox[ { round_in[40], state_in[163:160] } ];
	assign L1[159:156] = sbox[ { round_in[39], state_in[159:156] } ];
	assign L1[155:152] = sbox[ { round_in[38], state_in[155:152] } ];
	assign L1[151:148] = sbox[ { round_in[37], state_in[151:148] } ];
	assign L1[147:144] = sbox[ { round_in[36], state_in[147:144] } ];
	assign L1[143:140] = sbox[ { round_in[35], state_in[143:140] } ];
	assign L1[139:136] = sbox[ { round_in[34], state_in[139:136] } ];
	assign L1[135:132] = sbox[ { round_in[33], state_in[135:132] } ];
	assign L1[131:128] = sbox[ { round_in[32], state_in[131:128] } ];
	assign L1[127:124] = sbox[ { round_in[31], state_in[127:124] } ];
	assign L1[123:120] = sbox[ { round_in[30], state_in[123:120] } ];
	assign L1[119:116] = sbox[ { round_in[29], state_in[119:116] } ];
	assign L1[115:112] = sbox[ { round_in[28], state_in[115:112] } ];
	assign L1[111:108] = sbox[ { round_in[27], state_in[111:108] } ];
	assign L1[107:104] = sbox[ { round_in[26], state_in[107:104] } ];
	assign L1[103:100] = sbox[ { round_in[25], state_in[103:100] } ];
	assign L1[99:96] = sbox[ { round_in[24], state_in[99:96] } ];
	assign L1[95:92] = sbox[ { round_in[23], state_in[95:92] } ];
	assign L1[91:88] = sbox[ { round_in[22], state_in[91:88] } ];
	assign L1[87:84] = sbox[ { round_in[21], state_in[87:84] } ];
	assign L1[83:80] = sbox[ { round_in[20], state_in[83:80] } ];
	assign L1[79:76] = sbox[ { round_in[19], state_in[79:76] } ];
	assign L1[75:72] = sbox[ { round_in[18], state_in[75:72] } ];
	assign L1[71:68] = sbox[ { round_in[17], state_in[71:68] } ];
	assign L1[67:64] = sbox[ { round_in[16], state_in[67:64] } ];
	assign L1[63:60] = sbox[ { round_in[15], state_in[63:60] } ];
	assign L1[59:56] = sbox[ { round_in[14], state_in[59:56] } ];
	assign L1[55:52] = sbox[ { round_in[13], state_in[55:52] } ];
	assign L1[51:48] = sbox[ { round_in[12], state_in[51:48] } ];
	assign L1[47:44] = sbox[ { round_in[11], state_in[47:44] } ];
	assign L1[43:40] = sbox[ { round_in[10], state_in[43:40] } ];
	assign L1[39:36] = sbox[ { round_in[9], state_in[39:36] } ];
	assign L1[35:32] = sbox[ { round_in[8], state_in[35:32] } ];
	assign L1[31:28] = sbox[ { round_in[7], state_in[31:28] } ];
	assign L1[27:24] = sbox[ { round_in[6], state_in[27:24] } ];
	assign L1[23:20] = sbox[ { round_in[5], state_in[23:20] } ];
	assign L1[19:16] = sbox[ { round_in[4], state_in[19:16] } ];
	assign L1[15:12] = sbox[ { round_in[3], state_in[15:12] } ];
	assign L1[11:8] = sbox[ { round_in[2], state_in[11:8] } ];
	assign L1[7:4] = sbox[ { round_in[1], state_in[7:4] } ];
	assign L1[3:0] = sbox[ { round_in[0], state_in[3:0] } ];

	assign L2[1023:1020] = L1[1023:1020] ^ {L1[1018:1016],1'b0} ^ {3'b0,L1[1019]} ^ {2'b0,L1[1019],1'b0};
	assign L2[1019:1016] = L1[1019:1016] ^ {L2[1023:1020],1'b0} ^ {3'b0,L2[1023]} ^ {2'b0,L2[1023],1'b0};
	assign L2[1015:1012] = L1[1015:1012] ^ {L1[1010:1008],1'b0} ^ {3'b0,L1[1011]} ^ {2'b0,L1[1011],1'b0};
	assign L2[1011:1008] = L1[1011:1008] ^ {L2[1015:1012],1'b0} ^ {3'b0,L2[1015]} ^ {2'b0,L2[1015],1'b0};
	assign L2[1007:1004] = L1[1007:1004] ^ {L1[1002:1000],1'b0} ^ {3'b0,L1[1003]} ^ {2'b0,L1[1003],1'b0};
	assign L2[1003:1000] = L1[1003:1000] ^ {L2[1007:1004],1'b0} ^ {3'b0,L2[1007]} ^ {2'b0,L2[1007],1'b0};
	assign L2[999:996] = L1[999:996] ^ {L1[994:992],1'b0} ^ {3'b0,L1[995]} ^ {2'b0,L1[995],1'b0};
	assign L2[995:992] = L1[995:992] ^ {L2[999:996],1'b0} ^ {3'b0,L2[999]} ^ {2'b0,L2[999],1'b0};
	assign L2[991:988] = L1[991:988] ^ {L1[986:984],1'b0} ^ {3'b0,L1[987]} ^ {2'b0,L1[987],1'b0};
	assign L2[987:984] = L1[987:984] ^ {L2[991:988],1'b0} ^ {3'b0,L2[991]} ^ {2'b0,L2[991],1'b0};
	assign L2[983:980] = L1[983:980] ^ {L1[978:976],1'b0} ^ {3'b0,L1[979]} ^ {2'b0,L1[979],1'b0};
	assign L2[979:976] = L1[979:976] ^ {L2[983:980],1'b0} ^ {3'b0,L2[983]} ^ {2'b0,L2[983],1'b0};
	assign L2[975:972] = L1[975:972] ^ {L1[970:968],1'b0} ^ {3'b0,L1[971]} ^ {2'b0,L1[971],1'b0};
	assign L2[971:968] = L1[971:968] ^ {L2[975:972],1'b0} ^ {3'b0,L2[975]} ^ {2'b0,L2[975],1'b0};
	assign L2[967:964] = L1[967:964] ^ {L1[962:960],1'b0} ^ {3'b0,L1[963]} ^ {2'b0,L1[963],1'b0};
	assign L2[963:960] = L1[963:960] ^ {L2[967:964],1'b0} ^ {3'b0,L2[967]} ^ {2'b0,L2[967],1'b0};
	assign L2[959:956] = L1[959:956] ^ {L1[954:952],1'b0} ^ {3'b0,L1[955]} ^ {2'b0,L1[955],1'b0};
	assign L2[955:952] = L1[955:952] ^ {L2[959:956],1'b0} ^ {3'b0,L2[959]} ^ {2'b0,L2[959],1'b0};
	assign L2[951:948] = L1[951:948] ^ {L1[946:944],1'b0} ^ {3'b0,L1[947]} ^ {2'b0,L1[947],1'b0};
	assign L2[947:944] = L1[947:944] ^ {L2[951:948],1'b0} ^ {3'b0,L2[951]} ^ {2'b0,L2[951],1'b0};
	assign L2[943:940] = L1[943:940] ^ {L1[938:936],1'b0} ^ {3'b0,L1[939]} ^ {2'b0,L1[939],1'b0};
	assign L2[939:936] = L1[939:936] ^ {L2[943:940],1'b0} ^ {3'b0,L2[943]} ^ {2'b0,L2[943],1'b0};
	assign L2[935:932] = L1[935:932] ^ {L1[930:928],1'b0} ^ {3'b0,L1[931]} ^ {2'b0,L1[931],1'b0};
	assign L2[931:928] = L1[931:928] ^ {L2[935:932],1'b0} ^ {3'b0,L2[935]} ^ {2'b0,L2[935],1'b0};
	assign L2[927:924] = L1[927:924] ^ {L1[922:920],1'b0} ^ {3'b0,L1[923]} ^ {2'b0,L1[923],1'b0};
	assign L2[923:920] = L1[923:920] ^ {L2[927:924],1'b0} ^ {3'b0,L2[927]} ^ {2'b0,L2[927],1'b0};
	assign L2[919:916] = L1[919:916] ^ {L1[914:912],1'b0} ^ {3'b0,L1[915]} ^ {2'b0,L1[915],1'b0};
	assign L2[915:912] = L1[915:912] ^ {L2[919:916],1'b0} ^ {3'b0,L2[919]} ^ {2'b0,L2[919],1'b0};
	assign L2[911:908] = L1[911:908] ^ {L1[906:904],1'b0} ^ {3'b0,L1[907]} ^ {2'b0,L1[907],1'b0};
	assign L2[907:904] = L1[907:904] ^ {L2[911:908],1'b0} ^ {3'b0,L2[911]} ^ {2'b0,L2[911],1'b0};
	assign L2[903:900] = L1[903:900] ^ {L1[898:896],1'b0} ^ {3'b0,L1[899]} ^ {2'b0,L1[899],1'b0};
	assign L2[899:896] = L1[899:896] ^ {L2[903:900],1'b0} ^ {3'b0,L2[903]} ^ {2'b0,L2[903],1'b0};
	assign L2[895:892] = L1[895:892] ^ {L1[890:888],1'b0} ^ {3'b0,L1[891]} ^ {2'b0,L1[891],1'b0};
	assign L2[891:888] = L1[891:888] ^ {L2[895:892],1'b0} ^ {3'b0,L2[895]} ^ {2'b0,L2[895],1'b0};
	assign L2[887:884] = L1[887:884] ^ {L1[882:880],1'b0} ^ {3'b0,L1[883]} ^ {2'b0,L1[883],1'b0};
	assign L2[883:880] = L1[883:880] ^ {L2[887:884],1'b0} ^ {3'b0,L2[887]} ^ {2'b0,L2[887],1'b0};
	assign L2[879:876] = L1[879:876] ^ {L1[874:872],1'b0} ^ {3'b0,L1[875]} ^ {2'b0,L1[875],1'b0};
	assign L2[875:872] = L1[875:872] ^ {L2[879:876],1'b0} ^ {3'b0,L2[879]} ^ {2'b0,L2[879],1'b0};
	assign L2[871:868] = L1[871:868] ^ {L1[866:864],1'b0} ^ {3'b0,L1[867]} ^ {2'b0,L1[867],1'b0};
	assign L2[867:864] = L1[867:864] ^ {L2[871:868],1'b0} ^ {3'b0,L2[871]} ^ {2'b0,L2[871],1'b0};
	assign L2[863:860] = L1[863:860] ^ {L1[858:856],1'b0} ^ {3'b0,L1[859]} ^ {2'b0,L1[859],1'b0};
	assign L2[859:856] = L1[859:856] ^ {L2[863:860],1'b0} ^ {3'b0,L2[863]} ^ {2'b0,L2[863],1'b0};
	assign L2[855:852] = L1[855:852] ^ {L1[850:848],1'b0} ^ {3'b0,L1[851]} ^ {2'b0,L1[851],1'b0};
	assign L2[851:848] = L1[851:848] ^ {L2[855:852],1'b0} ^ {3'b0,L2[855]} ^ {2'b0,L2[855],1'b0};
	assign L2[847:844] = L1[847:844] ^ {L1[842:840],1'b0} ^ {3'b0,L1[843]} ^ {2'b0,L1[843],1'b0};
	assign L2[843:840] = L1[843:840] ^ {L2[847:844],1'b0} ^ {3'b0,L2[847]} ^ {2'b0,L2[847],1'b0};
	assign L2[839:836] = L1[839:836] ^ {L1[834:832],1'b0} ^ {3'b0,L1[835]} ^ {2'b0,L1[835],1'b0};
	assign L2[835:832] = L1[835:832] ^ {L2[839:836],1'b0} ^ {3'b0,L2[839]} ^ {2'b0,L2[839],1'b0};
	assign L2[831:828] = L1[831:828] ^ {L1[826:824],1'b0} ^ {3'b0,L1[827]} ^ {2'b0,L1[827],1'b0};
	assign L2[827:824] = L1[827:824] ^ {L2[831:828],1'b0} ^ {3'b0,L2[831]} ^ {2'b0,L2[831],1'b0};
	assign L2[823:820] = L1[823:820] ^ {L1[818:816],1'b0} ^ {3'b0,L1[819]} ^ {2'b0,L1[819],1'b0};
	assign L2[819:816] = L1[819:816] ^ {L2[823:820],1'b0} ^ {3'b0,L2[823]} ^ {2'b0,L2[823],1'b0};
	assign L2[815:812] = L1[815:812] ^ {L1[810:808],1'b0} ^ {3'b0,L1[811]} ^ {2'b0,L1[811],1'b0};
	assign L2[811:808] = L1[811:808] ^ {L2[815:812],1'b0} ^ {3'b0,L2[815]} ^ {2'b0,L2[815],1'b0};
	assign L2[807:804] = L1[807:804] ^ {L1[802:800],1'b0} ^ {3'b0,L1[803]} ^ {2'b0,L1[803],1'b0};
	assign L2[803:800] = L1[803:800] ^ {L2[807:804],1'b0} ^ {3'b0,L2[807]} ^ {2'b0,L2[807],1'b0};
	assign L2[799:796] = L1[799:796] ^ {L1[794:792],1'b0} ^ {3'b0,L1[795]} ^ {2'b0,L1[795],1'b0};
	assign L2[795:792] = L1[795:792] ^ {L2[799:796],1'b0} ^ {3'b0,L2[799]} ^ {2'b0,L2[799],1'b0};
	assign L2[791:788] = L1[791:788] ^ {L1[786:784],1'b0} ^ {3'b0,L1[787]} ^ {2'b0,L1[787],1'b0};
	assign L2[787:784] = L1[787:784] ^ {L2[791:788],1'b0} ^ {3'b0,L2[791]} ^ {2'b0,L2[791],1'b0};
	assign L2[783:780] = L1[783:780] ^ {L1[778:776],1'b0} ^ {3'b0,L1[779]} ^ {2'b0,L1[779],1'b0};
	assign L2[779:776] = L1[779:776] ^ {L2[783:780],1'b0} ^ {3'b0,L2[783]} ^ {2'b0,L2[783],1'b0};
	assign L2[775:772] = L1[775:772] ^ {L1[770:768],1'b0} ^ {3'b0,L1[771]} ^ {2'b0,L1[771],1'b0};
	assign L2[771:768] = L1[771:768] ^ {L2[775:772],1'b0} ^ {3'b0,L2[775]} ^ {2'b0,L2[775],1'b0};
	assign L2[767:764] = L1[767:764] ^ {L1[762:760],1'b0} ^ {3'b0,L1[763]} ^ {2'b0,L1[763],1'b0};
	assign L2[763:760] = L1[763:760] ^ {L2[767:764],1'b0} ^ {3'b0,L2[767]} ^ {2'b0,L2[767],1'b0};
	assign L2[759:756] = L1[759:756] ^ {L1[754:752],1'b0} ^ {3'b0,L1[755]} ^ {2'b0,L1[755],1'b0};
	assign L2[755:752] = L1[755:752] ^ {L2[759:756],1'b0} ^ {3'b0,L2[759]} ^ {2'b0,L2[759],1'b0};
	assign L2[751:748] = L1[751:748] ^ {L1[746:744],1'b0} ^ {3'b0,L1[747]} ^ {2'b0,L1[747],1'b0};
	assign L2[747:744] = L1[747:744] ^ {L2[751:748],1'b0} ^ {3'b0,L2[751]} ^ {2'b0,L2[751],1'b0};
	assign L2[743:740] = L1[743:740] ^ {L1[738:736],1'b0} ^ {3'b0,L1[739]} ^ {2'b0,L1[739],1'b0};
	assign L2[739:736] = L1[739:736] ^ {L2[743:740],1'b0} ^ {3'b0,L2[743]} ^ {2'b0,L2[743],1'b0};
	assign L2[735:732] = L1[735:732] ^ {L1[730:728],1'b0} ^ {3'b0,L1[731]} ^ {2'b0,L1[731],1'b0};
	assign L2[731:728] = L1[731:728] ^ {L2[735:732],1'b0} ^ {3'b0,L2[735]} ^ {2'b0,L2[735],1'b0};
	assign L2[727:724] = L1[727:724] ^ {L1[722:720],1'b0} ^ {3'b0,L1[723]} ^ {2'b0,L1[723],1'b0};
	assign L2[723:720] = L1[723:720] ^ {L2[727:724],1'b0} ^ {3'b0,L2[727]} ^ {2'b0,L2[727],1'b0};
	assign L2[719:716] = L1[719:716] ^ {L1[714:712],1'b0} ^ {3'b0,L1[715]} ^ {2'b0,L1[715],1'b0};
	assign L2[715:712] = L1[715:712] ^ {L2[719:716],1'b0} ^ {3'b0,L2[719]} ^ {2'b0,L2[719],1'b0};
	assign L2[711:708] = L1[711:708] ^ {L1[706:704],1'b0} ^ {3'b0,L1[707]} ^ {2'b0,L1[707],1'b0};
	assign L2[707:704] = L1[707:704] ^ {L2[711:708],1'b0} ^ {3'b0,L2[711]} ^ {2'b0,L2[711],1'b0};
	assign L2[703:700] = L1[703:700] ^ {L1[698:696],1'b0} ^ {3'b0,L1[699]} ^ {2'b0,L1[699],1'b0};
	assign L2[699:696] = L1[699:696] ^ {L2[703:700],1'b0} ^ {3'b0,L2[703]} ^ {2'b0,L2[703],1'b0};
	assign L2[695:692] = L1[695:692] ^ {L1[690:688],1'b0} ^ {3'b0,L1[691]} ^ {2'b0,L1[691],1'b0};
	assign L2[691:688] = L1[691:688] ^ {L2[695:692],1'b0} ^ {3'b0,L2[695]} ^ {2'b0,L2[695],1'b0};
	assign L2[687:684] = L1[687:684] ^ {L1[682:680],1'b0} ^ {3'b0,L1[683]} ^ {2'b0,L1[683],1'b0};
	assign L2[683:680] = L1[683:680] ^ {L2[687:684],1'b0} ^ {3'b0,L2[687]} ^ {2'b0,L2[687],1'b0};
	assign L2[679:676] = L1[679:676] ^ {L1[674:672],1'b0} ^ {3'b0,L1[675]} ^ {2'b0,L1[675],1'b0};
	assign L2[675:672] = L1[675:672] ^ {L2[679:676],1'b0} ^ {3'b0,L2[679]} ^ {2'b0,L2[679],1'b0};
	assign L2[671:668] = L1[671:668] ^ {L1[666:664],1'b0} ^ {3'b0,L1[667]} ^ {2'b0,L1[667],1'b0};
	assign L2[667:664] = L1[667:664] ^ {L2[671:668],1'b0} ^ {3'b0,L2[671]} ^ {2'b0,L2[671],1'b0};
	assign L2[663:660] = L1[663:660] ^ {L1[658:656],1'b0} ^ {3'b0,L1[659]} ^ {2'b0,L1[659],1'b0};
	assign L2[659:656] = L1[659:656] ^ {L2[663:660],1'b0} ^ {3'b0,L2[663]} ^ {2'b0,L2[663],1'b0};
	assign L2[655:652] = L1[655:652] ^ {L1[650:648],1'b0} ^ {3'b0,L1[651]} ^ {2'b0,L1[651],1'b0};
	assign L2[651:648] = L1[651:648] ^ {L2[655:652],1'b0} ^ {3'b0,L2[655]} ^ {2'b0,L2[655],1'b0};
	assign L2[647:644] = L1[647:644] ^ {L1[642:640],1'b0} ^ {3'b0,L1[643]} ^ {2'b0,L1[643],1'b0};
	assign L2[643:640] = L1[643:640] ^ {L2[647:644],1'b0} ^ {3'b0,L2[647]} ^ {2'b0,L2[647],1'b0};
	assign L2[639:636] = L1[639:636] ^ {L1[634:632],1'b0} ^ {3'b0,L1[635]} ^ {2'b0,L1[635],1'b0};
	assign L2[635:632] = L1[635:632] ^ {L2[639:636],1'b0} ^ {3'b0,L2[639]} ^ {2'b0,L2[639],1'b0};
	assign L2[631:628] = L1[631:628] ^ {L1[626:624],1'b0} ^ {3'b0,L1[627]} ^ {2'b0,L1[627],1'b0};
	assign L2[627:624] = L1[627:624] ^ {L2[631:628],1'b0} ^ {3'b0,L2[631]} ^ {2'b0,L2[631],1'b0};
	assign L2[623:620] = L1[623:620] ^ {L1[618:616],1'b0} ^ {3'b0,L1[619]} ^ {2'b0,L1[619],1'b0};
	assign L2[619:616] = L1[619:616] ^ {L2[623:620],1'b0} ^ {3'b0,L2[623]} ^ {2'b0,L2[623],1'b0};
	assign L2[615:612] = L1[615:612] ^ {L1[610:608],1'b0} ^ {3'b0,L1[611]} ^ {2'b0,L1[611],1'b0};
	assign L2[611:608] = L1[611:608] ^ {L2[615:612],1'b0} ^ {3'b0,L2[615]} ^ {2'b0,L2[615],1'b0};
	assign L2[607:604] = L1[607:604] ^ {L1[602:600],1'b0} ^ {3'b0,L1[603]} ^ {2'b0,L1[603],1'b0};
	assign L2[603:600] = L1[603:600] ^ {L2[607:604],1'b0} ^ {3'b0,L2[607]} ^ {2'b0,L2[607],1'b0};
	assign L2[599:596] = L1[599:596] ^ {L1[594:592],1'b0} ^ {3'b0,L1[595]} ^ {2'b0,L1[595],1'b0};
	assign L2[595:592] = L1[595:592] ^ {L2[599:596],1'b0} ^ {3'b0,L2[599]} ^ {2'b0,L2[599],1'b0};
	assign L2[591:588] = L1[591:588] ^ {L1[586:584],1'b0} ^ {3'b0,L1[587]} ^ {2'b0,L1[587],1'b0};
	assign L2[587:584] = L1[587:584] ^ {L2[591:588],1'b0} ^ {3'b0,L2[591]} ^ {2'b0,L2[591],1'b0};
	assign L2[583:580] = L1[583:580] ^ {L1[578:576],1'b0} ^ {3'b0,L1[579]} ^ {2'b0,L1[579],1'b0};
	assign L2[579:576] = L1[579:576] ^ {L2[583:580],1'b0} ^ {3'b0,L2[583]} ^ {2'b0,L2[583],1'b0};
	assign L2[575:572] = L1[575:572] ^ {L1[570:568],1'b0} ^ {3'b0,L1[571]} ^ {2'b0,L1[571],1'b0};
	assign L2[571:568] = L1[571:568] ^ {L2[575:572],1'b0} ^ {3'b0,L2[575]} ^ {2'b0,L2[575],1'b0};
	assign L2[567:564] = L1[567:564] ^ {L1[562:560],1'b0} ^ {3'b0,L1[563]} ^ {2'b0,L1[563],1'b0};
	assign L2[563:560] = L1[563:560] ^ {L2[567:564],1'b0} ^ {3'b0,L2[567]} ^ {2'b0,L2[567],1'b0};
	assign L2[559:556] = L1[559:556] ^ {L1[554:552],1'b0} ^ {3'b0,L1[555]} ^ {2'b0,L1[555],1'b0};
	assign L2[555:552] = L1[555:552] ^ {L2[559:556],1'b0} ^ {3'b0,L2[559]} ^ {2'b0,L2[559],1'b0};
	assign L2[551:548] = L1[551:548] ^ {L1[546:544],1'b0} ^ {3'b0,L1[547]} ^ {2'b0,L1[547],1'b0};
	assign L2[547:544] = L1[547:544] ^ {L2[551:548],1'b0} ^ {3'b0,L2[551]} ^ {2'b0,L2[551],1'b0};
	assign L2[543:540] = L1[543:540] ^ {L1[538:536],1'b0} ^ {3'b0,L1[539]} ^ {2'b0,L1[539],1'b0};
	assign L2[539:536] = L1[539:536] ^ {L2[543:540],1'b0} ^ {3'b0,L2[543]} ^ {2'b0,L2[543],1'b0};
	assign L2[535:532] = L1[535:532] ^ {L1[530:528],1'b0} ^ {3'b0,L1[531]} ^ {2'b0,L1[531],1'b0};
	assign L2[531:528] = L1[531:528] ^ {L2[535:532],1'b0} ^ {3'b0,L2[535]} ^ {2'b0,L2[535],1'b0};
	assign L2[527:524] = L1[527:524] ^ {L1[522:520],1'b0} ^ {3'b0,L1[523]} ^ {2'b0,L1[523],1'b0};
	assign L2[523:520] = L1[523:520] ^ {L2[527:524],1'b0} ^ {3'b0,L2[527]} ^ {2'b0,L2[527],1'b0};
	assign L2[519:516] = L1[519:516] ^ {L1[514:512],1'b0} ^ {3'b0,L1[515]} ^ {2'b0,L1[515],1'b0};
	assign L2[515:512] = L1[515:512] ^ {L2[519:516],1'b0} ^ {3'b0,L2[519]} ^ {2'b0,L2[519],1'b0};
	assign L2[511:508] = L1[511:508] ^ {L1[506:504],1'b0} ^ {3'b0,L1[507]} ^ {2'b0,L1[507],1'b0};
	assign L2[507:504] = L1[507:504] ^ {L2[511:508],1'b0} ^ {3'b0,L2[511]} ^ {2'b0,L2[511],1'b0};
	assign L2[503:500] = L1[503:500] ^ {L1[498:496],1'b0} ^ {3'b0,L1[499]} ^ {2'b0,L1[499],1'b0};
	assign L2[499:496] = L1[499:496] ^ {L2[503:500],1'b0} ^ {3'b0,L2[503]} ^ {2'b0,L2[503],1'b0};
	assign L2[495:492] = L1[495:492] ^ {L1[490:488],1'b0} ^ {3'b0,L1[491]} ^ {2'b0,L1[491],1'b0};
	assign L2[491:488] = L1[491:488] ^ {L2[495:492],1'b0} ^ {3'b0,L2[495]} ^ {2'b0,L2[495],1'b0};
	assign L2[487:484] = L1[487:484] ^ {L1[482:480],1'b0} ^ {3'b0,L1[483]} ^ {2'b0,L1[483],1'b0};
	assign L2[483:480] = L1[483:480] ^ {L2[487:484],1'b0} ^ {3'b0,L2[487]} ^ {2'b0,L2[487],1'b0};
	assign L2[479:476] = L1[479:476] ^ {L1[474:472],1'b0} ^ {3'b0,L1[475]} ^ {2'b0,L1[475],1'b0};
	assign L2[475:472] = L1[475:472] ^ {L2[479:476],1'b0} ^ {3'b0,L2[479]} ^ {2'b0,L2[479],1'b0};
	assign L2[471:468] = L1[471:468] ^ {L1[466:464],1'b0} ^ {3'b0,L1[467]} ^ {2'b0,L1[467],1'b0};
	assign L2[467:464] = L1[467:464] ^ {L2[471:468],1'b0} ^ {3'b0,L2[471]} ^ {2'b0,L2[471],1'b0};
	assign L2[463:460] = L1[463:460] ^ {L1[458:456],1'b0} ^ {3'b0,L1[459]} ^ {2'b0,L1[459],1'b0};
	assign L2[459:456] = L1[459:456] ^ {L2[463:460],1'b0} ^ {3'b0,L2[463]} ^ {2'b0,L2[463],1'b0};
	assign L2[455:452] = L1[455:452] ^ {L1[450:448],1'b0} ^ {3'b0,L1[451]} ^ {2'b0,L1[451],1'b0};
	assign L2[451:448] = L1[451:448] ^ {L2[455:452],1'b0} ^ {3'b0,L2[455]} ^ {2'b0,L2[455],1'b0};
	assign L2[447:444] = L1[447:444] ^ {L1[442:440],1'b0} ^ {3'b0,L1[443]} ^ {2'b0,L1[443],1'b0};
	assign L2[443:440] = L1[443:440] ^ {L2[447:444],1'b0} ^ {3'b0,L2[447]} ^ {2'b0,L2[447],1'b0};
	assign L2[439:436] = L1[439:436] ^ {L1[434:432],1'b0} ^ {3'b0,L1[435]} ^ {2'b0,L1[435],1'b0};
	assign L2[435:432] = L1[435:432] ^ {L2[439:436],1'b0} ^ {3'b0,L2[439]} ^ {2'b0,L2[439],1'b0};
	assign L2[431:428] = L1[431:428] ^ {L1[426:424],1'b0} ^ {3'b0,L1[427]} ^ {2'b0,L1[427],1'b0};
	assign L2[427:424] = L1[427:424] ^ {L2[431:428],1'b0} ^ {3'b0,L2[431]} ^ {2'b0,L2[431],1'b0};
	assign L2[423:420] = L1[423:420] ^ {L1[418:416],1'b0} ^ {3'b0,L1[419]} ^ {2'b0,L1[419],1'b0};
	assign L2[419:416] = L1[419:416] ^ {L2[423:420],1'b0} ^ {3'b0,L2[423]} ^ {2'b0,L2[423],1'b0};
	assign L2[415:412] = L1[415:412] ^ {L1[410:408],1'b0} ^ {3'b0,L1[411]} ^ {2'b0,L1[411],1'b0};
	assign L2[411:408] = L1[411:408] ^ {L2[415:412],1'b0} ^ {3'b0,L2[415]} ^ {2'b0,L2[415],1'b0};
	assign L2[407:404] = L1[407:404] ^ {L1[402:400],1'b0} ^ {3'b0,L1[403]} ^ {2'b0,L1[403],1'b0};
	assign L2[403:400] = L1[403:400] ^ {L2[407:404],1'b0} ^ {3'b0,L2[407]} ^ {2'b0,L2[407],1'b0};
	assign L2[399:396] = L1[399:396] ^ {L1[394:392],1'b0} ^ {3'b0,L1[395]} ^ {2'b0,L1[395],1'b0};
	assign L2[395:392] = L1[395:392] ^ {L2[399:396],1'b0} ^ {3'b0,L2[399]} ^ {2'b0,L2[399],1'b0};
	assign L2[391:388] = L1[391:388] ^ {L1[386:384],1'b0} ^ {3'b0,L1[387]} ^ {2'b0,L1[387],1'b0};
	assign L2[387:384] = L1[387:384] ^ {L2[391:388],1'b0} ^ {3'b0,L2[391]} ^ {2'b0,L2[391],1'b0};
	assign L2[383:380] = L1[383:380] ^ {L1[378:376],1'b0} ^ {3'b0,L1[379]} ^ {2'b0,L1[379],1'b0};
	assign L2[379:376] = L1[379:376] ^ {L2[383:380],1'b0} ^ {3'b0,L2[383]} ^ {2'b0,L2[383],1'b0};
	assign L2[375:372] = L1[375:372] ^ {L1[370:368],1'b0} ^ {3'b0,L1[371]} ^ {2'b0,L1[371],1'b0};
	assign L2[371:368] = L1[371:368] ^ {L2[375:372],1'b0} ^ {3'b0,L2[375]} ^ {2'b0,L2[375],1'b0};
	assign L2[367:364] = L1[367:364] ^ {L1[362:360],1'b0} ^ {3'b0,L1[363]} ^ {2'b0,L1[363],1'b0};
	assign L2[363:360] = L1[363:360] ^ {L2[367:364],1'b0} ^ {3'b0,L2[367]} ^ {2'b0,L2[367],1'b0};
	assign L2[359:356] = L1[359:356] ^ {L1[354:352],1'b0} ^ {3'b0,L1[355]} ^ {2'b0,L1[355],1'b0};
	assign L2[355:352] = L1[355:352] ^ {L2[359:356],1'b0} ^ {3'b0,L2[359]} ^ {2'b0,L2[359],1'b0};
	assign L2[351:348] = L1[351:348] ^ {L1[346:344],1'b0} ^ {3'b0,L1[347]} ^ {2'b0,L1[347],1'b0};
	assign L2[347:344] = L1[347:344] ^ {L2[351:348],1'b0} ^ {3'b0,L2[351]} ^ {2'b0,L2[351],1'b0};
	assign L2[343:340] = L1[343:340] ^ {L1[338:336],1'b0} ^ {3'b0,L1[339]} ^ {2'b0,L1[339],1'b0};
	assign L2[339:336] = L1[339:336] ^ {L2[343:340],1'b0} ^ {3'b0,L2[343]} ^ {2'b0,L2[343],1'b0};
	assign L2[335:332] = L1[335:332] ^ {L1[330:328],1'b0} ^ {3'b0,L1[331]} ^ {2'b0,L1[331],1'b0};
	assign L2[331:328] = L1[331:328] ^ {L2[335:332],1'b0} ^ {3'b0,L2[335]} ^ {2'b0,L2[335],1'b0};
	assign L2[327:324] = L1[327:324] ^ {L1[322:320],1'b0} ^ {3'b0,L1[323]} ^ {2'b0,L1[323],1'b0};
	assign L2[323:320] = L1[323:320] ^ {L2[327:324],1'b0} ^ {3'b0,L2[327]} ^ {2'b0,L2[327],1'b0};
	assign L2[319:316] = L1[319:316] ^ {L1[314:312],1'b0} ^ {3'b0,L1[315]} ^ {2'b0,L1[315],1'b0};
	assign L2[315:312] = L1[315:312] ^ {L2[319:316],1'b0} ^ {3'b0,L2[319]} ^ {2'b0,L2[319],1'b0};
	assign L2[311:308] = L1[311:308] ^ {L1[306:304],1'b0} ^ {3'b0,L1[307]} ^ {2'b0,L1[307],1'b0};
	assign L2[307:304] = L1[307:304] ^ {L2[311:308],1'b0} ^ {3'b0,L2[311]} ^ {2'b0,L2[311],1'b0};
	assign L2[303:300] = L1[303:300] ^ {L1[298:296],1'b0} ^ {3'b0,L1[299]} ^ {2'b0,L1[299],1'b0};
	assign L2[299:296] = L1[299:296] ^ {L2[303:300],1'b0} ^ {3'b0,L2[303]} ^ {2'b0,L2[303],1'b0};
	assign L2[295:292] = L1[295:292] ^ {L1[290:288],1'b0} ^ {3'b0,L1[291]} ^ {2'b0,L1[291],1'b0};
	assign L2[291:288] = L1[291:288] ^ {L2[295:292],1'b0} ^ {3'b0,L2[295]} ^ {2'b0,L2[295],1'b0};
	assign L2[287:284] = L1[287:284] ^ {L1[282:280],1'b0} ^ {3'b0,L1[283]} ^ {2'b0,L1[283],1'b0};
	assign L2[283:280] = L1[283:280] ^ {L2[287:284],1'b0} ^ {3'b0,L2[287]} ^ {2'b0,L2[287],1'b0};
	assign L2[279:276] = L1[279:276] ^ {L1[274:272],1'b0} ^ {3'b0,L1[275]} ^ {2'b0,L1[275],1'b0};
	assign L2[275:272] = L1[275:272] ^ {L2[279:276],1'b0} ^ {3'b0,L2[279]} ^ {2'b0,L2[279],1'b0};
	assign L2[271:268] = L1[271:268] ^ {L1[266:264],1'b0} ^ {3'b0,L1[267]} ^ {2'b0,L1[267],1'b0};
	assign L2[267:264] = L1[267:264] ^ {L2[271:268],1'b0} ^ {3'b0,L2[271]} ^ {2'b0,L2[271],1'b0};
	assign L2[263:260] = L1[263:260] ^ {L1[258:256],1'b0} ^ {3'b0,L1[259]} ^ {2'b0,L1[259],1'b0};
	assign L2[259:256] = L1[259:256] ^ {L2[263:260],1'b0} ^ {3'b0,L2[263]} ^ {2'b0,L2[263],1'b0};
	assign L2[255:252] = L1[255:252] ^ {L1[250:248],1'b0} ^ {3'b0,L1[251]} ^ {2'b0,L1[251],1'b0};
	assign L2[251:248] = L1[251:248] ^ {L2[255:252],1'b0} ^ {3'b0,L2[255]} ^ {2'b0,L2[255],1'b0};
	assign L2[247:244] = L1[247:244] ^ {L1[242:240],1'b0} ^ {3'b0,L1[243]} ^ {2'b0,L1[243],1'b0};
	assign L2[243:240] = L1[243:240] ^ {L2[247:244],1'b0} ^ {3'b0,L2[247]} ^ {2'b0,L2[247],1'b0};
	assign L2[239:236] = L1[239:236] ^ {L1[234:232],1'b0} ^ {3'b0,L1[235]} ^ {2'b0,L1[235],1'b0};
	assign L2[235:232] = L1[235:232] ^ {L2[239:236],1'b0} ^ {3'b0,L2[239]} ^ {2'b0,L2[239],1'b0};
	assign L2[231:228] = L1[231:228] ^ {L1[226:224],1'b0} ^ {3'b0,L1[227]} ^ {2'b0,L1[227],1'b0};
	assign L2[227:224] = L1[227:224] ^ {L2[231:228],1'b0} ^ {3'b0,L2[231]} ^ {2'b0,L2[231],1'b0};
	assign L2[223:220] = L1[223:220] ^ {L1[218:216],1'b0} ^ {3'b0,L1[219]} ^ {2'b0,L1[219],1'b0};
	assign L2[219:216] = L1[219:216] ^ {L2[223:220],1'b0} ^ {3'b0,L2[223]} ^ {2'b0,L2[223],1'b0};
	assign L2[215:212] = L1[215:212] ^ {L1[210:208],1'b0} ^ {3'b0,L1[211]} ^ {2'b0,L1[211],1'b0};
	assign L2[211:208] = L1[211:208] ^ {L2[215:212],1'b0} ^ {3'b0,L2[215]} ^ {2'b0,L2[215],1'b0};
	assign L2[207:204] = L1[207:204] ^ {L1[202:200],1'b0} ^ {3'b0,L1[203]} ^ {2'b0,L1[203],1'b0};
	assign L2[203:200] = L1[203:200] ^ {L2[207:204],1'b0} ^ {3'b0,L2[207]} ^ {2'b0,L2[207],1'b0};
	assign L2[199:196] = L1[199:196] ^ {L1[194:192],1'b0} ^ {3'b0,L1[195]} ^ {2'b0,L1[195],1'b0};
	assign L2[195:192] = L1[195:192] ^ {L2[199:196],1'b0} ^ {3'b0,L2[199]} ^ {2'b0,L2[199],1'b0};
	assign L2[191:188] = L1[191:188] ^ {L1[186:184],1'b0} ^ {3'b0,L1[187]} ^ {2'b0,L1[187],1'b0};
	assign L2[187:184] = L1[187:184] ^ {L2[191:188],1'b0} ^ {3'b0,L2[191]} ^ {2'b0,L2[191],1'b0};
	assign L2[183:180] = L1[183:180] ^ {L1[178:176],1'b0} ^ {3'b0,L1[179]} ^ {2'b0,L1[179],1'b0};
	assign L2[179:176] = L1[179:176] ^ {L2[183:180],1'b0} ^ {3'b0,L2[183]} ^ {2'b0,L2[183],1'b0};
	assign L2[175:172] = L1[175:172] ^ {L1[170:168],1'b0} ^ {3'b0,L1[171]} ^ {2'b0,L1[171],1'b0};
	assign L2[171:168] = L1[171:168] ^ {L2[175:172],1'b0} ^ {3'b0,L2[175]} ^ {2'b0,L2[175],1'b0};
	assign L2[167:164] = L1[167:164] ^ {L1[162:160],1'b0} ^ {3'b0,L1[163]} ^ {2'b0,L1[163],1'b0};
	assign L2[163:160] = L1[163:160] ^ {L2[167:164],1'b0} ^ {3'b0,L2[167]} ^ {2'b0,L2[167],1'b0};
	assign L2[159:156] = L1[159:156] ^ {L1[154:152],1'b0} ^ {3'b0,L1[155]} ^ {2'b0,L1[155],1'b0};
	assign L2[155:152] = L1[155:152] ^ {L2[159:156],1'b0} ^ {3'b0,L2[159]} ^ {2'b0,L2[159],1'b0};
	assign L2[151:148] = L1[151:148] ^ {L1[146:144],1'b0} ^ {3'b0,L1[147]} ^ {2'b0,L1[147],1'b0};
	assign L2[147:144] = L1[147:144] ^ {L2[151:148],1'b0} ^ {3'b0,L2[151]} ^ {2'b0,L2[151],1'b0};
	assign L2[143:140] = L1[143:140] ^ {L1[138:136],1'b0} ^ {3'b0,L1[139]} ^ {2'b0,L1[139],1'b0};
	assign L2[139:136] = L1[139:136] ^ {L2[143:140],1'b0} ^ {3'b0,L2[143]} ^ {2'b0,L2[143],1'b0};
	assign L2[135:132] = L1[135:132] ^ {L1[130:128],1'b0} ^ {3'b0,L1[131]} ^ {2'b0,L1[131],1'b0};
	assign L2[131:128] = L1[131:128] ^ {L2[135:132],1'b0} ^ {3'b0,L2[135]} ^ {2'b0,L2[135],1'b0};
	assign L2[127:124] = L1[127:124] ^ {L1[122:120],1'b0} ^ {3'b0,L1[123]} ^ {2'b0,L1[123],1'b0};
	assign L2[123:120] = L1[123:120] ^ {L2[127:124],1'b0} ^ {3'b0,L2[127]} ^ {2'b0,L2[127],1'b0};
	assign L2[119:116] = L1[119:116] ^ {L1[114:112],1'b0} ^ {3'b0,L1[115]} ^ {2'b0,L1[115],1'b0};
	assign L2[115:112] = L1[115:112] ^ {L2[119:116],1'b0} ^ {3'b0,L2[119]} ^ {2'b0,L2[119],1'b0};
	assign L2[111:108] = L1[111:108] ^ {L1[106:104],1'b0} ^ {3'b0,L1[107]} ^ {2'b0,L1[107],1'b0};
	assign L2[107:104] = L1[107:104] ^ {L2[111:108],1'b0} ^ {3'b0,L2[111]} ^ {2'b0,L2[111],1'b0};
	assign L2[103:100] = L1[103:100] ^ {L1[98:96],1'b0} ^ {3'b0,L1[99]} ^ {2'b0,L1[99],1'b0};
	assign L2[99:96] = L1[99:96] ^ {L2[103:100],1'b0} ^ {3'b0,L2[103]} ^ {2'b0,L2[103],1'b0};
	assign L2[95:92] = L1[95:92] ^ {L1[90:88],1'b0} ^ {3'b0,L1[91]} ^ {2'b0,L1[91],1'b0};
	assign L2[91:88] = L1[91:88] ^ {L2[95:92],1'b0} ^ {3'b0,L2[95]} ^ {2'b0,L2[95],1'b0};
	assign L2[87:84] = L1[87:84] ^ {L1[82:80],1'b0} ^ {3'b0,L1[83]} ^ {2'b0,L1[83],1'b0};
	assign L2[83:80] = L1[83:80] ^ {L2[87:84],1'b0} ^ {3'b0,L2[87]} ^ {2'b0,L2[87],1'b0};
	assign L2[79:76] = L1[79:76] ^ {L1[74:72],1'b0} ^ {3'b0,L1[75]} ^ {2'b0,L1[75],1'b0};
	assign L2[75:72] = L1[75:72] ^ {L2[79:76],1'b0} ^ {3'b0,L2[79]} ^ {2'b0,L2[79],1'b0};
	assign L2[71:68] = L1[71:68] ^ {L1[66:64],1'b0} ^ {3'b0,L1[67]} ^ {2'b0,L1[67],1'b0};
	assign L2[67:64] = L1[67:64] ^ {L2[71:68],1'b0} ^ {3'b0,L2[71]} ^ {2'b0,L2[71],1'b0};
	assign L2[63:60] = L1[63:60] ^ {L1[58:56],1'b0} ^ {3'b0,L1[59]} ^ {2'b0,L1[59],1'b0};
	assign L2[59:56] = L1[59:56] ^ {L2[63:60],1'b0} ^ {3'b0,L2[63]} ^ {2'b0,L2[63],1'b0};
	assign L2[55:52] = L1[55:52] ^ {L1[50:48],1'b0} ^ {3'b0,L1[51]} ^ {2'b0,L1[51],1'b0};
	assign L2[51:48] = L1[51:48] ^ {L2[55:52],1'b0} ^ {3'b0,L2[55]} ^ {2'b0,L2[55],1'b0};
	assign L2[47:44] = L1[47:44] ^ {L1[42:40],1'b0} ^ {3'b0,L1[43]} ^ {2'b0,L1[43],1'b0};
	assign L2[43:40] = L1[43:40] ^ {L2[47:44],1'b0} ^ {3'b0,L2[47]} ^ {2'b0,L2[47],1'b0};
	assign L2[39:36] = L1[39:36] ^ {L1[34:32],1'b0} ^ {3'b0,L1[35]} ^ {2'b0,L1[35],1'b0};
	assign L2[35:32] = L1[35:32] ^ {L2[39:36],1'b0} ^ {3'b0,L2[39]} ^ {2'b0,L2[39],1'b0};
	assign L2[31:28] = L1[31:28] ^ {L1[26:24],1'b0} ^ {3'b0,L1[27]} ^ {2'b0,L1[27],1'b0};
	assign L2[27:24] = L1[27:24] ^ {L2[31:28],1'b0} ^ {3'b0,L2[31]} ^ {2'b0,L2[31],1'b0};
	assign L2[23:20] = L1[23:20] ^ {L1[18:16],1'b0} ^ {3'b0,L1[19]} ^ {2'b0,L1[19],1'b0};
	assign L2[19:16] = L1[19:16] ^ {L2[23:20],1'b0} ^ {3'b0,L2[23]} ^ {2'b0,L2[23],1'b0};
	assign L2[15:12] = L1[15:12] ^ {L1[10:8],1'b0} ^ {3'b0,L1[11]} ^ {2'b0,L1[11],1'b0};
	assign L2[11:8] = L1[11:8] ^ {L2[15:12],1'b0} ^ {3'b0,L2[15]} ^ {2'b0,L2[15],1'b0};
	assign L2[7:4] = L1[7:4] ^ {L1[2:0],1'b0} ^ {3'b0,L1[3]} ^ {2'b0,L1[3],1'b0};
	assign L2[3:0] = L1[3:0] ^ {L2[7:4],1'b0} ^ {3'b0,L2[7]} ^ {2'b0,L2[7],1'b0};

	assign out[1023:1020] = L2[1015:1012];
	assign out[1019:1016] = L2[1019:1016];
	assign out[1015:1012] = L2[999:996];
	assign out[1011:1008] = L2[1003:1000];
	assign out[1007:1004] = L2[983:980];
	assign out[1003:1000] = L2[987:984];
	assign out[999:996] = L2[967:964];
	assign out[995:992] = L2[971:968];
	assign out[991:988] = L2[951:948];
	assign out[987:984] = L2[955:952];
	assign out[983:980] = L2[935:932];
	assign out[979:976] = L2[939:936];
	assign out[975:972] = L2[919:916];
	assign out[971:968] = L2[923:920];
	assign out[967:964] = L2[903:900];
	assign out[963:960] = L2[907:904];
	assign out[959:956] = L2[887:884];
	assign out[955:952] = L2[891:888];
	assign out[951:948] = L2[871:868];
	assign out[947:944] = L2[875:872];
	assign out[943:940] = L2[855:852];
	assign out[939:936] = L2[859:856];
	assign out[935:932] = L2[839:836];
	assign out[931:928] = L2[843:840];
	assign out[927:924] = L2[823:820];
	assign out[923:920] = L2[827:824];
	assign out[919:916] = L2[807:804];
	assign out[915:912] = L2[811:808];
	assign out[911:908] = L2[791:788];
	assign out[907:904] = L2[795:792];
	assign out[903:900] = L2[775:772];
	assign out[899:896] = L2[779:776];
	assign out[895:892] = L2[759:756];
	assign out[891:888] = L2[763:760];
	assign out[887:884] = L2[743:740];
	assign out[883:880] = L2[747:744];
	assign out[879:876] = L2[727:724];
	assign out[875:872] = L2[731:728];
	assign out[871:868] = L2[711:708];
	assign out[867:864] = L2[715:712];
	assign out[863:860] = L2[695:692];
	assign out[859:856] = L2[699:696];
	assign out[855:852] = L2[679:676];
	assign out[851:848] = L2[683:680];
	assign out[847:844] = L2[663:660];
	assign out[843:840] = L2[667:664];
	assign out[839:836] = L2[647:644];
	assign out[835:832] = L2[651:648];
	assign out[831:828] = L2[631:628];
	assign out[827:824] = L2[635:632];
	assign out[823:820] = L2[615:612];
	assign out[819:816] = L2[619:616];
	assign out[815:812] = L2[599:596];
	assign out[811:808] = L2[603:600];
	assign out[807:804] = L2[583:580];
	assign out[803:800] = L2[587:584];
	assign out[799:796] = L2[567:564];
	assign out[795:792] = L2[571:568];
	assign out[791:788] = L2[551:548];
	assign out[787:784] = L2[555:552];
	assign out[783:780] = L2[535:532];
	assign out[779:776] = L2[539:536];
	assign out[775:772] = L2[519:516];
	assign out[771:768] = L2[523:520];
	assign out[767:764] = L2[503:500];
	assign out[763:760] = L2[507:504];
	assign out[759:756] = L2[487:484];
	assign out[755:752] = L2[491:488];
	assign out[751:748] = L2[471:468];
	assign out[747:744] = L2[475:472];
	assign out[743:740] = L2[455:452];
	assign out[739:736] = L2[459:456];
	assign out[735:732] = L2[439:436];
	assign out[731:728] = L2[443:440];
	assign out[727:724] = L2[423:420];
	assign out[723:720] = L2[427:424];
	assign out[719:716] = L2[407:404];
	assign out[715:712] = L2[411:408];
	assign out[711:708] = L2[391:388];
	assign out[707:704] = L2[395:392];
	assign out[703:700] = L2[375:372];
	assign out[699:696] = L2[379:376];
	assign out[695:692] = L2[359:356];
	assign out[691:688] = L2[363:360];
	assign out[687:684] = L2[343:340];
	assign out[683:680] = L2[347:344];
	assign out[679:676] = L2[327:324];
	assign out[675:672] = L2[331:328];
	assign out[671:668] = L2[311:308];
	assign out[667:664] = L2[315:312];
	assign out[663:660] = L2[295:292];
	assign out[659:656] = L2[299:296];
	assign out[655:652] = L2[279:276];
	assign out[651:648] = L2[283:280];
	assign out[647:644] = L2[263:260];
	assign out[643:640] = L2[267:264];
	assign out[639:636] = L2[247:244];
	assign out[635:632] = L2[251:248];
	assign out[631:628] = L2[231:228];
	assign out[627:624] = L2[235:232];
	assign out[623:620] = L2[215:212];
	assign out[619:616] = L2[219:216];
	assign out[615:612] = L2[199:196];
	assign out[611:608] = L2[203:200];
	assign out[607:604] = L2[183:180];
	assign out[603:600] = L2[187:184];
	assign out[599:596] = L2[167:164];
	assign out[595:592] = L2[171:168];
	assign out[591:588] = L2[151:148];
	assign out[587:584] = L2[155:152];
	assign out[583:580] = L2[135:132];
	assign out[579:576] = L2[139:136];
	assign out[575:572] = L2[119:116];
	assign out[571:568] = L2[123:120];
	assign out[567:564] = L2[103:100];
	assign out[563:560] = L2[107:104];
	assign out[559:556] = L2[87:84];
	assign out[555:552] = L2[91:88];
	assign out[551:548] = L2[71:68];
	assign out[547:544] = L2[75:72];
	assign out[543:540] = L2[55:52];
	assign out[539:536] = L2[59:56];
	assign out[535:532] = L2[39:36];
	assign out[531:528] = L2[43:40];
	assign out[527:524] = L2[23:20];
	assign out[523:520] = L2[27:24];
	assign out[519:516] = L2[7:4];
	assign out[515:512] = L2[11:8];
	assign out[511:508] = L2[1023:1020];
	assign out[507:504] = L2[1011:1008];
	assign out[503:500] = L2[1007:1004];
	assign out[499:496] = L2[995:992];
	assign out[495:492] = L2[991:988];
	assign out[491:488] = L2[979:976];
	assign out[487:484] = L2[975:972];
	assign out[483:480] = L2[963:960];
	assign out[479:476] = L2[959:956];
	assign out[475:472] = L2[947:944];
	assign out[471:468] = L2[943:940];
	assign out[467:464] = L2[931:928];
	assign out[463:460] = L2[927:924];
	assign out[459:456] = L2[915:912];
	assign out[455:452] = L2[911:908];
	assign out[451:448] = L2[899:896];
	assign out[447:444] = L2[895:892];
	assign out[443:440] = L2[883:880];
	assign out[439:436] = L2[879:876];
	assign out[435:432] = L2[867:864];
	assign out[431:428] = L2[863:860];
	assign out[427:424] = L2[851:848];
	assign out[423:420] = L2[847:844];
	assign out[419:416] = L2[835:832];
	assign out[415:412] = L2[831:828];
	assign out[411:408] = L2[819:816];
	assign out[407:404] = L2[815:812];
	assign out[403:400] = L2[803:800];
	assign out[399:396] = L2[799:796];
	assign out[395:392] = L2[787:784];
	assign out[391:388] = L2[783:780];
	assign out[387:384] = L2[771:768];
	assign out[383:380] = L2[767:764];
	assign out[379:376] = L2[755:752];
	assign out[375:372] = L2[751:748];
	assign out[371:368] = L2[739:736];
	assign out[367:364] = L2[735:732];
	assign out[363:360] = L2[723:720];
	assign out[359:356] = L2[719:716];
	assign out[355:352] = L2[707:704];
	assign out[351:348] = L2[703:700];
	assign out[347:344] = L2[691:688];
	assign out[343:340] = L2[687:684];
	assign out[339:336] = L2[675:672];
	assign out[335:332] = L2[671:668];
	assign out[331:328] = L2[659:656];
	assign out[327:324] = L2[655:652];
	assign out[323:320] = L2[643:640];
	assign out[319:316] = L2[639:636];
	assign out[315:312] = L2[627:624];
	assign out[311:308] = L2[623:620];
	assign out[307:304] = L2[611:608];
	assign out[303:300] = L2[607:604];
	assign out[299:296] = L2[595:592];
	assign out[295:292] = L2[591:588];
	assign out[291:288] = L2[579:576];
	assign out[287:284] = L2[575:572];
	assign out[283:280] = L2[563:560];
	assign out[279:276] = L2[559:556];
	assign out[275:272] = L2[547:544];
	assign out[271:268] = L2[543:540];
	assign out[267:264] = L2[531:528];
	assign out[263:260] = L2[527:524];
	assign out[259:256] = L2[515:512];
	assign out[255:252] = L2[511:508];
	assign out[251:248] = L2[499:496];
	assign out[247:244] = L2[495:492];
	assign out[243:240] = L2[483:480];
	assign out[239:236] = L2[479:476];
	assign out[235:232] = L2[467:464];
	assign out[231:228] = L2[463:460];
	assign out[227:224] = L2[451:448];
	assign out[223:220] = L2[447:444];
	assign out[219:216] = L2[435:432];
	assign out[215:212] = L2[431:428];
	assign out[211:208] = L2[419:416];
	assign out[207:204] = L2[415:412];
	assign out[203:200] = L2[403:400];
	assign out[199:196] = L2[399:396];
	assign out[195:192] = L2[387:384];
	assign out[191:188] = L2[383:380];
	assign out[187:184] = L2[371:368];
	assign out[183:180] = L2[367:364];
	assign out[179:176] = L2[355:352];
	assign out[175:172] = L2[351:348];
	assign out[171:168] = L2[339:336];
	assign out[167:164] = L2[335:332];
	assign out[163:160] = L2[323:320];
	assign out[159:156] = L2[319:316];
	assign out[155:152] = L2[307:304];
	assign out[151:148] = L2[303:300];
	assign out[147:144] = L2[291:288];
	assign out[143:140] = L2[287:284];
	assign out[139:136] = L2[275:272];
	assign out[135:132] = L2[271:268];
	assign out[131:128] = L2[259:256];
	assign out[127:124] = L2[255:252];
	assign out[123:120] = L2[243:240];
	assign out[119:116] = L2[239:236];
	assign out[115:112] = L2[227:224];
	assign out[111:108] = L2[223:220];
	assign out[107:104] = L2[211:208];
	assign out[103:100] = L2[207:204];
	assign out[99:96] = L2[195:192];
	assign out[95:92] = L2[191:188];
	assign out[91:88] = L2[179:176];
	assign out[87:84] = L2[175:172];
	assign out[83:80] = L2[163:160];
	assign out[79:76] = L2[159:156];
	assign out[75:72] = L2[147:144];
	assign out[71:68] = L2[143:140];
	assign out[67:64] = L2[131:128];
	assign out[63:60] = L2[127:124];
	assign out[59:56] = L2[115:112];
	assign out[55:52] = L2[111:108];
	assign out[51:48] = L2[99:96];
	assign out[47:44] = L2[95:92];
	assign out[43:40] = L2[83:80];
	assign out[39:36] = L2[79:76];
	assign out[35:32] = L2[67:64];
	assign out[31:28] = L2[63:60];
	assign out[27:24] = L2[51:48];
	assign out[23:20] = L2[47:44];
	assign out[19:16] = L2[35:32];
	assign out[15:12] = L2[31:28];
	assign out[11:8] = L2[19:16];
	assign out[7:4] = L2[15:12];
	assign out[3:0] = L2[3:0];

endmodule 

module update_round (
	input [255:0] round_in, 
	output [255:0] round_out
);

	localparam [63:0] S_box = 64'he85762a1f3cdb409;

	wire [3:0] round_in_array [63:0];
	wire [3:0] round_out_array [63:0];
	wire [3:0] LUT_out [63:0]; //correspond to tem
	wire [3:0] S_box_array [15:0];
	wire [3:0] L [63:0]; //tem after linear transform
	wire [3:0] init_swap [63:0]; //tem after init swap
	wire [3:0] perm [63:0]; //tem after perm
	wire [3:0] fin_swap [63:0]; //tem after final swap

	genvar i;
	generate
		for(i=0; i<64; i=i+1)
		begin: IO_conv
			assign round_in_array [i] = round_in [i*4+3:i*4];
			assign round_out [i*4+3:i*4] = round_out_array [i];						
		end
		
		for(i=0; i<16; i=i+1)
		begin: S_box0_conv
			assign S_box_array [i] = S_box [i*4+3:i*4];
		end

		for(i=0; i<64; i=i+1)
		begin: LUT
			assign LUT_out [i] = S_box_array [round_in_array[i]];
		end
		
		for(i=0; i<64; i=i+2)
		begin: L_Trans
			assign L[i] = LUT_out [i] ^ {L [i+1][2:0],1'b0} ^ {3'b0,L [i+1][3]} ^ {2'b0,L [i+1][3],1'b0};
			assign L[i+1] = LUT_out [i+1] ^ {LUT_out [i][2:0],1'b0} ^ {3'b0,LUT_out [i][3]} ^ {2'b0,LUT_out [i][3],1'b0};
		end
		
		for(i=0; i<64; i=i+4)
		begin: initial_swap
			assign init_swap [i] = L [i];
			assign init_swap [i+1] = L [i+1];
			assign init_swap [i+2] = L [i+3];
			assign init_swap [i+3] = L [i+2];
		end
		
		for(i=0; i<32; i=i+1)
		begin: permutation
			assign perm [i] = init_swap [2*i];
			assign perm [i+32] = init_swap [2*i+1];
		end
		
		for(i=0; i<32; i=i+1)
		begin: copy_fin_swap
			assign fin_swap [i] = perm [i];
		end
		
		for(i=32; i<64; i=i+2)
		begin: final_swap
			assign fin_swap [i] = perm [i+1];
			assign fin_swap [i+1] = perm [i];
		end
		
		for(i=0; i<64; i=i+1)
		begin: copy_output
			assign round_out_array [i] = fin_swap [i];
		end
	endgenerate

endmodule 


module E8f (
	input [1023:0] A,
	output [1023:0] H
);

	wire [3:0] state_A_out_arr [255:0];
	wire [3:0] degrouped [255:0]; //refering to tem after degrouping stage

	genvar i;
	generate

		for(i=0; i<256; i=i+1)
		begin: state_A_out_array
			assign state_A_out_arr [i] = A[i*4+3:i*4];
		end
		
		for(i=0; i<128; i=i+1)
		begin: debgrouping
			assign degrouped [i] = state_A_out_arr [i << 1];
			assign degrouped [i+128] = state_A_out_arr [(i << 1) + 1];
		end
		
		for(i=0; i < 256; i=i+1)
		begin: state_H
			assign H[7 + (i >> 3) * 8 - (i & 7)] = degrouped [i] [3];
			assign H[7 + ((i + 256) >> 3) * 8 - (i & 7)] = degrouped [i] [2];
			assign H[7 + ((i + 512) >> 3) * 8 - (i & 7)] = degrouped [i] [1];
			assign H[7 + ((i + 768) >> 3) * 8 - (i & 7)] = degrouped [i] [0];
		end
	endgenerate	
	
endmodule
