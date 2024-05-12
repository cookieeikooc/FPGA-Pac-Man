`define WIDTH 1280
`define HEIGHT 720

module output_display_array (
    input [7:0]current_tile_row,
    input [7:0]current_tile_col,
    output [3:0] r_720p,
    output [3:0] g_720p,
    output [3:0] b_720p
);

    reg [3:0] r[0:`HEIGHT-1][0:`WIDTH-1];
    reg [3:0] g[0:`HEIGHT-1][0:`WIDTH-1];
    reg [3:0] b[0:`HEIGHT-1][0:`WIDTH-1];



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
    


endmodule
