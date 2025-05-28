transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+mic_to_led_pc  -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.mic_to_led_pc xil_defaultlib.glbl

do {mic_to_led_pc.udo}

run 1000ns

endsim

quit -force
