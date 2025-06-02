`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.05.2025 13:21:01
// Design Name: 
// Module Name: fake_xadc
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


module fake_xadc(
    input wire clk,
    output reg [15:0] do_out,
    output reg ready
    );
    
    parameter CLK_FREQ = 12000000;
    localparam SAMPLE_DELAY = CLK_FREQ/1000;
    
    reg [31:0] sample_delay = 0;
    reg [31:0] hold_delay = 0;
    
    always @(posedge clk) begin
        if (sample_delay < SAMPLE_DELAY) begin
            sample_delay <= sample_delay +1;
            ready <= 0;
        end else begin 
            if (hold_delay < SAMPLE_DELAY) begin
                do_out <= 16'hAA5A;
                ready <= 1;
                hold_delay <= hold_delay +1;
                end else begin
                    sample_delay <= 0;
                    hold_delay <= 0;
                    ready <= 0;
                end
        end
    end
endmodule
