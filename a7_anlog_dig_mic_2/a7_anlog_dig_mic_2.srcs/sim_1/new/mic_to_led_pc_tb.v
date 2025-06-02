`timescale 1ns / 1ps
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


module mic_to_led_pc_tb;

    reg clk = 0;
    reg pmod1 = 0;

    wire led0;
    wire led1;
    wire uart_rxd_out;
    wire [7:0] tx_debug;
    wire [7:0] xadc_debug;

    // Clock generation (12 MHz)
    always #41.67 clk = ~clk;

    // Instantiate the DUT
    mic_to_led_pc dut (
        .clk(clk),
        .pmod1(pmod1),
        .xa_p(),       // Not used in sim
        .xa_n(),       // Not used in sim
        .led0(led0),
        .led1(led1),
        .tx_debug(tx_debug),
        .xadc_debug(xadc_debug),
        .uart_rxd_out(uart_rxd_out)
    );

    initial begin
        $display("Starting simulation...");
        $monitor("Time: %t | TX Debug = 0x%h | XADC Debug = 0x%h", $time, tx_debug, xadc_debug);
        #100;

        // Simulate toggling digital mic signal
        repeat (100) begin
            #200 pmod1 = ~pmod1;
        end
        //$monitor("Time: %t | TX Byte = 0x%h", $time, dut.data_uart.uart_inst.data);
        // Run long enough to observe UART output
        #1_000_000;
        $finish;

        
    end

endmodule
