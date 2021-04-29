#!/usr/bin/tclsh
quit -sim

set SRAM_ROOT "."

exec vlib work

set sram_vhdls [list \
	"$SRAM_ROOT/SRAM.vhd" \
	"$SRAM_ROOT/SRAM_tb.vhd" \
	]
	
foreach src $sram_vhdls {
	if [expr {[string first # $src] eq 0}] {puts $src} else {
		vcom -64 -2008 -work work $src
	}
}

vsim -voptargs=+acc work.sram_tb
do wave.do
run 16 us
