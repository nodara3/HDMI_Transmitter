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
        input rst,
//        input [7:0] pixel_data
      
//    //HDMI Outputs
        output  wire hdmi_tx0_p,
        output  wire hdmi_tx0_n,
        output  wire hdmi_tx1_p,
        output  wire hdmi_tx1_n,
        output  wire hdmi_tx2_p,
        output  wire hdmi_tx2_n,
        output  wire hdmi_tx_clk_p,
        output  wire hdmi_tx_clk_n
        
//    //Test IO
//        input switch1,
//        input switch2,
//        output reg out1,
//        output out2
    );
    
    
    wire resetn;
   
   assign resetn = ~(~locked | rst);

    wire [2:0] h_state;
    wire [2:0] v_state;
//    wire m_clk;
    wire TMDS_Channel0_Data;
    wire TMDS_Channel1_Data;
    wire TMDS_Channel2_Data;
    
    wire TMDS_Channel_CLK;
    wire [9:0] channel_data0;
    wire [9:0] channel_data1;
    wire [9:0] channel_data2;
    
    // Output Buffers
    OBUFDS #(
      .IOSTANDARD("TMDS_33"), // Specify the output I/O standard
      .SLEW("FAST")           // Specify the output slew rate
    ) u_tmds_channel0_buf (
      .O    (hdmi_tx0_p),     // Diff_p output (connect directly to top-level port)
      .OB   (hdmi_tx0_n),   // Diff_n output (connect directly to top-level port)
      .I    (TMDS_Channel0_Data)      // Buffer input
    );
    
    OBUFDS #(
      .IOSTANDARD("TMDS_33"), // Specify the output I/O standard
      .SLEW("FAST")           // Specify the output slew rate
    ) u_tmds_channel1_buf (
      .O    (hdmi_tx1_p),     // Diff_p output (connect directly to top-level port)
      .OB   (hdmi_tx1_n),   // Diff_n output (connect directly to top-level port)
      .I    (TMDS_Channel1_Data)      // Buffer input
    );
    

    OBUFDS #(
      .IOSTANDARD("TMDS_33"), // Specify the output I/O standard
      .SLEW("FAST")           // Specify the output slew rate
    ) u_tmds_channel2_buf (
      .O    (hdmi_tx2_p),     // Diff_p output (connect directly to top-level port)
      .OB   (hdmi_tx2_n),   // Diff_n output (connect directly to top-level port)
      .I    (TMDS_Channel2_Data)      // Buffer input
    );  
    
    // Clock buffer
    OBUFDS #(
      .IOSTANDARD("TMDS_33"), // Specify the output I/O standard
      .SLEW("FAST")           // Specify the output slew rate
    ) u_tmds_clock_buf (
      .O    (hdmi_tx_clk_p),     // Diff_p output (connect directly to top-level port)
      .OB   (hdmi_tx_clk_n),   // Diff_n output (connect directly to top-level port)
      .I    (TMDS_Channel_CLK)      // Buffer input
    );
    
    
    // Encoder 0
    encoder #(
        .TMDS_Channel(0) 
        
    ) u_encode_blue (
        .clk            (m_clk),
        .resetn         (resetn),
        .pixel_data     (pixel_data0),
        .control_data   (control_data0),
//        .aux_data       (aux_data),
        .h_state        (h_state),
        .v_state        (v_state),
        
        .channel_data   (channel_data0)
    );
    
    // Encoder 1
    encoder #(
        .TMDS_Channel(1) 
        
    ) u_encode_green (
        .clk            (m_clk),
        .resetn         (resetn),
        .pixel_data     (pixel_data1),
        .control_data   (control_data1),
//        .aux_data       (aux_data),
        .h_state        (h_state),
        .v_state        (v_state),
        
        .channel_data   (channel_data1)
    );
    
    // Encoder 2
    encoder #(
        .TMDS_Channel(2) 
        
    ) u_encode_red (
        .clk            (m_clk),
        .resetn         (resetn),
        .pixel_data     (pixel_data2),
        .control_data   (control_data2),
//        .aux_data       (aux_data),
        .h_state        (h_state),
        .v_state        (v_state),
        
        .channel_data   (channel_data2)
    );
    
    
    //VGA Interface
    wire [1:0] control_data0;
    wire [1:0] control_data1;
    wire [1:0] control_data2;
    wire [7:0] pixel_data0;
    wire [7:0] pixel_data1;
    wire [7:0] pixel_data2;
    
    hdmi_interface #(

        .TMDS_Channel(0)
