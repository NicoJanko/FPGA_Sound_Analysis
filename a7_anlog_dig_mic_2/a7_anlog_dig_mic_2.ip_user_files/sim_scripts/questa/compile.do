vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib

vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 -incr -mfcu  \
"../../../a7_anlog_dig_mic_2.gen/sources_1/ip/xadc_wiz_0/xadc_wiz_0.v" \
"../../../a7_anlog_dig_mic_2.srcs/sources_1/imports/a7_anlog_mic_1/adc_to_uart.v" \
"../../../a7_anlog_dig_mic_2.srcs/sources_1/imports/a7_anlog_mic_1/mic_to_led.v" \
"../../../a7_anlog_dig_mic_2.srcs/sources_1/imports/a7_anlog_mic_1/uart.v" \
"../../../a7_anlog_dig_mic_2.srcs/sources_1/imports/a7_anlog_mic_1/mic_to_led_pc.v" \


vlog -work xil_defaultlib \
"glbl.v"

