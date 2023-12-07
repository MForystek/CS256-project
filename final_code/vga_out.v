`timescale 1ns / 1ps

module vga_out(
    input clk, input rst, input [3:0] red, input [3:0] green, input [3:0] blue,
    output [3:0] pix_r, output [3:0] pix_g, output [3:0] pix_b,
    output hsync, output vsync,
    output reg [10:0] curr_x, output reg [9:0] curr_y
    );
    reg [10:0] hcount;
    reg [9:0] vcount;
    
    always @ (posedge clk) begin
        if (!rst) begin
            hcount <= 11'd0;
            vcount <= 10'd0;
        end else begin
            if (hcount >= 11'd1679) begin
                hcount <= 11'd0;
                if (vcount >= 10'd827) vcount <= 10'd0;
                else vcount <= vcount + 1'b1;
            end
            else hcount <= hcount + 1'b1;
        end
    end
    
    always @ (posedge clk) begin
        if (!rst) begin
            curr_x <= 11'd0;
            curr_y <= 10'd0;
        end else begin
            if (hcount >= 11'd336 - 11'd1 && hcount <= 11'd1615 - 11'd1)
                curr_x <= hcount - 11'd335;
            if (vcount >= 10'd27 - 10'd1 && vcount <= 10'd826 - 10'd1 && hcount == 11'd1679)
                curr_y <= vcount - 10'd26;
        end
    end
    
    assign hsync = hcount <= 11'd135 ? 1'b0 : 1'b1;
    assign vsync = vcount <= 10'd2 ? 1'b1 : 1'b0;
    
    assign pix_r = hcount >= 11'd336 && hcount <= 11'd1615
        && vcount >= 10'd27 && vcount <= 10'd826 
        ? red : 4'd0;
    assign pix_g = hcount >= 11'd336 && hcount <= 11'd1615
        && vcount >= 10'd27 && vcount <= 10'd826
        ? green : 4'd0;
    assign pix_b = hcount >= 11'd336 && hcount <= 11'd1615
        && vcount >= 10'd27 && vcount <= 10'd826
        ? blue : 4'd0;
        
endmodule
