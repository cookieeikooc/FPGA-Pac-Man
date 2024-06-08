//Bing

module output_display_array (
    input clk,
    input h_sync,
    input v_sync,
    input [9:0] row,
    input [10:0] col,
    output [11:0] rgb_720p
);

    //Score 24 * 224
    //Board 248 * 224
    //Level 16 * 224
    wire board_ready;
    reg [7:0] board_px_row_counter = 8'd0;
    reg [7:0] board_px_col_counter = 8'd0;
    always @(posedge clk) begin
        if (board_ready == 1'b1 & row >= 10'd720) begin
            if (board_px_col_counter == 8'd223) begin
                board_px_col_counter <= 8'd0;
                if (board_px_row_counter == 8'd247) begin
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
        .rgb_720p(board_rgb)
    );

    //Read Cache and Scale
    reg [11:0] rgb[0:287][0:223];
    always @(posedge clk) begin
        if (board_ready == 1'b1 & row >= 10'd720) begin
            rgb[24 + board_px_row_counter][board_px_col_counter] <= board_rgb;
        end
    end

    assign rgb_720p = rgb[row][col];


endmodule
