`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.05.2025 09:55:50
// Design Name: 
// Module Name: xadc_wiz_0_stub
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


module xadc_wiz_0 (
    input wire dclk_in,
    input wire den_in,
    input wire [6:0] daddr_in,
    input wire [15:0] di_in,
    input wire dwe_in,
    input wire reset_in,
    input wire vauxp4,
    input wire vauxn4,
    input wire vp_in,
    input wire vn_in,
    output reg [15:0] do_out,
    output reg drdy_out,
    output wire busy_out,
    output wire eoc_out,
    output wire eos_out,
    output wire alarm_out,
    output reg [7:0] xadc_debug,
    output wire [4:0] channel_out
);

    initial begin
        do_out = 0;
        drdy_out = 0;
    end

    always @(posedge dclk_in) begin
        drdy_out <= 1;
        do_out <= $random % 4096;
        xadc_debug <= do_out;  // 12-bit value (max 4095)
    end

    assign busy_out = 0;
    assign eoc_out = 0;
    assign eos_out = 0;
    assign alarm_out = 0;
    assign channel_out = 0;

endmodule
