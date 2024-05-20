// Bing

module pacman_ROM (
    input [3:0] tile_px_row,
    input [3:0] tile_px_col,
    input [2:0] type, //0 ~ 7
    output [11:0] rgb
);

    reg ROM [0:2047];
    initial begin
        $readmemh("fruit_ROM.mem", ROM);
    end

    reg [11:0] tile[31:0];
    initial begin
        tile[0] = 12'h000; //Cherry
        tile[1] = 12'hD95;
        tile[2] = 12'hF00;
        tile[3] = 12'hDDF;
        tile[4] = 12'h000; //Strawberry
        tile[5] = 12'h0F0;
        tile[6] = 12'hF00;
        tile[7] = 12'hDDF;
        tile[8] = 12'h000; //Orange
        tile[9] = 12'h0F0;
        tile[10] = 12'hD95;
        tile[11] = 12'hFB5;
        tile[12] = 12'h000; //Apple
        tile[13] = 12'hD95;
        tile[14] = 12'hF00;
        tile[15] = 12'hDDF;
        tile[16] = 12'h000; //Melon
        tile[17] = 12'h4BA;
        tile[18] = 12'h0F0;
        tile[19] = 12'hDDF;
        tile[20] = 12'h000; //Galaxian
        tile[21] = 12'hF00;
        tile[22] = 12'h00F;
        tile[23] = 12'hFF0;
        tile[24] = 12'h000; //Bell
        tile[25] = 12'hFF0;
        tile[26] = 12'h4BF;
        tile[27] = 12'hDDF;
        tile[28] = 12'h000; //Key
        tile[29] = 12'hFF0;
        tile[30] = 12'h4BF;
        tile[31] = 12'hDDF;
    end

    assign rgb = tile[{type, ROM[{type, tile_px_row, tile_px_col}]}];
    
endmodule