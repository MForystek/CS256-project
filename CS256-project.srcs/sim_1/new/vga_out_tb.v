`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2023 01:41:26 PM
// Design Name: 
// Module Name: vga_out_tb
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


module vga_out_tb;
    reg clk; reg rst;
    reg [3:0] red; reg [3:0] green; reg [3:0] blue;
    
    wire [3:0] pix_r; wire [3:0] pix_g; wire [3:0] pix_b;
    wire hsync; wire vsync; wire [10:0] curr_x; wire [9:0] curr_y;
    
    vga_out uut (.clk(clk), .rst(rst), .red(red), .green(green), .blue(blue),
                 .pix_r(pix_r), .pix_g(pix_g), .pix_b(pix_b),
                 .hsync(hsync), .vsync(vsync), .curr_x(curr_x), .curr_y(curr_y));
    
    initial begin 
        clk = 1'b0;
        rst = 1'b0;
        #15 rst = 1'b1;
    end 
    always #5 clk = ~clk;
    
    initial begin
        red = 4'b1010;
        green = 4'b0101;
        blue = 4'b1111;
    end
    
endmodule
