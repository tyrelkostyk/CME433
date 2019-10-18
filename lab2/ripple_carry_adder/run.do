onbreak {resume}
if [file exists work] { vdel -all }
vlib work
vmap work work

vlog *.v

vopt +acc tbench_top -o tbench_top_opt
vsim tbench_top_opt

add log -r /*
run -all
if [file exists wave.do] { do wave.do }
