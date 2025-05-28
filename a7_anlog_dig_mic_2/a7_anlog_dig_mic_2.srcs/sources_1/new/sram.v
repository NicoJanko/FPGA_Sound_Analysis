`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/27/2025 02:02:54 PM
// Design Name: 
// Module Name: sram
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


module sram(
    input clk,
    input start,
    input rw,
    input adress,
    input data_in,
    output data_out,
    output write_enable,
    output output_enable,
    output chip_enable,
    output ready,
    output finish_write,
    output busy
    );
endmodule
