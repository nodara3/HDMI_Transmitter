`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2025 06:02:30 PM
// Design Name: 
// Module Name: hdmi_transmitter_tb
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


module hdmi_transmitter_tb( );

    reg [7:0]pixel_data;
    reg clk, rst;


    hdmi_transmitter_top u_dut(
        .clk_100MHz (clk),
        .rstn (rst),
        .pixel_data (pixel_data)
        
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        rst = 0;
        pixel_data = 8'h00;

        #20 rst = 1;
        #5 pixel_data = 8'h55; // Example pattern
        #10 pixel_data = 8'hAA; // Another pattern
        #10 pixel_data = 8'hF0;
        #10 pixel_data = 8'h0F;
        #40 $finish;
    end
endmodule
