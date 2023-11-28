-makelib ies_lib/xpm -sv \
  "/sw/workstations/apps/linux-ubuntu20.04-broadwell/xilinx/2020.2/gcc-9.3.0/u6ynmf6wlzv3korshbgj5smxvcsywk2v/Vivado/2020.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "/sw/workstations/apps/linux-ubuntu20.04-broadwell/xilinx/2020.2/gcc-9.3.0/u6ynmf6wlzv3korshbgj5smxvcsywk2v/Vivado/2020.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "/sw/workstations/apps/linux-ubuntu20.04-broadwell/xilinx/2020.2/gcc-9.3.0/u6ynmf6wlzv3korshbgj5smxvcsywk2v/Vivado/2020.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/blk_mem_gen_v8_4_4 \
  "../../../ipstatic/simulation/blk_mem_gen_v8_4.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../CS256-project.gen/sources_1/ip/enemy1_sprite/sim/enemy1_sprite.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

