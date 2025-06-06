`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.06.2025 15:38:29
// Design Name: 
// Module Name: processing
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


module processing(
    input wire clk,
    input wire ready,
    input  wire [15:0] i_xadc,
    output reg [15:0] r_pos_threshold,
    output reg [15:0] r_neg_threshold,
    output reg [15:0] out_wave
    );
    
    wire threshold_valid;
    wire [15:0] pos_threshold;
    wire [15:0] neg_threshold;
    
    threshold threshold (
    .clk(clk),
    .in_data(in_data),
    .f_compute(compute_thresh),
    .ready(ready),
    .valid(threshold_valid),
    .pos_threshold(pos_threshold),
    .neg_threshold(neg_threshold)
    );
    parameter N = 16384;
    parameter PEAK =8192;

    reg [$clog2(PEAK):0] peak_counter = 0;
    reg rec_peak = 0;
    reg [15:0] in_data;
    reg compute_thresh;
    //reg [15:0] r_pos_threshold;
    //reg [15:0] r_neg_threshold;


    localparam [1:0]
        init = 0,
        baseline = 1,
        peak = 2;
    
    reg [1:0] state = init;
   
    
    reg [$clog2(N):0] counter = 0;
    always @(posedge clk) begin
        //if ((neg_threshold == 0) && (pos_threshold == 0)) begin
          //  compute_thresh <=1;
           // in_data <= i_xadc;
            //out_wave <= 16'b0;
        //end
        if (ready) begin
            in_data <= i_xadc;
            out_wave <= 16'b0;
            if (counter < N) begin
                compute_thresh <=1;
                counter <= counter +1;
                out_wave <= 16'b0;
                r_pos_threshold <= pos_threshold;
                r_neg_threshold <= neg_threshold;
            end else if (threshold_valid) begin
                if (rec_peak && (peak_counter < PEAK)) begin
                    compute_thresh <= 0;
                    out_wave <= i_xadc;
                    peak_counter <= peak_counter +1;
                end else begin
                    if ((i_xadc < r_neg_threshold) || (i_xadc > r_pos_threshold)) begin
                        compute_thresh <= 0;
                        rec_peak <= 1;
                        peak_counter <= 0;
                        out_wave <= i_xadc;
                    end else begin
                        compute_thresh <=1;
                        r_pos_threshold <= pos_threshold;
                        r_neg_threshold <= neg_threshold;
                        rec_peak <= 0;
                        peak_counter <= 0;
                        out_wave <= 16'b0;
                        end 
                    end
                end 
            end
        end
endmodule
