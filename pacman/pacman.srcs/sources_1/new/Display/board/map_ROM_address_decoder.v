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
    reg [2:0] px_r = 3'd0;
    reg [2:0] px_c = 3'd0;
    always @(negedge px_clk) begin
        if (count_rst == 1) begin
            px_r <= 3'd0;
            px_c <= 3'd0;
            tile_r <= 5'd0;
            tile_c <= 5'd0;
        end
        else begin
            if (px_c == 3'd7) begin //if pre-column num reaches the end
                px_c <= 3'd0; //bsck to the first column
                if (px_r == 3'd7) begin //if pre-row num reaches the end
                    px_r <= 3'd0; //first row
                    if (tile_c == 5'd27) begin
                        tile_c <= 5'd0; //back to the first tile column
                        tile_r <= tile_r + 5'd1; //next tile row
                    end
                    else begin
                        tile_c <= tile_c + 5'd1; //next tile column
                    end
                end
                else begin
                    px_c <= px_c + 3'd1; //next column
                end
            end
            else begin
                px_c <= px_c + 3'd1; //next column
            end
        end
    end

    assign px_row = px_r;
    assign px_col = px_c;

endmodule