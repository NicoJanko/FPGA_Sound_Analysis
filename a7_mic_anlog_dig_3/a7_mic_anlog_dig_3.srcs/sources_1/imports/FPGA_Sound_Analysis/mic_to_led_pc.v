module mic_to_led_pc (
    input clk,         // 12 MHz clock
    input pmod1,       // Digital mic input
    input xa_p,        // XADC analog + input (vauxp4)
    input xa_n,        // XADC analog - input (vauxn4)
    output led0,       // LED driven from digital mic
    output led1,
    output uart_rxd_out  // UART TX to PC (FPGA TX → PC RX)
);

    wire [15:0] adc_data;
    wire ready;

    // === Digital mic to LED module ===
    mic_to_led mic_logic (
        .i_dig_mic(pmod1),
        .o_led0(led0),
        .o_led1(led1)
    );

    // === XADC for analog signal (vaux4 = DIP pin 15) ===
    xadc_wiz_0 xadc (
        .dclk_in(clk),
        .den_in(1'b1),
        .daddr_in(7'h14),       // Address for vaux4
        .di_in(16'b0),
        .dwe_in(1'b0),
        .reset_in(1'b0),
        .vauxp4(xa_p),
        .vauxn4(xa_n),
        .vp_in(1'b0),
        .vn_in(1'b0),
        .do_out(adc_data),
        .drdy_out(ready),
        .busy_out(),
        .eoc_out(),
        .eos_out(),
        .alarm_out(),
        .channel_out()
    );

    // === ADC-to-UART transmitter (with sync byte) ===
    adc_to_uart2 adc_dig_uart (
        .clk(clk),
        .ready(ready),
        .i_xadc(adc_data),
        .i_dig(pmod1),
        .uart_tx(uart_rxd_out),
        .busy()
    );

endmodule
