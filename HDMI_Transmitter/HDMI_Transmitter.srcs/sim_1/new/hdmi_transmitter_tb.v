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

    reg a, b;
    wire y0, y1;
    
    hdmi_transmitter_top u_dut(
        .a (a),
        .b (b),
        .y0 (y0),
        .y1 (y1)
        
    );
    
initial 
begin
        a= 0; b = 0;
    #10 a = 0; b = 1;
    #10 a = 1; b = 1;
    #10 $finish;
end
endmodule
