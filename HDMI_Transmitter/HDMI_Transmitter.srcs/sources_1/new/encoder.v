`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/10/2025 12:53:49 PM
// Design Name: 
// Module Name: encoder
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


module encoder #(

    parameter TMDS_Channel = 0)
    ( 
    input clk,
    input resetn,
    input [7:0] pixel_data,
    input [1:0] control_data,
    input [3:0] aux_data,
    input [2:0] h_state,
    input [2:0] v_state,
    
    output reg [9:0] TMDS_Data
    );
    
    localparam IDLE = 0, hFront = 1, hSync = 2, hBack = 3, Preamble = 4, Video_Guard = 5, Video_Data_Period = 6;
    localparam vFront = 1, vSync = 2, vBack = 3, vPixel = 4;
    
    // codings for control, video and island periods
    // 1: Control Period
    function [9:0] control_coding;
    input D1, D0;
    begin
        case ({D1, D0})
            2'b00: control_coding = 10'b1101010100;
            2'b01: control_coding = 10'b0010101011;
            2'b10: control_coding = 10'b0101010100;
            2'b11: control_coding = 10'b1010101011;
            default: control_coding = 10'b0000000000; // Optional: default case
        endcase
    end
    endfunction
    
    // 2: TERC4 Coding for Data Island Period
    function [9:0] data_island_coding;
    input D3, D2, D1, D0;
    begin
        case ({D3, D2, D1, D0})
            4'b0000: data_island_coding = 10'b1010011100; 
            4'b0001: data_island_coding = 10'b1001100011;
            4'b0010: data_island_coding = 10'b1011100100; 
            4'b0011: data_island_coding = 10'b1011100010; 
            4'b0100: data_island_coding = 10'b0101110001; 
            4'b0101: data_island_coding = 10'b0100011110; 
            4'b0110: data_island_coding = 10'b0110001110; 
            4'b0111: data_island_coding = 10'b0100111100; 
            4'b1000: data_island_coding = 10'b1011001100; 
            4'b1001: data_island_coding = 10'b0100111001; 
            4'b1010: data_island_coding = 10'b0110011100; 
            4'b1011: data_island_coding = 10'b1011000110; 
            4'b1100: data_island_coding = 10'b1010001110; 
            4'b1101: data_island_coding = 10'b1001110001; 
            4'b1110: data_island_coding = 10'b0101100011; 
            4'b1111: data_island_coding = 10'b1011000011;
            default: data_island_coding = 10'b0000000000; // Optional: default case
        endcase
    end
    endfunction
    
    
    // video guard coding
    function [9:0] f_video_guard;
    input channel;
    begin
        case (channel)
            0: f_video_guard = 10'b1011001100; 
            1: f_video_guard = 10'b0100110011;
            2: f_video_guard = 10'b1011001100; 
            default: f_video_guard = 10'b0000000000; // Optional: default case
        endcase
    end
    endfunction
    
    
    integer cnt_prev;
    integer cnt_new;
    integer i;
    reg [8:0] q_m;
    reg [9:0] q_out;
    
    reg [9:0] q_out_control;
    
    reg [9:0] video_guard_data;
    
    integer clock_cnt;
    
    
    always @(*) begin
        if (!resetn) begin
            TMDS_Data = 0;
        end else begin
            case (h_state)
                IDLE:
                    TMDS_Data = 0;
                hFront:
                    TMDS_Data = q_out_control;
                hSync: 
                    TMDS_Data = q_out_control;
                hBack:
                    TMDS_Data = q_out_control;
                Preamble: 
                    TMDS_Data = q_out_control;
                Video_Guard:
                    if (v_state == vPixel) begin
                        TMDS_Data = video_guard_data;
                    end else begin
                        TMDS_Data = q_out_control;
                    end
                
                Video_Data_Period:
                    if (v_state == vPixel) begin
                        TMDS_Data = q_out;
                    end else begin
                        TMDS_Data = q_out_control;
                    end
                
                default: TMDS_Data = 0;
            endcase    
        end
    end
    
    
    
    // Control data to 10 bit 
    always @(posedge clk) begin
        if (!resetn) begin
            q_out_control <= 0;
        end else begin
            q_out_control <= control_coding(control_data[1], control_data[0]);
            video_guard_data <= f_video_guard(TMDS_Channel);
        end
    end   
    
    
    // 3: Video Data Period Coding
    always @(posedge clk) begin
        if (!resetn) begin
            cnt_prev <= 0; 
            q_m <= 0;   
            clock_cnt <= 0;
            q_out = 0;
            cnt_new = 0;
        end else begin
            // Step 1:
            cnt_prev <= cnt_new;
            q_m <= video_encoding1(pixel_data);
            // Step 2:
            if (cnt_prev == 0 ||  N1(q_m[7:0]) == N0(q_m[7:0])) begin
        
                q_out[9] <= ~q_m[8]; 
                q_out[8] <= q_m[8]; 
                q_out[7:0] <= (q_m[8]) ? q_m[7:0]:~q_m[7:0];
                
                if (q_m[8] == 0) begin
                    cnt_new <= cnt_prev + (N0(q_m[7:0]) - N1(q_m[7:0]));
                end else begin
                    cnt_new <= cnt_prev + (N1(q_m[7:0]) - N0(q_m[7:0]));
                end
                
            end else begin
                
                if ((cnt_prev > 0 && N1(q_m[7:0]) > N0(q_m[7:0])) || (cnt_prev < 0 && N0(q_m[7:0]) > N1(q_m[7:0]))) begin
                
                    q_out[9] <= 1; 
                    q_out[8] <= q_m[8]; 
                    q_out[7:0] <= ~q_m[7:0]; 
                    cnt_new <= cnt_prev + 2*q_m[8] + N0(q_m[7:0]) - N1(q_m[7:0]);
                    
                end else begin
                
                    q_out[9] <= 0; 
                    q_out[8] <= q_m[8]; 
                    q_out[7:0] <= q_m[7:0]; 
                    cnt_new <= cnt_prev - 2*(~q_m[8]) + N1(q_m[7:0]) - N0(q_m[7:0]);
                
                end
            
            end
            
        end 
    end
    
    // Counts 1s in data
    function [8:0] video_encoding1;
    input [7:0] pixel_data;
    reg [8:0] q_m;
    integer i;
    begin
        q_m = 0;
        if (N1(pixel_data) > 4 || ( N1(pixel_data) == 4 && pixel_data[0] == 0)) begin
            
            q_m[0] = pixel_data[0];
            for (i = 0; i <7; i= i + 1) begin
                q_m[i+1] = q_m[i] ~^ pixel_data[i+1];
            end
            q_m[8] = 0;
            
        end else begin
        
            q_m[0] = pixel_data[0];
            for (i = 0; i <7; i= i + 1) begin
                q_m[i+1] = q_m[i] ^ pixel_data[i+1];
            end
            q_m[8] = 1;
            
        end 
        
        video_encoding1 = q_m;
    end
    endfunction
    
//    always @(posedge clk or negedge resetn) begin
//        if (!resetn) begin
//            cnt_prev <= 0;
//            q_m <= 0;
//            q_out <= 0;
//        end else begin
//            cnt_prev <= cnt_new_temp;
//            q_m <= q_m_temp;
//            q_out <= q_out_temp;
//        end
//    end
    
    
//    // STEP 2
//    always @(*) begin
    
//        if (!resetn) begin
//        //  Step 1 : 

            
//        end else begin
//            // Step 2:
           
//        end
//    end
    
    // Counts 1s in data
    function integer N1;
    input [7:0] data;
    integer i, cnt;
    begin
        cnt = 0;
        for (i = 0; i < 8; i = i + 1) begin
            cnt = cnt + data[i];
        end
        N1 = cnt;
    end
    endfunction
    
    // Counts 0s in data
    function integer N0;
    input [7:0] data;
    integer i, cnt;
    begin
        cnt = 0;
        for (i = 0; i < 8; i = i + 1) begin
            cnt = cnt + ~data[i];
        end
        N0 = cnt;
    end
    endfunction
    
   
endmodule
