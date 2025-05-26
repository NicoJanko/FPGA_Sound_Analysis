module mic_to_led_pc (
    input clk,         // 12 MHz clock
    input pmod1,       // Digital mic input        // XADC analog - input (vauxn4)
    output led0,       // LED driven from digital mic
    output led1,
    output uart_rxd_out  // UART TX to PC (FPGA TX → PC RX)
);


    // === Digital mic to LED module ===
    mic_to_led mic_logic (
        .i_dig_mic(pmod1),
        .o_led0(led0),
        .o_led1(led1)
    );

    // === ADC-to-UART transmitter (with sync byte) ===
    dig_to_uart dig_uart (
        .clk(clk),
        .i_dig(pmod1),
        .uart_tx(uart_rxd_out),
        .busy()
    );

endmodule
