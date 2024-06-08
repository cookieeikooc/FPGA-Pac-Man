//Bing

module map_ROM_address_decoder (
    input count_rst, //high at px_clk negedge to reset
    input px_clk, //detect negedge
    output [4:0] tile_row,
    output [4:0] tile_col,
    output [2:0] px_row,
    output [2:0] px_col
);

    reg [4:0] tile_r = 5'd0;
    reg [4:0] tile_c = 5'd0;
    reg [5:0] px = 6'd0;
    always @(negedge px_clk) begin
        if (count_rst == 1) begin
            px <= 6'd0;
            tile_r <= 5'd0;
            tile_c <= 5'd0;
        end
        else begin
            if (px == 6'd63) begin //if px num reaches the end
                px <= 6'd0; //back to the first px
                if (tile_c == 5'd27) begin
                    tile_c <= 5'd0; //back to the first tile column
                    tile_r <= tile_r + 5'd1; //next tile row
                end
                else begin
                    tile_c <= tile_c + 5'd1; //next tile column
                end
            end
            else begin
                px <= px + 6'd1; //next px
            end
        end
    end

    assign tile_row = tile_r;
    assign tile_col = tile_c;
    assign px_row = px[7:4];
    assign px_col = px[3:0];

endmodule