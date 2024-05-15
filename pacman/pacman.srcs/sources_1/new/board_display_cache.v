//Bing

`define WIDTH 1280
`define HEIGHT 720

module board_display_cache (
    input [7:0]current_px_row,
    input [7:0]current_px_col,
    // need to add refesh counter input from VGA module
    output [11:0] rgb_720p,

    //for map_ROM_address_decoder
    input [11:0] map_rgb

    //for ghost_ROM
    input [11:0] ghost_rgb

);
    reg diplay_720p[0:`HEIGHT-1][0:`WIDTH-1];

endmodule