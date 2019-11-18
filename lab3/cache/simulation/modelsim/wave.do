onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cache_testbench/clk
add wave -noupdate -radix unsigned /cache_testbench/data
add wave -noupdate -radix unsigned /cache_testbench/rdoffset
add wave -noupdate -radix unsigned /cache_testbench/wroffset
add wave -noupdate /cache_testbench/wren
add wave -noupdate /cache_testbench/q
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6891 ps} 0}
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
WaveRestoreZoom {0 ps} {105 ns}
