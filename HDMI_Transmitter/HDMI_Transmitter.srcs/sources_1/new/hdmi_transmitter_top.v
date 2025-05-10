`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2025 05:40:13 PM
// Design Name: 
// Module Name: hdmi_transmitter_top
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


module hdmi_transmitter_top(
    //Input Clock
        input clk_100MHz,
    //Main Reset
        input rstn,
        
        input [7:0] pixel_data
      
//    //HDMI Outputs
//        output  wire  hdmi_tx0_p,
//        output  wire hdmi_tx0_n,
//        output  wire hdmi_tx1_p,
//        output  wire hdmi_tx1_n,
//        output  wire hdmi_tx2_p,
//        output  wire hdmi_tx2_n,
//        output  wire hdmi_tx_clk_p,
//        output  wire hdmi_tx_clk_n,
        
//    //Test IO
//        input switch1,
//        input switch2,
//        output reg out1,
//        output out2
    );
    
    
    encoder u_encode_blue(
        .clk(clk_100MHz),
        .resetn(rstn),
        .pixel_data(pixel_data)
    );
    
    


    
    
endmodule
