//Bing

`define WIDTH 1280
`define HEIGHT 720

module board_display_cache (
    input clk,
    input [7:0]px_row,
    input [7:0]px_col,
    input refresh,
    output ready,
    output [11:0] rgb_720p,

    
);
    reg diplay_720p[0:`HEIGHT-1][0:`WIDTH-1];
    //input wire
    wire [11:0] map_rgb;
    wire [11:0] pacman_rgb;
    wire [11:0] ghost_rgb;

    //layers counter and reset signal
    //editing...
    //map
    //pac
    //fruit
    //ghost
    //pacman

    //State Machine
    parameter READY = 0, MAP = 1, PAC = 2, FRUIT = 3, BLINKY = 4, PINKY = 5, INKY = 6, CLYDE = 7, SCORE = 8;
    reg [1:0] current_state, next_state;
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
                    next_state <= READY;
                end
            end
            RENDER: begin
                if (done) begin
                    next_state <= READY;
                end
                else begin
                    next_state <= RENDER;
                end
            end
            default: begin
                next_state <= next_state;
            end
        endcase
    end
    always @(posedge clk) begin
        current_state <= next_state;
    end

    //ready signal
    assign current_state = READY ? ready = 1'b1 : 1'b0;

    //ROM Signal
    reg map_done = 1'b0;
    reg [5:0] count_px_8x8 = 6'd0;
    reg [7:0] count_px_16x16 = 8'd0;
    reg [4:0] count_tile_row = 5'd0;
    reg [4:0] count_tile_col = 5'd0;
    always @(posedge clk) begin
        case (current_state)
            MAP: begin
                if (count_px == 6'd63) begin
                    count_px <= 6'd0;
                    if (count_tile_col == 5'd27) begin
                        count_tile_col <= 5'd0;
                        if (count_tile_row == 5'd31) begin
                            count_tile_row <= 5'd0;
                            map_done <= 1'b1;
                        end
                        else begin
                            count_tile_row <= count_tile_row + 5'd1;
                            map_done <= 1'b0;
                        end
                    end
                    else begin
                        count_tile_col <= count_tile_col + 5'd1;
                    end
                end
                else begin
                    count_px <= count_px + 6'd1;
                end
            end
            PAC: begin
                //editing...
            end
            FRUIT: begin
                //editing...
            end
            BLINKY: begin
                
            end
            default: begin
                count_px <= 6'd0;
                count_tile_row <= 5'd0;
                count_tile_col <= 5'd0;
                map_done <= 1'b0;
            end
        endcase
    end

    

    //mearge all layers
    //editing...


    //######## Map ROM ########//
    //output wire
    wire map_count_reset;
    wire map_px_clk_out;
    wire [4:0] current_tile_row;
    wire [4:0] current_tile_col;
    //assign map_count_reset = 
    //assign map_px_clk_out = 
    assign current_tile_row = count_tile_row;
    assign current_tile_col = count_tile_col;
    //wiring wire
    wire [2:0] map_px_row;
    wire [2:0] map_px_col;
    map_ROM_address_decoder (
        .count_rst(map_count_reset),
        .px_clk(map_px_clk_out),
        .tile_row(decoded_map_tile_row),
        .tile_col(decoded_map_tile_col),
        .px_row(map_px_row),
        .px_col(map_px_col)
    );
    map_ROM (
        .tile_row(current_tile_row),
        .tile_col(current_tile_col),
        .tile_px_row(map_px_row),
        .tile_px_col(map_px_col),
        .rgb(map_rgb)
    );

    //######## Ghost ROM ########//
    //output wire
    wire ghost_count_reset;
    wire ghost_px_clk_out;
    //assign ghost_count_reset =
    //assign ghost_px_clk_out =
    //wiring wire
    wire [3:0] ghost_px_row;
    wire [3:0] ghost_px_col;
    ghost_ROM_address_decoder (
        .count_rst(ghost_count_reset),
        .px_clk(ghost_px_clk_out),
        .px_row(ghost_px_row),
        .px_col(ghost_px_col)
    );
    //output wire
    wire [1:0] current_facing;
    wire current_frame;
    wire [1:0] current_ghost;
    //assign current_facing =
    //assign current_frame =
    //assign current_ghost =
    ghost_ROM (
        .tile_px_row(ghost_px_row),
        .tile_px_col(ghost_px_col),
        .facing(current_facing),
        .frame(current_frame),
        .ghost(current_ghost),
        .rgb(ghost_rgb)
    );

    //######## PacMan ROM ########//
    //output wire
    wire pacman_count_reset;
    wire pacman_px_clk_out;
    //assign pacman_count_reset =
    //assign pacman_px_clk_out =
    //wiring wire
    wire [3:0] pacman_px_row;
    wire [3:0] pacman_px_col;
    pacman_ROM_address_decoder (
        .count_rst(pacman_count_reset),
        .px_clk(pacman_px_clk_out),
        .px_row(pacman_px_row),
        .px_col(pacman_px_col)
    );
    //output wire
    wire [4:0] current_frame;
    //assign current_frame =
    pacman_ROM (
        .tile_px_row(pacman_px_row),
        .tile_px_col(pacman_px_col),
        .frame(current_frame),
        .rgb(pacman_rgb)
    );
    

    //output

endmodule