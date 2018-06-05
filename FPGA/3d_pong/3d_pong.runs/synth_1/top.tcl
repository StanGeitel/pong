# 
# Synthesis run script generated by Vivado
# 

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param xicom.use_bs_reader 1
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir C:/Users/jobgr/stack/Computer/Documenten/GitHub/pong/FPGA/3d_pong/3d_pong.cache/wt [current_project]
set_property parent.project_path C:/Users/jobgr/stack/Computer/Documenten/GitHub/pong/FPGA/3d_pong/3d_pong.xpr [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property board_part digilentinc.com:basys3:part0:1.1 [current_project]
set_property ip_output_repo c:/Users/jobgr/stack/Computer/Documenten/GitHub/pong/FPGA/3d_pong/3d_pong.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
add_files C:/Users/jobgr/stack/Computer/Documenten/GitHub/pong/FPGA/Geluid/Retro.coe
add_files c:/Users/jobgr/stack/Computer/Documenten/GitHub/pong/FPGA/3d_pong/3d_pong.ip_user_files/mem_init_files/registers.coe
read_vhdl -library xil_defaultlib {
  C:/Users/jobgr/stack/Computer/Documenten/GitHub/pong/FPGA/3d_pong/3d_pong.srcs/sources_1/imports/new/buttons.vhd
  C:/Users/jobgr/stack/Computer/Documenten/GitHub/pong/FPGA/3d_pong/3d_pong.srcs/sources_1/imports/new/clk.vhd
  C:/Users/jobgr/stack/Computer/Documenten/GitHub/pong/FPGA/3d_pong/3d_pong.srcs/sources_1/new/image.vhd
  C:/Users/jobgr/stack/Computer/Documenten/GitHub/pong/FPGA/3d_pong/3d_pong.srcs/sources_1/new/memory.vhd
  C:/Users/jobgr/stack/Computer/Documenten/GitHub/pong/FPGA/3d_pong/3d_pong.srcs/sources_1/new/rom_Geluid.vhd
  C:/Users/jobgr/stack/Computer/Documenten/GitHub/pong/FPGA/3d_pong/3d_pong.srcs/sources_1/new/spi.vhd
  C:/Users/jobgr/stack/Computer/Documenten/GitHub/pong/FPGA/3d_pong/3d_pong.srcs/sources_1/new/vga.vhd
  C:/Users/jobgr/stack/Computer/Documenten/GitHub/pong/FPGA/3d_pong/3d_pong.srcs/sources_1/new/top.vhd
}
read_ip -quiet C:/Users/jobgr/stack/Computer/Documenten/GitHub/pong/FPGA/3d_pong/3d_pong.srcs/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0.xci
set_property used_in_implementation false [get_files -all c:/Users/jobgr/stack/Computer/Documenten/GitHub/pong/FPGA/3d_pong/3d_pong.srcs/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0_ooc.xdc]

read_ip -quiet C:/Users/jobgr/stack/Computer/Documenten/GitHub/pong/FPGA/3d_pong/3d_pong.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xci
set_property used_in_implementation false [get_files -all c:/Users/jobgr/stack/Computer/Documenten/GitHub/pong/FPGA/3d_pong/3d_pong.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_board.xdc]
set_property used_in_implementation false [get_files -all c:/Users/jobgr/stack/Computer/Documenten/GitHub/pong/FPGA/3d_pong/3d_pong.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc]
set_property used_in_implementation false [get_files -all c:/Users/jobgr/stack/Computer/Documenten/GitHub/pong/FPGA/3d_pong/3d_pong.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_ooc.xdc]

read_ip -quiet C:/Users/jobgr/stack/Computer/Documenten/GitHub/pong/FPGA/3d_pong/3d_pong.srcs/sources_1/ip/blk_mem_gen_1/blk_mem_gen_1.xci
set_property used_in_implementation false [get_files -all c:/Users/jobgr/stack/Computer/Documenten/GitHub/pong/FPGA/3d_pong/3d_pong.srcs/sources_1/ip/blk_mem_gen_1/blk_mem_gen_1_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/jobgr/stack/Computer/Documenten/GitHub/pong/FPGA/3d_pong/3d_pong.srcs/constrs_1/new/top.xdc
set_property used_in_implementation false [get_files C:/Users/jobgr/stack/Computer/Documenten/GitHub/pong/FPGA/3d_pong/3d_pong.srcs/constrs_1/new/top.xdc]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]

synth_design -top top -part xc7a35tcpg236-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef top.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file top_utilization_synth.rpt -pb top_utilization_synth.pb"
