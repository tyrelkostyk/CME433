onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /tbench_top/test/clk
add wave -noupdate -radix binary /tbench_top/test/P
add wave -noupdate -radix binary /tbench_top/test/G
add wave -noupdate -radix binary /tbench_top/test/Cout
add wave -noupdate -color Orange -itemcolor Orange -radix unsigned /tbench_top/test/S
add wave -noupdate -radix binary /tbench_top/test/Cin
add wave -noupdate -color Magenta -radix unsigned /tbench_top/test/A
add wave -noupdate -color Magenta -radix unsigned /tbench_top/test/B
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 us} 0}
quietly wave cursor active 0
configure wave -namecolwidth 125
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
WaveRestoreZoom {0 us} {321 us}
