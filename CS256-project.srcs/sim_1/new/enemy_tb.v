`timescale 1ns / 1ps

module enemy_tb;
    reg logclk;
    reg rst;
    reg btn_c;
    reg [11*`BULLETS_PER_CANNON-1:0] line_bullet_pos_x;
    
    wire [10:0] enemy_pos_x;
    wire [9:0] enemy_pos_y;
    wire killed;
    
    enemy #(.TOWARDS_CANNON(0), .ENEMY_NUM(0)) uut (
                    .logclk(logclk), .rst(rst), .btn_c(btn_c),
                    .line_bullet_pos_x(line_bullet_pos_x),
                    .enemy_pos_x(enemy_pos_x), .enemy_pos_y(enemy_pos_y),
                    .killed(killed));
                    
    initial begin 
        logclk = 1'b0;
        rst = 1'b0;
        btn_c = 1'b0;
        line_bullet_pos_x = 11'd600;
        #15 rst = 1'b1;
    end 
    always #5 logclk = ~logclk;

endmodule
