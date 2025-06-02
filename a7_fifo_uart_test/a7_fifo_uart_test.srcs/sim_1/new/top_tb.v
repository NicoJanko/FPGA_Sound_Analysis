`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.05.2025 09:47:48
// Design Name: 
// Module Name: mic_to_led_pc_tb
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


module top_tb;

    reg clk = 0;
    wire uart_rxd_out;
    wire [7:0] tx_debug;
    wire [15:0] xadc_debug;

    // Clock generation (12 MHz)
    always #41.67 clk = ~clk;

    // Instantiate the DUT
    top dut (
        .clk(clk),
        .tx_debug(tx_debug),
        .xadc_debug(xadc_debug),
        .uart_rxd_out(uart_rxd_out)
    );

    initial begin
        #100000;
        $finish;

        
    end

endmodule
