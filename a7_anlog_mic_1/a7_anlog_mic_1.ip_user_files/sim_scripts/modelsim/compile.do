vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 -incr -mfcu  \
"../../../a7_anlog_mic_1.gen/sources_1/ip/xadc_wiz_0/xadc_wiz_0.v" \
"../../../a7_anlog_mic_1.srcs/sources_1/imports/a7_anlog_mic_1/adc_to_uart.v" \
"../../../a7_anlog_mic_1.srcs/sources_1/imports/a7_anlog_mic_1/mic_to_led.v" \
"../../../a7_anlog_mic_1.srcs/sources_1/imports/a7_anlog_mic_1/uart.v" \
"../../../a7_anlog_mic_1.srcs/sources_1/imports/a7_anlog_mic_1/mic_to_led_pc.v" \


vlog -work xil_defaultlib \
"glbl.v"

