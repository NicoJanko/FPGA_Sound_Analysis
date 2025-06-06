`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.06.2025 15:28:27
// Design Name: 
// Module Name: threshold
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


module threshold #(
    parameter N = 8192,
    parameter K = 5 // a power of 2 for fastest average computation
    )
    (
    input wire clk,
    input wire [15:0] in_data,
    input wire f_compute,
    input wire ready,
    input wire rst,
    output reg valid,
    output reg [15:0] pos_threshold,
    output reg [15:0] neg_threshold,
    output wire [15:0] out_mean
    );

    localparam DATA_WIDTH = 16;
    localparam SQ_WIDTH = 2*DATA_WIDTH; // 12 bits data
    localparam ACC_WIDTH = DATA_WIDTH + $clog2(N);
    
    reg [DATA_WIDTH-1:0] data_buffer [0:N-1];
    reg [SQ_WIDTH-1:0] sq_diff_buffer [0:N-1];
    reg [ACC_WIDTH:0] acc = 0;
    reg [SQ_WIDTH+$clog2(N):0] sq_acc = 0;
    reg [$clog2(N)-1:0] pointer = 0;
    //reg [$clog2(N):0] counter = 0;
    integer index = 0;
    
    reg [16:0] mean = 0;
    
    wire [15:0] var;
    wire [15:0]std;
    wire sqrt_in_valid;
    
    reg [3:0] r_latency;
    parameter LATENCY = 9;
    cordic_0 sqrt (
        .aclk(clk),
        .s_axis_cartesian_tvalid(ready),
        .s_axis_cartesian_tdata(var), //16-bit input
        .m_axis_dout_tvalid(),
        .m_axis_dout_tdata(std) //16-bit output
    ); //9 cycle latency
        
    // first fill the buffer at 0
    
    wire [15:0] sample = in_data;
    wire [SQ_WIDTH-1:0] sq_diff = (in_data-mean)*(in_data-mean);
    always @(posedge clk) begin
        if (rst) begin
            acc <= 0;
            sq_acc <= 0;
            pointer <= 0;
            
        end
        if (f_compute) begin
            // start with moving average
            acc <= acc - data_buffer[pointer] + sample;
            sq_acc <= sq_acc - sq_diff_buffer[pointer] + sq_diff;
            
            data_buffer[pointer] <= sample;
            sq_diff_buffer[pointer] <= sq_diff;
            
            pointer <= (pointer +1 ) %N;
            
            //if (counter < N) begin
                //counter <= counter +1;
               //end
                
            
                mean <= acc>>$clog2(N);
                if (r_latency < LATENCY) begin
                 r_latency <= r_latency +1;
                end else begin
                    if ((std/2) != 0) begin
                        if ((mean + (K*std/2)) > 16'hFFFF) begin
                            pos_threshold <= 16'hFFFF;
                        end else begin
                            pos_threshold <= mean + (K*std/2);
                        end
                        if (K*(std/2) > mean) begin
                            neg_threshold <= mean - mean;
                        end else begin
                            neg_threshold <= mean - K*(std/2);
                        end
                        valid <= 1;
                    end else begin
                        pos_threshold <= mean + K;
                        neg_threshold <= mean - K;
                        
                        valid <= 1;
                    end
               end
                
            end
       //std <= 12'h123;
        end
    
    assign var = sq_acc>>$clog2(N);
    assign out_mean = mean;
  
endmodule
