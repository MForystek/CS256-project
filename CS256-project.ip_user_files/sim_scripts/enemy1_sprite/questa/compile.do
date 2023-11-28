vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xpm
vlib questa_lib/msim/blk_mem_gen_v8_4_4
vlib questa_lib/msim/xil_defaultlib

vmap xpm questa_lib/msim/xpm
vmap blk_mem_gen_v8_4_4 questa_lib/msim/blk_mem_gen_v8_4_4
vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xpm -64 -sv \
"/sw/workstations/apps/linux-ubuntu20.04-broadwell/xilinx/2020.2/gcc-9.3.0/u6ynmf6wlzv3korshbgj5smxvcsywk2v/Vivado/2020.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"/sw/workstations/apps/linux-ubuntu20.04-broadwell/xilinx/2020.2/gcc-9.3.0/u6ynmf6wlzv3korshbgj5smxvcsywk2v/Vivado/2020.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93 \
"/sw/workstations/apps/linux-ubuntu20.04-broadwell/xilinx/2020.2/gcc-9.3.0/u6ynmf6wlzv3korshbgj5smxvcsywk2v/Vivado/2020.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work blk_mem_gen_v8_4_4 -64 \
"../../../ipstatic/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib -64 \
"../../../../CS256-project.gen/sources_1/ip/enemy1_sprite/sim/enemy1_sprite.v" \

vlog -work xil_defaultlib \
"glbl.v"

