onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib background_sprite_opt

do {wave.do}

view wave
view structure
view signals

do {background_sprite.udo}

run -all

quit -force
