`timescale 1ns / 1ps

module output_display_array(

    );
endmodule
`timescale 1ns / 1ps

`define WIDTH 1280
`define HEIGHT 720

module output_display_array(
    output [3:0] r_720p[0:'HEIGHT-1][0:'WIDTH-1],
    output [3:0] g_720p[0:'HEIGHT-1][0:'WIDTH-1],
    output [3:0] b_720p[0:'HEIGHT-1][0:'WIDTH-1]
    );

    reg [3:0] r[0:'HEIGHT-1][0:'WIDTH-1];
    reg [3:0] g[0:'HEIGHT-1][0:'WIDTH-1];
    reg [3:0] b[0:'HEIGHT-1][0:'WIDTH-1];


endmodule
