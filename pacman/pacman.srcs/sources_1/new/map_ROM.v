//Bing

module map_ROM (
    input [7:0]current_tile_row,
    input [7:0]current_tile_col,
    input [2:0]current_tile_px_row,
    input [2:0]current_tile_px_col,
    output [11:0] rgb //three 4-bit Hexadecimal numbers
);

    //########################################################################//
    //# Map reference from https://www.spriters-resource.com/fullview/52631/ #//
    //########################################################################//

    //Map Telmplate
    reg [5:0] map_tile[0:867];
    initial begin
        $readmemh("map_ROM.mem", map_tile);
    end

    //Tile ROM
    reg [0:63] map_tile_px[0:33];
    initial begin
        $readmemh("map_tile.mem", map_tile_px);
    end
    /*
        00: empty       08: ┘           16: ╝           24: ]           32: ║ right 
        01: ┌ outer     09: ╔ outer     17: ╒           25: ─ top       33: gate
        02: ┐           10: ╗           18: ╕           26: ─ bottom    
        03: └           11: ╚           19: ╓           27: │ left      
        04: ┘           12: ╝           20: ╖           28: │ right     
        05: ┌ inner     13: ╔ sharp     21: ╙           29: ═ top       
        06: ┐           14: ╗           22: ╜           30: ═ bottom
        07: └           15: ╚           23: [           31: ║ left
    */

    assign rgb = 
            current_tile_row == 12 & (current_tile_col == 13 | current_tile_col == 14) & map_tile_px[{current_tile_px_row, current_tile_px_col}][map_tile[current_tile_row * 31 + current_tile_col]] == 1'b1 ? 12'hFBF :
            current_tile_row == 12 & (current_tile_col == 13 | current_tile_col == 14) & map_tile_px[{current_tile_px_row, current_tile_px_col}][map_tile[current_tile_row * 31 + current_tile_col]] == 1'b0 ? 12'h000 :
            map_tile_px[{current_tile_px_row, current_tile_px_col}][map_tile[current_tile_row * 31 + current_tile_col]] == 1'b1 ? 12'h22F : 12'h000;

endmodule