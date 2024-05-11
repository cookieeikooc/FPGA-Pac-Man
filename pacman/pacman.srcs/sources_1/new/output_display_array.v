`timescale 1ns / 1ps

module output_display_array(

    );
endmodule
`timescale 1ns / 1ps

`define WIDTH 1280
`define HEIGHT 720

module output_display_array(
    input current_block_row,
    input current_block_col,
    output [3:0] r_720p,
    output [3:0] g_720p,
    output [3:0] b_720p
    );

    reg [3:0] r[0:`HEIGHT-1][0:`WIDTH-1];
    reg [3:0] g[0:`HEIGHT-1][0:`WIDTH-1];
    reg [3:0] b[0:`HEIGHT-1][0:`WIDTH-1];

    //Map Template
    reg [5:0] map_block[0:30][0:27];
    initial begin
        //00
        map_block[1][1:12] = {12{6'd0}};
        map_block[1][15:26] = {12{6'd0}};
        map_block[2:8][1] = {8{6'd0}};
        map_block[2:8][26] = {8{6'd0}};
        map_block[2:13][6] = {12{6'd0}};
        map_block[2:13][21] = {12{6'd0}};
        map_block[3][12] = 6'd0;
        map_block[3][15] = 6'd0;
        map_block[5][2:5] = {4{6'd0}};
        map_block[5][7:20] = {14{6'd0}};
        map_block[5][22:25] = {4{6'd0}};
        map_block[6:8][9] = {3{6'd0}};
        map_block[6:8][18] = {3{6'd0}};
        map_block[8][2:5] = {4{6'd0}};
        map_block[8][10:12] = {3{6'd0}};
        map_block[8][15:17] = {3{6'd0}};
        map_block[8][22:25] = {4{6'd0}};
        map_block[9:10][12] = {2{6'd0}};
        map_block[9:10][15] = {2{6'd0}};
        map_block[10][0:4] = {5{6'd0}};
        map_block[10][23:27] = {5{6'd0}};
        map_block[11][0:4] = {5{6'd0}};
        map_block[11][23:27] = {5{6'd0}};
        map_block[11][9:18] = {10{6'd0}};
        map_block[12][0:4] = {5{6'd0}};
        map_block[12:19][9] = {8{6'd0}};
        map_block[12:19][18] = {8{6'd0}};
        map_block[12][23:27] = {5{6'd0}};
        map_block[13][11:16] = {6{6'd0}};
        map_block[14][0:8] = {9{6'd0}};
        map_block[14][11:16] = {6{6'd0}};
        map_block[14][19:27] = {9{6'd0}};
        map_block[15:26][6] = {12{6'd0}};
        map_block[15][11:16] = {6{6'd0}};
        map_block[15:26][21] = {12{6'd0}};
        map_block[16][0:4] = {5{6'd0}};
        map_block[16][23:27] = {5{6'd0}};
        map_block[17][0:4] = {5{6'd0}};
        map_block[17][10:17] = {8{6'd0}};
        map_block[17][23:27] = {5{6'd0}};
        map_block[18][0:4] = {5{6'd0}};
        map_block[18][23:27] = {5{6'd0}};
        map_block[20][1:5] = {5{6'd0}};
        map_block[20][7:12] = {6{6'd0}};
        map_block[20][15:20] = {6{6'd0}};
        map_block[20][22:26] = {5{6'd0}};
        map_block[21:22][1] = {2{6'd0}};
        map_block[21:22][12] = {2{6'd0}};
        map_block[21:22][15] = {2{6'd0}};
        map_block[21:22][26] = {2{6'd0}};
        map_block[23][1:3] = {3{6'd0}};
        map_block[23][7:20] = {14{6'd0}};
        map_block[23][24:26] = {3{6'd0}};
        map_block[24:25][3] = {2{6'd0}};
        map_block[24:25][9] = {2{6'd0}};
        map_block[24:25][18] = {2{6'd0}};
        map_block[24:25][24] = {2{6'd0}};
        map_block[26][1:5] = {5{6'd0}};
        map_block[26][9:12] = {4{6'd0}};
        map_block[26][15:18] = {4{6'd0}};
        map_block[26][22:26] = {5{6'd0}};
        map_block[27:28][1] = {2{6'd0}};
        map_block[27:28][12] = {2{6'd0}};
        map_block[27:28][15] = {2{6'd0}};
        map_block[27:28][26] = {2{6'd0}};
        map_block[29][1:26] = {26{6'd0}};
        //01
        map_block[2][2] = 6'd1;
        map_block[2][7] = 6'd1;
        map_block[2][16] = 6'd1;
        map_block[2][22] = 6'd1;
        map_block[6][2] = 6'd1;
        map_block[6][7] = 6'd1;
        map_block[6][10] = 6'd1;
        map_block[6][19] = 6'd1;
        map_block[6][22] = 6'd1;
        map_block[9][16] = 6'd1;
        map_block[15][7] = 6'd1;
        map_block[15][19] = 6'd1;
        map_block[18][10] = 6'd1;
        map_block[21][2] = 6'd1;
        map_block[21][7] = 6'd1;
        map_block[21][16] = 6'd1;
        map_block[21][22] = 6'd1;
        map_block[24][7] = 6'd1;
        map_block[24][10] = 6'd1;
        map_block[24][19] = 6'd1;
        map_block[24][25] = 6'd1;
        map_block[27][2] = 6'd1;
        map_block[27][16] = 6'd1;
        //02
        map_block[2][5] = 6'd2;
        map_block[2][11] = 6'd2;
        map_block[2][20] = 6'd2;
        map_block[2][25] = 6'd2;
        map_block[6][5] = 6'd2;
        map_block[6][8] = 6'd2;
        map_block[6][17] = 6'd2;
        map_block[6][20] = 6'd2;
        map_block[6][25] = 6'd2;
        map_block[9][11] = 6'd2;
        map_block[15][8] = 6'd2;
        map_block[15][20] = 6'd2;
        map_block[18][17] = 6'd2;
        map_block[21][5] = 6'd2;
        map_block[21][11] = 6'd2;
        map_block[21][20] = 6'd2;
        map_block[21][25] = 6'd2;
        map_block[24][2] = 6'd2;
        map_block[24][8] = 6'd2;
        map_block[24][17] = 6'd2;
        map_block[24][20] = 6'd2;
        map_block[27][11] = 6'd2;
        map_block[27][25] = 6'd2;
        //03
        map_block[4][2] = 6'd3;
        map_block[4][7] = 6'd3;
        map_block[4][13] = 6'd3;
        map_block[4][16] = 6'd3;
        map_block[4][22] = 6'd3;
        map_block[7][2] = 6'd3;
        map_block[7][10] = 6'd3;
        map_block[7][22] = 6'd3;
        map_block[10][13] = 6'd3;
        map_block[10][16] = 6'd3;
        map_block[13][7] = 6'd3;
        map_block[13][19] = 6'd3;
        map_block[19][7] = 6'd3;
        map_block[19][10] = 6'd3;
        map_block[19][19] = 6'd3;
        map_block[22][2] = 6'd3;
        map_block[22][7] = 6'd3;
        map_block[22][13] = 6'd3;
        map_block[22][16] = 6'd3;
        map_block[25][4] = 6'd3;
        map_block[25][10] = 6'd3;
        map_block[25][22] = 6'd3;
        map_block[25][25] = 6'd3;
        map_block[28][2] = 6'd3;
        map_block[28][13] = 6'd3;
        map_block[28][16] = 6'd3;
        //04
        map_block[4][5] = 6'd4;
        map_block[4][11] = 6'd4;
        map_block[4][14] = 6'd4;
        map_block[4][20] = 6'd4;
        map_block[4][25] = 6'd4;
        map_block[7][5] = 6'd4;
        map_block[7][17] = 6'd4;
        map_block[7][25] = 6'd4;
        map_block[10][11] = 6'd4;
        map_block[10][14] = 6'd4;
        map_block[13][8] = 6'd4;
        map_block[13][20] = 6'd4;
        map_block[19][8] = 6'd4;
        map_block[19][17] = 6'd4;
        map_block[19][20] = 6'd4;
        map_block[22][11] = 6'd4;
        map_block[22][14] = 6'd4;
        map_block[22][20] = 6'd4;
        map_block[22][25] = 6'd4;
        map_block[25][2] = 6'd4;
        map_block[25][5] = 6'd4;
        map_block[25][17] = 6'd4;
        map_block[25][23] = 6'd4;
        map_block[28][11] = 6'd4;
        map_block[28][14] = 6'd4;
        map_block[28][25] = 6'd4;
        //05
        map_block[7][14] = 6'd5;
        map_block[10][8] = 6'd5;
        map_block[19][14] = 6'd5;
        map_block[22][23] = 6'd5;
        map_block[25][14] = 6'd5;
        //06
        map_block[7][13] = 6'd6;
        map_block[10][19] = 6'd6;
        map_block[19][13] = 6'd6;
        map_block[22][4] = 6'd6;
        map_block[25][13] = 6'd6;
        //07
        map_block[9][8] = 6'd7;
        map_block[27][8] = 6'd7;
        map_block[27][20] = 6'd7;
        //08
        map_block[9][19] = 6'd8;
        map_block[27][7] = 6'd8;
        map_block[27][19] = 6'd8;
        //09 10 11 12
        map_block[0][0] = 6'd9;
        map_block[19][0] = 6'd9;
        map_block[0][27] = 6'd10;
        map_block[19][27] = 6'd10;
        map_block[29][0] = 6'd11;
        map_block[9][0] = 6'd11;
        map_block[29][27] = 6'd12;
        map_block[9][27] = 6'd12;
        //13 14 15 16
        map_block[9][22] = 6'd13;
        map_block[15][22] = 6'd13;
        map_block[9][5] = 6'd14;
        map_block[15][5] = 6'd14;
        map_block[13][22] = 6'd15;
        map_block[19][22] = 6'd15;
        map_block[13][5] = 6'd16;
        map_block[19][5] = 6'd16;
        //17 18 19 20
        map_block[12][10] = 6'd17;
        map_block[12][17] = 6'd18;
        map_block[16][10] = 6'd19;
        map_block[16][17] = 6'd20;
        //21 22 23 24 25 26
        map_block[0][14] = 6'd21;
        map_block[0][13] = 6'd22;
        map_block[25][0] = 6'd23;
        map_block[25][27] = 6'd24;
        map_block[24][0] = 6'd25;
        map_block[24][27] = 6'd26;
        //27 28
        map_block[12][15] = 6'd27;
        map_block[12][12] = 6'd28;
        //29
        map_block[2][3:4] = {2{6'd29}};
        map_block[2][8:10] = {3{6'd29}};
        map_block[2][17:19] = {3{6'd29}};
        map_block[2][23:24] = {2{6'd29}};
        map_block[6][3:4] = {2{6'd29}};
        map_block[6][11:16] = {6{6'd29}};
        map_block[6][23:24] = {2{6'd29}};
        map_block[9][9:10] = {2{6'd29}};
        map_block[9][17:18] = {2{6'd29}};
        map_block[18][11:16] = {6{6'd29}};
        map_block[21][3:4] = {2{6'd29}};
        map_block[21][8:10] = {3{6'd29}};
        map_block[21][17:19] = {3{6'd29}};
        map_block[21][23:24] = {2{6'd29}};
        map_block[24][1] = 6'd29;
        map_block[24][26] = 6'd29;
        map_block[27][3:6] = {4{6'd29}};
        map_block[27][9:10] = {2{6'd29}};
        map_block[27][17:18] = {2{6'd29}};
        map_block[27][21:24] = {4{6'd29}};
        //30
        map_block[4][3:4] = {2{6'd30}};
        map_block[4][8:10] = {3{6'd30}};
        map_block[4][17:19] = {3{6'd30}};
        map_block[4][23:24] = {2{6'd30}};
        map_block[7][3:4] = {2{6'd30}};
        map_block[7][11:12] = {2{6'd30}};
        map_block[7][15:16] = {2{6'd30}};
        map_block[7][23:24] = {2{6'd30}};
        map_block[10][9:10] = {2{6'd30}};
        map_block[10][17:18] = {2{6'd30}};
        map_block[19][11:12] = {2{6'd30}};
        map_block[19][15:16] = {2{6'd30}};
        map_block[22][3] = 6'd30;
        map_block[22][8:10] = {3{6'd30}};
        map_block[22][17:19] = {3{6'd30}};
        map_block[22][24] = 6'd30;
        map_block[25][1] = 6'd30;
        map_block[25][11:12] = {2{6'd30}};
        map_block[25][15:16] = {2{6'd30}};
        map_block[25][26] = 6'd30;
        map_block[28][3:10] = {8{6'd30}};
        map_block[28][17:24] = {8{6'd30}};
        //31
        map_block[1:3][13] = {3{6'd31}};
        map_block[3][2] = 6'd31;
        map_block[3][7] = 6'd31;
        map_block[3][16] = 6'd31;
        map_block[3][22] = 6'd31;
        map_block[7:12][7] = {6{6'd31}};
        map_block[8:9][13] = {2{6'd31}};
        map_block[11:12][19] = {2{6'd31}};
        map_block[16:18][7] = {3{6'd31}};
        map_block[16:18][19] = {3{6'd31}};
        map_block[20:21][13] = {2{6'd31}};
        map_block[22:24][22] = {3{6'd31}};
        map_block[23:24][4] = {2{6'd31}};
        map_block[25:26][7] = {2{6'd31}};
        map_block[25:26][19] = {2{6'd31}};
        map_block[26:27][13] = {2{6'd31}};
        //32
        map_block[1:3][14] = {3{6'd32}};
        map_block[3][5] = 6'd32;
        map_block[3][11] = 6'd32;
        map_block[3][20] = 6'd32;
        map_block[3][25] = 6'd32;
        map_block[7:8][8] = {2{6'd32}};
        map_block[7:12][20] = {6{6'd32}};
        map_block[8:9][14] = {2{6'd32}};
        map_block[11:12][8] = {2{6'd32}};
        map_block[16:18][8] = {3{6'd32}};
        map_block[16:18][20] = {3{6'd32}};
        map_block[20:21][14] = {2{6'd32}};
        map_block[22:24][5] = {3{6'd32}};
        map_block[23:24][23] = {2{6'd32}};
        map_block[25:26][8] = {2{6'd32}};
        map_block[25:26][20] = {2{6'd32}};
        map_block[26:27][14] = {2{6'd32}};
        //33
        map_block[0][1:12] = {12{6'd33}};
        map_block[0][15:26] = {12{6'd33}};
        map_block[13][0:4] = {5{6'd33}};
        map_block[13][23:27] = {5{6'd33}};
        map_block[16][11:16] = {6{6'd33}};
        map_block[19][1:4] = {4{6'd33}};
        map_block[19][23:26] = {4{6'd33}};
        //34
        map_block[9][1:4] = {4{6'd34}}; 
        map_block[9][23:26] = {4{6'd34}};
        map_block[12][11:12] = {2{6'd34}};
        map_block[12][15:16] = {2{6'd34}};
        map_block[15][0:4] = {5{6'd34}};
        map_block[15][23:27] = {5{6'd34}};
        map_block[30][1:26] = {26{6'd34}};
        //35
        map_block[1:8][0] = {8{6'd35}};
        map_block[10:12][5] = {3{6'd35}};
        map_block[13:15][17] = {3{6'd35}};
        map_block[16:18][5] = {3{6'd35}};
        map_block[20:23][0] = {4{6'd35}};
        map_block[26:29][0] = {4{6'd35}};
        //36
        map_block[1:8][27] = {8{6'd35}};
        map_block[10:12][22] = {3{6'd35}};
        map_block[13:15][10] = {3{6'd35}};
        map_block[16:18][22] = {3{6'd35}};
        map_block[20:23][27] = {4{6'd35}};
        map_block[26:29][27] = {4{6'd35}};

        /*
        00: empty       08: ┘           16: ╝           24: ╖           32: │ right
        01: ┌ outer     09: ╔ outer     17: ╔ sharp     25: ╙           33: ═ top
        02: ┐           10: ╗           18: ╗           26: ╛           34: ═ bottom
        03: └           11: ╚           19: ╚           27: [           35: ║ left
        04: ┘           12: ╝           20: ╝           28: ]           36: ║ right 
        05: ┌ inner     13: ╔ inner     21: ╒           29: ─ top
        06: ┐           14: ╗           22: ╕           30: ─ bottom
        07: └           15: ╚           23: ╓           31: │ left
        */

        /*
        for layer assignment
        if ...
            top
        else if ...
            second
        else if ...
            third
        ...
        else if ...
            bottom
        */
    end


endmodule
