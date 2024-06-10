//Bing

module pac(
    input clk,
    input reset,
    input [4:0] pacman_tile_row,
    input [4:0] pacman_tile_col,
    input [2:0] pacman_px_shift,
    input [1:0] pacman_facing,
    input [4:0] pac_row,
    input [4:0] pac_col,
    output pac_existance,
    output [8:0] eaten_pac_num // +1 for each eaten pac, +5 for each eaten energizer
);

    reg [4:0]mapped_row;
    reg [4:0]mapped_col;
    always @(*) begin
        if (pacman_px_shift == 3'd6 | pacman_px_shift == 3'd7) begin
            case (pacman_facing)
                2'd0: begin
                    mapped_row <= pacman_tile_row;
                    mapped_col <= pacman_tile_col + 5'd1;
                end
                2'd1: begin
                    mapped_row <= pacman_tile_row + 5'd1;
                    mapped_col <= pacman_tile_col;
                end
                default: begin
                    mapped_row <= pacman_tile_row;
                    mapped_col <= pacman_tile_col;
                end
            endcase
        end
        else if (pacman_px_shift == 3'd0 | pacman_px_shift == 3'd1) begin
            case (pacman_facing)
                2'd2: begin
                    mapped_row <= pacman_tile_row;
                    mapped_col <= pacman_tile_col - 5'd1;
                end
                2'd3: begin
                    mapped_row <= pacman_tile_row - 5'd1;
                    mapped_col <= pacman_tile_col;
                end
                default: begin
                    mapped_row <= pacman_tile_row;
                    mapped_col <= pacman_tile_col;
                end
            endcase
        end
        else begin
            mapped_row <= pacman_tile_row;
            mapped_col <= pacman_tile_col;
        end
    end

    (*rom_style = "block" *)reg pac[0:895];
    reg [8:0] score = 9'd0;
    initial begin
        $readmemb("pac_init.mem", pac);
    end
    always @(posedge clk) begin
        if (pac[{mapped_col, mapped_row}] == 1'b1) begin
            if ((mapped_row == 5'd3 | mapped_row == 5'd23) & (mapped_col == 5'd1 | mapped_col == 5'd26)) begin
                pac[{mapped_col, mapped_row}] <= 1'b0;
                score <= score + 9'd5;
            end
            else begin
                pac[{mapped_col, mapped_row}] <= 1'b0;
                score <= score + 9'd1;
            end
        end
    end

    assign pac_existance = pac[{pac_col, pac_row}];
    assign eaten_pac_num = score;

endmodule