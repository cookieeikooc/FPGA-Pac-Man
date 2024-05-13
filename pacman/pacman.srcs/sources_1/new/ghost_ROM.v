//edited by Bing

module ghost_ROM (
    input [4:0] current_tile_row,
    input [4:0] current_tile_col,
    input [1:0] facing,
    input frame,
    output [11:0] rgb
);

    reg [1:0] ROM[0:255][0:7];
    initial begin
        $readmemh("ghost_up0.mif", ROM[0:255][0]);
    end

endmodule