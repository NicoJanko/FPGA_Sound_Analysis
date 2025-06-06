transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib riviera/xpm
vlib riviera/fifo_generator_v13_2_11
vlib riviera/xil_defaultlib
vlib riviera/xbip_utils_v3_0_14
vlib riviera/c_reg_fd_v12_0_10
vlib riviera/xbip_dsp48_wrapper_v3_0_6
vlib riviera/xbip_pipe_v3_0_10
vlib riviera/c_addsub_v12_0_19
vlib riviera/mult_gen_v12_0_22
vlib riviera/axi_utils_v2_0_10
vlib riviera/cordic_v6_0_23

vmap xpm riviera/xpm
vmap fifo_generator_v13_2_11 riviera/fifo_generator_v13_2_11
vmap xil_defaultlib riviera/xil_defaultlib
vmap xbip_utils_v3_0_14 riviera/xbip_utils_v3_0_14
vmap c_reg_fd_v12_0_10 riviera/c_reg_fd_v12_0_10
vmap xbip_dsp48_wrapper_v3_0_6 riviera/xbip_dsp48_wrapper_v3_0_6
vmap xbip_pipe_v3_0_10 riviera/xbip_pipe_v3_0_10
vmap c_addsub_v12_0_19 riviera/c_addsub_v12_0_19
vmap mult_gen_v12_0_22 riviera/mult_gen_v12_0_22
vmap axi_utils_v2_0_10 riviera/axi_utils_v2_0_10
vmap cordic_v6_0_23 riviera/cordic_v6_0_23

vlog -work xpm  -incr -l xpm -l fifo_generator_v13_2_11 -l xil_defaultlib -l xbip_utils_v3_0_14 -l c_reg_fd_v12_0_10 -l xbip_dsp48_wrapper_v3_0_6 -l xbip_pipe_v3_0_10 -l c_addsub_v12_0_19 -l mult_gen_v12_0_22 -l axi_utils_v2_0_10 -l cordic_v6_0_23 \
"C:/Xilinx/Vivado/2024.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"C:/Xilinx/Vivado/2024.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93  -incr \
"C:/Xilinx/Vivado/2024.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work fifo_generator_v13_2_11  -incr -v2k5 -l xpm -l fifo_generator_v13_2_11 -l xil_defaultlib -l xbip_utils_v3_0_14 -l c_reg_fd_v12_0_10 -l xbip_dsp48_wrapper_v3_0_6 -l xbip_pipe_v3_0_10 -l c_addsub_v12_0_19 -l mult_gen_v12_0_22 -l axi_utils_v2_0_10 -l cordic_v6_0_23 \
"../../ipstatic/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_2_11 -93  -incr \
"../../ipstatic/hdl/fifo_generator_v13_2_rfs.vhd" \

vlog -work fifo_generator_v13_2_11  -incr -v2k5 -l xpm -l fifo_generator_v13_2_11 -l xil_defaultlib -l xbip_utils_v3_0_14 -l c_reg_fd_v12_0_10 -l xbip_dsp48_wrapper_v3_0_6 -l xbip_pipe_v3_0_10 -l c_addsub_v12_0_19 -l mult_gen_v12_0_22 -l axi_utils_v2_0_10 -l cordic_v6_0_23 \
"../../ipstatic/hdl/fifo_generator_v13_2_rfs.v" \

vlog -work xil_defaultlib  -incr -v2k5 -l xpm -l fifo_generator_v13_2_11 -l xil_defaultlib -l xbip_utils_v3_0_14 -l c_reg_fd_v12_0_10 -l xbip_dsp48_wrapper_v3_0_6 -l xbip_pipe_v3_0_10 -l c_addsub_v12_0_19 -l mult_gen_v12_0_22 -l axi_utils_v2_0_10 -l cordic_v6_0_23 \
"../../../a7_mic_processing_1.gen/sources_1/ip/fifo_generator_0/sim/fifo_generator_0.v" \

vcom -work xbip_utils_v3_0_14 -93  -incr \
"../../ipstatic/hdl/xbip_utils_v3_0_vh_rfs.vhd" \

vcom -work c_reg_fd_v12_0_10 -93  -incr \
"../../ipstatic/hdl/c_reg_fd_v12_0_vh_rfs.vhd" \

vcom -work xbip_dsp48_wrapper_v3_0_6 -93  -incr \
"../../ipstatic/hdl/xbip_dsp48_wrapper_v3_0_vh_rfs.vhd" \

vcom -work xbip_pipe_v3_0_10 -93  -incr \
"../../ipstatic/hdl/xbip_pipe_v3_0_vh_rfs.vhd" \

vcom -work c_addsub_v12_0_19 -93  -incr \
"../../ipstatic/hdl/c_addsub_v12_0_vh_rfs.vhd" \

vcom -work mult_gen_v12_0_22 -93  -incr \
"../../ipstatic/hdl/mult_gen_v12_0_vh_rfs.vhd" \

vcom -work axi_utils_v2_0_10 -93  -incr \
"../../ipstatic/hdl/axi_utils_v2_0_vh_rfs.vhd" \

vcom -work cordic_v6_0_23 -93  -incr \
"../../ipstatic/hdl/cordic_v6_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93  -incr \
"../../../a7_mic_processing_1.gen/sources_1/ip/cordic_0_2/sim/cordic_0.vhd" \

vlog -work xil_defaultlib  -incr -v2k5 -l xpm -l fifo_generator_v13_2_11 -l xil_defaultlib -l xbip_utils_v3_0_14 -l c_reg_fd_v12_0_10 -l xbip_dsp48_wrapper_v3_0_6 -l xbip_pipe_v3_0_10 -l c_addsub_v12_0_19 -l mult_gen_v12_0_22 -l axi_utils_v2_0_10 -l cordic_v6_0_23 \
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

