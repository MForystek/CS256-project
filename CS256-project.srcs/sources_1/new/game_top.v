`timescale 1ns / 1ps

`include <constants.v>

module game_top(
    input clk, input rst, input [`CANNONS_NUM-1:0] cannons_on,
    input btn_u, input btn_d, input btn_l, input btn_r, input btn_c,
    output [3:0] pix_r, output [3:0] pix_g, output [3:0] pix_b,
    output hsync, output vsync,
    output a, output b, output c, output d,
    output e, output f, output g, output [7:0] an
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
// Shooting bullets
// ----------------------------------------------------------------------------------------------------------           
    wire [10:0] bullet_pos_x [`CANNONS_NUM-1:0][`BULLETS_PER_CANNON-1:0];
    wire [9:0] bullet_pos_y [`CANNONS_NUM-1:0][`BULLETS_PER_CANNON-1:0];
    
    wire [11*`CANNONS_NUM*`BULLETS_PER_CANNON-1:0] all_bullet_pos_x;
    wire [10*`CANNONS_NUM*`BULLETS_PER_CANNON-1:0] all_bullet_pos_y;
    
    generate
        genvar i; genvar j;
        for (i = 1; i < `CANNONS_NUM; i = i + 1) begin
            for (j = 0; j < `BULLETS_PER_CANNON; j = j + 1) begin
                bullet #(.FROM_CANNON(i), .BULLET_NUM(j)) bullet (
                    .logclk(logclk[16]), .rst(rst), .btn_c(btn_c), .cannons_on(cannons_on),
                    .line_enemy_pos_x(all_enemy_pos_x[11*`ENEMIES_PER_CANNON*i +: 11*`ENEMIES_PER_CANNON]),
                    .global_gameover(global_gameover),
                    .bullet_pos_x(bullet_pos_x[i][j]), .bullet_pos_y(bullet_pos_y[i][j]));
                assign all_bullet_pos_x[11*`BULLETS_PER_CANNON*i+11*j +: 11] = bullet_pos_x[i][j];
                assign all_bullet_pos_y[10*`BULLETS_PER_CANNON*i+10*j +: 10] = bullet_pos_y[i][j];
            end
        end
    endgenerate

// ----------------------------------------------------------------------------------------------------------    
// Generating enemies 
// ----------------------------------------------------------------------------------------------------------    
    wire [10:0] enemy_pos_x [`CANNONS_NUM-1:0][`ENEMIES_PER_CANNON-1:0];
    wire [9:0] enemy_pos_y [`CANNONS_NUM-1:0][`ENEMIES_PER_CANNON-1:0];
    
    wire [11*`CANNONS_NUM*`ENEMIES_PER_CANNON-1:0] all_enemy_pos_x;
    wire [10*`CANNONS_NUM*`ENEMIES_PER_CANNON-1:0] all_enemy_pos_y;
    
    wire [`CANNONS_NUM*`ENEMIES_PER_CANNON-1:0] killed;
    wire [`CANNONS_NUM*`ENEMIES_PER_CANNON-1:0] gameover;
    assign global_gameover = |gameover;
    
    wire [`ENEMY_DELAY_SIZE-1:0] rnd;
    prng #(.SEED(`RNG_SIZE'hF)) prng1(.clk(clk), .rst(rst), .rnd(rnd[15:0]));
    prng #(.SEED(`RNG_SIZE'h3)) prng2(.clk(clk), .rst(rst), .rnd(rnd[31:16]));
    prng #(.SEED(`RNG_SIZE'h5)) prng3(.clk(clk), .rst(rst), .rnd(rnd[47:32]));
    prng #(.SEED(`RNG_SIZE'hB)) prng4(.clk(clk), .rst(rst), .rnd(rnd[63:48]));
    
    reg [`ENEMY_DELAY_SIZE-1:0] enemy_mask;
    
    always @ * begin
        if (!rst || btn_c)
            enemy_mask = `ENEMY_DELAY_SIZE'd0;
        else if (enemy_mask == `ENEMY_DELAY_SIZE'd0 && rnd != enemy_mask)
            enemy_mask = rnd;
        else
            enemy_mask = enemy_mask; 
    end
        
    generate
        genvar k; genvar l;
        for (k = 1; k < `CANNONS_NUM; k = k + 1) begin
            for (l = 0; l < `ENEMIES_PER_CANNON; l = l + 1) begin
                enemy #(.TOWARDS_CANNON(k), .ENEMY_NUM(l)) enemy (
                    .logclk(logclk[16]), .rst(rst), .btn_c(btn_c),
                    .line_bullet_pos_x(all_bullet_pos_x[11*`BULLETS_PER_CANNON*k +: 11*`BULLETS_PER_CANNON]),
                    .enemy_pos_x(enemy_pos_x[k][l]), .enemy_pos_y(enemy_pos_y[k][l]),
                    .global_gameover(global_gameover), .is_masked(enemy_mask[`ENEMIES_PER_CANNON*k + l]),
                    .killed(killed[`ENEMIES_PER_CANNON*k + l]), .gameover(gameover[`ENEMIES_PER_CANNON*k + l]));
                assign all_enemy_pos_x[11*`ENEMIES_PER_CANNON*k+11*l +: 11] = enemy_pos_x[k][l];
                assign all_enemy_pos_y[10*`ENEMIES_PER_CANNON*k+10*l +: 10] = enemy_pos_y[k][l];
            end
        end
    endgenerate

