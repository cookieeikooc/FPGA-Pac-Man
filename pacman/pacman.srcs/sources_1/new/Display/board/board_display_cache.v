//Bing

//248 * 224

module board_display_cache (
    input clk_setup,
    input clk_cache,
    input clk_60, // 60Hz clock
    input [7:0]px_row,
    input [7:0]px_col,
    input refresh,
    input fright,
    output ready,
    output [11:0] rgb_720p,

    input [4:0] pacman_tile_row,
    input [4:0] pacman_tile_col,
    input [2:0] pacman_px_shift,
    input [1:0] pacman_facing,

    input [4:0] bliky_tile_row,
    input [4:0] bliky_tile_col,
    input [2:0] bliky_px_shift,
    input [1:0] bliky_facing,

    input [4:0] pinky_tile_row,
    input [4:0] pinky_tile_col,
    input [2:0] pinky_px_shift,
    input [1:0] pinky_facing,
    
    input [4:0] inky_tile_row,
    input [4:0] inky_tile_col,
    input [2:0] inky_px_shift,
    input [1:0] inky_facing,

    input [4:0] clyde_tile_row,
    input [4:0] clyde_tile_col,
    input [2:0] clyde_px_shift,
    input [1:0] clyde_facing,

    input [3:0] fruit_type,
    input fruit_exist,

    input [1:0] score_num
);


