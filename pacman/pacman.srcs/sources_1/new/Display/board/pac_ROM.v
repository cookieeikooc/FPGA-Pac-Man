//Bing

module pac_ROM (
    input [2:0] tile_px_row,
    input [2:0] tile_px_col,
    input energizers, //0: false, 1: true
    input flash_frame, //0: darken, 1: lit
    output [11:0] rgb
);

    (*rom_style = "block" *) reg ROM[0:127];
    initial begin
        $readmemb("pac_ROM.mem", ROM);
    end

    wire [7:0] ROM_addr = {energizers, flash_frame, tile_px_row, tile_px_col};
    wire ROM_read = ROM[ROM_addr];

    assign rgb =
        energizers == 1'b0 & ROM_read == 1'b1 ? 12'hFBA :
        energizers == 1'b0 & ROM_read == 1'b0 ? 12'h000 :
        energizers == 1'b1 & flash_frame == 1'b0 ? 12'h000 :
        energizers == 1'b1 & flash_frame == 1'b1 & ROM_read == 1'b1 ? 12'hFBA : 12'h000;
endmodule