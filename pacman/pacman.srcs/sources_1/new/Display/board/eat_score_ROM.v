//Bing

module eat_score_ROM (
    input [2:0] tile_px_row,
    input [2:0] tile_px_col,
    input need, //0: false, 1: true
    input [1:0] num, //0: 200 1: 400 2: 800 3: 1600
    output [11:0] rgb
);

    reg ROM[0:1023];
    initial begin
        $readmemh("eat_score_ROM.mem", ROM);
    end

    assign rgb =
        need == 1'b1 & ROM[{num, tile_px_row, tile_px_col}] == 1'b1 ? 12'h0FF : 12'h000;
endmodule