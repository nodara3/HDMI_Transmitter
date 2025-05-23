`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2025 09:04:26 PM
// Design Name: 
// Module Name: serdes_block
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


module serdes_block(
        input [9:0] data,
        input SERDES_CLK,
        input SERDES_CLKDIV,
        input resetn,
        
        output data_out
    );
    
    
    wire shiftout1_slv;
    wire shiftout2_slv;
    
    OSERDESE2 #(
        .DATA_RATE_OQ   ("DDR"), // DDR, SDR
        .DATA_RATE_TQ   ("DDR"), // DDR, BUF, SDR
        .DATA_WIDTH     (10), // Parallel data width (2-8,10,14)
        .INIT_OQ        (1'b0), // Initial value of OQ output (1'b0,1'b1)
        .INIT_TQ        (1'b0), // Initial value of TQ output (1'b0,1'b1)
        .SERDES_MODE    ("MASTER"), // MASTER, SLAVE
        .SRVAL_OQ       (1'b0), // OQ output value when SR is used (1'b0,1'b1)
        .SRVAL_TQ       (1'b0), // TQ output value when SR is used (1'b0,1'b1)
        .TBYTE_CTL      ("FALSE"), // Enable tristate byte operation (FALSE, TRUE)
        .TBYTE_SRC      ("FALSE"), // Tristate byte source (FALSE, TRUE)
        .TRISTATE_WIDTH (1) // 3-state converter width (1,4)
        
    )OSERDESE2_inst_master (
    
        .OFB        (), // 1-bit output: Feedback path for data
        .OQ         (data_out), // 1-bit output: Data path output
        // SHIFTOUT1 / SHIFTOUT2: 1-bit (each) output: Data output expansion (1-bit each)
        .SHIFTOUT1  (),
        .SHIFTOUT2  (),
        .TBYTEOUT   (), // 1-bit output: Byte group tristate
        .TFB        (), // 1-bit output: 3-state control
        .TQ         (), // 1-bit output: 3-state control
        .CLK        (SERDES_CLK), // 1-bit input: High speed clock
        .CLKDIV     (SERDES_CLKDIV), // 1-bit input: Divided clock
        // D1 - D8: 1-bit (each) input: Parallel data inputs (1-bit each)
        .D1         (data[0]),
        .D2         (data[1]),
        .D3         (data[2]),
        .D4         (data[3]),
        .D5         (data[4]),
        .D6         (data[5]),
        .D7         (data[6]),
        .D8         (data[7]),
        .OCE        (1'b1), // 1-bit input: Output data clock enable
        .RST        (~resetn), // 1-bit input: Reset
        // SHIFTIN1 / SHIFTIN2: 1-bit (each) input: Data input expansion (1-bit each)
        .SHIFTIN1   (shiftout1_slv),
        .SHIFTIN2   (shiftout2_slv),
        // T1 - T4: 1-bit (each) input: Parallel 3-state inputs
        .T1         (1'b0),
        .T2         (1'b0),
        .T3         (1'b0),
        .T4         (1'b0),
        .TBYTEIN    (1'b0), // 1-bit input: Byte group tristate
        .TCE        (1'b0) // 1-bit input: 3-state clock enable
        );
        
        OSERDESE2 #(
        .DATA_RATE_OQ   ("DDR"), // DDR, SDR
        .DATA_RATE_TQ   ("DDR"), // DDR, BUF, SDR
        .DATA_WIDTH     (10), // Parallel data width (2-8,10,14)
        .INIT_OQ        (1'b0), // Initial value of OQ output (1'b0,1'b1)
        .INIT_TQ        (1'b0), // Initial value of TQ output (1'b0,1'b1)
        .SERDES_MODE    ("SLAVE"), // MASTER, SLAVE
        .SRVAL_OQ       (1'b0), // OQ output value when SR is used (1'b0,1'b1)
        .SRVAL_TQ       (1'b0), // TQ output value when SR is used (1'b0,1'b1)
        .TBYTE_CTL      ("FALSE"), // Enable tristate byte operation (FALSE, TRUE)
        .TBYTE_SRC      ("FALSE"), // Tristate byte source (FALSE, TRUE)
        .TRISTATE_WIDTH (1) // 3-state converter width (1,4)
        
    )OSERDESE2_inst_slave (
    
        .OFB            (), // 1-bit output: Feedback path for data
        .OQ             (), // 1-bit output: Data path output
        // SHIFTOUT1 / SHIFTOUT2: 1-bit (each) output: Data output expansion (1-bit each)
        .SHIFTOUT1      (shiftout1_slv),
        .SHIFTOUT2      (shiftout2_slv),
        .TBYTEOUT       (), // 1-bit output: Byte group tristate
        .TFB            (), // 1-bit output: 3-state control
        .TQ             (), // 1-bit output: 3-state control
        .CLK            (SERDES_CLK), // 1-bit input: High speed clock
        .CLKDIV         (SERDES_CLKDIV), // 1-bit input: Divided clock
        // D1 - D8: 1-bit (each) input: Parallel data inputs (1-bit each)
        .D1             (1'b0),
        .D2             (1'b0),
        .D3             (data[8]),
        .D4             (data[9]),
        .D5             (1'b0),
        .D6             (1'b0),
        .D7             (1'b0),
        .D8             (1'b0),
        .OCE            (1'b1), // 1-bit input: Output data clock enable
        .RST            (~resetn), // 1-bit input: Reset
        // SHIFTIN1 / SHIFTIN2: 1-bit (each) input: Data input expansion (1-bit each)
        .SHIFTIN1       (1'b0),
        .SHIFTIN2       (1'b0),
        // T1 - T4: 1-bit (each) input: Parallel 3-state inputs
        .T1             (1'b0),
        .T2             (1'b0),
        .T3             (1'b0),
        .T4             (1'b0),
        .TBYTEIN        (1'b0), // 1-bit input: Byte group tristate
        .TCE            (1'b0) // 1-bit input: 3-state clock enable
        );
        
endmodule
