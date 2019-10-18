onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tbench_top/test/clk
add wave -noupdate -color Yellow -itemcolor Yellow -radix unsigned /tbench_top/test/S
add wave -noupdate -radix unsigned /tbench_top/test/A
add wave -noupdate -radix unsigned /tbench_top/test/B
add wave -noupdate /tbench_top/test/Cout
add wave -noupdate /tbench_top/test/Cin
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {217 us} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {0 us} {315 us}
