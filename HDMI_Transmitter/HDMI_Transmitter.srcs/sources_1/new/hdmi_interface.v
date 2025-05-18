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


module hdmi_interface#(

    parameter TMDS_Channel = 0,
    parameter Horizontal_Visible_Pixels = 1440,
    parameter Horizontal_Front_Porch = 80,
    parameter Horizontal_Sync_Pulse = 152,   //(active-high)
    parameter Horizontal_Back_Porch = 232,
    parameter Vertical_Visible_Lines = 900,
    parameter Vertical_Front_Porch = 1,
    parameter Vertical_Sync_Pulse = 3,  //(active-high)
    parameter Vertical_Back_Porch = 28
    
    )
    (
    input clk,
    input resetn,
    
    output reg [1:0] control_data,
    output reg [7:0] pixel_data,
    output reg [3:0] aux_data,
    output [2:0] h_state,
    output [2:0] v_state
    );
    
    reg [2:0] h_cur_state, v_cur_state;
    reg [2:0] h_next_state, v_next_state;
    reg count_enable;
    reg hStandby;
    integer hCounter, vCounter;
    
    reg vSync_Pulse, hSync_Pulse;
    reg [3:0] CTL;
    localparam Vertical_Blanking = Vertical_Front_Porch + Vertical_Sync_Pulse + Vertical_Back_Porch;
    localparam Vertical_Full_Period = Vertical_Blanking + Vertical_Visible_Lines;
    
    localparam Preamble_Size = 8;
    localparam Video_Guard_Size = 2;
  
    localparam Horizontal_Blanking = Horizontal_Front_Porch + Horizontal_Sync_Pulse + Horizontal_Back_Porch;
    localparam Horizontal_Full_Period = Horizontal_Blanking + Horizontal_Visible_Pixels; 
    
    localparam IDLE = 0, hFront = 1, hSync = 2, hBack = 3, Video_Data_Period = 4;
    localparam vFront = 1, vSync = 2, vBack = 3, vPixel = 4;
    
    assign v_state = v_cur_state;
    assign h_state = h_cur_state;
    
    always @ (posedge clk) begin

        if (! resetn) begin
            h_cur_state <= IDLE;
            v_cur_state <= IDLE;
            hCounter <= 0;
            vCounter <= 0;

        end else begin
        
