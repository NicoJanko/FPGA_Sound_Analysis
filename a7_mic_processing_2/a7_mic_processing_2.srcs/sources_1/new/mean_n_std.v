`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.06.2025 15:24:26
// Design Name: 
// Module Name: mean_n_std
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


module mean_n_std(
    input wire clk,
    input wire [15:0] in_data,
    input wire compute,
    output reg [15:0]out_mean,
    output reg [15:0] out_std
    );
endmodule
