transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/quartus/Pro11 {D:/quartus/Pro11/clkgen.v}
vlog -vlog01compat -work work +incdir+D:/quartus/Pro11 {D:/quartus/Pro11/ps2_keyboard.v}
vlog -vlog01compat -work work +incdir+D:/quartus/Pro11 {D:/quartus/Pro11/vga_ctrl.v}
vlog -vlog01compat -work work +incdir+D:/quartus/Pro11 {D:/quartus/Pro11/picture.v}
vlog -vlog01compat -work work +incdir+D:/quartus/Pro11 {D:/quartus/Pro11/vga_font.v}
vlog -vlog01compat -work work +incdir+D:/quartus/Pro11 {D:/quartus/Pro11/transfer.v}
vlog -vlog01compat -work work +incdir+D:/quartus/Pro11 {D:/quartus/Pro11/my_IO.v}

vlog -vlog01compat -work work +incdir+D:/quartus/Pro11/simulation/modelsim {D:/quartus/Pro11/simulation/modelsim/my_IO.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  my_IO_vlg_tst

add wave *
view structure
view signals
run -all
