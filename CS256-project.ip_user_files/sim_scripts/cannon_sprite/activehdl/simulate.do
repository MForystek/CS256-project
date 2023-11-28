onbreak {quit -force}
onerror {quit -force}

asim +access +r +m+cannon_sprite -L xpm -L blk_mem_gen_v8_4_4 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.cannon_sprite xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {cannon_sprite.udo}

run -all

endsim

quit -force
