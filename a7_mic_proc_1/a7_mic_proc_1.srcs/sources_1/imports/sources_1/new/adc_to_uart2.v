`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.05.2025 11:14:48
// Design Name: 
// Module Name: adc_to_uart2
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


module adc_to_uart2(
    input wire clk,               // 12 MHz clock
    input wire ready,             // XADC drdy_out: new sample ready
    input wire [15:0] i_xadc,
    input wire i_dig,     // Raw XADC output
    output wire uart_tx,          // UART TX line to PC
    output wire busy   
    );
    
    //write
    wire write;
    wire [7:0] data_in;
    wire read;
    wire [7:0] data_out;
    wire almost_full;
    wire almost_empty;
    
    
    
    
    adc_to_fifo adc_to_fifo (
        .clk(clk),
        .ready(ready),
        .i_xadc(i_xadc),
        .i_dig(i_dig),
        .data_in(data_in),
        .write(write),
        .almost_full(almost_full)
    );
    
     fifo_generator_0 fifo (
    .clk(clk),
    .wr_en(write),
    .din(data_in),
    .rd_en(read),
    .dout(data_out),
    .almost_full(almost_full),
    .almost_empty(almost_empty)
    );
    
    fifo_to_uart fifo_to_uart (
    .clk(clk),
    .data_out(data_out),
    .read(read),
    .almost_empty(almost_empty),
    .uart_tx(uart_tx),
    .busy(busy)
    );
    
    
endmodule
