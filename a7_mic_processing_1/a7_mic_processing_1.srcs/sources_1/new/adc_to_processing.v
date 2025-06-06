`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.06.2025 08:35:26
// Design Name: 
// Module Name: adc_to_processing
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


module adc_to_processing(
    input wire clk,
    input wire ready,
    input wire [15:0] i_xadc,
    output wire [15:0] mean,
    output wire [15:0] std
    );
    
    parameter N = 4096; // a power of 2 for fastest average computation
    localparam DATA_WIDTH = 12;
    localparam SQ_WIDTH = 2*DATA_WIDTH; // 12 bits data
    localparam ACC_WIDTH = DATA_WIDTH + $clog2(N);
    
    reg [DATA_WIDTH-1:0] data_buffer [0:N-1];
    reg [SQ_WIDTH-1:0] sq_diff_buffer [0:N-1];
    reg [ACC_WIDTH:0] acc = 0;
    reg [SQ_WIDTH+$clog2(N):0] sq_acc = 0;
    reg [$clog2(N)-1:0] pointer = 0;
    reg [$clog2(N):0] counter = 0;
    integer index = 0;
    
    reg [31:0] variance = 0;
    reg signed [11:0] diff;
    integer i;
    
    wire [15:0] var;
    wire sqrt_in_valid;
    
    cordic_0 sqrt (
        .aclk(clk),
        .s_axis_cartesian_tvalid(ready),
        .s_axis_cartesian_tdata(var), //16-bit input
        .m_axis_dout_tvalid(),
        .m_axis_dout_tdata(std) //16-bit output
    ); //9 cycle latency
        
    // first fill the buffer at 0
    
    wire [11:0] sample = i_xadc[15:4];
    wire [SQ_WIDTH-1:0] sq_diff = (i_xadc[15:4]-mean)*(i_xadc[15:4]-mean);
    always @(posedge clk) begin
        if (ready) begin
            // start with moving average
            acc <= acc - data_buffer[pointer] + sample;
            sq_acc <= sq_acc - sq_diff_buffer[pointer] + sq_diff;
            
            data_buffer[pointer] <= sample;
            sq_diff_buffer[pointer] <= sq_diff;
            
            pointer <= (pointer +1 ) %N;
            
            if (counter < N) begin
                counter <= counter +1;
            end 
       //std <= 12'h123;
        end
    end
    
    assign mean = acc>>$clog2(N);
    assign var = sq_acc>>$clog2(N);
endmodule
