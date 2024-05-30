//Bing

`define WIDTH 1280
`define HEIGHT 720

module output_display_array (
    input clk,
    input h_sync,
    input v_sync,
    input [10:0] row,
    input [10:0] col,
    output [3:0] rgb_720p
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

    //Score 24 * 224
    //Board 248 * 224
    //Level 8 * 224
    wire board_ready;
    reg [7:0] board_px_row_counter = 8'd0;
    reg [7:0] board_px_col_counter = 8'd0;
    always @(posedge clk) begin
        if (board_ready == 1'b1 & h_sync == 1'b0 & v_sync == 1'b0) begin
            if (board_px_col_counter == 8'd223) begin
                board_px_col_counter <= 8'd0;
                if (board_px_row_counter == 8'd248) begin
                    board_px_row_counter <= 8'd0;
                end
                else begin
                    board_px_row_counter <= board_px_row_counter + 8'd1;
                end
            end
            else begin
                board_px_col_counter <= board_px_col_counter + 8'd1;
            end
        end
        else begin
            board_px_col_counter <= 8'd0;
            board_px_row_counter <= 8'd0;
        end
    end

    wire [11:0] board_rgb;
    board_display_cache (
        .px_row(board_px_row_counter),
        .px_col(board_px_col_counter),
        .ready(board_ready),
        .rgb(board_rgb)
    );

    //Read Cache and Scale
    reg [11:0] rgb[0:`HEIGHT-1][0:`WIDTH-1];
    always @(posedge clk) begin
        if (board_ready == 1'b1 & h_sync == 1'b0 & v_sync == 1'b0) begin
            rgb[128 + board_px_row_counter * 2][784 + board_px_col_counter * 2] <= board_rgb;
            rgb[128 + board_px_row_counter * 2][784 + board_px_col_counter * 2 + 1] <= board_rgb;
            rgb[128 + board_px_row_counter * 2 + 1][784 + board_px_col_counter * 2] <= board_rgb;
            rgb[128 + board_px_row_counter * 2 + 1][784 + board_px_col_counter * 2 + 1] <= board_rgb;
        end
        else begin
            rgb <= rgb;
        end
    end

    assign rgb_720p = rgb[row][col];


endmodule
