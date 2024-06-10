//Bing

module pac(
    input clk,
    input level_reset,
    input [4:0] pacman_tile_row,
    input [4:0] pacman_tile_col,
    input [2:0] pacman_px_shift,
    input [1:0] pacman_facing,
    input [4:0] pac_row,
    input [4:0] pac_col,
    output setup_finish,
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

    //State Machine
    parameter IDLE = 2'd0, SETUP = 2'd1, READY = 2'd2;
    reg [1:0] corrent_state;
    reg [1:0] next_state;


    //Dual Port RAM (Read: 2, Write: 1)
    (*ram_style = "block"*)reg [0:0] pac_mem[0:895];
    reg [8:0] score = 9'd0;
    initial begin
        $readmemb("pac_init.mem", pac_mem);
    end

    reg mem_rout1; //internal: previously stored value
    reg mem_rout2; //external: currently stored value
    wire [9:0] mem_rwaddr = {mapped_col, mapped_row}
    wire [9:0] mem_raddr = {pac_col, pac_row}
    wire pac_pre;
    assign pac_pre = mem_rout1; //previously stored value
    wire [8:0] score_next = score + 
        (pac_pre ? 
            (((mapped_row == 5'd3 | mapped_row == 5'd23) & (mapped_col == 5'd1 | mapped_col == 5'd26)) ? 
            9'd5 : 9'd1) : 
        9'd0);

    //Write depends on previously stored value
    always @(negedge clk) begin
        mem_rout1 = pac_mem[mem_rwaddr];
        if (pac_pre) begin
            pac_mem[mem_rwaddr] = 1'b0;
        end
    end
    //Read
    always @(posedge clk) begin
        mem_rout2 <= pac_mem[mem_raddr];
    end

    //Score
    always @(negedge clk) begin
        if (level_reset == 1'b1) begin
            score <= 9'd0;
        end
        else if (ready) begin
            score <= score_next;
        end
    end


    assign pac_existance = mem_rout2;
    assign eaten_pac_num = score;

endmodule