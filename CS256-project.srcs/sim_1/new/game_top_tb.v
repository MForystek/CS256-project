`timescale 1ns / 1ps

module game_top_tb;
    reg clk; reg rst;
    reg btn_u; reg btn_d; reg btn_l; reg btn_r; reg btn_c;
    reg [3:0] cannons_on;
    
    wire [3:0] pix_r; wire [3:0] pix_g; wire [3:0] pix_b;
    wire hsync; wire vsync;
    
    game_top uut (.clk(clk), .rst(rst), .cannons_on(cannons_on), 
                  .btn_u(btn_u), .btn_d(btn_d), .btn_l(btn_l), .btn_r(btn_r), .btn_c(btn_c),
                  .pix_r(pix_r), .pix_g(pix_g), .pix_b(pix_b),
                  .hsync(hsync), .vsync(vsync));
    
    initial begin 
        clk = 1'b0;
        rst = 1'b0;
        btn_u = 1'b0;
        btn_d = 1'b0;
        btn_l = 1'b0;
        btn_r = 1'b0;
        btn_c = 1'b1;
        cannons_on = 4'b1111;
        #13950000 rst = 1'b1;
        btn_c = 1'b0;        
    end 
    always #5 clk = ~clk;
    
endmodule
