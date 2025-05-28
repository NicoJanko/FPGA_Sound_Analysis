`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/27/2025 02:14:28 PM
// Design Name: 
// Module Name: bram_fifo
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


module bram_fifo #(
    parameter WIDTH = 8, //length of the word (byte)
    parameter DEPTH = 64,//number of words in the fifo
    parameter ADRR_WIDTH = $clog2(DEPTH) 
)(
    input wire clk,
    input wire rst,
    //write interface
    input wire write,
    input wire [WIDTH-1:0] data_in,
    output wire almost_full,
    //read interface
    input wire read,
    output reg [WIDTH-1:0] data_out,
    output wire almost_empty,
    output reg valid = 0
   
    );
    
    // this is the memory
    (* ram_style = "block" *)
    reg [WIDTH-1:0] memory [0:DEPTH-1];
    
    // pointers and count
    reg [ADRR_WIDTH-1:0] w_pointer = 0;
    reg [ADRR_WIDTH-1:0] r_pointer = 0;
    reg [ADRR_WIDTH-1:0] count = 0;
    
    // flags
    localparam ALMOST_F = WIDTH - 4;
    localparam ALMOST_E = 4;
    
    assign almost_full = (count > ALMOST_F);
    assign almost_empty = (count < ALMOST_E);
    
    //fifo logic
    always @(posedge clk) begin
        if (rst) begin
            count <= 0;
            w_pointer <= 0;
            r_pointer <= 0;
            data_out <= 0;
            valid <= 0;
        end else begin
            if (write && !almost_full) begin
                memory[w_pointer] <= data_in;
                w_pointer <= w_pointer + 1;
                count <= count + 1;
            end
            if (read && !almost_empty) begin
                data_out <= memory[r_pointer];
                r_pointer <= r_pointer + 1;
                count <= count - 1;
                valid <= 1;
                
            end
        end
    end
endmodule
