`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.05.2025 11:19:39
// Design Name: 
// Module Name: adc_to_fifo
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


module adc_to_fifo(
    input wire clk,
    input wire ready,
    input wire [15:0] i_xadc,
    input wire i_dig,
    output reg [7:0] data_in,
    output reg write,
    input wire almost_full
    );
    
    reg [15:0] adc_sample;
    reg [15:0] post_sample;
    reg [15:0] negt_sample;
    reg [15:0] wave_sample;
    //reg [7:0] data_in;
    //reg write;
    //wire almost_full;
    
    

    
    
    localparam [3:0]
        idle = 0,
        xadc_ready =1,
        start = 2,
        analog_msb = 3,
        analog_lsb = 4,
        post_msb = 5,
        post_lsb = 6,
        negt_msb = 7,
        negt_lsb = 8,
        wave_msb = 9,
        wave_lsb = 10,
        start_dig = 11,
        dig = 12
        ;
        
    reg [3:0] state = idle;
    
    reg i_dig_sync_0 = 0;
    reg i_dig_sync_1 = 0;
    wire [15:0] pos_threshold;
    wire [15:0] neg_threshold;
    wire [15:0] wire_wave;
    
    processing processing (
        .clk(clk),
        .ready(ready),
        .i_xadc({4'b0000, i_xadc[15:4]}),
        .r_pos_threshold(pos_threshold),
        .r_neg_threshold(neg_threshold),
        .out_wave(wire_wave)
    
    );

    
    always @(posedge clk) begin
        i_dig_sync_0 <= i_dig;
        i_dig_sync_1 <= i_dig_sync_0;
    end
    
    always @(posedge clk) begin
        write <= 0;
        
        case(state)
        idle: begin
            if (ready) begin
                state <= xadc_ready;
            end
        end
        xadc_ready: begin
            adc_sample <= {4'b0000, i_xadc[15:4]};
            post_sample <= pos_threshold;//{4'b0000, mean};
            negt_sample <= neg_threshold;//{4'b0000, std};
            wave_sample <= wire_wave;
            //adc_sample = 16'h1234;
            state <= start;
        end
        start: begin
            if (!almost_full) begin
                data_in <= 8'hAA;
                write <= 1;
                state <= analog_msb;
            end
        end
        analog_msb: begin
            if (!almost_full) begin
                data_in <= adc_sample[15:8];
                //data_in <= 8'hBB;
                write <= 1;
                state <= analog_lsb;
            end
        end
        analog_lsb: begin
            if (!almost_full) begin
                data_in <= adc_sample[7:0];
                //data_in <= 8'hCC;
                write <= 1;
                state <= post_msb;
            end
        end
        post_msb: begin
            if (!almost_full) begin
                data_in <= post_sample[15:8];
                //data_in <= 8'hCC;
                write <= 1;
                state <= post_lsb;
            end
        end
        post_lsb: begin
            if (!almost_full) begin
                data_in <= post_sample[7:0];
                //data_in <= 8'hCC;
                write <= 1;
                state <= negt_msb;
            end
        end
         negt_msb: begin
            if (!almost_full) begin
                data_in <= negt_sample[15:8];
                //data_in <= 8'hCC;
                write <= 1;
                state <= negt_lsb;
            end
        end
        negt_lsb: begin
            if (!almost_full) begin
                data_in <= negt_sample[7:0];
                //data_in <= 8'hCC;
                write <= 1;
                state <= wave_msb;
            end
        end
        wave_msb: begin
            if (!almost_full) begin
                data_in <= wave_sample[15:8];
                //data_in <= 8'hCC;
                write <= 1;
                state <= wave_lsb;
            end
        end
        wave_lsb: begin
            if (!almost_full) begin
                data_in <= wave_sample[7:0];
                //data_in <= 8'hCC;
                write <= 1;
                state <= start_dig;
            end
        end
        start_dig: begin
            if (!almost_full) begin
                data_in <= 8'hBB;
                write <= 1;
                state <= dig;
            end
        end
        dig: begin
            if (!almost_full) begin
                data_in <= {7'b000000,i_dig_sync_1};
                //data_in <= 8'hEE;
                write <= 1;
                state <= idle;
            end
        end
    endcase
    end
endmodule
