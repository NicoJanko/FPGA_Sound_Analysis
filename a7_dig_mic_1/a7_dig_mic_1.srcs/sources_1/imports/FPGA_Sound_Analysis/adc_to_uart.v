module dig_to_uart (
    input wire clk,               // 12 MHz clock             // XADC drdy_out: new sample ready
    input wire i_dig,     // Raw XADC output
    output wire uart_tx,          // UART TX line to PC
    output wire busy              // UART busy status
);

    parameter CLK_FREQ = 12000000;
    parameter SAMPLE_FREQ = 10000;
    localparam SAMPLE_DELAY = CLK_FREQ / SAMPLE_FREQ;

    reg [15:0] sample_delay = 0;            
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
        end else if (!uart_busy) begin
            sample_delay <= 0;

            case (state)
                0: begin                   // Pad lower bits
                    tx_byte <= 8'hBB;                         // Start byte
                    send <= 1;
                    state <= 1;
                end
                1: begin
                    tx_byte <= {7'b0,i_dig};              // MSB
                    send <= 1;
                    state <= 0;
                end
            endcase
        end
    end
endmodule
