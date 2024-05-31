//Bing

module pac_ROM_address_decoder (
    input count_rst, //high at px_clk negedge to reset
    input px_clk, //detect negedge
    output [2:0] px_row,
    output [2:0] px_col
);

    reg [5:0] px = 6'd0;
    always @(negedge px_clk) begin
        if (count_rst == 1) begin
            px <= 6'd0;
        end
        else begin
            if (px == 6'd63) begin
                px <= 6'd0;
            end
            else begin
                px <= px + 6'd1;
            end
        end
    end

    assign px_row = px[5:3];
    assign px_col = px[2:0];

endmodule