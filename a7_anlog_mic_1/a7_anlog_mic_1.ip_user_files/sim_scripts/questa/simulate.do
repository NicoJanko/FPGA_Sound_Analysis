onbreak {quit -f}
onerror {quit -f}

vsim  -lib xil_defaultlib mic_to_led_pc_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {mic_to_led_pc.udo}

run 1000ns

quit -force
