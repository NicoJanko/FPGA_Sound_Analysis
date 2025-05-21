`timescale 1ns/1ps

module uart (
    input wire clk,
    input wire send,
    input wire [7:0] data, //byte to send
    output reg tx = 1,          // UART TX line (default high = idle)
    output reg busy = 0 

);
    parameter CLK_FREQ = 12000000;
    parameter BAUD = 115200;
    localparam CLKS_PER_BIT = CLK_FREQ / BAUD;

    reg [3:0] bit_index = 0;        // Index of the bit being sent (0 to 9)
    reg [15:0] clk_count = 0;       // Clock divider
    reg [9:0] shift_reg = 10'b1111111111;  // Start + 8 data + stop
    reg sending = 0;

    always @(posedge clk) begin
        if (send && !sending) begin
            // Begin a new transmission
            sending <= 1;
            busy <= 1;
            bit_index <= 0;
            clk_count <= 0;
            shift_reg <= {1'b1, data, 1'b0};  // stop bit, data[7:0], start bit
            tx <= 0; // start bit (0)
        end else if (sending) begin
            if (clk_count < CLKS_PER_BIT - 1) begin
                clk_count <= clk_count + 1;
            end else begin
                clk_count <= 0;
                bit_index <= bit_index + 1;
                shift_reg <= {1'b1, shift_reg[9:1]};  // shift right
                tx <= shift_reg[1];

                if (bit_index == 9) begin
                    sending <= 0;
                    busy <= 0;
                    tx <= 1;  // return to idle
                end
            end
        end else begin
            tx <= 1;  // idle state when not sending
        end
    end


endmodule