////////////////////////////////////////////////////////////////
//                       STATE MACHINE                        //
////////////////////////////////////////////////////////////////
    reg pac_count_rst = 1'b0;
    reg fruit_count_rst = 1'b0;
    reg clyde_count_rst = 1'b0;
    reg inky_count_rst = 1'b0;
    reg pinky_count_rst = 1'b0;
    reg blinky_count_rst = 1'b0;
    reg pacman_count_rst = 1'b0;
    reg score_count_rst = 1'b0;
    reg done = 1'b0;


    //State Machine Switch
    parameter READY = 0, MAP = 1, PAC = 2, FRUIT = 3, PACMAN = 4, BLINKY = 5, PINKY = 6, INKY = 7, CLYDE = 8, SCORE = 9;
    reg [3:0] current_state, next_state;
    initial begin
        current_state = READY;
    end
    always @(*) begin
        case (current_state)
            READY: begin
                if (refresh) begin
                    next_state <= MAP;
                end
                else begin
                    next_state <= next_state;
                end
            end
            MAP: begin
                if (pac_count_rst) begin
                    next_state <= PAC;
                end
                else begin
                    next_state <= next_state;
                end
            end
            PAC: begin
                if (fruit_count_rst) begin
                    next_state <= FRUIT;
                end
                else begin
                    next_state <= next_state;
                end
            end
            FRUIT: begin
                if (pacman_count_rst) begin
                    next_state <= PACMAN;
                end
                else if (clyde_count_rst) begin
                    next_state <= CLYDE;
                end
                else begin
                    next_state <= next_state;
                end
            end
            PACMAN: begin
                if (clyde_count_rst) begin
                    next_state <= CLYDE;
                end
                else if (score_count_rst) begin
                    next_state <= SCORE;
                end
                else begin
                    next_state <= next_state;
                end
            end
            CLYDE: begin
                if (inky_count_rst) begin
                    next_state <= INKY;
                end
                else begin
                    next_state <= next_state;
                end
            end
            INKY: begin
                if (pinky_count_rst) begin
                    next_state <= PINKY;
                end
                else begin
                    next_state <= next_state;
                end
            end
            PINKY: begin
                if (blinky_count_rst) begin
                    next_state <= BLINKY;
                end
                else begin
                    next_state <= next_state;
                end
            end
            BLINKY: begin
                if (pacman_count_rst) begin
                    next_state <= PACMAN;
                end
                else if (score_count_rst) begin
                    next_state <= SCORE;
                end
                else begin
                    next_state <= next_state;
                end
            end
            SCORE: begin
                if (done) begin
                    next_state <= READY;
                end
                else begin
                    next_state <= next_state;
                end
            end
            default: begin
                next_state <= next_state;
            end
        endcase
    end
    always @(negedge clk_setup) begin
        current_state <= next_state;
    end

    //Ready Signal Out
    assign ready = current_state == READY ? 1'b1 : 1'b0;


    //ROM Pixel Signal
    reg [15:0] count_map_px = 16'd0;
    always @(negedge clk_setup) begin
        if (current_state == MAP & refresh == 1'b0) begin
            if (count_map_px == 16'd55551) begin
                count_map_px <= 16'd0;
            end
            else begin
                count_map_px <= count_map_px + 16'd1;
            end
        end
        else begin
            count_map_px <= 16'd0;
        end
    end
    reg [13:0] count_pac_px = 14'd0;
    always @(negedge clk_setup) begin
        if (current_state == PAC & pac_count_rst == 1'b0) begin
            if (count_pac_px == 14'd15615) begin
                count_pac_px <= 14'd0;
            end
            else begin
                count_pac_px <= count_pac_px + 14'd1;
            end
        end
        else begin
            count_pac_px <= 14'd0;
        end
    end
    reg [7:0] count_fruit_px = 8'd0;
    always @(negedge clk_setup) begin
        if (current_state == FRUIT & fruit_count_rst == 1'b0) begin
            if (count_fruit_px == 8'd255) begin
                count_fruit_px <= 8'd0;
            end
            else begin
                count_fruit_px <= count_fruit_px + 8'd1;
            end
        end
        else begin
            count_fruit_px <= 8'd0;
        end
    end
    reg [7:0] count_blinky_px = 8'd0;
    always @(negedge clk_setup) begin
        if (current_state == BLINKY & blinky_count_rst == 1'b0) begin
            if (count_blinky_px == 8'd255) begin
                count_blinky_px <= 8'd0;
            end
            else begin
                count_blinky_px <= count_blinky_px + 8'd1;
            end
        end
        else begin
            count_blinky_px <= 8'd0;
        end
    end
    reg [7:0] count_pinky_px = 8'd0;
    always @(negedge clk_setup) begin
        if (current_state == PINKY & pinky_count_rst == 1'b0) begin
            if (count_pinky_px == 8'd255) begin
                count_pinky_px <= 8'd0;
            end
            else begin
                count_pinky_px <= count_pinky_px + 8'd1;
            end
        end
        else begin
            count_pinky_px <= 8'd0;
        end
    end
    reg [7:0] count_inky_px = 8'd0;
    always @(negedge clk_setup) begin
        if (current_state == INKY & inky_count_rst == 1'b0) begin
            if (count_inky_px == 8'd255) begin
                count_inky_px <= 8'd0;
            end
            else begin
                count_inky_px <= count_inky_px + 8'd1;
            end
        end
        else begin
            count_inky_px <= 8'd0;
        end
    end
    reg [7:0] count_clyde_px = 8'd0;
    always @(negedge clk_setup) begin
        if (current_state == CLYDE & clyde_count_rst == 1'b0) begin
            if (count_clyde_px == 8'd255) begin
                count_clyde_px <= 8'd0;
            end
            else begin
                count_clyde_px <= count_clyde_px + 8'd1;
            end
        end
        else begin
            count_clyde_px <= 8'd0;
        end
    end
    reg [7:0] count_pacman_px = 8'd0;
    always @(negedge clk_setup) begin
        if (current_state == PACMAN & pacman_count_rst == 1'b0) begin
            if (count_pacman_px == 8'd255) begin
                count_pacman_px <= 8'd0;
            end
            else begin
                count_pacman_px <= count_pacman_px + 8'd1;
            end
        end
        else begin
            count_pacman_px <= 8'd0;
        end
    end
    reg [7:0] count_score_px = 8'd0;
    always @(negedge clk_setup) begin
        if (current_state == SCORE & score_count_rst == 1'b0) begin
            if (count_score_px == 8'd255) begin
                count_score_px <= 8'd0;
            end
            else begin
                count_score_px <= count_score_px + 8'd1;
            end
        end
        else begin
            count_score_px <= 8'd0;
        end
    end


    //Reset Signal
    always @(posedge clk_setup) begin
        if (count_map_px == 16'd55551) begin
            pac_count_rst <= 1'b1;
        end
        else begin
            pac_count_rst <= 1'b0;
        end
    end
    always @(posedge clk_setup) begin
        if (count_pac_px == 14'd15615) begin
            fruit_count_rst <= 1'b1;
        end
        else begin
            fruit_count_rst <= 1'b0;
        end
    end
    always @(posedge clk_setup) begin
        if (count_fruit_px == 8'd255 & fright == 1'b0) begin
            pacman_count_rst <= 1'b1;
        end
        else if (count_fruit_px == 8'd255 & fright == 1'b1) begin
            clyde_count_rst <= 1'b1;
        end
        else begin
            pacman_count_rst <= 1'b0;
            clyde_count_rst <= 1'b0;
        end
    end
    always @(posedge clk_setup) begin
        if (count_pacman_px == 8'd255 & fright == 1'b0) begin
            clyde_count_rst <= 1'b1;
        end
        else if (count_pacman_px == 8'd255 & fright == 1'b1) begin
            score_count_rst <= 1'b0;
        end
        else begin
            clyde_count_rst <= 1'b0;
            score_count_rst <= 1'b0;
        end
    end
    always @(posedge clk_setup) begin
        if (count_clyde_px == 8'd255) begin
            inky_count_rst <= 1'b1;
        end
        else begin
            inky_count_rst <= 1'b0;
        end
    end
    always @(posedge clk_setup) begin
        if (count_inky_px == 8'd255) begin
            pinky_count_rst <= 1'b1;
        end
        else begin
            pinky_count_rst <= 1'b0;
        end
    end
    always @(posedge clk_setup) begin
        if (count_pinky_px == 8'd255) begin
            blinky_count_rst <= 1'b1;
        end
        else begin
            blinky_count_rst <= 1'b0;
        end
    end
    always @(posedge clk_setup) begin
        if (count_blinky_px == 8'd255 & fright == 1'b1) begin
            pacman_count_rst <= 1'b1;
        end
        else if (count_blinky_px == 8'd255 & fright == 1'b0) begin
            score_count_rst <= 1'b1;
        end
        else begin
            pacman_count_rst <= 1'b0;
            score_count_rst <= 1'b0;
        end
    end
    always @(posedge clk_setup) begin
        if (count_score_px == 8'd255) begin
            done <= 1'b1;
        end
        else begin
            done <= 1'b0;
        end
    end

////////////////////////////////////////////////////////////////
//             INPUT MANAGEMENT & CONTROL SIGNALS             //
////////////////////////////////////////////////////////////////
    //Pac Existance Signal
    reg [4:0] pac_coordinate[0:487];
    initial begin
        $readmemb("pac_coordinate_ROM.mem", pac_coordinate);
    end
    wire [4:0] pac_row;
    wire [4:0] pac_col;
    assign pac_row = pac_coordinate[count_pac_px[13:6] * 2];
    assign pac_col = pac_coordinate[count_pac_px[13:6] * 2 + 1];
    wire pac_exist;
    pac (
        .pac_row(pac_row),
        .pac_col(pac_col),
        .pac_existance(pac_exist)
    );

    //Energizer Flash Frame
    reg [2:0] counter_energizer_flash_frame = 3'd0;
    reg energizer_flash_frame = 1'b0;
    always @(posedge clk_60) begin
        if (counter_energizer_flash_frame == 3'd7) begin
            energizer_flash_frame <= ~energizer_flash_frame;
            counter_energizer_flash_frame <= 0;
        end else begin
            counter_energizer_flash_frame <= counter_energizer_flash_frame + 1;
        end
    end

    //Ghost Animation Frame
    reg [3:0] counter_ghost_frame = 4'd0;
    reg ghost_frame = 1'b0;
    always @(posedge clk_60) begin
        if (counter_ghost_frame == 4'd14) begin
            ghost_frame <= ~ghost_frame;
            counter_ghost_frame <= 0;
        end else begin
            counter_ghost_frame <= counter_ghost_frame + 1;
        end
    end
    
    
////////////////////////////////////////////////////////////////
//                        DISPLAY ROM                         //
////////////////////////////////////////////////////////////////
    //######## Map ROM ########//
    //output wire
    wire map_count_reset;
    assign map_count_reset = refresh;
    //input wire
    wire [4:0] map_tile_row;
    wire [4:0] map_tile_col;
    wire [5:0] map_px;
    wire [11:0] map_rgb;
    map_ROM (
        .count_rst(map_count_reset),
        .px_clk(clk_setup),
        .tile_row_out(map_tile_row),
        .tile_col_out(map_tile_col),
        .px_out(map_px),
        .rgb(map_rgb)
    );

    //######## Pac ROM ########//
    //output wire
    wire pac_count_reset;
    assign pac_count_reset = pac_count_rst;
    //wiring wire
    wire [2:0] pac_px_row;
    wire [2:0] pac_px_col;
    pac_ROM_address_decoder (
        .count_rst(pac_count_reset),
        .px_clk(clk_setup),
        .px_row(pac_px_row),
        .px_col(pac_px_col)
    );
    //output wire
    wire energizer_bool;
    wire current_pac_flash_frame;
    assign energizer_bool = count_pac_px[13:6] == 8'd30 | count_pac_px[13:6] == 8'd35 | count_pac_px[13:6] == 8'd158 | count_pac_px[13:6] == 8'd177 ? 1'b1 : 1'b0;
    assign current_pac_flash_frame = energizer_flash_frame;
    //input wire
    wire [11:0] pac_rgb;
    pac_ROM (
        .tile_px_row(pac_px_row),
        .tile_px_col(pac_px_col),
        .energizers(energizer_bool),
        .flash_frame(current_pac_flash_frame),
        .rgb(pac_rgb)
    );

    //######## Fruit ROM ########//
    //output wire
    wire fruit_count_reset;
    assign fruit_count_reset = fruit_count_rst;
    //wiring wire
    wire [3:0] fruit_px_row;
    wire [3:0] fruit_px_col;
    fruit_ROM_address_decoder (
        .count_rst(fruit_count_reset),
        .px_clk(clk_setup),
        .px_row(fruit_px_row),
        .px_col(fruit_px_col)
    );
    //output wire
    wire [2:0] current_fruit_type;
    assign current_fruit_type = 3'd0; //TEMP VAL
    //input wire
    wire [11:0] fruit_rgb;
    fruit_ROM (
        .tile_px_row(fruit_px_row),
        .tile_px_col(fruit_px_col),
        .type(current_fruit_type),
        .rgb(fruit_rgb)
    );

    //######## Ghost ROM ########//
    //output wire
    wire ghost_count_reset;
    assign ghost_count_reset = blinky_count_rst | pinky_count_rst | inky_count_rst | clyde_count_rst;
    //wiring wire
    wire [3:0] ghost_px_row;
    wire [3:0] ghost_px_col;
    ghost_ROM_address_decoder (
        .count_rst(ghost_count_reset),
        .px_clk(clk_setup),
        .px_row(ghost_px_row),
        .px_col(ghost_px_col)
    );
    //output wire
    wire [1:0] current_facing;
    wire fright_signal;
    wire current_ghost_frame;
    wire curent__ghost_flash_frame;
    wire [1:0] current_ghost;
    assign current_facing = 2'd0; //TEMP VAL
    assign fright_signal = 1'b0; //TEMP VAL
    assign current_ghost_frame = ghost_frame;
    assign curent__ghost_flash_frame = 1'b0; //TEMP VAL
    assign current_ghost =
        current_state == BLINKY ? 2'd0 :
        current_state == PINKY ? 2'd1 :
        current_state == INKY ? 2'd2 :
        current_state == CLYDE ? 2'd3 : 2'd0;
    //input wire
    wire [11:0] ghost_rgb;
    ghost_ROM (
        .tile_px_row(ghost_px_row),
        .tile_px_col(ghost_px_col),
        .facing(current_facing),
        .fright(fright_signal),
        .frame(current_ghost_frame),
        .flash_frame(curent_ghost_flash_frame),
        .ghost(current_ghost),
        .rgb(ghost_rgb)
    );

    //######## PacMan ROM ########//
    //output wire
    wire pacman_count_reset;
    assign pacman_count_reset = pacman_count_rst;
    //wiring wire
    wire [3:0] pacman_px_row;
    wire [3:0] pacman_px_col;
    pacman_ROM_address_decoder (
        .count_rst(pacman_count_reset),
        .px_clk(clk_setup),
        .px_row(pacman_px_row),
        .px_col(pacman_px_col)
    );
    //output wire
    wire [4:0] current_pacman_frame;
    //assign current_frame =
    //input wire
    wire [11:0] pacman_rgb;
    pacman_ROM (
        .tile_px_row(pacman_px_row),
        .tile_px_col(pacman_px_col),
        .frame(current_pacman_frame),
        .rgb(pacman_rgb)
    );

    //######## Score ROM ########//
    //editing...
    

////////////////////////////////////////////////////////////////
//                           LAYERS                           //
////////////////////////////////////////////////////////////////
    //mearge all layers
    //editing...
    parameter BOARD_HIGHT = 248, BOARD_WIDTH = 224;
    reg [11:0] rgb[0:BOARD_HIGHT * BOARD_WIDTH - 1];
    always @(posedge clk_setup) begin
        case (current_state)
            MAP: begin
                rgb[{map_tile_row, map_px[5:3]}*BOARD_WIDTH + {map_tile_col, map_px[2:0]}] <= map_rgb;
            end
            PAC: begin
                if (pac_exist) begin
                    if (pac_rgb != 12'h000) begin
                        rgb[{pac_row, pac_px_row}*BOARD_WIDTH + {pac_col, pac_px_col}] <= pac_rgb;
                    end
                end
            end /*
            FRUIT: begin

            end
            BLINKY, PINKY, INKY, CLYDE: begin

            end
            PACMAN: begin

            end
            default: begin

            end */
        endcase
    end
    reg [11:0] rgb_out;
    always@(negedge clk_cache) begin
        if (current_state == READY) begin
            rgb_out <= rgb[px_row * BOARD_WIDTH + px_col];
        end
        else begin
            rgb_out <= 12'h000;
        end
    end

    //output
    assign rgb_720p = rgb_out;

endmodule