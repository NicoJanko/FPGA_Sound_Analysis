module adc_to_uart (
    input wire clk,               // 12 MHz clock
    input wire ready,             // XADC drdy_out: new sample ready
    input wire [15:0] i_xdac,     // 12-bit ADC output (upper bits valid)
    output wire uart_tx,          // UART TX line to PC
    output wire busy              // High when transmitting
);

    parameter CLK_FREQ = 12000000;
    parameter SAMPLE_FREQ = 1000;
    localparam SAMPLE_DELAY = CLK_FREQ / SAMPLE_FREQ;

    reg [15:0] sample_delay = 0;
    reg [15:0] adc_sample = 0;
    reg [7:0] tx_byte = 0;
    reg send = 0;

    reg [1:0] state = 0;  // FSM state: 0 = start, 1 = MSB, 2 = LSB

    wire uart_busy;

    // Instantiate UART transmitter
    uart_tx uart_inst (
        .clk(clk),
        .send(send),
        .data(tx_byte),
        .tx(uart_tx),
        .busy(uart_busy)
    );

    assign busy = uart_busy;

    always @(posedge clk) begin
        send <= 0;  // default low unless sending

        if (sample_delay < SAMPLE_DELAY) begin
            sample_delay <= sample_delay + 1;
        end else if (!uart_busy && ready) begin
            sample_delay <= 0;

            case (state)
                0: begin
                    tx_byte <= 8'hAA; // Start byte
                    send <= 1;
                    adc_sample <= i_xdac; // Capture XADC data
                    state <= 1;
                end
                1: begin
                    tx_byte <= adc_sample[15:8]; // MSB
                    send <= 1;
                    state <= 2;
                end
                2: begin
                    tx_byte <= adc_sample[7:0];  // LSB
                    send <= 1;
                    state <= 0;
                end
            endcase
        end
    end
endmodule
