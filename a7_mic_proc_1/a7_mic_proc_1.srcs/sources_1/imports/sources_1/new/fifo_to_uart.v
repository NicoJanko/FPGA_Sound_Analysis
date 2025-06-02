`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.05.2025 11:16:35
// Design Name: 
// Module Name: fifo_to_uart
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


module fifo_to_uart(
    input wire clk,
    input wire [7:0] data_out,
    output reg read,
    input wire almost_empty,
    output wire uart_tx,
    output wire busy
    );
    
    parameter CLK_FREQ = 12000000;
    parameter SAMPLE_FREQ = 1000;
    localparam SAMPLE_DELAY = CLK_FREQ / SAMPLE_FREQ;
    parameter BYTE_TO_SEND = 5;
    
    reg [15:0] sample_delay = 0;
    reg [3:0] number_byte = 0;
    
    //reg read = 0;
    
    wire [7:0] tx_byte;
    //reg [7:0] data_out = 0;
    reg send_pending = 0;
    reg send = 0;
    
    localparam [3:0]
        idle = 0,
        read_fifo = 1,
        wait_fifo = 2,
        send_uart = 3,
        wait_uart = 4
        ;
    reg [3:0] state = idle;
    
    wire uart_busy;
    //wire almost_empty;
    
    uart uart_inst (
        .clk(clk),
        .send(send),
        .data(tx_byte),
        .tx(uart_tx),
        .busy(uart_busy)
    );

    assign busy = uart_busy;
    assign tx_byte = data_out;
    
    always @(posedge clk) begin
        read <= 0;
        if (send_pending && !uart_busy) begin
        send <= 1;
        send_pending <= 0;
            end else begin
                send <= 0;
            end
        case (state)
            idle: begin
                if (sample_delay < SAMPLE_DELAY) begin
                    // sample delay to link to the receiver-end
                        sample_delay <= sample_delay + 1;
                end else begin
                    state <= read_fifo;
                end
            end
            read_fifo: begin
                if (!almost_empty) begin
                    read <= 1;
                    state <= wait_fifo;
                end
            end
            wait_fifo: begin
                
                    //tx_byte <= data_out;
                    state <= send_uart;
                
            end
            send_uart: begin
                if (!uart_busy) begin
                    send_pending <= 1;
                    state <= wait_uart;
                end
            end
            wait_uart: begin
                if (number_byte < BYTE_TO_SEND) begin
                    number_byte = number_byte +1;
                    state <= read_fifo;
                end else begin
                number_byte <= 0;
                sample_delay <= 0;
                state <= idle;
                end
            end
    endcase
    end
    
endmodule
