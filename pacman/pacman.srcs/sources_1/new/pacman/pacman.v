//Yoshida

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/18 15:48:28
// Design Name: 
// Module Name: pm_idle
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pm_idle (
  input           l_b,r_b,u_b,d_b,
  input           sys_clk,
  input           sys_rst_n,
  input[1:0]      dir,
  output reg[1:0] pm_c_dir,
  output [2:0] g_col,g_row,
  output [2:0] gp_col,gp_row,
  output reg[4:0] col,row,
  output reg[2:0] p_col,p_row,
  output reg[1:0] pm_state,
  output reg[1:0] g_state
);

//reg l, r, u, d;
reg[1:0] pm_n_dir;
reg [5:0] map_tile[0:867];
initial
begin
  $readmemh("map_ROM.mem", map_tile);
end

    // row: 1, col: 1
    //map_tile_px[28 * row + col] == 6'b000000

always @ (posedge sys_clk or negedge sys_rst_n)
begin
  if(!sys_rst_n)
  begin
    pm_c_dir <= 2'd2;
    pm_n_dir <= 2'd2;
  end
  else if(col != 3'd0 && p_col == 3'd3 && p_row == 3'd3 && map_tile[28 * row + col - 1] == 6'b000000 && (pm_n_dir == 2'd2 || l_b == 1'd1))
  begin
    pm_c_dir <= 2'd2;
    pm_n_dir <= 2'd2;
  end
  else if(col == 3'd0 && p_col == 3'd3 && p_row == 3'd3 && map_tile[28 * row + col + 27] == 6'b000000 && (pm_n_dir == 2'd2 || l_b == 1'd1))
  begin
    pm_c_dir <= 2'd2;
    pm_n_dir <= 2'd2;
  end
  else if(l_b == 1'd1)
  begin
    pm_c_dir <= pm_c_dir;
    pm_n_dir <= 2'd2;
  end
  else if(col != 5'd27 && p_col == 3'd3 && p_row == 3'd3 && map_tile[28 * row + col + 1] == 6'b000000 && (r_b == 1'd1 || pm_n_dir == 2'd0))
  begin
    pm_c_dir <= 2'd0;
    pm_n_dir <= 2'd0;
  end
  else if(col == 5'd27 && p_col == 3'd3 && p_row == 3'd3 && map_tile[28 * row + col - 27] == 6'b000000 && (r_b == 1'd1 || pm_n_dir == 2'd0))
  begin
    pm_c_dir <= 2'd0;
    pm_n_dir <= 2'd0;
  end
  else if(r_b == 1'd1)
  begin
    pm_c_dir <= pm_c_dir;
    pm_n_dir <= 2'd0;
  end
  else if(row != 5'd0 && p_col == 3'd3 && p_row == 3'd3 && map_tile[28 * (row - 1) + col] == 6'b000000 && (u_b == 1'd1 || pm_n_dir == 2'd3))
  begin
    pm_c_dir <= 2'd3;
    pm_n_dir <= 2'd3;
  end
  else if(row == 5'd0 && p_col == 3'd3 && p_row == 3'd3 && map_tile[28 * (row + 30) + col] == 6'b000000 && (u_b == 1'd1 || pm_n_dir == 2'd3))
  begin
    pm_c_dir <= 2'd3;
    pm_n_dir <= 2'd3;
  end
  else if(u_b == 1'd1)
  begin
    pm_c_dir <= pm_c_dir;
    pm_n_dir <= 2'd3;
  end
  else if(row != 5'd30 && p_col == 3'd3 && p_row == 3'd3 && map_tile[28 * (row + 1) + col] == 6'b000000 && (d_b == 1'd1 || pm_n_dir == 2'd1))
  begin
    pm_c_dir <= 2'd1;
    pm_n_dir <= 2'd1;
  end
  else if(row == 5'd30 && p_col == 3'd3 && p_row == 3'd3 && map_tile[28 * (row - 30) + col] == 6'b000000 && (d_b == 1'd1 || pm_n_dir == 2'd1))
  begin
    pm_c_dir <= 2'd1;
    pm_n_dir <= 2'd1;
  end
  else if(d_b == 1'd1)
  begin
    pm_c_dir <= pm_c_dir;
    pm_n_dir <= 2'd1;
  end
  
end
    
  

/*always @ (posedge sys_clk or negedge sys_rst_n)
begin
  if(!sys_rst_n)
    pm_state <= 2'b0;
  else if(l_b == 1'b1 && r_b == 1'b1)
  begin
    pm_state <= 2'b1;
    col <= 5'd13;
    row <= 5'd23;
    p_col <= 3'd3;
    p_row <= 3'd3;
    pm_c_dir <= 2'd2;  
  end
  else
  begin
    pm_state <= pm_state;
    col <= col;
    row <= row;
    p_col <= p_col;
    p_row <= p_row;
  end
end*/

parameter   PERIOD  = 28'd50_000000;
parameter   DUTY    = 28'd12_500000;

// The length of count register must equal to the parameter
reg[28:0]   cnt;
reg         freq;

// Count from 0 to 49,999,999
always @(posedge sys_clk or negedge sys_rst_n)
begin
    if (!sys_rst_n)
        cnt     <= 28'd0;
    else if (cnt == PERIOD - 28'd1)
        cnt     <= 28'd0;
    else 
        cnt     <= cnt + 28'd1;
end

// Duty cycle = 12500000/50000000 = 25%
always @(posedge sys_clk or negedge sys_rst_n)
begin
    if (!sys_rst_n)
        freq    <= 1'b0;
    else if (cnt < DUTY - 28'd1)
        freq    <= 1'b1;
    else
        freq    <= 1'b0;
end

reg[3:0] c;

always @ (posedge freq or negedge sys_rst_n)
begin
  if (!sys_rst_n)
  begin
    col <= 5'd13;
    row <= 5'd23;
    p_col <= 3'd3;
    p_col <= 3'd3;
    c <= 4'd0;
  end
  else if(p_col == 3'd3 && p_row == 3'd3)
  begin
    if(col != 27 && pm_c_dir == 2'd0 && map_tile[28 * row + col + 1] != 6'b000000)
    begin
      row <= row;
      col <= col;
      p_row <= p_row;
      p_col <= p_col;
    end
    else if(col == 27 && pm_c_dir == 2'd0 && map_tile[28 * row + col - 27] != 6'b000000)
    begin
      row <= row;
      col <= col;
      p_row <= p_row;
      p_col <= p_col;
    end
    else if(row != 5'd30 && pm_c_dir == 2'd1 && map_tile[28 * (row + 1) + col] != 6'b000000)
    begin
      row <= row;
      col <= col;
      p_row <= p_row;
      p_col <= p_col;
    end
    else if(row == 5'd30 && pm_c_dir == 2'd1 && map_tile[28 * (row - 30) + col] != 6'b000000)
    begin
      row <= row;
      col <= col;
      p_row <= p_row;
      p_col <= p_col;
    end
    else if(col != 5'd0 && pm_c_dir == 2'd1 && map_tile[28 * row + col - 1] != 6'b000000)
    begin
      row <= row;
      col <= col;
      p_row <= p_row;
      p_col <= p_col;
    end
    else if(col == 5'd0 && pm_c_dir == 2'd1 && map_tile[28 * row + col + 27] != 6'b000000)
    begin
      row <= row;
      col <= col;
      p_row <= p_row;
      p_col <= p_col;
    end
    else if(row != 0 && pm_c_dir == 2'd3 && map_tile[28 * (row - 1) + col] != 6'b000000)
    begin
      row <= row;
      col <= col;
      p_row <= p_row;
      p_col <= p_col;
    end
    else if(row == 0 && pm_c_dir == 2'd3 && map_tile[28 * (row + 30) + col] != 6'b000000)
    begin
      row <= row;
      col <= col;
      p_row <= p_row;
      p_col <= p_col;
    end
  end
  else if(pm_c_dir == 2'd1 && map_tile[28 * (row + 1) + col] == 6'b000000 && pm_state == 1'd1)
  begin
    if(p_row == 3'd7)
    begin 
      p_row <= p_row + 3'd1;
      row <= row + 3'd1;
    end
    else
      p_row <= p_row + 3'd1;
  end
  else if(pm_c_dir == 2'd3 && map_tile[28 * (row - 1) + col] == 6'b000000 && pm_state == 1'd1)
  begin
    if(p_row == 4'd0) 
    begin
      p_row <= p_row - 3'd1;
      row <= row - 3'd1;
    end
    else
      p_row <= p_row - 3'd1;
  end
  else if(pm_c_dir == 2'd2 && map_tile[28 * row + col - 1] == 6'b000000 && pm_state == 1'd1)
  begin
    if(p_col == 4'd0) 
    begin
      p_col <= p_col - 3'd1;
      col <= col - 3'd1;
    end
    else
      p_col <= p_col - 4'd1;
  end
  else if(pm_c_dir == 2'd0 && map_tile[28 * row + col + 1] == 6'b000000 && pm_state == 1'd1)
  begin
    if(p_col == 4'd7) 
    begin
      p_col <= 4'd0;
      col <= col + 3'd1;
    end
    else
      p_col <= p_col + 4'd1;
  end
  else if(pm_state == 2'd1)
  begin 
    if(c != 4'd15)
      c <= c + 4'd1;
    else
    begin
      c <= 4'd0;
      pm_state <= 4'd1;
    end
  end
  else if(pm_state == 2'd3)
  begin 
    if(c != 4'd15)
      c <= c + 4'd1;
    else
    begin
      c <= 4'd0;
      pm_state <= pm_state;
    end
  end
  
      
end

always @ (posedge freq or negedge sys_rst_n)
begin
  if(g_col == col && g_row == row && gp_col == p_col && gp_row == p_row)
  begin
    if(!sys_rst_n)
      pm_state <= 2'd1;
    else if(pm_state == 2'd1)
    begin
      pm_state <= 2'd0;
      g_state <= 2'd3;
    end
    else
    begin
      pm_state <= 2'd3;
      g_state <= 2'd0;
    end
  end
end

endmodule