//            if (h_cur_state != h_next_state) begin
//                hCounter <= 0;
//            end else begin
//                hCounter <= hCounter + 1;
//            end
            
            
            if (hCounter < Horizontal_Full_Period - 2) begin
                hCounter <= hCounter + 1;
                
            end else if (hCounter < Horizontal_Full_Period - 1)begin
            
                hCounter <= hCounter + 1;
                if (vCounter < Vertical_Full_Period - 1) begin
                    vCounter <= vCounter + 1;
                end else begin
                    vCounter <= 0;
                end
             end else begin   
                hCounter <= 0;
                
                //increment vCounter before it runs whole vertical 
                
            end
            
            // State Update 
            h_cur_state <= h_next_state;
            v_cur_state <= v_next_state;
        end
    end
  
    // Sync pulse change
    always @ (posedge clk) begin

        if (! resetn) begin
            vSync_Pulse <= 0;
            hSync_Pulse <= 0;
        end else begin
        
            case(v_cur_state)  
                IDLE    : vSync_Pulse <= 0;
                vFront  : vSync_Pulse <= 0;    
                vSync   : vSync_Pulse <= 1;                             
                vBack   : vSync_Pulse <= 0;                       
                vPixel  : vSync_Pulse <= 0;                
                default : vSync_Pulse <= 0;          
            endcase        

            case(h_cur_state)                
                IDLE    : hSync_Pulse <= 0;                     
                hFront  : hSync_Pulse <= 0;    
                hSync   : hSync_Pulse <= 1;
                hBack   : hSync_Pulse <= 0;
                Video_Data_Period : hSync_Pulse <= 0;
                default : hSync_Pulse <= 0;        
            endcase
            
        end
    end
    
    
    always @ (*) begin
        
        if (! resetn) begin
            control_data = 1'b00;      
        end else begin
        
            case(TMDS_Channel)
            
                0: begin
                    control_data[0] = vSync_Pulse;
                    control_data[1] = hSync_Pulse;
                end
                    
                1 : control_data = 1'b00;
                
                2 : control_data = 1'b00;  
                
                default: control_data = 1'b00;
                
            endcase
        end
    end  
    

    // Vertical Sync FSM
    always @ (*) begin
        pixel_data = 0;
        aux_data = 0;
        
       if (!resetn) begin
       
            v_next_state = IDLE;
            
       end else begin 
       
            case(v_cur_state) 
             
                IDLE: begin                    
                    if (!resetn) begin
                        v_next_state = IDLE;
                    end else begin
                        v_next_state = vFront;
                    end
                end
                     
                vFront : begin                    
                    if (vCounter == Vertical_Front_Porch) begin                        
                        v_next_state = vSync;
                    end else begin
                        v_next_state = vFront;
                    end    
                end
    
                vSync : begin                    
                    if (vCounter == Vertical_Front_Porch + Vertical_Sync_Pulse) begin
                        v_next_state = vBack;
                    end else begin
                        v_next_state = vSync;
                    end
                end
                
                vBack  : begin                    
                    if (vCounter == Vertical_Blanking) begin
                        v_next_state = vPixel;
                    end else begin
                        v_next_state = vBack;                        
                    end
                    
                end
                
                vPixel : begin                 
                    if (vCounter == Vertical_Full_Period) begin                        
                        v_next_state = vFront;
                    end else begin
                        v_next_state = vPixel;
                    end
                end
                
                default: v_next_state = IDLE;
            
            endcase
        end
    end
    
    // Horizontal Sync FSM
    always @ (*) begin
        
        if (!resetn) begin
            h_next_state = IDLE;
        end else begin 
            
            case(h_cur_state)
                
                IDLE: begin                    
                    if (!resetn) begin
                        h_next_state = IDLE;
                    end else begin
                        h_next_state = hFront;
                    end
                end
                     
                hFront : begin                    
                    if (hCounter == Horizontal_Front_Porch - 1) begin
                        h_next_state = hSync;
                    end else begin
                        h_next_state = hFront;
                    end   
                end
    
                hSync : begin                    
                    if (hCounter == Horizontal_Front_Porch + Horizontal_Sync_Pulse - 1) begin
                        h_next_state = hBack;
                    end else begin
                        h_next_state = hSync;                        
                    end
                end
                
                hBack  : begin                    
                    if (hCounter == Horizontal_Blanking - 1) begin
                        h_next_state = Video_Data_Period;
                    end else begin
                        h_next_state = hBack;
                        
                    end                    
                end
                
//                Preamble : begin
                
//                   hSync_Pulse = 0;
//                   CTL = 4'b0001;
                    
//                   if (hCounter < Horizontal_Blanking - Video_Guard_Size - 1) begin
//                        h_next_state = Preamble;
//                    end else begin
//                        h_next_state = Video_Guard;
//                    end
//                end
                
//                Video_Guard : begin
//                    hSync_Pulse = 0;
//                   if (hCounter < Horizontal_Blanking - 1) begin
//                        h_next_state = Video_Guard;
//                    end else begin
//                        h_next_state = Video_Data_Period;
//                    end    
                           
//                end 
                
                Video_Data_Period : begin                    
                    if (hCounter == Horizontal_Full_Period - 1) begin         
                        h_next_state = hFront;
                    end else begin
                        h_next_state = Video_Data_Period;
                    end
                end
                
                
                default: h_next_state = IDLE;
            
            endcase
        end
    end
    
endmodule
