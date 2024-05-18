//Bing

`define WIDTH 1280
`define HEIGHT 720

module board_display_cache (
    input clk,
    input [7:0]px_row,
    input [7:0]px_col,
    input refresh,
    input fright,
    output ready,
    output [11:0] rgb_720p,

    
);
    reg diplay_720p[0:`HEIGHT-1][0:`WIDTH-1];

    reg pac_count_rst = 1'b0;
    reg fruit_count_rst = 1'b0;
    reg clyde_count_rst = 1'b0;
    reg inky_count_rst = 1'b0;
    reg pinky_count_rst = 1'b0;
    reg blinky_count_rst = 1'b0;
    reg pacman_count_rst = 1'b0;
    reg score_count_rst = 1'b0;


    //State Machine
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
                else if (clyde_counter_rst) begin
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
            SOCORE: begin
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
    always @(negedge clk) begin
        current_state <= next_state;
    end

    //ready signal
    assign current_state = READY ? ready = 1'b1 : 1'b0;


    //ROM Signal
    reg [13:0] count_map_px = 'd0;
    always @(negedge clk) begin
        if (current_state == MAP & refresh == 1'b0) begin
            if (count_map_px == 14'd13887) begin
                count_map_px <= 14'd0;
            end
            else begin
                count_map_px <= count_map_px + 14'd1;
            end
        end
        else begin
            count_map_px <= 14'd0;
        end
    end
    //pac editing...
    //fruit editing...
    reg [7:0] count_blinky_px = 8'd0;
    always @(negedge clk) begin
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
    always @(negedge clk) begin
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
    always @(negedge clk) begin
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
    always @(negedge clk) begin
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
    always @(negedge clk) begin
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
    //score editing...


    //Reset Signal
    always @(posedge clk) begin
        if (count_map_px == 14'd13887) begin
            pac_count_rst <= 1'b1;
        end
        else begin
            pac_count_rst <= 1'b0;
        end
    end
    //pac editing...
    //fruit editing...
    always @(posedge clk) begin
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
    always @(posedge clk) begin
        if (count_clyde_px == 8'd255) begin
            inky_count_rst <= 1'b1;
        end
        else begin
            inky_count_rst <= 1'b0;
        end
    end
    always @(posedge clk) begin
        if (count_inky_px == 8'd255) begin
            pinky_count_rst <= 1'b1;
        end
        else begin
            pinky_count_rst <= 1'b0;
        end
    end
    always @(posedge clk) begin
        if (count_pinky_px == 8'd255) begin
            blinky_count_rst <= 1'b1;
        end
        else begin
            blinky_count_rst <= 1'b0;
        end
    end
    always @(posedge clk) begin
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

    
    //######## Map ROM ########//
    //output wire
    wire map_count_reset;
    assign map_count_reset = refresh;
    //wiring wire
    wire [4:0] decoded_map_tile_row;
    wire [4:0] decoded_map_tile_col;
    wire [2:0] map_px_row;
    wire [2:0] map_px_col;
    map_ROM_address_decoder (
        .count_rst(map_count_reset),
        .px_clk(clk),
        .tile_row(decoded_map_tile_row),
        .tile_col(decoded_map_tile_col),
        .px_row(map_px_row),
        .px_col(map_px_col)
    );
    //input wire
    wire [11:0] map_rgb;
    map_ROM (
        .tile_row(decoded_map_tile_row),
        .tile_col(decoded_map_tile_col),
        .tile_px_row(map_px_row),
        .tile_px_col(map_px_col),
        .rgb(map_rgb)
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
        .px_clk(clk),
        .px_row(ghost_px_row),
        .px_col(ghost_px_col)
    );
    //output wire
    wire [1:0] current_facing;
    wire fright_signal;
    wire current_frame;
    wire curent_flash_frame;
    wire [1:0] current_ghost;
    //assign current_facing =
    //assign fright_signal =
    //assign current_frame =
    //assign flash_frame =
    assign current_ghost =
        current_state == BLINKY ? 2'd0 :
        current_state == PINKY ? 2'd1 :
        current_state == INKY ? 2'd2 :
        current_state == CLYDE ? 2'd3 : 2'd0;
    //input wire
    wire [11:0] pacman_rgb;
    ghost_ROM (
        .tile_px_row(ghost_px_row),
        .tile_px_col(ghost_px_col),
        .facing(current_facing),
        .fright(fright_signal),
        .frame(current_frame),
        .flash_frame(curent_flash_frame),
        .ghost(current_ghost),
        .rgb(ghost_rgb)
    );

    //######## PacMan ROM ########//
    //output wire
    wire pacman_count_reset;
    assign pacman_count_reset = pacman_count_rst;
    //assign pacman_px_clk_out =
    //wiring wire
    wire [3:0] pacman_px_row;
    wire [3:0] pacman_px_col;
    pacman_ROM_address_decoder (
        .count_rst(pacman_count_reset),
        .px_clk(clk),
        .px_row(pacman_px_row),
        .px_col(pacman_px_col)
    );
    //output wire
    wire [4:0] current_frame;
    //assign current_frame =
    //input wire
    wire [11:0] ghost_rgb;
    pacman_ROM (
        .tile_px_row(pacman_px_row),
        .tile_px_col(pacman_px_col),
        .frame(current_frame),
        .rgb(pacman_rgb)
    );


    //mearge all layers
    //editing...


    //output

endmodule