// edited by Bing

module random_generator (
    input clk, //give a positive edge when the random is needed
    input [7:0]current_level, //level of the game, which is 1 to 256
    output [1:0] random //return a random number of right: 00, down: 01, left: 10, up: 11
);
    
    reg [7:0] ROM[0:8191];
    initial begin
        $readmemh("random.mif", ROM);
    end
    reg [15:0]index = 16'h00;
    always @(posedge clk) begin
        if (index != current_level) begin
            index <= current_level;
        end
        else begin
            index <= index * 5 + 1;
        end
    end

    assign random = ROM[index % 8192];

endmodule