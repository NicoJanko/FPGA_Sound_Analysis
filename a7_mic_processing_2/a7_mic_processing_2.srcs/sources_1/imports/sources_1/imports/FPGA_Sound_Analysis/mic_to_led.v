`timescale 1ns/1ps

module mic_to_led (
    input i_dig_mic,
    output o_led0,
    output o_led1
);

assign o_led0 = !i_dig_mic;
assign o_led1 = i_dig_mic;

endmodule