//        .Vertical_Visible_Lines (100),
//        .Vertical_Front_Porch(1),
//        .Vertical_Sync_Pulse(3),  //(active-high)
//        .Vertical_Back_Porch(28)
    
    ) u_vga_interface (
    
        .clk            (m_clk),
        .resetn         (resetn),
        
        .pixel_data0    (pixel_data0),
        .pixel_data1    (pixel_data1),
        .pixel_data2    (pixel_data2),
        .control_data0  (control_data0),
        .control_data1  (control_data1),
        .control_data2  (control_data2),
//        .aux_data       (aux_data),
        .h_state        (h_state),
        .v_state        (v_state)
    );
    
    
    
   //CLOCK
    wire clkfb;
    wire locked;
    wire SERDES_CLK;
    wire SERDES_CLKDIV; 
    
    
    //SERDES
    serdes_block u_serdes_0 (
        .data           (channel_data0),
        .SERDES_CLK     (SERDES_CLK),
        .SERDES_CLKDIV  (m_clk),
        .resetn         (resetn),
        .data_out       (TMDS_Channel0_Data)
    );

    serdes_block u_serdes_1 (
        .data           (channel_data1),
        .SERDES_CLK     (SERDES_CLK),
        .SERDES_CLKDIV  (m_clk),
        .resetn         (resetn),
        .data_out       (TMDS_Channel1_Data)
    );
    
    serdes_block u_serdes_2 (
        .data           (channel_data2),
        .SERDES_CLK     (SERDES_CLK),
        .SERDES_CLKDIV  (m_clk),
        .resetn         (resetn),
        .data_out       (TMDS_Channel2_Data)
    );
    
    //CLOCK
    MMCME2_BASE #(
        .BANDWIDTH("OPTIMIZED"), // Jitter programming (OPTIMIZED, HIGH, LOW)
        .CLKFBOUT_MULT_F(10.750), // Multiply value for all CLKOUT (2.000-64.000).  // get 1.0647 GHz
        .CLKFBOUT_PHASE(0.0), // Phase offset in degrees of CLKFB (-360.000-360.000).
        .CLKIN1_PERIOD(10.0), // Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
        // CLKOUT0_DIVIDE - CLKOUT6_DIVIDE: Divide amount for each CLKOUT (1-128)
        .CLKOUT1_DIVIDE(10),
        .CLKOUT2_DIVIDE(2),
        .CLKOUT3_DIVIDE(4),
        .CLKOUT4_DIVIDE(1),
        .CLKOUT5_DIVIDE(1),
        .CLKOUT6_DIVIDE(1),
        .CLKOUT0_DIVIDE_F(1.0), // Divide amount for CLKOUT0 (1.000-128.000).
        // CLKOUT0_DUTY_CYCLE - CLKOUT6_DUTY_CYCLE: Duty cycle for each CLKOUT (0.01-0.99).
        .CLKOUT0_DUTY_CYCLE(0.5),
        .CLKOUT1_DUTY_CYCLE(0.5),
        .CLKOUT2_DUTY_CYCLE(0.5),
        .CLKOUT3_DUTY_CYCLE(0.5),
        .CLKOUT4_DUTY_CYCLE(0.5),
        .CLKOUT5_DUTY_CYCLE(0.5),
        .CLKOUT6_DUTY_CYCLE(0.5),
        // CLKOUT0_PHASE - CLKOUT6_PHASE: Phase offset for each CLKOUT (-360.000-360.000).
        .CLKOUT0_PHASE(0.0),
        .CLKOUT1_PHASE(0.0),
        .CLKOUT2_PHASE(0.0),
        .CLKOUT3_PHASE(0.0),
        .CLKOUT4_PHASE(0.0),
        .CLKOUT5_PHASE(0.0),
        .CLKOUT6_PHASE(0.0),
        .CLKOUT4_CASCADE("FALSE"), // Cascade CLKOUT4 counter with CLKOUT6 (FALSE, TRUE)
        .DIVCLK_DIVIDE(1), // Master division value (1-106)
        .REF_JITTER1(0.0), // Reference input jitter in UI (0.000-0.999).
        .STARTUP_WAIT("FALSE") // Delays DONE until MMCM is locked (FALSE, TRUE)
        )
        MMCME2_BASE_inst (
        // Clock Outputs: 1-bit (each) output: User configurable clock outputs
        .CLKOUT0    (TMDS_Channel_CLK), // 1-bit output: CLKOUT0 // TMDS Pixel Clock
        .CLKOUT0B   (), // 1-bit output: Inverted CLKOUT0 
        .CLKOUT1    (m_clk), // 1-bit output: CLKOUT1    // Normal CLock
        .CLKOUT1B   (), // 1-bit output: Inverted CLKOUT1
        .CLKOUT2    (SERDES_CLK), // 1-bit output: CLKOUT2
        .CLKOUT2B   (), // 1-bit output: Inverted CLKOUT2
        .CLKOUT3    (SERDES_CLKDIV), // 1-bit output: CLKOUT3
        .CLKOUT3B   (), // 1-bit output: Inverted CLKOUT3
        .CLKOUT4    (), // 1-bit output: CLKOUT4
        .CLKOUT5    (), // 1-bit output: CLKOUT5
        .CLKOUT6    (), // 1-bit output: CLKOUT6
        // Feedback Clocks: 1-bit (each) output: Clock feedback ports
        .CLKFBOUT   (clkfb), // 1-bit output: Feedback clock
        .CLKFBOUTB  (), // 1-bit output: Inverted CLKFBOUT
        // Status Ports: 1-bit (each) output: MMCM status ports
        .LOCKED     (locked), // 1-bit output: LOCK
        // Clock Inputs: 1-bit (each) input: Clock input
        .CLKIN1     (clk_100MHz), // 1-bit input: Clock
        // Control Ports: 1-bit (each) input: MMCM control ports
        .PWRDWN     (), // 1-bit input: Power-down
        .RST        (0), // 1-bit input: Reset
        // Feedback Clocks: 1-bit (each) input: Clock feedback ports
        .CLKFBIN    (clkfb) // 1-bit input: Feedback clock
        );

    
    
endmodule
