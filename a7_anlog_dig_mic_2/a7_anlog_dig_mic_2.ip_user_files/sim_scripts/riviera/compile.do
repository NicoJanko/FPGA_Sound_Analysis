transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib riviera/xil_defaultlib

vmap xil_defaultlib riviera/xil_defaultlib

vlog -work xil_defaultlib  -incr -v2k5 -l xil_defaultlib \
"../../../a7_anlog_dig_mic_2.gen/sources_1/ip/xadc_wiz_0/xadc_wiz_0.v" \
"../../../a7_anlog_dig_mic_2.srcs/sources_1/imports/a7_anlog_mic_1/adc_to_uart.v" \
"../../../a7_anlog_dig_mic_2.srcs/sources_1/imports/a7_anlog_mic_1/mic_to_led.v" \
"../../../a7_anlog_dig_mic_2.srcs/sources_1/imports/a7_anlog_mic_1/uart.v" \
"../../../a7_anlog_dig_mic_2.srcs/sources_1/imports/a7_anlog_mic_1/mic_to_led_pc.v" \


vlog -work xil_defaultlib \
"glbl.v"

