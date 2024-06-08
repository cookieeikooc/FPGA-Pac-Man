//Bing

module output_display_array (
    input clk,
    input h_sync,
    input v_sync,
    input [10:0] row,
    input [9:0] col,
    output [3:0] rgb_720p
);

    //Score 24 * 224
    //Board 248 * 224
    //Level 16 * 224
    wire board_ready;
    reg [7:0] board_row_counter = 8'd0;
    always @(posedge clk) begin
        if (board_ready == 1'b1 & row >= 11'd1280) begin
            if (board_row_counter == 8'd247) begin
                board_row_counter <= 8'd0;
            end
            else begin
                board_row_counter <= board_row_counter + 8'd1;
            end
        end
        else begin
            board_row_counter <= 8'd0;
        end
    end

    wire [2687:0] board_rgb;
    board_display_cache (
        .px_row(board_row_counter),
        .ready(board_ready),
        .rgb(board_rgb)
    );

    //Read Cache and Scale
    reg [11:0] rgb[0:287][0:223];
    always @(posedge clk) begin
        if (board_ready == 1'b1 & row >= 11'd1280) begin
            rgb[24 + board_row_counter][0:223] <= board_rgb;
        end
    end

    assign rgb_720p = rgb[row][col];


endmodule
