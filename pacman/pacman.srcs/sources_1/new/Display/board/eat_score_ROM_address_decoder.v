//Bing

module eat_score_ROM_address_decoder (
    input count_rst, //high at px_clk negedge to reset
    input px_clk, //detect negedge
    output [3:0] px_row,
    output [3:0] px_col
);

    reg [7:0] px = 8'd0;
    always @(negedge px_clk) begin
        if (count_rst == 1) begin
            px <= 8'd0;
        end
        else begin
            if (px == 8'd255) begin
                px <= 8'd0;
            end
            else begin
                px <= px + 8'd1;
            end
        end
    end

    assign px_row = px[7:4];
    assign px_col = px[3:0];

endmodule