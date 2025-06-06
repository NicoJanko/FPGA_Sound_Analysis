vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xpm
vlib questa_lib/msim/fifo_generator_v13_2_11
vlib questa_lib/msim/xil_defaultlib

vmap xpm questa_lib/msim/xpm
vmap fifo_generator_v13_2_11 questa_lib/msim/fifo_generator_v13_2_11
vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xpm  -incr -mfcu  -sv \
"C:/Xilinx/Vivado/2024.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"C:/Xilinx/Vivado/2024.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm  -93  \
"C:/Xilinx/Vivado/2024.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work fifo_generator_v13_2_11  -incr -mfcu  \
"../../ipstatic/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_2_11  -93  \
"../../ipstatic/hdl/fifo_generator_v13_2_rfs.vhd" \

vlog -work fifo_generator_v13_2_11  -incr -mfcu  \
"../../ipstatic/hdl/fifo_generator_v13_2_rfs.v" \

vlog -work xil_defaultlib  -incr -mfcu  \
"../../../a7_mic_anlog_dig_3.gen/sources_1/ip/fifo_generator_0/sim/fifo_generator_0.v" \
"../../../a7_mic_anlog_dig_3.gen/sources_1/ip/xadc_wiz_0/xadc_wiz_0.v" \
"../../../a7_mic_anlog_dig_3.srcs/sources_1/new/adc_to_fifo.v" \
"../../../a7_mic_anlog_dig_3.srcs/sources_1/new/adc_to_uart2.v" \
"../../../a7_mic_anlog_dig_3.srcs/sources_1/new/fifo_to_uart.v" \
"../../../a7_mic_anlog_dig_3.srcs/sources_1/imports/FPGA_Sound_Analysis/mic_to_led.v" \
"../../../a7_mic_anlog_dig_3.srcs/sources_1/imports/FPGA_Sound_Analysis/uart.v" \
"../../../a7_mic_anlog_dig_3.srcs/sources_1/imports/FPGA_Sound_Analysis/mic_to_led_pc.v" \

vlog -work xil_defaultlib \
"glbl.v"

