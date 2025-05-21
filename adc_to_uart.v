module adc_to_uart (
    input wire clk,               // 12 MHz clock
    input wire ready,             // XADC drdy_out: new sample ready
    input wire [15:0] i_xdac,     // Raw XADC output
    output wire uart_tx,          // UART TX line to PC
    output wire busy              // UART busy status
);

    parameter CLK_FREQ = 12000000;
    parameter SAMPLE_FREQ = 1000;
    localparam SAMPLE_DELAY = CLK_FREQ / SAMPLE_FREQ;

    reg [15:0] sample_delay = 0;
    reg [11:0] adc_raw = 0;               // Correct 12-bit value
    reg [15:0] adc_sample = 0;            // Padded for UART
    reg [7:0] tx_byte = 0;
    reg send = 0;

    reg [1:0] state = 0;

    wire uart_busy;

    uart uart_inst (
        .clk(clk),
        .send(send),
        .data(tx_byte),
        .tx(uart_tx),
        .busy(uart_busy)
    );

    assign busy = uart_busy;

    always @(posedge clk) begin
        send <= 0;  // Default

        if (sample_delay < SAMPLE_DELAY) begin
            sample_delay <= sample_delay + 1;
        end else if (!uart_busy && ready) begin
            sample_delay <= 0;

            case (state)
                0: begin
                    adc_raw <= i_xdac[15:4];                  // Mask: get true 12-bit value
                    adc_sample <= {4'b0000, i_xdac[15:4]};    // Pad lower bits
                    tx_byte <= 8'hAA;                         // Start byte
                    send <= 1;
                    state <= 1;
                end
                1: begin
                    tx_byte <= adc_sample[15:8];              // MSB
                    send <= 1;
                    state <= 2;
                end
                2: begin
                    tx_byte <= adc_sample[7:0];               // LSB
                    send <= 1;
                    state <= 0;
                end
            endcase
        end
    end
endmodule
