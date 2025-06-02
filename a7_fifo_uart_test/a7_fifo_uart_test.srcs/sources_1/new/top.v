`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.05.2025 13:16:32
// Design Name: 
// Module Name: uart
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


module top(
    input clk,
    output uart_rxd_out,
    output wire [7:0] tx_debug,
    output wire [15:0] xadc_debug
    );
    
    wire [15:0] fake_adc_data;
    wire ready;
    
    fake_xadc fake_xadc (
    .clk(clk),
    .do_out(fake_adc_data),
    .ready(ready)
        );
    
    data_to_uart data_to_uart (
    .clk(clk),
    .ready(ready),
    .i_xdac(fake_adc_data),
    .uart_tx(uart_rxd_out),
    .tx_debug(tx_debug),
    .xadc_debug(xadc_debug),
    .busy()
    );
    
endmodule
