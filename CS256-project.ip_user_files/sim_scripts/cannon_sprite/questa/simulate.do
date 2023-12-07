onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib cannon_sprite_opt

do {wave.do}

view wave
view structure
view signals

do {cannon_sprite.udo}

run -all

quit -force
