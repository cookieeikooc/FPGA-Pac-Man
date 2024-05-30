//Bing

module ghost_ROM (
    input [3:0] tile_px_row,
    input [3:0] tile_px_col,
    input [1:0] facing,
    input fright,
    input frame,
    input flash_frame,
    input [1:0] ghost, // 0: Blinky, 1: Pinky, 2: Inky, 3: Clyde
    output [11:0] rgb
);

    reg [1:0] ROM[0:2559];
    initial begin
        $readmemh("ghost_ROM.mem", ROM);
    end

    reg [11:0] palette1[0:3];
    initial begin
        palette1[0] = 12'hF00;
        palette1[1] = 12'hFBF;
        palette1[2] = 12'h0FF;
        palette1[3] = 12'hFB5;
    end
    reg [11:0] palette2[0:2];
    initial begin
        palette2[0] = 12'h22F;
        palette2[1] = 12'hDDF;
    end
    reg [11:0] palette3[0:2];
    initial begin
        palette3[0] = 12'hFBA;
        palette3[1] = 12'hF00;
    end

    assign rgb =
        fright == 1'b1 & ROM[{3'b100, frame, tile_px_row, tile_px_col}] == 2'b00 ? 12'h000 :
        fright == 1'b1 & ROM[{3'b100, frame, tile_px_row, tile_px_col}] == 2'b01 ? palette2[flash_frame] :
        fright == 1'b1 & ROM[{3'b100, frame, tile_px_row, tile_px_col}] == 2'b10 ? palette3[flash_frame] :
        ROM[{facing, frame, tile_px_row, tile_px_col}] == 2'b00 ? 12'h000 :
        ROM[{facing, frame, tile_px_row, tile_px_col}] == 2'b01 ? palette1[ghost] :
        ROM[{facing, frame, tile_px_row, tile_px_col}] == 2'b10 ? 12'h00F :
        ROM[{facing, frame, tile_px_row, tile_px_col}] == 2'b11 ? 12'hDDF : 12'h000;

endmodule