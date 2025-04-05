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
        input switch1,
        input switch2,
        output out1,
        output out2
    );
    
    assign out1 = (switch1&switch2);
    assign out2 = switch2|switch1;
    
endmodule
