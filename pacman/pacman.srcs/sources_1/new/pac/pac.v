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

    /*
    reg pac[0:895];
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

    */

    reg [8:0] score = 9'd0;
    //By NormanHsieh
    (*ram_style="distributed"*) reg mem[0:895];
    initial begin
        $readmemb("pac_init.mem", mem);
    end
    wire       mem_out1; //internal read
    wire       mem_out2; //external read

    wire [9:0] mem_waddr1 = {mapped_col, mapped_row};
    wire [9:0] mem_raddr1 = {mapped_col, mapped_row};
    wire [9:0] mem_raddr2 = {pac_col, pac_row};
    wire       pac        = mem_out1;
    wire       clr_pac    = ((maaped_row == 5'd3) | (mapped_row == 5'd23)) & ((mapped_col == 5'd1) | (mapped_col == 5'd26));
    wire       mem_wr     = (pac == 1'b1); 
    wire       mem_wdata1 = 1'b0;
    wire [8:0] score_next = score + (pac ? (clr_pac ? 9'd5 : 9'd1) : 9'd0);

    assign pac_existance = mem_out2;
    assign eaten_pac_num = score;
    
    always @(posedge clk or posedge reset)
    if (reset)
        score <= 9'd0;
    else if (pac)
        score <= score_next;

    ///// RAMbehavior here
    always @(posedge clk)
    if (mem_wr)
        mem[mem_waddr1] <= mem_wdata1;

    assign mem_out1 = mem[mem_raddr1];
    assign mem_out2 = mem[mem_raddr2];
    //end of NormanHsieh

    assign pac_existance = mem_out2;
    assign eaten_pac_num = score;

endmodule