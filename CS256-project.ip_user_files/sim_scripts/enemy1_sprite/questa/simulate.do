onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib enemy1_sprite_opt

do {wave.do}

view wave
view structure
view signals

do {enemy1_sprite.udo}

run -all

quit -force
