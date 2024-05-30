//Bing

`define WIDTH 1280
`define HEIGHT 720

module output_display_array (
    input clk,
    input [7:0] current_tile_row,
    input [7:0] current_tile_col,
    output [3:0] r_720p,
    output [3:0] g_720p,
    output [3:0] b_720p
);

    wire board_ready;
    wire [11:0] board_rgb;
    board_display_cache (
        .ready(board_ready)
        .rgb(board_rgb)
    );


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
    //248 * 224
    reg [7:0] board_row_counter = 8'd0;
    reg [7:0] board_col_counter = 8'd0;
    always @(posedge clk) begin
        if ()
    end

    reg [11:0] rgb[0:`HEIGHT-1][0:`WIDTH-1];
    always @(posedge clk) begin
        
    end


endmodule
