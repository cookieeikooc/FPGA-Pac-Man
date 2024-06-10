//Bing

module map_ROM (
    input count_rst, //high at px_clk negedge to reset
    input px_clk, //detect negedge
    output [11:0] rgb //three 4-bit Hexadecimal numbers
);

    //################################################################################//
    //# Map graphic reference from https://www.spriters-resource.com/fullview/52631/ #//
    //################################################################################//

    //Map Telmplate
    reg [5:0] map_tile[0:867];
    initial begin
        $readmemb("map_ROM.mem", map_tile);
    end

    //Tile ROM
    reg [0:63] map_tile_px[0:33];
    initial begin
        $readmemb("map_tile_ROM.mem", map_tile_px);
    end
    /*
        00: empty       08: ┘           16: ╝           24: ]           32: ║ right 
        01: ┌ outer     09: ╔ outer     17: ╒           25: ─ top       33: gate
        02: ┐           10: ╗           18: ╕           26: ─ bottom    
        03: └           11: ╚           19: ╓           27: │ left      
        04: ┘           12: ╝           20: ╖           28: │ right     
        05: ┌ inner     13: ╔ sharp     21: ╙           29: ═ top       
        06: ┐           14: ╗           22: ╜           30: ═ bottom
        07: └           15: ╚           23: [           31: ║ left
    */

    reg [4:0] tile_row = 5'd0;
    reg [4:0] tile_col = 5'd0;
    reg [5:0] px = 6'd0;
    reg [11:0] rgb_out = 12'h000;
    always @(negedge px_clk) begin
        //map_ROM_address_decoder
        if (count_rst == 1) begin
            px <= 6'd0;
            tile_row <= 5'd0;
            tile_col <= 5'd0;
        end
        else begin
            if (px == 6'd63) begin //if px num reaches the end
                px <= 6'd0; //back to the first px
                if (tile_col == 5'd27) begin
                    tile_col <= 5'd0; //back to the first tile column
                    tile_row <= tile_row + 5'd1; //next tile row
                end
                else begin
                    tile_col <= tile_col + 5'd1; //next tile column
                end
            end
            else begin
                px <= px + 6'd1; //next px
            end
        end
        //Read
        if (tile_row == 5'd12 & (tile_col == 13 | tile_col == 14) & map_tile_px[map_tile[tile_row * 31 + tile_col]][px] == 1'b1) begin
            rgb_out = 12'hFBF;
        end
        else if (tile_row == 5'd12 & (tile_col == 13 | tile_col == 14) & map_tile_px[map_tile[tile_row * 31 + tile_col]][px] == 1'b0) begin
            rgb_out = 12'h000;
        end
        else if (map_tile_px[map_tile[tile_row * 31 + tile_col]][px] == 1'b1) begin
            rgb_out = 12'h22F;
        end
        else begin
            rgb_out = 12'h000;
        end
    end

    assign rgb = rgb_out;

endmodule