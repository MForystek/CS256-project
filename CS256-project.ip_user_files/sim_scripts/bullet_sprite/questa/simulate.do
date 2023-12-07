onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib bullet_sprite_opt

do {wave.do}

view wave
view structure
view signals

do {bullet_sprite.udo}

run -all

quit -force
