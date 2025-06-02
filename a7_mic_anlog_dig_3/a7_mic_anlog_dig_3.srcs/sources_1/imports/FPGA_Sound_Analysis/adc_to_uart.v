module adc_dig_to_uart (
    input wire clk,               // 12 MHz clock
    input wire ready,             // XADC drdy_out: new sample ready
    input wire [15:0] i_xdac,
    input wire i_dig,     // Raw XADC output
    output wire uart_tx,          // UART TX line to PC
    output wire busy              // UART busy status
);

    parameter CLK_FREQ = 12000000;
    parameter SAMPLE_FREQ = 1000;
    localparam SAMPLE_DELAY = CLK_FREQ / SAMPLE_FREQ;

    reg [15:0] sample_delay = 0;
    reg [11:0] adc_raw = 0;               // Correct 12-bit value
    reg [15:0] adc_sample = 0;
    reg [7:0] dig_sample =0;            // Padded for UART
    reg [7:0] tx_byte = 0;
    reg send_pending = 0;
    reg send = 0;
    
    //reg fsm_active = 0;
    reg [2:0] state = 0;

    wire uart_busy;

    uart uart_inst (
        .clk(clk),
        .send(send),
        .data(tx_byte),
        .tx(uart_tx),
        .busy(uart_busy)
    );

    assign busy = uart_busy;

    always @(posedge clk) begin
        if (send_pending && !uart_busy) begin
        send <= 1;
        send_pending <= 0;
            end else begin
                send <= 0;
            end  

       
        // if the uart is not busy 
                //sample_delay <= 0;
            

            case (state)
                0: begin
                //if (ready) begin
                
                    if (sample_delay < SAMPLE_DELAY) begin
                    // sample delay to link to the receiver-end
                        sample_delay <= sample_delay + 1;
                    end
                    if (ready) begin
                        if (!uart_busy) begin                                       //start analog byte
                        adc_raw <= i_xdac[15:4];                  
                        adc_sample <= {4'b0000, i_xdac[15:4]};    
                        tx_byte <= 8'hAA;                         
                        send_pending <= 1;
                        state <= 1;
                        end
                    end
                end
                1: begin
                if (!uart_busy) begin                                       // analog MSB
                    tx_byte <= adc_sample[15:8]; 
                    //tx_byte <= 8'h2A;             
                    send_pending <= 1;
                    state <= 2;
                    end
                end
                2: begin
                if (!uart_busy) begin
                                       // analog LSB
                    tx_byte <= adc_sample[7:0];
                    //tx_byte <= 8'h2B;               
                    send_pending <= 1;
                    state <= 3;
                end
                end
                3: begin
                if (!uart_busy) begin
                                                         //start digital byte
                    
                    tx_byte <= 8'hBB;
                    send_pending <= 1;
                    state <= 4;
                end
                end
                4: begin
                if (!uart_busy) begin
                 
                    tx_byte <= {7'b0, i_dig};
                    //tx_byte <= 8'h2C;                      //digital byte
                    send_pending <=1;
                    state <= 0;
                    sample_delay <= 0;
                end
                end

            endcase
           
    end
endmodule
