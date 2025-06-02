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
    reg [15:0] mean_sample;
    reg [15:0] std_sample;
    //reg [7:0] data_in;
    //reg write;
    //wire almost_full;
    
    

    
    
    localparam [3:0]
        idle = 0,
        xadc_ready =1,
        start = 2,
        analog_msb = 3,
        analog_lsb = 4,
        mean_msb = 5,
        mean_lsb = 6,
        std_msb = 7,
        std_lsb = 8,
        start_dig = 9,
        dig = 10
        ;
        
    reg [3:0] state = idle;
    
    reg i_dig_sync_0 = 0;
    reg i_dig_sync_1 = 0;
    wire [11:0] mean;
    wire [11:0] var;
    
    adc_to_processing adc_to_processing (
        .clk(clk),
        .ready(ready),
        .i_xadc(i_xadc),
        .mean(mean),
        .var(std)    
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
            adc_sample = {4'b0000, i_xadc[15:4]};
            mean_sample = {4'b0000, mean};
            std_sample = {4'b0000, std};
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
                state <= mean_msb;
            end
        end
        mean_msb: begin
            if (!almost_full) begin
                data_in <= mean_sample[15:8];
                //data_in <= 8'hCC;
                write <= 1;
                state <= mean_lsb;
            end
        end
        mean_lsb: begin
            if (!almost_full) begin
                data_in <= mean_sample[7:0];
                //data_in <= 8'hCC;
                write <= 1;
                state <= std_msb;
            end
        end
         std_msb: begin
            if (!almost_full) begin
                data_in <= std_sample[15:8];
                //data_in <= 8'hCC;
                write <= 1;
                state <= std_lsb;
            end
        end
        std_lsb: begin
            if (!almost_full) begin
                data_in <= std_sample[7:0];
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
