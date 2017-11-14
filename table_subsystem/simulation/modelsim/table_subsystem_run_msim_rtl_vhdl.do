transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/jld60/Documents/project_workspace/table_subsystem/table_interface/rx_fsm.vhd}
vcom -93 -work work {C:/Users/jld60/Documents/project_workspace/table_subsystem/table_interface/tx_fsm.vhd}
vcom -93 -work work {C:/Users/jld60/Documents/project_workspace/table_subsystem/table_interface/table_interface.vhd}

