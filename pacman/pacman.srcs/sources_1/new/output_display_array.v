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

        map_block[1][1:12] = {12{6'd0}};
        map_block[1][15:26] = {12{6'd0}};
        map_block[2:8][1] = {8{6'd0}};
        map_block[2:8][26] = {8{6'd0}};
        map_block[0][0] = 6'd9;
        map_block[0][1:12] = {12{6'd33}};
        map_block[0][13] = 6'd24;
        map_block[0][15:26] = {12{6'd33}};
        map_block[0][27] = 6'd10;

    end


endmodule
