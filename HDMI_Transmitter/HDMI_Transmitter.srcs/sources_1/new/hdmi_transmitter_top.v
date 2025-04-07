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
        input clk,
    //Main Reset
        input rstn,
      
    //HDMI Outputs
        output  hdmi_tx0_p,
        output  hdmi_tx0_n,
        output  hdmi_tx1_p,
        output  hdmi_tx1_n,
        output  hdmi_tx2_p,
        output  hdmi_tx2_n,
        output  hdmi_tx_clk_p,
        output  hdmi_tx_clk_n,
        
    //Test IO
        input switch1,
        input switch2,
        output out1,
        output out2
    );
    
    assign out1 = (switch1&switch2);
    assign out2 = switch2|switch1;
    
endmodule
