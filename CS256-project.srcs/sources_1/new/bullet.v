`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2023 12:12:37 AM
// Design Name: 
// Module Name: bullet
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

module bullet #(parameter FROM_CANNON = 0, parameter BULLET_NUM = 0)(
    input logclk, input rst, input [`CANNONS_NUM-1:0] cannons_on,
    output reg [10:0] bullet_pos_x, output [9:0] bullet_pos_y
    );
    
    localparam [5:0] DELAY = 6'd60 / `BULLETS_PER_CANNON * BULLET_NUM;
    reg [5:0] bullet_timer;
    
    
    always @ (posedge logclk) begin
        if (!rst || !cannons_on[FROM_CANNON])
            bullet_timer <= 6'd0;
        else if (bullet_timer < DELAY && bullet_pos_x == `CANNON_OFFSET_X + `CANNON_WIDTH - `BULLET_WIDTH)
            bullet_timer <= bullet_timer + 1'b1;
        
        if (!rst || bullet_pos_x >= `WIDTH - `FRAME_WIDTH - 11'd1 
            || (bullet_pos_x == `CANNON_OFFSET_X + `CANNON_WIDTH - `BULLET_WIDTH 
                && (!cannons_on[FROM_CANNON] || (cannons_on[FROM_CANNON] && bullet_timer < DELAY))))
            bullet_pos_x <= `CANNON_OFFSET_X + `CANNON_WIDTH - `BULLET_WIDTH;
        else
            bullet_pos_x <= bullet_pos_x + `BULLET_SPEED;
    end
    
    assign bullet_pos_y = `CANNON_OFFSET_Y + `CANNON_HEIGHT*FROM_CANNON + `CANNON_DISTANCE*FROM_CANNON + (`CANNON_HEIGHT - `BULLET_HEIGHT) / 2;

endmodule