// ----------------------------------------------------------------------------------------------------------    
// Instanciating Drawcon 
// ----------------------------------------------------------------------------------------------------------    
    drawcon drawcon(.pixclk(pixclk),
                    .all_bullet_pos_x(all_bullet_pos_x), .all_bullet_pos_y(all_bullet_pos_y),
                    .all_enemy_pos_x(all_enemy_pos_x), .all_enemy_pos_y(all_enemy_pos_y),
                    .draw_x(curr_x), .draw_y(curr_y),
                    .r(red), .g(green), .b(blue));
                    
// ----------------------------------------------------------------------------------------------------------    
// Displaying score and texts on sevenseg
// ----------------------------------------------------------------------------------------------------------        
    reg [15:0] killed_num;
    
    integer ki;
    always @ (killed) begin
        if (!global_gameover) begin
            killed_num = 16'd0;
            for (ki = `ENEMIES_PER_CANNON; ki < `CANNONS_NUM*`ENEMIES_PER_CANNON; ki = ki + 1) begin
                killed_num[3:0] = killed_num[3:0] > 4'd9 ? 4'd0 : killed_num[3:0] + killed[ki];
                if (killed_num[3:0] > 4'd9) begin
                    killed_num[7:4] = killed_num[7:4] > 4'd9 ? 4'd0 : killed_num[7:4] + 1'b1;
                    if (killed_num[7:4] > 4'd9) begin
                        killed_num[11:8] = killed_num[11:8] > 4'd9 ? 4'd0 : killed_num[11:8] + 1'b1;
                        if (killed_num[11:8] > 4'd9) begin
                            killed_num[15:12] = killed_num[15:12] > 4'd9 ? 4'd0 : killed_num[15:12] + 1'b1;
                        end
                    end
                end 
            end
        end
    end
    
    wire [19:0] text = global_gameover == 1'b1
        ? {5'd14, 5'd17, 5'd13, 5'd31}  // End
        : {5'd18, 5'd16, 5'd10, 5'd19}; // PLAY
    
    multidigit multidigit(
        .clk(clk), .rst(rst),
        .dig0(killed_num[3:0]), .dig1(killed_num[7:4]), .dig2(killed_num[11:8]),
        .dig3(killed_num[15:12]), .dig4(text[4:0]), .dig5(text[9:5]),
        .dig6(text[14:10]), .dig7(text[19:15]),
        .a(a), .b(b), .c(c), .d(d),
        .e(e), .f(f), .g(g), .an(an));
        
endmodule