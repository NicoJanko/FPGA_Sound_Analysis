`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.06.2025 13:59:41
// Design Name: 
// Module Name: processing_to_peak_detection
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


module processing_to_peak_detection(
    input wire clk,
    input wire [15:0] i_xadc,
    input wire [15:0] in_pos_threshold,
    input wire [15:0] in_neg_threshold,
    output reg [15:0] out_wave
    );
  
  always @(posedge clk) begin
    if ((i_xadc < in_neg_threshold) || (i_xadc < in_pos_threshold)) begin
        out_wave <= i_xadc;
    end else begin
        out_wave <= 16'b0;
    end
  end

endmodule





