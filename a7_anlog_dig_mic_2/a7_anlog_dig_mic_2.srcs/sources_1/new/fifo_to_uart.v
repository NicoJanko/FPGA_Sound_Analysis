`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/27/2025 10:35:05 AM
// Design Name: 
// Module Name: fifo_to_uart
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


module fifo_to_uart(
    input wire clk,
    input wire ready,
    input wire [15:0] i_word, // 8 bits or 16 bits ? 
    output wire uart_tx,
    output wire busy
    );
    
    parameter CLK_RATE = 12000000; //12MHz clock
    parameter UART_BAUD = 115200; //bit per seconds
    localparam SAMPLE_DELAY = CLK_RATE/UART_BAUD;
    
    reg [15:0] sample_delay = 0; // sample delay clock
    reg [15:0] fifo_data = 0; // data read from the fifo
    reg [7:0] tx_byte = 0; // 8-bit byte send through the uart
    reg send = 0;
    
    // param of the fsm
    localparam [3:0]
    sd_start = 3'b000,
    sd_msb_analog = 3'b001,
    sd_lsb_analog = 3'b010,
    sd_dig = 3'b011,
    sd_stop = 3'b100,
    idle = 3'b101;
    
    reg [3:0] state;
    
    
    
    
    
endmodule
