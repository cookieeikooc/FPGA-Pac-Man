`define WIDTH 1280
`define HEIGHT 720

module display_cache (
    input [7:0]current_px_row,
    input [7:0]current_px_col,
    output [11:0] rgb_720p,

    //for map_template
    input [11:0] map_rgb,
    output [7:0]current_tile_row,
    output [7:0]current_tile_col,
    output [2:0]current_tile_px_row,
    output [2:0]current_tile_px_col

    //
):

endmodule