//Bing

`define WIDTH 1280
`define HEIGHT 720

module board_display_cache (
    input [7:0]current_px_row,
    input [7:0]current_px_col,
    // need to add refesh counter input from VGA module
    output [11:0] rgb_720p,
);
    reg diplay_720p[0:`HEIGHT-1][0:`WIDTH-1];


    //layer counter and assign
    //editing...


    //=======================//
    //  get map px form ROM  //
    //=======================//
    //output wire
    wire map_count_reset;
    wire map_px_clk_out;
    wire [7:0] current_tile_row;
    wire [7:0] current_tile_col;
    //assign map_count_reset = 
    //assign map_px_clk_out = 
    //assign current_tile_row =
    //assign current_tile_col =
    //wiring wire
    wire [7:0] decoded_map_tile_row;
    wire [7:0] decoded_map_tile_col;
    wire [2:0] map_px_row;
    wire [2:0] map_px_col;
    map_ROM_address_decoder (
        .count_rst(map_count_reset),
        .px_clk(map_px_clk_out),
        .display_tile_row(current_tile_row),
        .display_tile_col(current_tile_col),
        .tile_row(decoded_map_tile_row),
        .tile_col(decoded_map_tile_col),
        .px_row(map_px_row),
        .px_col(map_px_col)
    );
    //input wire
    wire [11:0] map_rgb;
    map_ROM (
        .tile_row(decoded_map_tile_row),
        .tile_col(decoded_map_tile_col),
        .tile_px_row(map_px_row),
        .tile_px_col(map_px_col),
        .rgb(map_rgb)
    );


endmodule