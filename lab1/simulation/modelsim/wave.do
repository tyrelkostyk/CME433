onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /parity_testbench/D
add wave -noupdate /parity_testbench/F_conv
add wave -noupdate /parity_testbench/F_davio
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 us} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {0 us} {1050 us}
