`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2023 04:54:39 PM
// Design Name: 
// Module Name: game_top
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


module game_top(
    input clk, input rst,
    input btn_u, input btn_d, input btn_l, input btn_r, input btn_c,
    output [3:0] pix_r, output [3:0] pix_g, output [3:0] pix_b,
    output hsync, output vsync
    );
    
    wire pixclk, prelogclk;
    
    wire [10:0] curr_x;
    wire [9:0] curr_y;
    
    wire [3:0] red;
    wire [3:0] green;
    wire [3:0] blue;

    clk_wiz_0 instance_name(.clk_in1(clk), .clk_out1(pixclk), .clk_out2(prelogclk));
    
    vga_out vga(.clk(pixclk), .rst(rst), .red(red), .green(green), .blue(blue),
                .pix_r(pix_r), .pix_g(pix_g), .pix_b(pix_b),
                .hsync(hsync), .vsync(vsync), .curr_x(curr_x), .curr_y(curr_y));
    
    reg [10:0] blkpos_x;
    reg [9:0] blkpos_y;
    
    // wire [3:0] red_con; wire [3:0] green_con; wire [3:0] blue_con;
    // drawcon drawcon(.blkpos_x(blkpos_x), .blkpos_y(blkpos_y),
    //                 .draw_x(curr_x), .draw_y(curr_y),
    //                 .r(red_con), .g(green_con), .b(blue_con));
    
    // add -->
    wire [10:0] next_pixel_x = curr_x + 2; // Account for 2 clock cycle delay
    wire [9:0] next_pixel_y = curr_y;
    wire [3:0] red_sprite; wire [3:0] green_sprite; wire [3:0] blue_sprite;
    drawsprite drawsprite (
        .clk(pixclk),
        .pixel_x(curr_x), .pixel_y(curr_y),
        .next_pixel_x(next_pixel_x), .next_pixel_y(next_pixel_y),
        .sprite_pos_x(blkpos_x), .sprite_pos_y(blkpos_y),
        .red_sprite(red), .green_sprite(green), .blue_sprite(blue)
    );

    // // add --> Combine sprite and con colors
    // display_logic display_logic (
    //     .blkpos_x(blkpos_x), .blkpos_y(blkpos_y),
    //     .draw_x(curr_x), .draw_y(curr_y),
    //     .red_con(red), .green_con(green), .blue_con(blue),
    //     .red_sprite(red_sprite), .green_sprite(green_sprite), .blue_sprite(blue_sprite),
    //     .red(red), .green(green), .blue(blue)
    // );


    reg [16:0] logclk;
    
    always @ (posedge prelogclk) begin
        if (!rst || logclk >= 17'd78776)
            logclk <= 17'd0;
        else
            logclk <= logclk + 1'b1;
    end
    
    always @ (posedge logclk[16]) begin
        if (btn_c) begin
            blkpos_x <= 11'd623;
            blkpos_y <= 10'd383;
        end else begin            
            if (btn_u)
                blkpos_y <= blkpos_y <= 10'd11 ? 10'd11 : blkpos_y - 10'd4;
            else if (btn_d)
                blkpos_y <= blkpos_y >= 10'd789 - 10'd33 ? 10'd789 - 10'd33 : blkpos_y + 10'd4;
            else if (blkpos_y <= 10'd11)
                blkpos_y <= 10'd11;
            else if (blkpos_y >= 10'd789 - 10'd33)
                blkpos_y <= 10'd789 - 10'd33;
            
            if (btn_l)
                blkpos_x <= blkpos_x <= 11'd11 ? 11'd11 : blkpos_x - 11'd4;
            else if (btn_r)
                blkpos_x <= blkpos_x >= 11'd1269 - 11'd33 ? 11'd1269 - 11'd33 : blkpos_x + 11'd4;
            else if (blkpos_x <= 11'd11)
                blkpos_x <= 11'd11;
            else if (blkpos_x >= 11'd1269 - 11'd33)
                blkpos_x <= 11'd1269 - 11'd33;
        end
    end
    
endmodule
