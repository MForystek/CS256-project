`timescale 1ns / 1ps

module bullet_tb;
    reg logclk; 
    reg rst;
    reg [`CANNONS_NUM-1:0] cannons_on;
    reg [11*`ENEMIES_PER_CANNON-1:0] line_enemy_pos_x;
    
    wire [10:0] bullet_pos_x; 
    wire[9:0] bullet_pos_y;
    
    bullet #(.FROM_CANNON(0), .BULLET_NUM(0)) uut (
                    .logclk(logclk), .rst(rst), .cannons_on(cannons_on),
                    .line_enemy_pos_x(line_enemy_pos_x),
                    .bullet_pos_x(bullet_pos_x), .bullet_pos_y(bullet_pos_y));
                    
    initial begin 
        logclk = 1'b0;
        rst = 1'b0;
        cannons_on = 4'b1111;
        line_enemy_pos_x = 11'd600;
        #15 rst = 1'b1;
    end 
    always #5 logclk = ~logclk;
    
endmodule
