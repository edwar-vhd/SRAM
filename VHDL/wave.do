onerror {resume}
quietly WaveActivateNextPane {} 0
radix -hexadecimal -showbase


add wave -noupdate -group Test_Bench_Signals /SRAM_tb/*

add wave -noupdate -group SRAM_PORTS -divider Control_bus
add wave -noupdate -group SRAM_PORTS -label CE  /SRAM_tb/DUT/CE	
add wave -noupdate -group SRAM_PORTS -label WE  /SRAM_tb/DUT/WE	
add wave -noupdate -group SRAM_PORTS -label OE  /SRAM_tb/DUT/OE	
add wave -noupdate -group SRAM_PORTS -label LB  /SRAM_tb/DUT/LB	
add wave -noupdate -group SRAM_PORTS -label UB  /SRAM_tb/DUT/UB

add wave -noupdate -group SRAM_PORTS -divider Address_bus
add wave -noupdate -group SRAM_PORTS -label addr /SRAM_tb/DUT/addr

add wave -noupdate -group SRAM_PORTS -divider Data_bus
add wave -noupdate -group SRAM_PORTS -label data /SRAM_tb/DUT/data

add wave -noupdate -group SRAM_PORTS -divider Mem_states_simulation
add wave -noupdate -group SRAM_PORTS -label State_sim -color "yellow" /SRAM_tb/s_mode