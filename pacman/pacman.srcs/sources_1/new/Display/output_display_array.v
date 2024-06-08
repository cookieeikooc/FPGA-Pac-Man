//Bing

module output_display_array (
    input clk,
    input h_sync,
    input v_sync,
    input [10:0] row,
    input [9:0] col,
    output [3:0] rgb_720p
);

    //Score 24 * 224
    //Board 248 * 224
    //Level 16 * 224
    wire board_ready;
    reg [7:0] board_row_counter = 8'd0;
    always @(posedge clk) begin
        if (board_ready == 1'b1 & row >= 11'd1280) begin
            if (board_row_counter == 8'd247) begin
                board_row_counter <= 8'd0;
            end
            else begin
                board_row_counter <= board_row_counter + 8'd1;
            end
        end
        else begin
            board_row_counter <= 8'd0;
        end
    end

    wire [2687:0] board_rgb;
    board_display_cache (
        .px_row(board_row_counter),
        .ready(board_ready),
        .rgb(board_rgb)
    );

    //Read Cache and Scale
    reg [11:0] rgb[0:287][0:223];
    always @(posedge clk) begin
        if (board_ready == 1'b1 & row >= 11'd1280) begin
            rgb[24 + board_row_counter][0] = board_rgb[2687:2676];
            rgb[24 + board_row_counter][1] = board_rgb[2675:2664];
            rgb[24 + board_row_counter][2] = board_rgb[2663:2652];
            rgb[24 + board_row_counter][3] = board_rgb[2651:2640];
            rgb[24 + board_row_counter][4] = board_rgb[2639:2628];
            rgb[24 + board_row_counter][5] = board_rgb[2627:2616];
            rgb[24 + board_row_counter][6] = board_rgb[2615:2604];
            rgb[24 + board_row_counter][7] = board_rgb[2603:2592];
            rgb[24 + board_row_counter][8] = board_rgb[2591:2580];
            rgb[24 + board_row_counter][9] = board_rgb[2579:2568];
            rgb[24 + board_row_counter][10] = board_rgb[2567:2556];
            rgb[24 + board_row_counter][11] = board_rgb[2555:2544];
            rgb[24 + board_row_counter][12] = board_rgb[2543:2532];
            rgb[24 + board_row_counter][13] = board_rgb[2531:2520];
            rgb[24 + board_row_counter][14] = board_rgb[2519:2508];
            rgb[24 + board_row_counter][15] = board_rgb[2507:2496];
            rgb[24 + board_row_counter][16] = board_rgb[2495:2484];
            rgb[24 + board_row_counter][17] = board_rgb[2483:2472];
            rgb[24 + board_row_counter][18] = board_rgb[2471:2460];
            rgb[24 + board_row_counter][19] = board_rgb[2459:2448];
            rgb[24 + board_row_counter][20] = board_rgb[2447:2436];
            rgb[24 + board_row_counter][21] = board_rgb[2435:2424];
            rgb[24 + board_row_counter][22] = board_rgb[2423:2412];
            rgb[24 + board_row_counter][23] = board_rgb[2411:2400];
            rgb[24 + board_row_counter][24] = board_rgb[2399:2388];
            rgb[24 + board_row_counter][25] = board_rgb[2387:2376];
            rgb[24 + board_row_counter][26] = board_rgb[2375:2364];
            rgb[24 + board_row_counter][27] = board_rgb[2363:2352];
            rgb[24 + board_row_counter][28] = board_rgb[2351:2340];
            rgb[24 + board_row_counter][29] = board_rgb[2339:2328];
            rgb[24 + board_row_counter][30] = board_rgb[2327:2316];
            rgb[24 + board_row_counter][31] = board_rgb[2315:2304];
            rgb[24 + board_row_counter][32] = board_rgb[2303:2292];
            rgb[24 + board_row_counter][33] = board_rgb[2291:2280];
            rgb[24 + board_row_counter][34] = board_rgb[2279:2268];
            rgb[24 + board_row_counter][35] = board_rgb[2267:2256];
            rgb[24 + board_row_counter][36] = board_rgb[2255:2244];
            rgb[24 + board_row_counter][37] = board_rgb[2243:2232];
            rgb[24 + board_row_counter][38] = board_rgb[2231:2220];
            rgb[24 + board_row_counter][39] = board_rgb[2219:2208];
            rgb[24 + board_row_counter][40] = board_rgb[2207:2196];
            rgb[24 + board_row_counter][41] = board_rgb[2195:2184];
            rgb[24 + board_row_counter][42] = board_rgb[2183:2172];
            rgb[24 + board_row_counter][43] = board_rgb[2171:2160];
            rgb[24 + board_row_counter][44] = board_rgb[2159:2148];
            rgb[24 + board_row_counter][45] = board_rgb[2147:2136];
            rgb[24 + board_row_counter][46] = board_rgb[2135:2124];
            rgb[24 + board_row_counter][47] = board_rgb[2123:2112];
            rgb[24 + board_row_counter][48] = board_rgb[2111:2100];
            rgb[24 + board_row_counter][49] = board_rgb[2099:2088];
            rgb[24 + board_row_counter][50] = board_rgb[2087:2076];
            rgb[24 + board_row_counter][51] = board_rgb[2075:2064];
            rgb[24 + board_row_counter][52] = board_rgb[2063:2052];
            rgb[24 + board_row_counter][53] = board_rgb[2051:2040];
            rgb[24 + board_row_counter][54] = board_rgb[2039:2028];
            rgb[24 + board_row_counter][55] = board_rgb[2027:2016];
            rgb[24 + board_row_counter][56] = board_rgb[2015:2004];
            rgb[24 + board_row_counter][57] = board_rgb[2003:1992];
            rgb[24 + board_row_counter][58] = board_rgb[1991:1980];
            rgb[24 + board_row_counter][59] = board_rgb[1979:1968];
            rgb[24 + board_row_counter][60] = board_rgb[1967:1956];
            rgb[24 + board_row_counter][61] = board_rgb[1955:1944];
            rgb[24 + board_row_counter][62] = board_rgb[1943:1932];
            rgb[24 + board_row_counter][63] = board_rgb[1931:1920];
            rgb[24 + board_row_counter][64] = board_rgb[1919:1908];
            rgb[24 + board_row_counter][65] = board_rgb[1907:1896];
            rgb[24 + board_row_counter][66] = board_rgb[1895:1884];
            rgb[24 + board_row_counter][67] = board_rgb[1883:1872];
            rgb[24 + board_row_counter][68] = board_rgb[1871:1860];
            rgb[24 + board_row_counter][69] = board_rgb[1859:1848];
            rgb[24 + board_row_counter][70] = board_rgb[1847:1836];
            rgb[24 + board_row_counter][71] = board_rgb[1835:1824];
            rgb[24 + board_row_counter][72] = board_rgb[1823:1812];
            rgb[24 + board_row_counter][73] = board_rgb[1811:1800];
            rgb[24 + board_row_counter][74] = board_rgb[1799:1788];
            rgb[24 + board_row_counter][75] = board_rgb[1787:1776];
            rgb[24 + board_row_counter][76] = board_rgb[1775:1764];
            rgb[24 + board_row_counter][77] = board_rgb[1763:1752];
            rgb[24 + board_row_counter][78] = board_rgb[1751:1740];
            rgb[24 + board_row_counter][79] = board_rgb[1739:1728];
            rgb[24 + board_row_counter][80] = board_rgb[1727:1716];
            rgb[24 + board_row_counter][81] = board_rgb[1715:1704];
            rgb[24 + board_row_counter][82] = board_rgb[1703:1692];
            rgb[24 + board_row_counter][83] = board_rgb[1691:1680];
            rgb[24 + board_row_counter][84] = board_rgb[1679:1668];
            rgb[24 + board_row_counter][85] = board_rgb[1667:1656];
            rgb[24 + board_row_counter][86] = board_rgb[1655:1644];
            rgb[24 + board_row_counter][87] = board_rgb[1643:1632];
            rgb[24 + board_row_counter][88] = board_rgb[1631:1620];
            rgb[24 + board_row_counter][89] = board_rgb[1619:1608];
            rgb[24 + board_row_counter][90] = board_rgb[1607:1596];
            rgb[24 + board_row_counter][91] = board_rgb[1595:1584];
            rgb[24 + board_row_counter][92] = board_rgb[1583:1572];
            rgb[24 + board_row_counter][93] = board_rgb[1571:1560];
            rgb[24 + board_row_counter][94] = board_rgb[1559:1548];
            rgb[24 + board_row_counter][95] = board_rgb[1547:1536];
            rgb[24 + board_row_counter][96] = board_rgb[1535:1524];
            rgb[24 + board_row_counter][97] = board_rgb[1523:1512];
            rgb[24 + board_row_counter][98] = board_rgb[1511:1500];
            rgb[24 + board_row_counter][99] = board_rgb[1499:1488];
            rgb[24 + board_row_counter][100] = board_rgb[1487:1476];
            rgb[24 + board_row_counter][101] = board_rgb[1475:1464];
            rgb[24 + board_row_counter][102] = board_rgb[1463:1452];
            rgb[24 + board_row_counter][103] = board_rgb[1451:1440];
            rgb[24 + board_row_counter][104] = board_rgb[1439:1428];
            rgb[24 + board_row_counter][105] = board_rgb[1427:1416];
            rgb[24 + board_row_counter][106] = board_rgb[1415:1404];
            rgb[24 + board_row_counter][107] = board_rgb[1403:1392];
            rgb[24 + board_row_counter][108] = board_rgb[1391:1380];
            rgb[24 + board_row_counter][109] = board_rgb[1379:1368];
            rgb[24 + board_row_counter][110] = board_rgb[1367:1356];
            rgb[24 + board_row_counter][111] = board_rgb[1355:1344];
            rgb[24 + board_row_counter][112] = board_rgb[1343:1332];
            rgb[24 + board_row_counter][113] = board_rgb[1331:1320];
            rgb[24 + board_row_counter][114] = board_rgb[1319:1308];
            rgb[24 + board_row_counter][115] = board_rgb[1307:1296];
            rgb[24 + board_row_counter][116] = board_rgb[1295:1284];
            rgb[24 + board_row_counter][117] = board_rgb[1283:1272];
            rgb[24 + board_row_counter][118] = board_rgb[1271:1260];
            rgb[24 + board_row_counter][119] = board_rgb[1259:1248];
            rgb[24 + board_row_counter][120] = board_rgb[1247:1236];
            rgb[24 + board_row_counter][121] = board_rgb[1235:1224];
            rgb[24 + board_row_counter][122] = board_rgb[1223:1212];
            rgb[24 + board_row_counter][123] = board_rgb[1211:1200];
            rgb[24 + board_row_counter][124] = board_rgb[1199:1188];
            rgb[24 + board_row_counter][125] = board_rgb[1187:1176];
            rgb[24 + board_row_counter][126] = board_rgb[1175:1164];
            rgb[24 + board_row_counter][127] = board_rgb[1163:1152];
            rgb[24 + board_row_counter][128] = board_rgb[1151:1140];
            rgb[24 + board_row_counter][129] = board_rgb[1139:1128];
            rgb[24 + board_row_counter][130] = board_rgb[1127:1116];
            rgb[24 + board_row_counter][131] = board_rgb[1115:1104];
            rgb[24 + board_row_counter][132] = board_rgb[1103:1092];
            rgb[24 + board_row_counter][133] = board_rgb[1091:1080];
            rgb[24 + board_row_counter][134] = board_rgb[1079:1068];
            rgb[24 + board_row_counter][135] = board_rgb[1067:1056];
            rgb[24 + board_row_counter][136] = board_rgb[1055:1044];
            rgb[24 + board_row_counter][137] = board_rgb[1043:1032];
            rgb[24 + board_row_counter][138] = board_rgb[1031:1020];
            rgb[24 + board_row_counter][139] = board_rgb[1019:1008];
            rgb[24 + board_row_counter][140] = board_rgb[1007:996];
            rgb[24 + board_row_counter][141] = board_rgb[995:984];
            rgb[24 + board_row_counter][142] = board_rgb[983:972];
            rgb[24 + board_row_counter][143] = board_rgb[971:960];
            rgb[24 + board_row_counter][144] = board_rgb[959:948];
            rgb[24 + board_row_counter][145] = board_rgb[947:936];
            rgb[24 + board_row_counter][146] = board_rgb[935:924];
            rgb[24 + board_row_counter][147] = board_rgb[923:912];
            rgb[24 + board_row_counter][148] = board_rgb[911:900];
            rgb[24 + board_row_counter][149] = board_rgb[899:888];
            rgb[24 + board_row_counter][150] = board_rgb[887:876];
            rgb[24 + board_row_counter][151] = board_rgb[875:864];
            rgb[24 + board_row_counter][152] = board_rgb[863:852];
            rgb[24 + board_row_counter][153] = board_rgb[851:840];
            rgb[24 + board_row_counter][154] = board_rgb[839:828];
            rgb[24 + board_row_counter][155] = board_rgb[827:816];
            rgb[24 + board_row_counter][156] = board_rgb[815:804];
            rgb[24 + board_row_counter][157] = board_rgb[803:792];
            rgb[24 + board_row_counter][158] = board_rgb[791:780];
            rgb[24 + board_row_counter][159] = board_rgb[779:768];
            rgb[24 + board_row_counter][160] = board_rgb[767:756];
            rgb[24 + board_row_counter][161] = board_rgb[755:744];
            rgb[24 + board_row_counter][162] = board_rgb[743:732];
            rgb[24 + board_row_counter][163] = board_rgb[731:720];
            rgb[24 + board_row_counter][164] = board_rgb[719:708];
            rgb[24 + board_row_counter][165] = board_rgb[707:696];
            rgb[24 + board_row_counter][166] = board_rgb[695:684];
            rgb[24 + board_row_counter][167] = board_rgb[683:672];
            rgb[24 + board_row_counter][168] = board_rgb[671:660];
            rgb[24 + board_row_counter][169] = board_rgb[659:648];
            rgb[24 + board_row_counter][170] = board_rgb[647:636];
            rgb[24 + board_row_counter][171] = board_rgb[635:624];
            rgb[24 + board_row_counter][172] = board_rgb[623:612];
            rgb[24 + board_row_counter][173] = board_rgb[611:600];
            rgb[24 + board_row_counter][174] = board_rgb[599:588];
            rgb[24 + board_row_counter][175] = board_rgb[587:576];
            rgb[24 + board_row_counter][176] = board_rgb[575:564];
            rgb[24 + board_row_counter][177] = board_rgb[563:552];
            rgb[24 + board_row_counter][178] = board_rgb[551:540];
            rgb[24 + board_row_counter][179] = board_rgb[539:528];
            rgb[24 + board_row_counter][180] = board_rgb[527:516];
            rgb[24 + board_row_counter][181] = board_rgb[515:504];
            rgb[24 + board_row_counter][182] = board_rgb[503:492];
            rgb[24 + board_row_counter][183] = board_rgb[491:480];
            rgb[24 + board_row_counter][184] = board_rgb[479:468];
            rgb[24 + board_row_counter][185] = board_rgb[467:456];
            rgb[24 + board_row_counter][186] = board_rgb[455:444];
            rgb[24 + board_row_counter][187] = board_rgb[443:432];
            rgb[24 + board_row_counter][188] = board_rgb[431:420];
            rgb[24 + board_row_counter][189] = board_rgb[419:408];
            rgb[24 + board_row_counter][190] = board_rgb[407:396];
            rgb[24 + board_row_counter][191] = board_rgb[395:384];
            rgb[24 + board_row_counter][192] = board_rgb[383:372];
            rgb[24 + board_row_counter][193] = board_rgb[371:360];
            rgb[24 + board_row_counter][194] = board_rgb[359:348];
            rgb[24 + board_row_counter][195] = board_rgb[347:336];
            rgb[24 + board_row_counter][196] = board_rgb[335:324];
            rgb[24 + board_row_counter][197] = board_rgb[323:312];
            rgb[24 + board_row_counter][198] = board_rgb[311:300];
            rgb[24 + board_row_counter][199] = board_rgb[299:288];
            rgb[24 + board_row_counter][200] = board_rgb[287:276];
            rgb[24 + board_row_counter][201] = board_rgb[275:264];
            rgb[24 + board_row_counter][202] = board_rgb[263:252];
            rgb[24 + board_row_counter][203] = board_rgb[251:240];
            rgb[24 + board_row_counter][204] = board_rgb[239:228];
            rgb[24 + board_row_counter][205] = board_rgb[227:216];
            rgb[24 + board_row_counter][206] = board_rgb[215:204];
            rgb[24 + board_row_counter][207] = board_rgb[203:192];
            rgb[24 + board_row_counter][208] = board_rgb[191:180];
            rgb[24 + board_row_counter][209] = board_rgb[179:168];
            rgb[24 + board_row_counter][210] = board_rgb[167:156];
            rgb[24 + board_row_counter][211] = board_rgb[155:144];
            rgb[24 + board_row_counter][212] = board_rgb[143:132];
            rgb[24 + board_row_counter][213] = board_rgb[131:120];
            rgb[24 + board_row_counter][214] = board_rgb[119:108];
            rgb[24 + board_row_counter][215] = board_rgb[107:96];
            rgb[24 + board_row_counter][216] = board_rgb[95:84];
            rgb[24 + board_row_counter][217] = board_rgb[83:72];
            rgb[24 + board_row_counter][218] = board_rgb[71:60];
            rgb[24 + board_row_counter][219] = board_rgb[59:48];
            rgb[24 + board_row_counter][220] = board_rgb[47:36];
            rgb[24 + board_row_counter][221] = board_rgb[35:24];
            rgb[24 + board_row_counter][222] = board_rgb[23:12];
            rgb[24 + board_row_counter][223] = board_rgb[11:0];
        end
    end

    assign rgb_720p = rgb[row][col];


endmodule
