//Bing

`define WIDTH 1280
`define HEIGHT 720

module board_display_cache (
    input [7:0]px_row,
    input [7:0]px_col,
    output [11:0] rgb_720p,
);
    reg diplay_720p[0:`HEIGHT-1][0:`WIDTH-1];
    //input wire
    wire [11:0] map_rgb;
    wire [11:0] ghost_rgb;

    //layers counter and reset signal
    //editing...

    //mearge all layers
    //editing...


    //######## Map ROM ########//
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
    map_ROM (
        .tile_row(decoded_map_tile_row),
        .tile_col(decoded_map_tile_col),
        .tile_px_row(map_px_row),
        .tile_px_col(map_px_col),
        .rgb(map_rgb)
    );

    //######## Ghost ROM ########//
    //output wire
    wire ghost_count_reset;
    wire ghost_px_clk_out;
    //assign ghost_count_reset =
    //assign ghost_px_clk_out =
    //wiring wire
    wire [3:0] ghost_px_row;
    wire [3:0] ghost_px_col;
    ghost_ROM_address_decoder (
        .count_rst(ghost_count_reset),
        .px_clk(ghost_px_clk_out),
        .px_row(ghost_px_row),
        .px_col(ghost_px_col)
    );
    //output wire
    wire [1:0] current_facing;
    wire current_frame;
    wire [1:0] current_ghost;
    //assign current_facing =
    //assign current_frame =
    //assign current_ghost =
    ghost_ROM (
        .tile_px_row(ghost_px_row),
        .tile_px_col(ghost_px_col),
        .facing(current_facing),
        .frame(current_frame),
        .ghost(current_ghost),
        .rgb(ghost_rgb)
    );



    //output

endmodule