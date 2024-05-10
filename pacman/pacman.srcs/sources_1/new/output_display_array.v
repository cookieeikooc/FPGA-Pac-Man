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



        map_block[0][0] = 6'd9;
        map_block[0][1:12] = {12{6'd33}};
        map_block[0][13] = 6'd24;
        map_block[0][15:26] = {12{6'd33}};
        map_block[0][27] = 6'd10;

    end


endmodule
