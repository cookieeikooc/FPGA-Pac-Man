//Bing

module score_ROM_address_decoder (
    input count_rst, //high at px_clk negedge to reset
    input px_clk, //detect negedge
    output [3:0] px_row,
    output [3:0] px_col
);

    reg [3:0] px_r = 4'd0;
    reg [3:0] px_c = 4'd0;
    always @(negedge px_clk) begin
        if (count_rst == 1) begin
            px_r <= 4'd0;
            px_c <= 4'd0;
        end
        else begin
            if (px_c == 4'd15) begin //if pre-column num reaches the end
                px_c <= 4'd0; //first column
                px_r <= px_r + 4'd1; //next row
            end
            else begin
                px_c <= px_c + 4'd1; //next column
            end
        end
    end

    assign px_row = px_r;
    assign px_col = px_c;

endmodule