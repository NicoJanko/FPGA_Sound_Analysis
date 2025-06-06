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
    wire [15:0] in_mean;
    
    threshold threshold (
    .clk(clk),
    .in_data(in_data),
    .f_compute(compute_thresh),
    .ready(ready),
    .rst(thresh_rst),
    .valid(threshold_valid),
    .pos_threshold(pos_threshold),
    .neg_threshold(neg_threshold),
    .out_mean(in_mean)
    );
    parameter N = 8192;
    parameter PEAK =64;
    parameter DELAY = 64;
    
    reg [$clog2(PEAK):0] peak_counter = 0;
    reg thresh_rst = 0;
    reg rec_peak = 0;
    reg [15:0] in_data;
    reg compute_thresh;
    //reg [15:0] r_pos_threshold;
    //reg [15:0] r_neg_threshold;
    reg [15:0] pos_thresh_delay_line [0:DELAY-1];
    reg [15:0] neg_thresh_delay_line [0:DELAY-1];
    reg [$clog2(DELAY):0] delay_ptr = 0;

    localparam [1:0]
        init = 0,
        baseline = 1,
        peak = 2;
    
    reg [1:0] state = init;
    
    wire [15:0] delayed_pos_threshold = pos_thresh_delay_line[(delay_ptr + 1) % DELAY];
    wire [15:0] delayed_neg_threshold = neg_thresh_delay_line[(delay_ptr + 1) % DELAY];
    
    reg [$clog2(N):0] counter = 0;
    always @(posedge clk) begin
            //in_data <= i_xadc;
            //out_wave <= 16'b0;
            
        
        case (state)
        
        init: begin
            if (counter < N) begin
                thresh_rst <= 0;
                if (ready) begin
                    in_data <= i_xadc;
                    compute_thresh <= 1;
                    pos_thresh_delay_line[delay_ptr] <= pos_threshold;
                    neg_thresh_delay_line[delay_ptr] <= neg_threshold;
                    delay_ptr <= (delay_ptr + 1) % DELAY;
                    counter <= counter + 1;
                    out_wave <= 16'b0;
                end
            end else begin
                if (ready) begin
                    in_data <= i_xadc;
                    compute_thresh <= 1;
                    pos_thresh_delay_line[delay_ptr] <= pos_threshold;
                    neg_thresh_delay_line[delay_ptr] <= neg_threshold;
                    r_pos_threshold <= delayed_pos_threshold;
                    r_neg_threshold <= delayed_neg_threshold;
                                //mean_delay_line[delay_ptr] <= in_mean;

                    delay_ptr <= (delay_ptr + 1) % DELAY;
                    out_wave <= 16'b0;
                    state <= baseline;
                end
            end
        end
        
        baseline: begin
            if (threshold_valid) begin
                if ((i_xadc < delayed_neg_threshold) || (i_xadc > delayed_pos_threshold)) begin
                    if (ready) begin
                        compute_thresh <= 0;
                        in_data <= in_mean;
                        out_wave <= i_xadc;
                        state <= peak;
                    end
                end else begin
                    if (ready) begin
                        compute_thresh <= 1;
                        in_data <= i_xadc;
                        r_pos_threshold <= delayed_pos_threshold;
                        r_neg_threshold <= delayed_neg_threshold;
                        pos_thresh_delay_line[delay_ptr] <= pos_threshold;
                        neg_thresh_delay_line[delay_ptr] <= neg_threshold;
                        delay_ptr <= (delay_ptr + 1) % DELAY;
                        out_wave <= 16'b0;
                    end
                end
            end
        end
        peak: begin
            if (peak_counter < PEAK) begin
                if (ready) begin
                    compute_thresh <= 0;
                    out_wave <= i_xadc;
                    in_data <= in_mean;
                    peak_counter <= peak_counter + 1 ;
                end
            end else if (threshold_valid) begin
                if ((i_xadc < delayed_neg_threshold) || (i_xadc > delayed_pos_threshold)) begin
                    if (ready) begin
                        compute_thresh <= 0;
                        in_data <= in_mean;
                        out_wave <= i_xadc;
                        peak_counter <= 0;
                    end
                end else if ((i_xadc < delayed_neg_threshold) && (i_xadc < delayed_pos_threshold)) begin
                    thresh_rst <= 1;
                    state <= init;
                    counter <= 0;
                end else if ((i_xadc > delayed_neg_threshold) && (i_xadc > delayed_pos_threshold)) begin
                    thresh_rst <= 1;
                    state <= init;
                    counter <= 0;
                end else begin
                    if (ready) begin
                        compute_thresh <= 1;
                        in_data <= i_xadc;
                        r_pos_threshold <= pos_threshold;
                        r_neg_threshold <= neg_threshold;
                        pos_thresh_delay_line[delay_ptr] <= pos_threshold;
                        neg_thresh_delay_line[delay_ptr] <= neg_threshold;
                        delay_ptr <= (delay_ptr + 1) % DELAY;
                        out_wave <= 16'b0;
                        state <= baseline;
                    end
                end
            end
        end
        endcase
    end
endmodule
