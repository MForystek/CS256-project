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
`include <constants.v>

module game_top(
    input clk, input rst, input [`CANNONS_NUM-1:0] cannons_on,
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

    clk_wiz_0 clock_wizard(.clk_in1(clk), .clk_out1(pixclk), .clk_out2(prelogclk));
    
    vga_out vga(.clk(pixclk), .rst(rst), .red(red), .green(green), .blue(blue),
                .pix_r(pix_r), .pix_g(pix_g), .pix_b(pix_b),
                .hsync(hsync), .vsync(vsync), .curr_x(curr_x), .curr_y(curr_y));
    
    reg [16:0] logclk;
    
    always @ (posedge prelogclk) begin
        if (!rst || logclk >= 17'd78776)
            logclk <= 17'd0;
        else
            logclk <= logclk + 1'b1;
    end

// ----------------------------------------------------------------------------------------------------------
// Moving block
// ----------------------------------------------------------------------------------------------------------    
    reg [10:0] block_pos_x;
    reg [9:0] block_pos_y;
    
    always @ (posedge logclk[16]) begin
        if (!rst || btn_c) begin
            block_pos_x <= 11'd623;
            block_pos_y <= 10'd383;
        end else begin            
            if (btn_u)
                block_pos_y <= block_pos_y <= `FRAME_HEIGHT + 10'd1 ? `FRAME_WIDTH + 10'd1 : block_pos_y - `BLOCK_SPEED_Y;
            else if (btn_d)
                block_pos_y <= block_pos_y >= `HEIGHT - `FRAME_HEIGHT - `BLOCK_HEIGHT - 10'd1 ? `HEIGHT - `FRAME_HEIGHT - `BLOCK_HEIGHT - 10'd1 : block_pos_y + `BLOCK_SPEED_Y;
            else if (block_pos_y <= `FRAME_HEIGHT + 10'd1)
                block_pos_y <= `FRAME_HEIGHT + 10'd1;
            else if (block_pos_y >= `HEIGHT - `FRAME_HEIGHT - `BLOCK_HEIGHT - 10'd1)
                block_pos_y <=  `HEIGHT - `FRAME_HEIGHT - `BLOCK_HEIGHT - 10'd1;
            
            if (btn_l)
                block_pos_x <= block_pos_x <= `FRAME_WIDTH + 11'd1 ? `FRAME_WIDTH + 11'd1 : block_pos_x - `BLOCK_SPEED_X;
            else if (btn_r)
                block_pos_x <= block_pos_x >= `WIDTH - `FRAME_WIDTH - `BLOCK_WIDTH - 11'd1 ? `WIDTH - `FRAME_WIDTH - `BLOCK_WIDTH - 11'd1 : block_pos_x + `BLOCK_SPEED_X;
            else if (block_pos_x <= `FRAME_WIDTH + 11'd1)
                block_pos_x <= `FRAME_WIDTH + 11'd1;
            else if (block_pos_x >= `WIDTH - `FRAME_WIDTH - `BLOCK_WIDTH - 11'd1)
                block_pos_x <= `WIDTH - `FRAME_WIDTH - `BLOCK_WIDTH - 11'd1;
        end
    end

// ----------------------------------------------------------------------------------------------------------    
// Shooting bullets
// ----------------------------------------------------------------------------------------------------------       
    wire [10:0] bullet_pos_x [`CANNONS_NUM-1:0][`BULLETS_PER_CANNON-1:0];
    wire [9:0] bullet_pos_y [`CANNONS_NUM-1:0][`BULLETS_PER_CANNON-1:0];
    
    wire [11*`CANNONS_NUM*`BULLETS_PER_CANNON-1:0] all_bullet_pos_x;
    wire [10*`CANNONS_NUM*`BULLETS_PER_CANNON-1:0] all_bullet_pos_y;
    
    generate
        genvar i; genvar j;
        for (i = 0; i < `CANNONS_NUM; i = i + 1) begin
            for (j = 0; j < `BULLETS_PER_CANNON; j = j + 1) begin
                bullet #(.FROM_CANNON(i)) bullet (
                    .logclk(logclk[16]), .rst(rst), .cannons_on(cannons_on),
                    .bullet_pos_x(bullet_pos_x[i][j]), .bullet_pos_y(bullet_pos_y[i][j]));
                assign all_bullet_pos_x[11*`BULLETS_PER_CANNON*i+11*j +: 11] = bullet_pos_x[i][j];
                assign all_bullet_pos_y[10*`BULLETS_PER_CANNON*i+10*j +: 10] = bullet_pos_y[i][j];
            end
        end
    endgenerate
    
// ----------------------------------------------------------------------------------------------------------    
// Drawcon instance 
// ----------------------------------------------------------------------------------------------------------    
    drawcon drawcon(.block_pos_x(block_pos_x), .block_pos_y(block_pos_y),
                    .all_bullet_pos_x(all_bullet_pos_x), .all_bullet_pos_y(all_bullet_pos_y),
                    .draw_x(curr_x), .draw_y(curr_y),
                    .r(red), .g(green), .b(blue)); 
endmodule


module bullet #(parameter FROM_CANNON = 0)(
    input logclk, input rst, input [`CANNONS_NUM-1:0] cannons_on,
    output reg [10:0] bullet_pos_x, output [9:0] bullet_pos_y
    );
    
    localparam [5:0] DELAY = 6'd60 / `BULLETS_PER_CANNON;
    reg [5:0] bullet_timer;
    
    always @ (posedge logclk) begin
        if (!rst || !cannons_on[FROM_CANNON])
            bullet_timer <= 4'd0;
        else if (bullet_timer < DELAY)
            bullet_timer <= bullet_timer + 1'b1;
        
        if (bullet_timer < DELAY || !rst || bullet_pos_x >= `WIDTH - `FRAME_WIDTH - 11'd1 
            || (!cannons_on[FROM_CANNON] && bullet_pos_x == `CANNON_OFFSET_X + `CANNON_WIDTH - `BULLET_WIDTH))
            bullet_pos_x <= `CANNON_OFFSET_X + `CANNON_WIDTH - `BULLET_WIDTH;
        else
            bullet_pos_x <= bullet_pos_x + `BULLET_SPEED;
    end
    
    assign bullet_pos_y = `CANNON_OFFSET_Y + `CANNON_HEIGHT*FROM_CANNON + `CANNON_DISTANCE*FROM_CANNON + (`CANNON_HEIGHT - `BULLET_HEIGHT) / 2;

endmodule
