// Bing

module pacman_ROM (
    input [3:0] tile_px_row,
    input [3:0] tile_px_col,
    input [4:0] frame, //0: Closed 1: R wide open 2: R open 3: D wide open
                       //4: D open 5: L wide open 6: L open 7: U wide open
                       //8: U open 9: Die 1       21: Die 13
    output [11:0] rgb
);

    reg ROM [0:5631];
    initial begin
        $readmemh("pacman_ROM.mem", ROM);
    end

    assign rgb = ROM[{frame, tile_px_row, tile_px_col}] == 1'b1 ? 12'hFF0 : 12'h000;
    
endmodule