//Bing

module map_ROM_address_decoder (
    input count_rst, //high at plx_clk negedge to reset
    input px_clk, //detect negedge and cache will get signal from ROM at posedge
    input [7:0] display_tile_row, //$3B ~ $20
    input [7:0] display_tile_col, //$21 ~ $3F
    output [7:0] tile_row,
    output [7:0] tile_col,
    output [2:0] px_row,
    output [2:0] px_col
);

    reg [2:0] px_r = 3'd0;
    reg [2:0] px_c = 3'd0;
    always @(negedge px_clk) begin
        if (count_rst == 1) begin
            px_r <= 3'd0;
            px_c <= 3'd0;
        end
        else begin
            if (px_c == 3'd7) begin //if pre-column num reaches the end
                px_c <= 3'd0; //first column
                px_r <= px_r + 3'd1; //next row
            end
            else begin
                px_c <= px_c + 3'd1; //next column
            end
        end
    end

    assign tile_row = display_tile_row - 8'h21;
    assign tile_col = display_tile_col - 8'h3B;
    assign px_row = px_r;
    assign px_col = px_c;

endmodule