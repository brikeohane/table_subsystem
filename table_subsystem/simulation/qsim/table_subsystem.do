onerror {exit -code 1}
vlib work
vlog -work work table_subsystem.vo
vlog -work work replacement_fsm_waveform.vwf.vt
vsim -novopt -c -t 1ps -L cyclonev_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate_ver -L altera_lnsim_ver work.replacement_fsm_vlg_vec_tst -voptargs="+acc"
vcd file -direction table_subsystem.msim.vcd
vcd add -internal replacement_fsm_vlg_vec_tst/*
vcd add -internal replacement_fsm_vlg_vec_tst/i1/*
run -all
quit -f
