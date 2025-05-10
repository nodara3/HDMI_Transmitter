`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/08/2025 02:28:08 PM
// Design Name: 
// Module Name: hdmi_interface
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


module hdmi_interface(
    input clk,
    input resetn,
    
    output wire hSync,
    output wire vSync
    );
    
    reg cur_state[2:0];
    reg next_state[2:0];
    
    parameter IDLE = 0, Control_Period = 1, Data_Island_Period = 2, Video_Data_Period = 3;
    
    always @ (posedge clk) begin
        // If reset is asserted, go back to IDLE state
        if (! resetn) begin
            cur_state <= IDLE;

        // Else transition to the next state
        end else begin
            cur_state <= next_state;
        end
    end
  
  
    
    always @ (*) begin
        
        next_state = IDLE;
        
        case(cur_state)
            IDLE: begin
            
            end
            
            
            Control_Period : begin
            
            end
            
            Data_Island_Period : begin
            
            end
            
            Video_Data_Period : begin
            
            end
            
            default: next_state = IDLE;
        
        endcase
    
    end
    
endmodule
