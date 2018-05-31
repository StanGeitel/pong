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
set_param synth.incrementalSynthesisCache {D:/Documenten/Avans 2017-2018/Blok 8/Pong/Geluid code/Week 5/week_5/.Xil/Vivado-4796-LAPTOP-NJE0O93L/incrSyn}
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir {D:/Documenten/Avans 2017-2018/Blok 8/Pong/Geluid code/Week 5/week_5/week_5.cache/wt} [current_project]
set_property parent.project_path {D:/Documenten/Avans 2017-2018/Blok 8/Pong/Geluid code/Week 5/week_5/week_5.xpr} [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property board_part digilentinc.com:basys3:part0:1.1 [current_project]
set_property ip_output_repo {d:/Documenten/Avans 2017-2018/Blok 8/Pong/Geluid code/Week 5/week_5/week_5.cache/ip} [current_project]
set_property ip_cache_permissions {read write} [current_project]
add_files {{D:/Documenten/Avans 2017-2018/Blok 8/Pong/Geluid code/Week 5/week_5/week_5.ip_user_files/mem_init_files/hallo.coe}}
add_files {{d:/Documenten/Avans 2017-2018/Blok 8/Pong/Retro.coe}}
read_vhdl -library xil_defaultlib {
  {D:/Documenten/Avans 2017-2018/Blok 8/Pong/Geluid code/Week 5/week_5/week_5.srcs/sources_1/new/clk.vhd}
  {D:/Documenten/Avans 2017-2018/Blok 8/Pong/Geluid code/Week 5/week_5/week_5.srcs/sources_1/new/demodulatie.vhd}
  {D:/Documenten/Avans 2017-2018/Blok 8/Pong/Geluid code/Week 5/week_5/week_5.srcs/sources_1/new/rom.vhd}
  {D:/Documenten/Avans 2017-2018/Blok 8/Pong/Geluid code/Week 5/week_5/week_5.srcs/sources_1/new/top.vhd}
}
read_ip -quiet {{D:/Documenten/Avans 2017-2018/Blok 8/Pong/Geluid code/Week 5/week_5/week_5.srcs/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0.xci}}
set_property used_in_implementation false [get_files -all {{d:/Documenten/Avans 2017-2018/Blok 8/Pong/Geluid code/Week 5/week_5/week_5.srcs/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0_ooc.xdc}}]

read_ip -quiet {{D:/Documenten/Avans 2017-2018/Blok 8/Pong/Geluid code/Week 5/week_5/week_5.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xci}}
set_property used_in_implementation false [get_files -all {{d:/Documenten/Avans 2017-2018/Blok 8/Pong/Geluid code/Week 5/week_5/week_5.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_board.xdc}}]
set_property used_in_implementation false [get_files -all {{d:/Documenten/Avans 2017-2018/Blok 8/Pong/Geluid code/Week 5/week_5/week_5.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc}}]
set_property used_in_implementation false [get_files -all {{d:/Documenten/Avans 2017-2018/Blok 8/Pong/Geluid code/Week 5/week_5/week_5.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_ooc.xdc}}]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc {{D:/Documenten/Avans 2017-2018/Blok 8/Pong/Geluid code/Week 5/week_5/week_5.srcs/constrs_1/new/top.xdc}}
set_property used_in_implementation false [get_files {{D:/Documenten/Avans 2017-2018/Blok 8/Pong/Geluid code/Week 5/week_5/week_5.srcs/constrs_1/new/top.xdc}}]


synth_design -top top -part xc7a35tcpg236-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef top.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file top_utilization_synth.rpt -pb top_utilization_synth.pb"
