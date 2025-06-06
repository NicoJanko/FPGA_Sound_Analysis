vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xpm
vlib questa_lib/msim/fifo_generator_v13_2_11
vlib questa_lib/msim/xil_defaultlib
vlib questa_lib/msim/xbip_utils_v3_0_14
vlib questa_lib/msim/c_reg_fd_v12_0_10
vlib questa_lib/msim/xbip_dsp48_wrapper_v3_0_6
vlib questa_lib/msim/xbip_pipe_v3_0_10
vlib questa_lib/msim/c_addsub_v12_0_19
vlib questa_lib/msim/mult_gen_v12_0_22
vlib questa_lib/msim/axi_utils_v2_0_10
vlib questa_lib/msim/cordic_v6_0_23

vmap xpm questa_lib/msim/xpm
vmap fifo_generator_v13_2_11 questa_lib/msim/fifo_generator_v13_2_11
vmap xil_defaultlib questa_lib/msim/xil_defaultlib
vmap xbip_utils_v3_0_14 questa_lib/msim/xbip_utils_v3_0_14
vmap c_reg_fd_v12_0_10 questa_lib/msim/c_reg_fd_v12_0_10
vmap xbip_dsp48_wrapper_v3_0_6 questa_lib/msim/xbip_dsp48_wrapper_v3_0_6
vmap xbip_pipe_v3_0_10 questa_lib/msim/xbip_pipe_v3_0_10
vmap c_addsub_v12_0_19 questa_lib/msim/c_addsub_v12_0_19
vmap mult_gen_v12_0_22 questa_lib/msim/mult_gen_v12_0_22
vmap axi_utils_v2_0_10 questa_lib/msim/axi_utils_v2_0_10
vmap cordic_v6_0_23 questa_lib/msim/cordic_v6_0_23

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
"../../../a7_mic_processing_1.gen/sources_1/ip/fifo_generator_0/sim/fifo_generator_0.v" \

vcom -work xbip_utils_v3_0_14  -93  \
"../../ipstatic/hdl/xbip_utils_v3_0_vh_rfs.vhd" \

vcom -work c_reg_fd_v12_0_10  -93  \
"../../ipstatic/hdl/c_reg_fd_v12_0_vh_rfs.vhd" \

vcom -work xbip_dsp48_wrapper_v3_0_6  -93  \
"../../ipstatic/hdl/xbip_dsp48_wrapper_v3_0_vh_rfs.vhd" \

vcom -work xbip_pipe_v3_0_10  -93  \
"../../ipstatic/hdl/xbip_pipe_v3_0_vh_rfs.vhd" \

vcom -work c_addsub_v12_0_19  -93  \
"../../ipstatic/hdl/c_addsub_v12_0_vh_rfs.vhd" \

vcom -work mult_gen_v12_0_22  -93  \
"../../ipstatic/hdl/mult_gen_v12_0_vh_rfs.vhd" \

vcom -work axi_utils_v2_0_10  -93  \
"../../ipstatic/hdl/axi_utils_v2_0_vh_rfs.vhd" \

vcom -work cordic_v6_0_23  -93  \
"../../ipstatic/hdl/cordic_v6_0_vh_rfs.vhd" \

vcom -work xil_defaultlib  -93  \
"../../../a7_mic_processing_1.gen/sources_1/ip/cordic_0_2/sim/cordic_0.vhd" \

vlog -work xil_defaultlib  -incr -mfcu  \
"../../../a7_mic_processing_1.gen/sources_1/ip/xadc_wiz_0/xadc_wiz_0.v" \
"../../../a7_mic_processing_1.srcs/sources_1/imports/sources_1/new/adc_to_fifo.v" \
"../../../a7_mic_processing_1.srcs/sources_1/new/adc_to_processing.v" \
"../../../a7_mic_processing_1.srcs/sources_1/imports/sources_1/new/adc_to_uart2.v" \
"../../../a7_mic_processing_1.srcs/sources_1/imports/sources_1/new/fifo_to_uart.v" \
"../../../a7_mic_processing_1.srcs/sources_1/imports/sources_1/imports/FPGA_Sound_Analysis/mic_to_led.v" \
"../../../a7_mic_processing_1.srcs/sources_1/imports/sources_1/imports/FPGA_Sound_Analysis/uart.v" \
"../../../a7_mic_processing_1.srcs/sources_1/imports/sources_1/imports/FPGA_Sound_Analysis/mic_to_led_pc.v" \

vlog -work xil_defaultlib \
"glbl.v"

