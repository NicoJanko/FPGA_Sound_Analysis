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


module data_to_uart(
    input wire clk,
    input wire ready,
    input wire [15:0] i_xdac,
    output wire uart_tx,
    output wire tx_debug,
    output wire [15:0] xadc_debug,
    output wire busy
    );
    
    parameter CLK_FREQ = 12000000;
    parameter SAMPLE_FREQ = 1000;
    localparam SAMPLE_DELAY = CLK_FREQ / SAMPLE_FREQ;
    reg [15:0] sample_delay = 0;
    
    //
    reg [11:0] adc_raw = 0;               // Correct 12-bit value
    reg [15:0] adc_sample = 0;            // Padded for UART
    reg [7:0] tx_byte = 0;
    reg send = 0;
    
    localparam [3:0]
    start = 0,
    w0 = 1,
    w1 = 2,
    w2 = 3,
    r0 = 4,
    r0w = 5,
    r1 = 6,
    r1w = 7,
    r2 = 8,
    r2w = 9,
    stop = 10
    ;
    
    reg [3:0] state = start;
    
    wire uart_busy;    
    
    //bram logic
    reg rst = 0;
    reg bram_w;
    reg [7:0] data_2_bram = 0;
    wire almost_full;
    reg bram_r;
    wire [7:0] bram_2_data;
    wire almost_empty;
    
    fifo_bram fifo_bram (
    .clk(clk),
    .rst(rst),
    .write(bram_w),
    .data_in(data_2_bram),
    .almost_full(almost_full),
    .read(bram_r),
    .data_out(bram_2_data),
    .almost_empty(almost_empty));
        
    uart uart (
    .clk(clk),
    .send(send),
    .data(tx_byte),
    .tx(uart_tx),
    .tx_debug(tx_debug),
    .busy(uart_busy)
    );
    
    assign xadc_debug = i_xdac;
    
    always @(posedge clk) begin
        send <= 0;
        bram_r <= 0;
        bram_w <= 0;
        
        case (state)
            start: begin
                if (sample_delay < SAMPLE_DELAY) begin
                    sample_delay <= sample_delay +1;
                end else if (!uart_busy && ready) begin
                    adc_sample <= {4'b0000,i_xdac[15:4]};
                    state <= w0;
                end
            end
            w0:begin
                if (!almost_full) begin
                    data_2_bram <= 8'haa;
                    bram_w <= 1;
                    state <= w1;
                end
            end
            w1:begin if(!almost_full) begin
                            data_2_bram <=adc_sample[15:8]; //8'hAA--adc_sample[7:0]-{7'b0000000, i_dig}-8'hbb
                            bram_w <= 1;
                            state <= w2;
                         end
                 end
            w2:begin if(!almost_full) begin
                            data_2_bram <=adc_sample[7:0]; //8'hAA-adc_sample[15:8]--{7'b0000000, i_dig}-8'hbb
                            bram_w <= 1;
                            state <= r0;
                         end
                 end
             r0:begin if(!uart_busy ) begin
                            bram_r <= 1;
                            state <= r0w;
                            end
                    end
             r0w:begin
                            //if (!uart_busy) begin
                                tx_byte <= bram_2_data;
                                send <= 1;
                                //tx_byte <= 0'haa;
                                
                                state <= r1;
                            //end
                        end
             r1:begin if(!uart_busy ) begin
                            bram_r <= 1;
                            state <= r1w;
                            end
                    end
             r1w:begin
                            //if (!uart_busy) begin
                                tx_byte <= bram_2_data;
                                send <= 1;
                                //tx_byte <= 0'hbb;
                                
                                state <= r2;
                            //end
                        end
             r2:begin if(!uart_busy ) begin
                            bram_r <= 1;
                            state <= r2w;
                            end
                    end
             r2w:begin
                            //if (!uart_busy) begin
                                tx_byte <= bram_2_data;
                                send <= 1;
                                //tx_byte <= 0'hcc;
                                
                                state <= stop;
                            //end
                        end
            stop: begin
                        send <= 0;
                        bram_r <= 0;
                        bram_w <= 0;
                        state <= start;
                        sample_delay <= 0;
                    end 
                endcase
                
               end
endmodule
